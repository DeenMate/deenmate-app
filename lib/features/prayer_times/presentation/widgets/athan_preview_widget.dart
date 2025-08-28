import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/audio_providers.dart';

/// Widget for previewing Athan audio
class AthanPreviewWidget extends ConsumerWidget {

  const AthanPreviewWidget({
    required this.muadhinVoice, required this.volume, super.key,
  });
  final String muadhinVoice;
  final double volume;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final athanAudioState = ref.watch(athanAudioProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.play_circle_outline,
                color: Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.athanPreviewTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.athanPreviewDescription,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          
          // Preview controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (athanAudioState.isPlaying) ...[
                _buildStopButton(context, ref),
                const SizedBox(width: 16),
                const CircularProgressIndicator(),
                const SizedBox(width: 16),
                Text(
                  AppLocalizations.of(context)!.athanPreviewPlaying,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ] else ...[
                _buildPlayButton(context, ref),
                const SizedBox(width: 16),
                const Icon(
                  Icons.volume_up,
                  color: Colors.blue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${(volume * 100).toInt()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ],
            ],
          ),
          
          // Error message
          if (athanAudioState.error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red[600],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      athanAudioState.error!.message,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Information about the voice
          const SizedBox(height: 16),
          _buildVoiceInfo(context),
        ],
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () {
        ref.read(athanAudioProvider.notifier).previewAthan(muadhinVoice);
      },
      icon: const Icon(Icons.play_arrow),
      label: Text(AppLocalizations.of(context)!.athanPreviewPlay),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  Widget _buildStopButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () {
        ref.read(athanAudioProvider.notifier).stopAthan();
      },
      icon: const Icon(Icons.stop),
      label: Text(AppLocalizations.of(context)!.athanPreviewStop),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  Widget _buildVoiceInfo(BuildContext context) {
    // Get voice information based on selected voice
    final voiceInfo = _getVoiceInfo(context, muadhinVoice);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.blue,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voiceInfo['name']!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  voiceInfo['description']!,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> _getVoiceInfo(BuildContext context, String voiceId) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (voiceId) {
      case 'abdulbasit':
        return {
          'name': l10n.reciterAbdulBasit,
          'description': l10n.reciterAbdulBasitDesc,
        };
      case 'mishary':
        return {
          'name': l10n.reciterMishary,
          'description': l10n.reciterMisharyDesc,
        };
      case 'sudais':
        return {
          'name': l10n.reciterSudais,
          'description': l10n.reciterSudaisDesc,
        };
      case 'shuraim':
        return {
          'name': l10n.reciterShuraim,
          'description': l10n.reciterShuraimDesc,
        };
      case 'maher':
        return {
          'name': l10n.reciterMaher,
          'description': l10n.reciterMaherDesc,
        };
      case 'yasser':
        return {
          'name': l10n.reciterYasser,
          'description': l10n.reciterYasserDesc,
        };
      case 'ajmi':
        return {
          'name': l10n.reciterAjmi,
          'description': l10n.reciterAjmiDesc,
        };
      case 'ghamdi':
        return {
          'name': l10n.reciterGhamdi,
          'description': l10n.reciterGhamdiDesc,
        };
      default:
        return {
          'name': l10n.reciterDefault,
          'description': l10n.reciterDefaultDesc,
        };
    }
  }
}
