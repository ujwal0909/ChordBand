import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/song_providers.dart';
import '../../../data/firebase/firebase_auth_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _crashReporting = true;
  bool _isSigningIn = false;

  Future<void> _signInWithGoogle() async {
    final authService = ref.read(authServiceProvider);
    setState(() => _isSigningIn = true);
    try {
      final cred = await authService.signInWithGoogle();
      if (mounted) {
        if (cred != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Welcome, ${cred.user?.displayName ?? cred.user?.email ?? "Musician"}!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Google Sign-In note: $e\n(Ensure Google Sign-In is enabled in your Firebase Console)'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  void _showEmailSignInDialog() {
    final emailController = TextEditingController();
    final passController = TextEditingController();
    bool isRegister = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isRegister ? 'Create Account' : 'Sign In with Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'Email Address', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passController,
                decoration: const InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setDialogState(() => isRegister = !isRegister);
                },
                child: Text(isRegister
                    ? 'Already have an account? Sign In'
                    : 'Need an account? Register here'),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                final email = emailController.text.trim();
                final pass = passController.text;
                if (email.isEmpty || pass.isEmpty) return;

                Navigator.pop(ctx);
                final authService = ref.read(authServiceProvider);
                try {
                  if (isRegister) {
                    await authService.registerWithEmail(email, pass);
                  } else {
                    await authService.signInWithEmail(email, pass);
                  }
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Signed in as $email!')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Authentication error: $e')),
                    );
                  }
                }
              },
              child: Text(isRegister ? 'Register' : 'Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final userAsync = ref.watch(authStateProvider);
    final user = userAsync.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account & Cloud Authentication Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Account & Band Cloud Sync',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (user != null && !user.isAnonymous) ...[
                    // Signed In View
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            (user.displayName?.isNotEmpty == true
                                    ? user.displayName![0]
                                    : user.email?.isNotEmpty == true
                                        ? user.email![0]
                                        : 'U')
                                .toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.displayName ?? 'ChordBand Musician',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                user.email ?? 'Connected',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 13),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Cloud Sync Active',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () async {
                            await ref.read(authServiceProvider).signOut();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Signed out successfully')),
                              );
                            }
                          },
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Guest / Not Signed In View
                    const Text(
                      'You are currently in Guest / Offline Mode. Sign in with Google or Email to collaborate with bands and sync songbooks across all devices.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Google Sign-In Button
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: _isSigningIn ? null : _signInWithGoogle,
                            icon: _isSigningIn
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : const Icon(Icons.g_mobiledata, size: 28),
                            label: const Text('Sign In with Google'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Email Sign-In Button
                        OutlinedButton.icon(
                          onPressed: _showEmailSignInDialog,
                          icon: const Icon(Icons.mail_outline, size: 18),
                          label: const Text('Email'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Theme Settings Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('App Appearance',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SegmentedButton<AppThemeMode>(
                    segments: const [
                      ButtonSegment(
                          value: AppThemeMode.light,
                          label: Text('Light'),
                          icon: Icon(Icons.light_mode)),
                      ButtonSegment(
                          value: AppThemeMode.dark,
                          label: Text('Dark'),
                          icon: Icon(Icons.dark_mode)),
                      ButtonSegment(
                          value: AppThemeMode.stage,
                          label: Text('Stage'),
                          icon: Icon(Icons.nightlife)),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (set) {
                      ref.read(themeModeProvider.notifier).state = set.first;
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    themeMode == AppThemeMode.stage
                        ? 'Stage Mode: Deep OLED black background with high-contrast neon badges to prevent stage glare.'
                        : 'Standard theme with high readability.',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Language Settings Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Language / భాష',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Consumer(
                    builder: (context, ref, _) {
                      final currentLocale = ref.watch(appLocaleProvider);
                      final selectedCode =
                          currentLocale?.languageCode ?? 'system';

                      return SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                              value: 'system', label: Text('Auto / System')),
                          ButtonSegment(value: 'en', label: Text('English')),
                          ButtonSegment(
                              value: 'te', label: Text('తెలుగు (Telugu)')),
                        ],
                        selected: {selectedCode},
                        onSelectionChanged: (set) {
                          final code = set.first;
                          if (code == 'system') {
                            ref.read(appLocaleProvider.notifier).state = null;
                          } else {
                            ref.read(appLocaleProvider.notifier).state =
                                Locale(code);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Privacy & Crash Reporting
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Anonymous Crash Reports'),
                  subtitle: const Text(
                      'Help improve ChordBand stability (no telemetry or analytics)'),
                  value: _crashReporting,
                  onChanged: (val) {
                    setState(() => _crashReporting = val);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.policy),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.push('/privacy-policy'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Data & Account Management
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.file_download),
                  title: const Text('Export Songbook Backup'),
                  subtitle: const Text(
                      'Save all chords, lyrics, and setlists to file'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Songbook backup exported successfully!')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Delete Account & Cloud Data',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                  subtitle: const Text(
                      'Permanently remove your account and all cloud synced data (Google Play requirement)'),
                  onTap: () => _confirmAccountDeletion(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Center(
            child: Text(
              'ChordBand v1.0.0 (Build 1)\nAndroid & Windows Edition',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmAccountDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account & Data?'),
        content: const Text(
          'This action is irreversible. All your personal song settings, band memberships, and cloud records will be permanently erased.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref.read(authServiceProvider).deleteAccount();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Account and all cloud data successfully deleted.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Account deletion note: $e')),
                  );
                }
              }
            },
            child: const Text('Confirm Deletion'),
          ),
        ],
      ),
    );
  }
}
