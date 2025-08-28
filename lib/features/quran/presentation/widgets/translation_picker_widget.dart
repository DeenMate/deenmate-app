import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../state/providers.dart';
import '../../data/dto/translation_resource_dto.dart';

class TranslationPickerWidget extends ConsumerStatefulWidget {
  const TranslationPickerWidget({super.key});

  @override
  ConsumerState<TranslationPickerWidget> createState() => _TranslationPickerWidgetState();
}

class _TranslationPickerWidgetState extends ConsumerState<TranslationPickerWidget> {
  String _selectedLanguage = 'all';

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(prefsProvider);
    final resourcesAsync = ref.watch(translationResourcesProvider);

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.translationPickerTitle),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: resourcesAsync.when(
          data: (resources) => _buildTranslationList(context, ref, resources, prefs),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text(AppLocalizations.of(context)!.translationPickerErrorLoading(error.toString())),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.translationPickerCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.translationPickerApply),
        ),
      ],
    );
  }

  Widget _buildTranslationList(
    BuildContext context,
    WidgetRef ref,
    List<TranslationResourceDto> resources,
    QuranPrefs prefs,
  ) {
    print('DEBUG: Building translation list with ${resources.length} resources');
    print('DEBUG: Current selected translation IDs: ${prefs.selectedTranslationIds}');
    for (final resource in resources.take(5)) {
      print('DEBUG: Resource ${resource.id}: ${resource.name} (${resource.languageName})');
    }
    return Column(
      children: [
        // Filter by language
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Text(AppLocalizations.of(context)!.translationPickerLanguageLabel),
              DropdownButton<String>(
                value: _selectedLanguage,
                items: [
                  DropdownMenuItem(value: 'all', child: Text(AppLocalizations.of(context)!.translationPickerAllLanguages)),
                  DropdownMenuItem(value: 'en', child: Text(AppLocalizations.of(context)!.translationPickerEnglish)),
                  DropdownMenuItem(value: 'ar', child: Text(AppLocalizations.of(context)!.translationPickerArabic)),
                  DropdownMenuItem(value: 'ur', child: Text(AppLocalizations.of(context)!.translationPickerUrdu)),
                  DropdownMenuItem(value: 'bn', child: Text(AppLocalizations.of(context)!.translationPickerBengali)),
                  DropdownMenuItem(value: 'id', child: Text(AppLocalizations.of(context)!.translationPickerIndonesian)),
                  DropdownMenuItem(value: 'tr', child: Text(AppLocalizations.of(context)!.translationPickerTurkish)),
                  DropdownMenuItem(value: 'fr', child: Text(AppLocalizations.of(context)!.translationPickerFrench)),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value ?? 'all';
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _getFilteredResources(resources).length,
            itemBuilder: (context, index) {
              final filteredResources = _getFilteredResources(resources);
              final resource = filteredResources[index];
              final isSelected = prefs.selectedTranslationIds.contains(resource.id);
              
              return CheckboxListTile(
                title: Text(
                  resource.name ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'by ${resource.authorName ?? 'Unknown'}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                value: isSelected,
                onChanged: (selected) {
                  if (selected == null) return;
                  
                  print('DEBUG: Translation ${resource.id} (${resource.name}) ${selected ? 'selected' : 'deselected'}');
                  final notifier = ref.read(prefsProvider.notifier);
                  if (selected) {
                    // Add translation
                    final newIds = [...prefs.selectedTranslationIds, resource.id];
                    print('DEBUG: Adding translation ${resource.id}, new IDs: $newIds');
                    notifier.updateTranslationIds(newIds);
                  } else {
                    // Remove translation (but keep at least one)
                    if (prefs.selectedTranslationIds.length > 1) {
                      final newIds = prefs.selectedTranslationIds
                          .where((id) => id != resource.id)
                          .toList();
                      print('DEBUG: Removing translation ${resource.id}, new IDs: $newIds');
                      notifier.updateTranslationIds(newIds);
                    } else {
                      print('DEBUG: Cannot remove translation ${resource.id} - only one left');
                    }
                  }
                },
                secondary: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      (resource.languageName ?? 'EN').substring(0, 2).toUpperCase(),
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Selected count
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            '${prefs.selectedTranslationIds.length} translation${prefs.selectedTranslationIds.length == 1 ? '' : 's'} selected',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  List<TranslationResourceDto> _getFilteredResources(List<TranslationResourceDto> resources) {
    if (_selectedLanguage == 'all') {
      return resources;
    }
    
    return resources.where((resource) {
      final languageName = resource.languageName?.toLowerCase() ?? '';
      switch (_selectedLanguage) {
        case 'en':
          return languageName.contains('english');
        case 'ar':
          return languageName.contains('arabic') || languageName.contains('عربي');
        case 'ur':
          return languageName.contains('urdu');
        case 'bn':
          return languageName.contains('bengali') || languageName.contains('bangla');
        case 'id':
          return languageName.contains('indonesian');
        case 'tr':
          return languageName.contains('turkish');
        case 'fr':
          return languageName.contains('french');
        default:
          return true;
      }
    }).toList();
  }
}
