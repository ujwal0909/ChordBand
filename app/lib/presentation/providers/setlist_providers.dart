import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import 'song_providers.dart';

class SetlistRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  SetlistRepository(this._db);

  Stream<List<SetlistsTableData>> watchSetlists() => _db.watchAllSetlists();

  Future<SetlistsTableData?> getSetlist(String id) => _db.getSetlistById(id);

  Stream<List<SetlistItemsTableData>> watchSetlistItems(String setlistId) =>
      _db.watchSetlistItems(setlistId);

  Future<String> createSetlist({required String title, String? description, String? groupId}) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db.insertSetlist(SetlistsTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      groupId: Value(groupId),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
    return id;
  }

  Future<void> addSongToSetlist({
    required String setlistId,
    required String songId,
    required int sortOrder,
    String? keyOverride,
    int? capoOverride,
    String? notes,
  }) async {
    await _db.insertSetlistItem(SetlistItemsTableCompanion(
      id: Value(_uuid.v4()),
      setlistId: Value(setlistId),
      songId: Value(songId),
      sortOrder: Value(sortOrder),
      keyOverride: Value(keyOverride),
      capoOverride: Value(capoOverride),
      notes: Value(notes),
      estimatedDurationSeconds: const Value(240),
    ));
  }

  Future<void> deleteSetlistItem(String itemId) => _db.deleteSetlistItem(itemId);

  Future<void> deleteSetlist(String id) => _db.deleteSetlist(id);
}

final setlistRepositoryProvider = Provider<SetlistRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SetlistRepository(db);
});

final allSetlistsStreamProvider = StreamProvider<List<SetlistsTableData>>((ref) {
  final repo = ref.watch(setlistRepositoryProvider);
  return repo.watchSetlists();
});

final setlistItemsStreamProvider =
    StreamProvider.family<List<SetlistItemsTableData>, String>((ref, setlistId) {
  final repo = ref.watch(setlistRepositoryProvider);
  return repo.watchSetlistItems(setlistId);
});
