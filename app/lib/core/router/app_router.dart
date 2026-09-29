import 'package:go_router/go_router.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/song_viewer/song_viewer_screen.dart';
import '../../presentation/screens/song_editor/song_edit_screen.dart';
import '../../presentation/screens/setlists/setlists_screen.dart';
import '../../presentation/screens/setlists/setlist_detail_screen.dart';
import '../../presentation/screens/live_band/live_band_screen.dart';
import '../../presentation/screens/groups/groups_screen.dart';
import '../../presentation/screens/import_export/import_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/settings/privacy_policy_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/song/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return SongViewerScreen(songId: id);
      },
    ),
    GoRoute(
      path: '/song/:id/edit',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return SongEditScreen(songId: id);
      },
    ),
    GoRoute(
      path: '/setlists',
      builder: (context, state) => const SetlistsScreen(),
    ),
    GoRoute(
      path: '/setlist/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return SetlistDetailScreen(setlistId: id);
      },
    ),
    GoRoute(
      path: '/live',
      builder: (context, state) => const LiveBandScreen(),
    ),
    GoRoute(
      path: '/groups',
      builder: (context, state) => const GroupsScreen(),
    ),
    GoRoute(
      path: '/import',
      builder: (context, state) => const ImportScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
  ],
);
