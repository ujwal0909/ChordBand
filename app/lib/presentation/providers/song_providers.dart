import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/song_repository.dart';
import '../../core/theme/app_theme.dart';

// Database Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// Song Repository Provider
final songRepositoryProvider = Provider<SongRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SongRepository(db);
});

// Theme Mode Provider (Light, Dark, Stage)
final themeModeProvider =
    StateProvider<AppThemeMode>((ref) => AppThemeMode.dark);

// App Locale Provider (null for system, 'en', 'te')
final appLocaleProvider = StateProvider<Locale?>((ref) => null);

// Search Query Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filter Key Provider
final filterKeyProvider = StateProvider<String?>((ref) => null);

// All Songs Stream Provider
final allSongsStreamProvider = StreamProvider<List<SongsTableData>>((ref) {
  final repo = ref.watch(songRepositoryProvider);
  return repo.watchSongs();
});

// Filtered Songs Provider
final filteredSongsProvider = Provider<AsyncValue<List<SongsTableData>>>((ref) {
  final songsAsync = ref.watch(allSongsStreamProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final filterKey = ref.watch(filterKeyProvider);

  return songsAsync.whenData((songs) {
    return songs.where((s) {
      final matchesQuery = query.isEmpty ||
          s.title.toLowerCase().contains(query) ||
          s.artist.toLowerCase().contains(query) ||
          s.chordProContent.toLowerCase().contains(query);

      final matchesKey = filterKey == null ||
          s.originalKey?.toLowerCase() == filterKey.toLowerCase() ||
          s.currentKey?.toLowerCase() == filterKey.toLowerCase();

      return matchesQuery && matchesKey;
    }).toList();
  });
});

// Single Song Watcher
final singleSongStreamProvider =
    StreamProvider.family<SongsTableData?, String>((ref, songId) {
  final repo = ref.watch(songRepositoryProvider);
  return repo.watchSong(songId);
});

// Lyric Versions Watcher
final lyricVersionsStreamProvider =
    StreamProvider.family<List<LyricVersionsTableData>, String>((ref, songId) {
  final repo = ref.watch(songRepositoryProvider);
  return repo.watchLyricVersions(songId);
});

// User Song Settings Watcher
final userSongSettingsStreamProvider =
    StreamProvider.family<UserSongSettingsTableData?, String>((ref, songId) {
  final repo = ref.watch(songRepositoryProvider);
  return repo.watchUserSettings(songId);
});
