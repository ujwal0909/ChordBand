import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/song_providers.dart';

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isStage = themeMode == AppThemeMode.stage;
    final primaryAccent = isStage ? AppColors.stageChord : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bands & Shared Songbooks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            tooltip: 'Create Band',
            onPressed: () => _createBandDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Step-by-Step Instructions Banner
          Card(
            color: Colors.blue.withOpacity(0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text('How Band Collaboration Works', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Create or select a band group below.\n2. Tap "Share Invite Code" or show the QR code to musicians.\n3. Songs, setlists, and edits sync automatically between all devices via Cloud Firestore.',
                    style: TextStyle(fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: () => context.push('/live'),
                        icon: const Icon(Icons.podcasts, size: 16),
                        label: const Text('Go to Live Stage Broadcast Mode', style: TextStyle(fontSize: 12)),
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Band Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryAccent.withOpacity(0.2),
                            child: Icon(Icons.music_video, color: primaryAccent),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('The Sunday Collective', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('Role: Band Leader (Owner)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.qr_code_2),
                        tooltip: 'Invite via QR Code',
                        onPressed: () => _showInviteQrDialog(context, 'BAND-7829-SUN'),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text('Permissions & Members:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  _buildMemberTile('Ujwal (You)', 'Owner / Leader', Icons.star),
                  _buildMemberTile('David', 'Editor (Chords & Lyrics)', Icons.edit),
                  _buildMemberTile('Sarah', 'Viewer (Musician)', Icons.visibility),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showInviteQrDialog(context, 'BAND-7829-SUN'),
                          icon: const Icon(Icons.share),
                          label: const Text('Share Invite Code'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(String name, String role, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(role, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  void _showInviteQrDialog(BuildContext context, String inviteCode) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invite Band Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Scan this QR code with the ChordBand app on any device:'),
            const SizedBox(height: 16),
            SizedBox(
              width: 180,
              height: 180,
              child: QrImageView(
                data: 'chordband://join?code=$inviteCode',
                version: QrVersions.auto,
                size: 180.0,
              ),
            ),
            const SizedBox(height: 16),
            SelectableText(
              'Invite Code: $inviteCode',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _createBandDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Band / Group'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Band Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
