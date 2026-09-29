import 'package:flutter/services.dart' show rootBundle;
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:chord_engine/chord_engine.dart';
import '../database/app_database.dart';

class SongRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  SongRepository(this._db);

  Stream<List<SongsTableData>> watchSongs() => _db.watchAllSongs();

  Future<List<SongsTableData>> getAllSongs() => _db.getAllSongs();

  Stream<SongsTableData?> watchSong(String id) => _db.watchSongById(id);

  Future<SongsTableData?> getSong(String id) => _db.getSongById(id);

  Stream<List<LyricVersionsTableData>> watchLyricVersions(String songId) =>
      _db.watchLyricVersions(songId);

  Stream<UserSongSettingsTableData?> watchUserSettings(String songId) =>
      _db.watchUserSettings(songId);

  Future<void> saveUserSettings({
    required String songId,
    String? preferredKey,
    int? preferredCapo,
    bool? displayNashville,
    bool? displayRoman,
    double? fontSize,
    double? autoScrollSpeed,
    String? selectedLyricVersionId,
  }) async {
    final existing = await _db.getUserSettings(songId);
    await _db.saveUserSettings(UserSongSettingsTableCompanion(
      songId: Value(songId),
      preferredKey: Value(preferredKey ?? existing?.preferredKey),
      preferredCapo: Value(preferredCapo ?? existing?.preferredCapo ?? 0),
      displayNashville: Value(displayNashville ?? existing?.displayNashville ?? false),
      displayRoman: Value(displayRoman ?? existing?.displayRoman ?? false),
      fontSize: Value(fontSize ?? existing?.fontSize ?? 16.0),
      autoScrollSpeed: Value(autoScrollSpeed ?? existing?.autoScrollSpeed ?? 1.0),
      selectedLyricVersionId: Value(selectedLyricVersionId ?? existing?.selectedLyricVersionId),
    ));
  }

  Future<String> saveSong({
    String? id,
    required String title,
    required String artist,
    String? originalKey,
    int capo = 0,
    int? tempo,
    String? timeSignature,
    required String chordProContent,
    String? sourceUrl,
    String? attribution,
    String? groupId,
  }) async {
    final songId = id ?? _uuid.v4();
    final now = DateTime.now();

    final companion = SongsTableCompanion(
      id: Value(songId),
      title: Value(title),
      artist: Value(artist),
      originalKey: Value(originalKey),
      currentKey: Value(originalKey),
      capo: Value(capo),
      tempo: Value(tempo),
      timeSignature: Value(timeSignature),
      chordProContent: Value(chordProContent),
      sourceUrl: Value(sourceUrl),
      attribution: Value(attribution),
      groupId: Value(groupId),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: const Value('pending_upload'),
      version: const Value(1),
    );

    await _db.insertSong(companion);
    return songId;
  }

  Future<void> addLyricVersion({
    required String songId,
    required String languageCode,
    required String languageName,
    required String content,
    bool isPrimary = false,
  }) async {
    await _db.insertLyricVersion(LyricVersionsTableCompanion(
      id: Value(_uuid.v4()),
      songId: Value(songId),
      languageCode: Value(languageCode),
      languageName: Value(languageName),
      content: Value(content),
      isPrimary: Value(isPrimary),
    ));
  }

  Future<void> deleteSong(String id) => _db.deleteSong(id);

  /// Seeds the local database with the 5 demonstration songs on first run
  Future<void> seedInitialSongsIfEmpty() async {
    final existing = await _db.getAllSongs();
    if (existing.isEmpty) {
      final seedFiles = [
        'assets/seed_songs/01_amazing_grace.chordpro',
        'assets/seed_songs/02_hotel_california.chordpro',
        'assets/seed_songs/03_telugu_aanandham.chordpro',
        'assets/seed_songs/04_telugu_krupa.chordpro',
        'assets/seed_songs/05_telugu_sthuthi_paadeda.chordpro',
      ];

      for (final assetPath in seedFiles) {
        try {
          final content = await rootBundle.loadString(assetPath);
          final parsed = ChordProParser.parse(content);
          final songId = await saveSong(
            title: parsed.title,
            artist: parsed.artist,
            originalKey: parsed.originalKey?.toString(),
            capo: parsed.capo,
            tempo: parsed.tempo,
            timeSignature: parsed.timeSignature,
            chordProContent: content,
            attribution: 'Public Domain / Demonstrative Music',
          );

          // For Telugu songs, also create a transliterated English version
          if (assetPath.contains('krupa')) {
            await addLyricVersion(
              songId: songId,
              languageCode: 'te',
              languageName: 'తెలుగు (Telugu)',
              content: content,
              isPrimary: true,
            );

            const transliterated = '''
{title: Krupa Choopina Deva}
{artist: Joshua Aaron & Telugu Translation}
{key: C}

{start_of_chorus: Chorus}
[C]Krupa choopina [G]Deva [Am]sthothramu
[F]Nanu preminchina [C]Yesa [G]vandhanam
[C]Krupa choopina [G]Deva [Am]sthothramu
[F]Nanu aadharinchina [G]Thandri [C]vandhanam
{end_of_chorus}

{start_of_verse: Verse 1}
[C]Ye yogyatha leni [Am]nannu
Nee [F]krupalo daachina [G]vaadavu
[Dm]Nee krupa lenicho [G]nenundalenu
[F]Nee prema lenicho [G]ne brathuka[C]lenu
{end_of_verse}
''';
            await addLyricVersion(
              songId: songId,
              languageCode: 'te-latn',
              languageName: 'Telugu (English Letters)',
              content: transliterated,
              isPrimary: false,
            );
          }
        } catch (e) {
          // Continue if any seed fails
        }
      }
    }

    // Always seed default playlists/setlists if setlists table is empty
    await seedInitialSetlistsIfEmpty();
  }

  /// Seeds default playlists/setlists so users can immediately test setlists
  Future<void> seedInitialSetlistsIfEmpty() async {
    try {
      final existingSetlists = await _db.getAllSetlists();
      if (existingSetlists.isNotEmpty) return;

      final allSongs = await _db.getAllSongs();
      if (allSongs.isEmpty) return;

      SongsTableData findSong(String query, int fallbackIndex) {
        final match = allSongs.where((s) =>
            s.title.toLowerCase().contains(query.toLowerCase()) ||
            s.artist.toLowerCase().contains(query.toLowerCase())).firstOrNull;
        if (match != null) return match;
        return allSongs[fallbackIndex.clamp(0, allSongs.length - 1)];
      }

      final amazingGrace = findSong('Grace', 0);
      final krupa = findSong('krupa', 3);
      final aanandham = findSong('aanandham', 2);
      final hotel = findSong('california', 1);
      final sthuthi = findSong('sthuthi', 4);

      final now = DateTime.now();

      // Playlist 1: Sunday Worship Gathering
      final setlist1Id = _uuid.v4();
      await _db.insertSetlist(SetlistsTableCompanion(
        id: Value(setlist1Id),
        title: const Value('Sunday Worship Gathering'),
        description: const Value('3 Songs • Acoustic worship & celebration order'),
        createdAt: Value(now),
        updatedAt: Value(now),
      ));

      await _db.insertSetlistItem(SetlistItemsTableCompanion(
        id: Value(_uuid.v4()),
        setlistId: Value(setlist1Id),
        songId: Value(amazingGrace.id),
        sortOrder: const Value(1),
        keyOverride: const Value('G'),
        notes: const Value('Gentle acoustic guitar opening, tempo 74 BPM'),
        estimatedDurationSeconds: const Value(240),
      ));

      await _db.insertSetlistItem(SetlistItemsTableCompanion(
        id: Value(_uuid.v4()),
        setlistId: Value(setlist1Id),
        songId: Value(krupa.id),
        sortOrder: const Value(2),
        keyOverride: const Value('C'),
        notes: const Value('Pad swell intro, full band worship chorus'),
        estimatedDurationSeconds: const Value(300),
      ));

      await _db.insertSetlistItem(SetlistItemsTableCompanion(
        id: Value(_uuid.v4()),
        setlistId: Value(setlist1Id),
        songId: Value(aanandham.id),
        sortOrder: const Value(3),
        keyOverride: const Value('D'),
        notes: const Value('Upbeat celebration closing at 112 BPM'),
        estimatedDurationSeconds: const Value(210),
      ));

      // Playlist 2: Acoustic Band Rehearsal
      final setlist2Id = _uuid.v4();
      await _db.insertSetlist(SetlistsTableCompanion(
        id: Value(setlist2Id),
        title: const Value('Acoustic Band Rehearsal'),
        description: const Value('2 Songs • Live performance showcase repertoire'),
        createdAt: Value(now),
        updatedAt: Value(now),
      ));

      await _db.insertSetlistItem(SetlistItemsTableCompanion(
        id: Value(_uuid.v4()),
        setlistId: Value(setlist2Id),
        songId: Value(hotel.id),
        sortOrder: const Value(1),
        keyOverride: const Value('Bm'),
        capoOverride: const Value(7),
        notes: const Value('12-string guitar intro with Capo 7'),
        estimatedDurationSeconds: const Value(390),
      ));

      await _db.insertSetlistItem(SetlistItemsTableCompanion(
        id: Value(_uuid.v4()),
        setlistId: Value(setlist2Id),
        songId: Value(sthuthi.id),
        sortOrder: const Value(2),
        keyOverride: const Value('G'),
        notes: const Value('Vocal harmonies on bridge and chorus'),
        estimatedDurationSeconds: const Value(270),
      ));
    } catch (_) {
      // Continue without crashing if seeding setlists fails
    }
  }
}
