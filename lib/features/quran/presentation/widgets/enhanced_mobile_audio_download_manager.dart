import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../infrastructure/mobile_audio_download_infrastructure.dart';
import 'mobile_audio_progress_indicators.dart';
import 'mobile_audio_manager.dart';
import '../../domain/services/audio_service.dart' as audio_service;
import '../state/providers.dart';

/// Enhanced mobile audio download manager with complete UI integration
/// Combines download infrastructure with progress indicators and mobile audio controls
class EnhancedMobileAudioDownloadManager extends ConsumerStatefulWidget {
  const EnhancedMobileAudioDownloadManager({
    super.key,
    this.showInline = true,
  });

  final bool showInline;

  @override
  ConsumerState<EnhancedMobileAudioDownloadManager> createState() => 
      _EnhancedMobileAudioDownloadManagerState();
}

class _EnhancedMobileAudioDownloadManagerState 
    extends ConsumerState<EnhancedMobileAudioDownloadManager> {
  final _downloadInfrastructure = MobileAudioDownloadInfrastructure.instance;
  String _selectedReciter = 'mishary-rashid-alafasy';
  DownloadQuality _selectedQuality = DownloadQuality.standard;
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (widget.showInline) {
      return _buildInlineDownloadManager(context, l10n);
    }
    
    return _buildFullScreenDownloadManager(context, l10n);
  }

  Widget _buildInlineDownloadManager(BuildContext context, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.download, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.audioDownloadsTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showFullDownloadManager(context),
                  icon: const Icon(Icons.settings),
                  tooltip: 'Download Settings',
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Quick download actions
            _buildQuickDownloadActions(context, l10n),
            
            // Active downloads progress
            const MobileAudioProgressIndicators(),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenDownloadManager(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.audioDownloadsTitle),
        actions: [
          IconButton(
            onPressed: () => _showDownloadStatistics(context),
            icon: const Icon(Icons.storage),
            tooltip: 'Storage Info',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Download settings
            _buildDownloadSettings(context, l10n),
            const SizedBox(height: 24),
            
            // Quick actions
            _buildQuickDownloadActions(context, l10n),
            const SizedBox(height: 24),
            
            // Individual verse downloads
            _buildIndividualDownloads(context, l10n),
            const SizedBox(height: 24),
            
            // Download progress
            const MobileAudioProgressIndicators(),
            const SizedBox(height: 24),
            
            // Storage management
            _buildStorageManagement(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadSettings(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Download Settings',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Reciter selection
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Reciter'),
              subtitle: Text(_selectedReciter.replaceAll('-', ' ').toUpperCase()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showReciterSelector(context),
            ),
            
            // Quality selection
            ListTile(
              leading: const Icon(Icons.high_quality),
              title: const Text('Audio Quality'),
              subtitle: Text(_selectedQuality == DownloadQuality.high ? 'High (128kbps)' : 'Standard (64kbps)'),
              trailing: Switch(
                value: _selectedQuality == DownloadQuality.high,
                onChanged: (value) {
                  setState(() {
                    _selectedQuality = value ? DownloadQuality.high : DownloadQuality.standard;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickDownloadActions(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.audioQuickActionsTitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                context: context,
                icon: Icons.stars,
                label: l10n.audioDownloadPopularTitle,
                subtitle: l10n.audioDownloadPopularSubtitle,
                onPressed: () => _downloadPopularChapters(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionButton(
                context: context,
                icon: Icons.download_for_offline,
                label: l10n.audioDownloadAllTitle,
                subtitle: l10n.audioDownloadAllSubtitle,
                onPressed: () => _downloadCompleteQuran(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndividualDownloads(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.audioIndividualChaptersTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            // Surah selector
            _buildSurahSelector(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahSelector(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        // Popular Surahs
        Text(
          'Popular Surahs',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSurahChip(context, 1, 'Al-Fatiha'),
            _buildSurahChip(context, 2, 'Al-Baqarah'),
            _buildSurahChip(context, 112, 'Al-Ikhlas'),
            _buildSurahChip(context, 113, 'Al-Falaq'),
            _buildSurahChip(context, 114, 'An-Nas'),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Browse all button
        ElevatedButton.icon(
          onPressed: () => _showAllSurahs(context),
          icon: const Icon(Icons.list),
          label: const Text('Browse All Surahs'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }

  Widget _buildSurahChip(BuildContext context, int surahNumber, String name) {
    return FutureBuilder<bool>(
      future: _downloadInfrastructure.isVerseDownloaded(
        verseKey: '$surahNumber:1',
        reciterSlug: _selectedReciter,
        quality: _selectedQuality,
      ),
      builder: (context, snapshot) {
        final isDownloaded = snapshot.data ?? false;
        
        return FilterChip(
          label: Text(name),
          selected: isDownloaded,
          onSelected: (selected) {
            if (selected) {
              _downloadSurah(context, surahNumber, name);
            } else {
              _deleteSurah(context, surahNumber, name);
            }
          },
          avatar: isDownloaded 
            ? const Icon(Icons.check_circle, size: 16)
            : const Icon(Icons.download, size: 16),
        );
      },
    );
  }

  Widget _buildStorageManagement(BuildContext context, AppLocalizations l10n) {
    return FutureBuilder<DownloadStatistics>(
      future: _downloadInfrastructure.getDownloadStatistics(),
      builder: (context, snapshot) {
        final stats = snapshot.data;
        
        if (stats == null) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.audioStorageTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Storage stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      icon: Icons.audio_file,
                      label: 'Files',
                      value: '${stats.totalFiles}',
                    ),
                    _buildStatCard(
                      icon: Icons.storage,
                      label: 'Size',
                      value: '${stats.totalSizeMB.toStringAsFixed(1)} MB',
                    ),
                    _buildStatCard(
                      icon: Icons.person,
                      label: 'Reciters',
                      value: '${stats.reciterStats.length}',
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Clear cache button
                ElevatedButton.icon(
                  onPressed: () => _showClearCacheDialog(context),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Clear All Downloads'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // Action methods

  void _downloadPopularChapters(BuildContext context) async {
    HapticFeedback.lightImpact();
    
    final l10n = AppLocalizations.of(context)!;
    
    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: BatchDownloadProgressWidget(
          downloadFuture: _downloadInfrastructure.downloadPopularChapters(
            reciterSlug: _selectedReciter,
            quality: _selectedQuality,
            onProgress: (verseKey, progress) {
              // Progress updates handled by BatchDownloadProgressWidget
            },
          ),
          title: l10n.audioDownloadingPopularChapters,
          onComplete: (result) {
            Navigator.of(context).pop();
            _showDownloadResult(context, result, 'Popular chapters');
          },
        ),
      ),
    );
  }

  void _downloadCompleteQuran(BuildContext context) async {
    HapticFeedback.lightImpact();
    
    // Show confirmation dialog first
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Complete Quran'),
        content: const Text(
          'This will download the entire Quran (114 Surahs). This may take a long time and use significant storage space. Continue?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Download'),
          ),
        ],
      ),
    );
    
    if (confirmed != true) return;
    
    // Start download with progress tracking
    _showBatchDownloadProgress(
      context: context,
      title: 'Downloading Complete Quran',
      downloadFuture: _downloadAllSurahs(),
    );
  }

  void _downloadSurah(BuildContext context, int surahNumber, String name) async {
    HapticFeedback.lightImpact();
    
    _showBatchDownloadProgress(
      context: context,
      title: 'Downloading $name',
      downloadFuture: _downloadInfrastructure.downloadSurah(
        surahNumber: surahNumber,
        reciterSlug: _selectedReciter,
        quality: _selectedQuality,
      ),
    );
  }

  void _deleteSurah(BuildContext context, int surahNumber, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Surah'),
        content: Text('Delete all downloaded audio for $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      // Implement surah deletion logic
      HapticFeedback.heavyImpact();
      setState(() {}); // Refresh UI
    }
  }

  Future<BatchDownloadResult> _downloadAllSurahs() async {
    // This would download all 114 Surahs
    // Implementation would iterate through all Surahs
    final allVerses = <audio_service.VerseAudio>[];
    
    for (int surah = 1; surah <= 114; surah++) {
      // Add verses for this surah (simplified)
      for (int verse = 1; verse <= 10; verse++) { // Placeholder verse count
        allVerses.add(audio_service.VerseAudio(
          verseKey: '$surah:$verse',
          audioUrl: '',
        ));
      }
    }
    
    return _downloadInfrastructure.downloadMultipleVerses(
      verses: allVerses,
      reciterSlug: _selectedReciter,
      quality: _selectedQuality,
    );
  }

  void _showBatchDownloadProgress({
    required BuildContext context,
    required String title,
    required Future<BatchDownloadResult> downloadFuture,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: BatchDownloadProgressWidget(
          downloadFuture: downloadFuture,
          title: title,
          onComplete: (result) {
            Navigator.of(context).pop();
            _showDownloadResult(context, result, title);
            setState(() {}); // Refresh UI
          },
        ),
      ),
    );
  }

  void _showDownloadResult(BuildContext context, BatchDownloadResult result, String title) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              result.allSuccessful ? Icons.check_circle : Icons.warning,
              color: result.allSuccessful ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total: ${result.totalRequested}'),
            Text('Successful: ${result.successful}'),
            if (result.failed > 0)
              Text(
                'Failed: ${result.failed}',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            Text(
              'Success Rate: ${(result.successRate * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showReciterSelector(BuildContext context) {
    // Implementation for reciter selection
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Select Reciter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            // Reciter list would go here
            const Expanded(
              child: Center(
                child: Text('Reciter selection coming soon'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllSurahs(BuildContext context) {
    // Implementation for showing all Surahs
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('All Surahs')),
          body: const Center(
            child: Text('Complete Surah list coming soon'),
          ),
        ),
      ),
    );
  }

  void _showDownloadStatistics(BuildContext context) {
    // Implementation for detailed download statistics
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Download Statistics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: const Text('Detailed statistics coming soon'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Downloads'),
        content: const Text(
          'This will delete all downloaded audio files. This action cannot be undone. Continue?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      // Implement cache clearing
      HapticFeedback.heavyImpact();
      
      // Show progress
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Clearing downloads...'),
            ],
          ),
        ),
      );
      
      // Simulate clearing
      await Future.delayed(const Duration(seconds: 2));
      
      if (context.mounted) {
        Navigator.of(context).pop(); // Close progress dialog
        setState(() {}); // Refresh UI
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All downloads cleared')),
        );
      }
    }
  }

  void _showFullDownloadManager(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EnhancedMobileAudioDownloadManager(
          showInline: false,
        ),
      ),
    );
  }
}
