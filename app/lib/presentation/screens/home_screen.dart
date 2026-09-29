import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../providers/song_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredSongsAsync = ref.watch(filteredSongsProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isStageMode = themeMode == AppThemeMode.stage;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isStageMode ? AppColors.stageChord : AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.music_note,
                color: isStageMode ? Colors.black : Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'ChordBand',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isStageMode ? AppColors.stageTextPrimary : null,
              ),
            ),
          ],
        ),
        actions: [
          // Unified Band & Collaboration Button
          PopupMenuButton<String>(
            tooltip: 'Band Collaboration & Sharing\n• Live Stage Broadcast (Follow-the-Leader)\n• Band Songbooks & Member Sharing',
            icon: const Icon(Icons.groups_3),
            onSelected: (val) {
              if (val == 'live') context.push('/live');
              if (val == 'groups') context.push('/groups');
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'live',
                child: Row(
                  children: [
                    Icon(Icons.podcasts, color: Colors.indigo),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Live Stage Broadcast', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Follow-the-Leader live band sync', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'groups',
                child: Row(
                  children: [
                    Icon(Icons.share, color: Colors.teal),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Band Songbooks & Members', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Share via QR code & cloud sync', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Setlists
          IconButton(
            icon: const Icon(Icons.playlist_play),
            tooltip: 'Setlists & Repertoire\nOrganize song orders for performances',
            onPressed: () => context.push('/setlists'),
          ),

          // Stage Mode Toggle
          IconButton(
            icon: Icon(
              isStageMode ? Icons.nightlife : Icons.nightlife_outlined,
              color: isStageMode ? AppColors.stageChordAccent : null,
            ),
            tooltip: isStageMode ? 'Exit Stage Mode' : 'Enter Stage Mode',
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
                  isStageMode ? AppThemeMode.dark : AppThemeMode.stage;
            },
          ),

          // Settings
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search songs, artists, lyrics...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isStageMode ? AppColors.stageSurface : Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isStageMode ? AppColors.stageBorder : Theme.of(context).dividerColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isStageMode ? AppColors.stageBorder : Theme.of(context).dividerColor,
                  ),
                ),
              ),
              onChanged: (val) {
                ref.read(searchQueryProvider.notifier).state = val;
              },
            ),
          ),

          // Songs List
          Expanded(
            child: filteredSongsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error loading songs: $err')),
              data: (songs) {
                if (songs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.library_music_outlined, size: 64, color: Colors.grey.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        const Text(
                          'No songs found',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + below to add or import a song',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                  itemCount: songs.length,
                  itemBuilder: (ctx, index) {
                    final song = songs[index];
                    final isTelugu = RegExp(r'[\u0C00-\u0C7F]').hasMatch(song.chordProContent);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        title: Text(
                          song.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isStageMode ? AppColors.stageTextPrimary : null,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              song.artist,
                              style: TextStyle(
                                color: isStageMode ? AppColors.stageTextSecondary : null,
                              ),
                            ),
                            if (song.tempo != null) ...[
                              const Text(' • '),
                              Text('${song.tempo} BPM'),
                            ],
                          ],
                        ),
                        leading: CircleAvatar(
                          backgroundColor: isStageMode
                              ? AppColors.stageChord.withOpacity(0.15)
                              : AppColors.primary.withOpacity(0.12),
                          child: Text(
                            song.originalKey ?? '?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isStageMode ? AppColors.stageChord : AppColors.primary,
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isTelugu)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.teal.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.teal.withOpacity(0.4)),
                                ),
                                child: const Text(
                                  'తెలుగు',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                        onTap: () => context.push('/song/${song.id}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddOptions(context),
        icon: const Icon(Icons.add),
        label: const Text('New Song'),
        backgroundColor: isStageMode ? AppColors.stageChord : null,
        foregroundColor: isStageMode ? Colors.black : null,
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Add Song to Songbook', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit_note, color: Colors.blue),
                title: const Text('Create Song Manually'),
                subtitle: const Text('Interactive chord palette, section tags & auto-formatting'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/song/new/edit');
                },
              ),
              ListTile(
                leading: const Icon(Icons.content_paste_go, color: Colors.teal),
                title: const Text('Paste Lyrics from PDF, Word or Web'),
                subtitle: const Text('Auto-detects chords above lyrics and formats instantly'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/import');
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder_open, color: Colors.indigo),
                title: const Text('Import Document / File'),
                subtitle: const Text('Open .pdf, .docx, .txt, or .chordpro file'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/import');
                },
              ),
              ListTile(
                leading: const Icon(Icons.link, color: Colors.orange),
                title: const Text('Import from Webpage URL'),
                subtitle: const Text('Fetch chords from public song link'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/import');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
