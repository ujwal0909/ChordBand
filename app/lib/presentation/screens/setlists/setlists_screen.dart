import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/song_providers.dart';
import '../../providers/setlist_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class SetlistsScreen extends ConsumerWidget {
  const SetlistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isStage = themeMode == AppThemeMode.stage;
    final setlistsAsync = ref.watch(allSetlistsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setlists & Playlists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Setlist',
            onPressed: () => _createSetlistDialog(context, ref),
          ),
        ],
      ),
      body: setlistsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (setlists) {
          if (setlists.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.queue_music,
                      size: 64, color: Colors.grey.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text('No Setlists Yet',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                      'Create setlists for gigs, Sunday services, or rehearsals'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _createSetlistDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('New Setlist'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: setlists.length,
            itemBuilder: (ctx, index) {
              final setlist = setlists[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isStage
                        ? AppColors.stageChord.withValues(alpha: 0.2)
                        : AppColors.primary.withValues(alpha: 0.12),
                    child: Icon(Icons.playlist_play,
                        color:
                            isStage ? AppColors.stageChord : AppColors.primary),
                  ),
                  title: Text(setlist.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(setlist.description ??
                      'Setlist • ${setlist.updatedAt.toLocal().toString().split(' ')[0]}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.push('/setlist/${setlist.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _createSetlistDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Setlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  labelText: 'Setlist Name (e.g. Sunday Morning)'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration:
                  const InputDecoration(labelText: 'Description / Event Notes'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (titleController.text.trim().isNotEmpty) {
                await ref.read(setlistRepositoryProvider).createSetlist(
                      title: titleController.text.trim(),
                      description: descController.text.trim(),
                    );
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
