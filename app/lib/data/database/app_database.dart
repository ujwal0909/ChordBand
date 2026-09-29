import 'package:drift/drift.dart';
import 'connection/connection.dart' as impl;

part 'app_database.g.dart';

class SongsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get artist => text()();
  TextColumn get originalKey => text().nullable()();
  TextColumn get currentKey => text().nullable()();
  IntColumn get capo => integer().withDefault(const Constant(0))();
  IntColumn get tempo => integer().nullable()();
  TextColumn get timeSignature => text().nullable()();
  TextColumn get chordProContent => text()();
  TextColumn get sourceUrl => text().nullable()();
  TextColumn get attribution => text().nullable()();
  TextColumn get groupId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

class LyricVersionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get songId => text()();
  TextColumn get languageCode => text()(); // 'en', 'te', 'te-latn'
  TextColumn get languageName =>
      text()(); // 'English', 'తెలుగు', 'Telugu (English script)'
  TextColumn get content =>
      text()(); // ChordPro formatted content in this script
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class SetlistsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get groupId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class SetlistItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get setlistId => text()();
  TextColumn get songId => text()();
  IntColumn get sortOrder => integer()();
  TextColumn get keyOverride => text().nullable()();
  IntColumn get capoOverride => integer().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get estimatedDurationSeconds =>
      integer().withDefault(const Constant(240))();

  @override
  Set<Column> get primaryKey => {id};
}

class UserSongSettingsTable extends Table {
  TextColumn get songId => text()();
  TextColumn get preferredKey => text().nullable()();
  IntColumn get preferredCapo => integer().withDefault(const Constant(0))();
  BoolColumn get displayNashville =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get displayRoman => boolean().withDefault(const Constant(false))();
  RealColumn get fontSize => real().withDefault(const Constant(16.0))();
  RealColumn get autoScrollSpeed => real().withDefault(const Constant(1.0))();
  TextColumn get selectedLyricVersionId => text().nullable()();

  @override
  Set<Column> get primaryKey => {songId};
}

class BandGroupsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get role => text()
      .withDefault(const Constant('owner'))(); // owner, admin, editor, viewer
  TextColumn get inviteCode => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class AuditLogsTable extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()(); // 'song', 'setlist', 'group'
  TextColumn get entityId => text()();
  TextColumn get action => text()(); // 'create', 'update', 'delete'
  TextColumn get userId => text()();
  TextColumn get userName => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get details => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  SongsTable,
  LyricVersionsTable,
  SetlistsTable,
  SetlistItemsTable,
  UserSongSettingsTable,
  BandGroupsTable,
  AuditLogsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? impl.openConnection());

  @override
  int get schemaVersion => 1;

  // Song Queries
  Future<List<SongsTableData>> getAllSongs() =>
      (select(songsTable)..orderBy([(t) => OrderingTerm(expression: t.title)]))
          .get();

  Stream<List<SongsTableData>> watchAllSongs() =>
      (select(songsTable)..orderBy([(t) => OrderingTerm(expression: t.title)]))
          .watch();

  Future<SongsTableData?> getSongById(String id) =>
      (select(songsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<SongsTableData?> watchSongById(String id) =>
      (select(songsTable)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<int> insertSong(SongsTableCompanion song) =>
      into(songsTable).insert(song, mode: InsertMode.insertOrReplace);

  Future<bool> updateSong(SongsTableCompanion song) =>
      update(songsTable).replace(song);

  Future<int> deleteSong(String id) async {
    await (delete(lyricVersionsTable)..where((t) => t.songId.equals(id))).go();
    await (delete(userSongSettingsTable)..where((t) => t.songId.equals(id)))
        .go();
    await (delete(setlistItemsTable)..where((t) => t.songId.equals(id))).go();
    return (delete(songsTable)..where((t) => t.id.equals(id))).go();
  }

  // Lyric Version Queries
  Future<List<LyricVersionsTableData>> getLyricVersions(String songId) =>
      (select(lyricVersionsTable)..where((t) => t.songId.equals(songId))).get();

  Stream<List<LyricVersionsTableData>> watchLyricVersions(String songId) =>
      (select(lyricVersionsTable)..where((t) => t.songId.equals(songId)))
          .watch();

  Future<int> insertLyricVersion(LyricVersionsTableCompanion version) =>
      into(lyricVersionsTable)
          .insert(version, mode: InsertMode.insertOrReplace);

  // User Song Settings
  Future<UserSongSettingsTableData?> getUserSettings(String songId) =>
      (select(userSongSettingsTable)..where((t) => t.songId.equals(songId)))
          .getSingleOrNull();

  Stream<UserSongSettingsTableData?> watchUserSettings(String songId) =>
      (select(userSongSettingsTable)..where((t) => t.songId.equals(songId)))
          .watchSingleOrNull();

  Future<int> saveUserSettings(UserSongSettingsTableCompanion settings) =>
      into(userSongSettingsTable)
          .insert(settings, mode: InsertMode.insertOrReplace);

  // Setlists
  Future<List<SetlistsTableData>> getAllSetlists() =>
      (select(setlistsTable)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .get();

  Stream<List<SetlistsTableData>> watchAllSetlists() =>
      (select(setlistsTable)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  Future<SetlistsTableData?> getSetlistById(String id) =>
      (select(setlistsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertSetlist(SetlistsTableCompanion setlist) =>
      into(setlistsTable).insert(setlist, mode: InsertMode.insertOrReplace);

  Future<int> deleteSetlist(String id) async {
    await (delete(setlistItemsTable)..where((t) => t.setlistId.equals(id)))
        .go();
    return (delete(setlistsTable)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<SetlistItemsTableData>> watchSetlistItems(String setlistId) =>
      (select(setlistItemsTable)
            ..where((t) => t.setlistId.equals(setlistId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<int> insertSetlistItem(SetlistItemsTableCompanion item) =>
      into(setlistItemsTable).insert(item, mode: InsertMode.insertOrReplace);

  Future<int> deleteSetlistItem(String itemId) =>
      (delete(setlistItemsTable)..where((t) => t.id.equals(itemId))).go();

  // Band Groups
  Stream<List<BandGroupsTableData>> watchGroups() =>
      select(bandGroupsTable).watch();

  Future<int> insertGroup(BandGroupsTableCompanion group) =>
      into(bandGroupsTable).insert(group, mode: InsertMode.insertOrReplace);

  Future<int> deleteGroup(String groupId) =>
      (delete(bandGroupsTable)..where((t) => t.id.equals(groupId))).go();

  // Audit Logs
  Future<int> insertAuditLog(AuditLogsTableCompanion log) =>
      into(auditLogsTable).insert(log);

  Stream<List<AuditLogsTableData>> watchAuditLogs(String entityId) =>
      (select(auditLogsTable)
            ..where((t) => t.entityId.equals(entityId))
            ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
          .watch();
}
