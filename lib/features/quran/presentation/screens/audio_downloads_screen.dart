import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/dto/chapter_dto.dart';
import '../../data/dto/recitation_resource_dto.dart';
import '../state/providers.dart';
import '../../domain/services/audio_service.dart' as audio_service;
import '../../../../core/theme/theme_helper.dart';

class AudioDownloadsScreen extends ConsumerStatefulWidget {
  const AudioDownloadsScreen({super.key});

  @override
  ConsumerState<AudioDownloadsScreen> createState() =>
      _AudioDownloadsScreenState();
}

class _AudioDownloadsScreenState extends ConsumerState<AudioDownloadsScreen> {
  int _selectedReciterId = 7; // Default to Alafasy
  bool _isDownloading = false;
  Map<int, double> _chapterProgress = {};
  String _currentDownloadStatus = '';
  final Map<int, CancelToken> _cancelTokens = {};

  @override
  void initState() {
    super.initState();
    _loadSavedReciter();
    // Listen to global download progress stream to reflect live updates
    ref.listen(audioDownloadProgressProvider, (previous, next) {
      next.whenData((progress) {
        // verseKey formats like "2:255" or chapter completion key "chapter_2"
        int? chapterId;
        if (progress.verseKey.startsWith('chapter_')) {
          chapterId =
              int.tryParse(progress.verseKey.replaceFirst('chapter_', ''));
        } else if (progress.verseKey.contains(':')) {
          final parts = progress.verseKey.split(':');
          chapterId = int.tryParse(parts.first);
        }
        if (chapterId != null && mounted) {
          setState(() {
            _chapterProgress[chapterId!] = progress.progress;
            _currentDownloadStatus = progress.status ?? '';
            _isDownloading = !progress.isComplete && progress.progress > 0.0;
          });
        }
      });
    });
  }

