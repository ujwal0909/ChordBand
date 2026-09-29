import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/song_providers.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (graceful fallback if offline or unconfigured)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully for ChordBand');
  } catch (e) {
    debugPrint(
        'Firebase initialization skipped or in offline fallback mode: $e');
  }

  // Create ProviderContainer to seed songs before starting UI
  final container = ProviderContainer();
  try {
    final songRepo = container.read(songRepositoryProvider);
    await songRepo.seedInitialSongsIfEmpty();
  } catch (e) {
    debugPrint('Database seeding error: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ChordBandApp(),
    ),
  );
}

class ChordBandApp extends ConsumerWidget {
  const ChordBandApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    ThemeData theme;
    switch (themeMode) {
      case AppThemeMode.light:
        theme = AppTheme.lightTheme;
        break;
      case AppThemeMode.dark:
        theme = AppTheme.darkTheme;
        break;
      case AppThemeMode.stage:
        theme = AppTheme.stageTheme;
        break;
    }

    final locale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: 'ChordBand',
      debugShowCheckedModeBanner: false,
      theme: theme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }
}
