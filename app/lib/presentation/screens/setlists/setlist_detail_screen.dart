import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/song_providers.dart';
import '../../providers/setlist_providers.dart';

class SetlistDetailScreen extends ConsumerWidget {
  final String setlistId;

  const SetlistDetailScreen({super.key, required this.setlistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(setlistItemsStreamProvider(setlistId));
    final allSongsAsync = ref.watch(allSongsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setlist Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add),
            tooltip: 'Add Song to Setlist',
            onPressed: () => _showAddSongDialog(context, ref),
          ),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.music_off, size: 56, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('No songs in this setlist yet',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => _showAddSongDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Songs'),
                  ),
                ],
              ),
            );
          }

          final allSongs = allSongsAsync.value ?? [];
          final songMap = {for (final s in allSongs) s.id: s};

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              final item = items[index];
              final song = songMap[item.songId];

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    song?.title ?? 'Unknown Song',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Key: ${item.keyOverride ?? song?.originalKey ?? "C"}${item.capoOverride != null ? " • Capo ${item.capoOverride}" : ""}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      await ref
                          .read(setlistRepositoryProvider)
                          .deleteSetlistItem(item.id);
                    },
                  ),
                  onTap: () {
                    if (song != null) {
                      context.push('/song/${song.id}');
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddSongDialog(BuildContext context, WidgetRef ref) {
    final allSongs = ref.read(allSongsStreamProvider).value ?? [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Select Song to Add',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: allSongs.length,
                itemBuilder: (c, i) {
                  final song = allSongs[i];
                  return ListTile(
                    title: Text(song.title),
                    subtitle: Text('${song.artist} • Key: ${song.originalKey}'),
                    onTap: () async {
                      await ref
                          .read(setlistRepositoryProvider)
                          .addSongToSetlist(
                            setlistId: setlistId,
                            songId: song.id,
                            sortOrder: 999,
                          );
                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