  Future<void> _loadSavedReciter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getInt('quran_audio_selected_reciter_id');
      if (saved != null && mounted) {
        setState(() => _selectedReciterId = saved);
      }
    } catch (_) {}
  }

  Future<void> _saveSelectedReciter(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('quran_audio_selected_reciter_id', id);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final chaptersAsync = ref.watch(surahListProvider);
    final recitersAsync = ref.watch(recitationResourcesProvider);
    final storageStats = ref.watch(audioStorageStatsProvider);

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.audioDownloadsTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: ThemeHelper.getTextPrimaryColor(context)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Storage overview
          _buildStorageOverview(storageStats),
          const SizedBox(height: 20),

          // Reciter selection
          _buildReciterSelection(recitersAsync),
          const SizedBox(height: 20),

          // Quick actions
          _buildQuickActions(),
          const SizedBox(height: 20),

          // Chapter list
          _buildChaptersList(chaptersAsync),
        ],
      ),
    );
  }

  Widget _buildStorageOverview(
      AsyncValue<audio_service.AudioStorageStats> statsAsync) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeHelper.getDividerColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.audiotrack,
                  color: ThemeHelper.getPrimaryColor(context),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.audioStorageTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ThemeHelper.getTextPrimaryColor(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    statsAsync.when(
                      data: (stats) => Text(
                        '${stats.totalSizeMB.toStringAsFixed(1)} MB • ${stats.fileCount} files',
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeHelper.getTextSecondaryColor(context),
                        ),
                      ),
                      loading: () => Text(
                        AppLocalizations.of(context)!.commonLoading,
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeHelper.getTextSecondaryColor(context),
                        ),
                      ),
                      error: (_, __) => Text(
                        AppLocalizations.of(context)!.audioStorageErrorStats,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isDownloading) ...[
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentDownloadStatus,
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeHelper.getTextSecondaryColor(context),
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  backgroundColor: ThemeHelper.getDividerColor(context),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      ThemeHelper.getPrimaryColor(context)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReciterSelection(
      AsyncValue<List<RecitationResourceDto>> recitersAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.audioSelectReciterTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
        ),
        const SizedBox(height: 12),
        recitersAsync.when(
          data: (reciters) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: ThemeHelper.getSurfaceColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeHelper.getDividerColor(context)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedReciterId,
                isExpanded: true,
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
                items: reciters.map((reciter) {
                  return DropdownMenuItem<int>(
                    value: reciter.id,
                    child: Text(reciter.name),
                  );
                }).toList(),
                onChanged: _isDownloading
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            _selectedReciterId = value;
                          });
                          _saveSelectedReciter(value);
                        }
                      },
              ),
            ),
          ),
          loading: () => Container(
            height: 48,
            decoration: BoxDecoration(
              color: ThemeHelper.getSurfaceColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ThemeHelper.getDividerColor(context)),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => Container(
            height: 48,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ThemeHelper.getSurfaceColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red),
            ),
            child: Text(
              AppLocalizations.of(context)!.audioRecitersLoadError,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.audioQuickActionsTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                AppLocalizations.of(context)!.audioDownloadPopularTitle,
                Icons.star,
                AppLocalizations.of(context)!.audioDownloadPopularSubtitle,
                _isDownloading ? null : _downloadPopularChapters,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                AppLocalizations.of(context)!.audioDownloadAllTitle,
                Icons.download_for_offline,
                AppLocalizations.of(context)!.audioDownloadAllSubtitle,
                _isDownloading ? null : _downloadAllChapters,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    String subtitle,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeHelper.getSurfaceColor(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ThemeHelper.getDividerColor(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: onTap != null
                  ? ThemeHelper.getPrimaryColor(context)
                  : ThemeHelper.getTextSecondaryColor(context),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: onTap != null
                    ? ThemeHelper.getTextPrimaryColor(context)
                    : ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChaptersList(AsyncValue<List<ChapterDto>> chaptersAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.audioIndividualChaptersTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
        ),
        const SizedBox(height: 12),
        chaptersAsync.when(
          data: (chapters) => Column(
            children: chapters
                .map(
                  (chapter) => FutureBuilder<bool>(
                    future: _isChapterDownloaded(chapter.id),
                    builder: (context, snapshot) {
                      final isDownloaded = snapshot.data ?? false;
                      return _buildChapterTile(chapter,
                          persistentDownload: isDownloaded);
                    },
                  ),
                )
                .toList(),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              AppLocalizations.of(context)!.audioErrorLoadingChapters(error.toString()),
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChapterTile(ChapterDto chapter,
      {bool persistentDownload = false}) {
    final progress = _chapterProgress[chapter.id] ?? 0.0;
    final isDownloading = progress > 0 && progress < 1.0;
    final isDownloaded = progress >= 1.0 || persistentDownload;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeHelper.getDividerColor(context)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDownloaded
                ? Colors.green.withOpacity(0.1)
                : ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: isDownloading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ThemeHelper.getPrimaryColor(context),
                      ),
                    ),
                  )
                : Icon(
                    isDownloaded ? Icons.download_done : Icons.download,
                    color: isDownloaded
                        ? Colors.green
                        : ThemeHelper.getPrimaryColor(context),
                    size: 20,
                  ),
          ),
        ),
        title: Text(
          chapter.nameSimple,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chapter.nameArabic,
              style: TextStyle(
                fontSize: 12,
                color: ThemeHelper.getTextSecondaryColor(context),
                fontFamily: 'Uthmani',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${chapter.versesCount} verses • ${chapter.revelationPlace}',
              style: TextStyle(
                fontSize: 11,
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
            if (isDownloading) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: ThemeHelper.getDividerColor(context),
                valueColor: AlwaysStoppedAnimation<Color>(
                  ThemeHelper.getPrimaryColor(context),
                ),
              ),
            ],
          ],
        ),
        trailing: isDownloading
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                tooltip: AppLocalizations.of(context)!.audioDownloadCancel,
                onPressed: () => _cancelDownload(chapter.id),
              )
            : isDownloaded
                ? PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: ThemeHelper.getTextSecondaryColor(context),
                    ),
                    onSelected: (value) {
                      if (value == 'delete') {
                        _deleteChapterAudio(chapter.id);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                size: 18, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.audioChapterDelete, style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  )
                : IconButton(
                    icon: Icon(
                      Icons.download,
                      color: _isDownloading
                          ? ThemeHelper.getTextSecondaryColor(context)
                          : ThemeHelper.getPrimaryColor(context),
                    ),
                    onPressed: _isDownloading
                        ? null
                        : () => _downloadChapter(chapter.id),
                  ),
      ),
    );
  }

  // Action handlers

  void _downloadPopularChapters() async {
    final popularChapters = [
      1,
      2,
      18,
      36,
      55,
      67,
      112,
      113,
      114
    ]; // Popular surahs

    setState(() {
      _isDownloading = true;
      _currentDownloadStatus = AppLocalizations.of(context)!.audioDownloadingPopularChapters;
    });

    try {
      for (int i = 0; i < popularChapters.length; i++) {
        final chapterId = popularChapters[i];
        await _downloadChapterInternal(chapterId, (progress, status) {
          setState(() {
            _currentDownloadStatus = AppLocalizations.of(context)!.audioDownloadingChapter(chapterId.toString(), status);
            _chapterProgress[chapterId] = progress;
          });
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.audioPopularChaptersDownloadSuccess),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.audioDownloadFailed(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isDownloading = false;
        _currentDownloadStatus = '';
      });

      // Refresh storage stats
      ref.invalidate(audioStorageStatsProvider);
    }
  }

  void _downloadAllChapters() async {
    final chapters = await ref.read(surahListProvider.future);

    setState(() {
      _isDownloading = true;
      _currentDownloadStatus = AppLocalizations.of(context)!.audioDownloadingCompleteQuran;
    });

    try {
      // Batch to avoid overwhelming IO/network
      const batchSize = 3;
      for (int start = 0; start < chapters.length; start += batchSize) {
        final batch = chapters.sublist(
            start, (start + batchSize).clamp(0, chapters.length));
        await Future.wait(batch.map((chapter) async {
          await _downloadChapterInternal(chapter.id, (progress, status) {
            setState(() {
              _currentDownloadStatus = AppLocalizations.of(context)!.audioDownloadingSurah(chapter.nameSimple, status);
              _chapterProgress[chapter.id] = progress;
            });
          });
        }));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.audioCompleteQuranDownloadSuccess),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.audioDownloadFailed(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isDownloading = false;
        _currentDownloadStatus = '';
      });

      // Refresh storage stats
      ref.invalidate(audioStorageStatsProvider);
    }
  }

  void _downloadChapter(int chapterId) async {
    setState(() {
      _chapterProgress[chapterId] = 0.01; // Show as starting
    });

    try {
      await _downloadChapterInternal(chapterId, (progress, status) {
        setState(() {
          _chapterProgress[chapterId] = progress;
        });
      });

      setState(() {
        _chapterProgress[chapterId] = 1.0; // Mark as complete
      });

      // Refresh storage stats
      ref.invalidate(audioStorageStatsProvider);
    } catch (e) {
      setState(() {
        _chapterProgress.remove(chapterId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.audioDownloadFailed(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadChapterInternal(
    int chapterId,
    Function(double progress, String status) onProgress,
  ) async {
    try {
      final audioService = ref.read(quranAudioServiceProvider);

      // Get selected reciter
      final reciterId = _selectedReciterId;

      // Create cancel token per chapter
      final token = CancelToken();
      _cancelTokens[chapterId] = token;

      // Start the actual download using the audio service
      await audioService.downloadChapterAudio(
        chapterId,
        reciterId,
        null, // Let service fetch verses automatically
        onProgress: (progress, currentVerse) {
          onProgress(progress, AppLocalizations.of(context)!.audioDownloadingVerse(currentVerse));
        },
        cancelToken: token,
      );

      // Completion handled by service; clear cancel token
      _cancelTokens.remove(chapterId);
    } catch (e) {
      print('Download error: $e');
      _cancelTokens.remove(chapterId);
      rethrow;
    }
  }

  Future<void> _clearServiceChapterStatus(int chapterId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('audio_complete_${chapterId}_$_selectedReciterId');
      await prefs.remove('audio_progress_${chapterId}_$_selectedReciterId');
    } catch (_) {}
  }

  Future<bool> _isChapterDownloaded(int chapterId) async {
    try {
      final service = ref.read(quranAudioServiceProvider);
      final complete =
          await service.isChapterComplete(chapterId, _selectedReciterId);
      if (complete) return true;
      // Fallback to file presence
      final sizeMb =
          await service.getChapterAudioSize(chapterId, _selectedReciterId);
      return sizeMb > 0.01;
    } catch (e) {
      print('Error checking download status: $e');
      return false;
    }
  }

  void _deleteChapterAudio(int chapterId) async {
    try {
      final audioService = ref.read(quranAudioServiceProvider);

      // Delete audio files through audio service
      await audioService.deleteChapterAudio(chapterId, _selectedReciterId);

      // Clear completion/progress flags maintained by service
      await _clearServiceChapterStatus(chapterId);

      setState(() {
        _chapterProgress.remove(chapterId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.audioChapterDeleted),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh storage stats
      ref.invalidate(audioStorageStatsProvider);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.audioDeleteFailed(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _markChapterAsNotDownloaded(int chapterId) async {
    // Deprecated: handled by _clearServiceChapterStatus
  }

  void _cancelDownload(int chapterId) {
    final token = _cancelTokens[chapterId];
    if (token != null && !token.isCancelled) {
      token.cancel(AppLocalizations.of(context)!.audioUserCancelled);
    }
  }
}
