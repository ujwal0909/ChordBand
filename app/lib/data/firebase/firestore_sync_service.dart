import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../../presentation/providers/song_providers.dart';

enum SyncState { idle, syncing, offline, error }

final firestoreInstanceProvider = Provider<FirebaseFirestore?>((ref) {
  try {
    return FirebaseFirestore.instance;
  } catch (e) {
    debugPrint('FirebaseFirestore not available: $e');
    return null;
  }
});

final firestoreSyncServiceProvider = Provider<FirestoreSyncService>((ref) {
  final db = ref.watch(databaseProvider);
  final firestore = ref.watch(firestoreInstanceProvider);
  return FirestoreSyncService(db, firestore: firestore);
});

class FirestoreSyncService {
  final AppDatabase _db;
  final FirebaseFirestore? _firestore;
  SyncState _state = SyncState.idle;

  FirestoreSyncService(this._db, {FirebaseFirestore? firestore})
      : _firestore = firestore;

  SyncState get state => _state;
  bool get hasFirestore => _firestore != null;

  /// Sync pending local offline modifications with Cloud Firestore
  Future<void> syncPendingLocalChanges(
      {String? groupId, String? userId}) async {
    _state = SyncState.syncing;
    try {
      final songs = await _db.getAllSongs();
      final pendingUploads =
          songs.where((s) => s.syncStatus == 'pending_upload').toList();

      for (final song in pendingUploads) {
        final targetGroupId = groupId ?? song.groupId;

        // If Cloud Firestore is configured and connected, upload the song document
        if (_firestore != null &&
            targetGroupId != null &&
            targetGroupId.isNotEmpty) {
          final songDoc = _firestore!
              .collection('bands')
              .doc(targetGroupId)
              .collection('songs')
              .doc(song.id);

          await songDoc.set({
            'title': song.title,
            'artist': song.artist,
            'originalKey': song.originalKey,
            'currentKey': song.currentKey,
            'capo': song.capo,
            'tempo': song.tempo,
            'timeSignature': song.timeSignature,
            'chordProContent': song.chordProContent,
            'sourceUrl': song.sourceUrl,
            'attribution': song.attribution,
            'groupId': targetGroupId,
            'version': song.version + 1,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          // Write audit log entry in Firestore
          await _firestore!
              .collection('bands')
              .doc(targetGroupId)
              .collection('auditLogs')
              .add({
            'entityType': 'song',
            'entityId': song.id,
            'action': 'sync_upload',
            'userId': userId ?? 'local_user',
            'userName': 'Musician',
            'timestamp': FieldValue.serverTimestamp(),
            'details': 'Synced song "${song.title}" with cloud songbook',
          });
        }

        // Record audit entry in local Drift DB
        await _db.insertAuditLog(AuditLogsTableCompanion(
          id: Value('audit_${DateTime.now().millisecondsSinceEpoch}'),
          entityType: const Value('song'),
          entityId: Value(song.id),
          action: const Value('sync_upload'),
          userId: Value(userId ?? 'local_user'),
          userName: const Value('Musician'),
          timestamp: Value(DateTime.now()),
          details: Value('Synced song "${song.title}" with cloud songbook'),
        ));

        // Mark as synced locally
        await _db.updateSong(SongsTableCompanion(
          id: Value(song.id),
          title: Value(song.title),
          artist: Value(song.artist),
          originalKey: Value(song.originalKey),
          currentKey: Value(song.currentKey),
          capo: Value(song.capo),
          tempo: Value(song.tempo),
          timeSignature: Value(song.timeSignature),
          chordProContent: Value(song.chordProContent),
          sourceUrl: Value(song.sourceUrl),
          attribution: Value(song.attribution),
          groupId: Value(targetGroupId),
          createdAt: Value(song.createdAt),
          updatedAt: Value(DateTime.now()),
          syncStatus: const Value('synced'),
          version: Value(song.version + 1),
        ));
      }

      _state = SyncState.idle;
    } catch (e) {
      debugPrint('FirestoreSyncService error: $e');
      _state = SyncState.error;
    }
  }

  /// Merges remote song from Firestore into local Drift SQLite cache
  Future<void> mergeRemoteSong({
    required String id,
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
    required DateTime remoteUpdatedAt,
    required int remoteVersion,
  }) async {
    final localSong = await _db.getSongById(id);

    // Conflict Resolution: Last-Write-Wins with version tracking
    if (localSong != null) {
      if (localSong.syncStatus == 'pending_upload' &&
          localSong.updatedAt.isAfter(remoteUpdatedAt)) {
        // Local has newer un-synced edits: preserve local, keep pending
        return;
      }
    }

    // Insert or update into local Drift cache
    await _db.insertSong(SongsTableCompanion(
      id: Value(id),
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
      createdAt: Value(localSong?.createdAt ?? remoteUpdatedAt),
      updatedAt: Value(remoteUpdatedAt),
      syncStatus: const Value('synced'),
      version: Value(remoteVersion),
    ));
  }

  /// Subscribe to remote band song changes in real-time
  StreamSubscription? subscribeToBandSongs(String groupId) {
    if (_firestore == null) return null;

    return _firestore!
        .collection('bands')
        .doc(groupId)
        .collection('songs')
        .snapshots()
        .listen((snapshot) {
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) {
          final data = change.doc.data();
          if (data != null) {
            final updatedAtTimestamp = data['updatedAt'] as Timestamp?;
            final updatedAt = updatedAtTimestamp?.toDate() ?? DateTime.now();

            mergeRemoteSong(
              id: change.doc.id,
              title: data['title'] ?? 'Untitled',
              artist: data['artist'] ?? 'Unknown Artist',
              originalKey: data['originalKey'],
              capo: (data['capo'] as num?)?.toInt() ?? 0,
              tempo: (data['tempo'] as num?)?.toInt(),
              timeSignature: data['timeSignature'],
              chordProContent: data['chordProContent'] ?? '',
              sourceUrl: data['sourceUrl'],
              attribution: data['attribution'],
              groupId: groupId,
              remoteUpdatedAt: updatedAt,
              remoteVersion: (data['version'] as num?)?.toInt() ?? 1,
            );
          }
        }
      }
    });
  }

  /// Follow-the-Leader: Leader broadcasts current song position
  Future<void> broadcastLiveState({
    required String sessionId,
    required String songId,
    required String songTitle,
    required int sectionIndex,
    required String currentKey,
    required int tempo,
  }) async {
    if (_firestore == null) return;
    try {
      await _firestore!.collection('live_sessions').doc(sessionId).set({
        'songId': songId,
        'songTitle': songTitle,
        'sectionIndex': sectionIndex,
        'currentKey': currentKey,
        'tempo': tempo,
        'lastBeatTimestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Failed to broadcast live session state: $e');
    }
  }

  /// Follow-the-Leader: Band members listen to session in real-time
  Stream<Map<String, dynamic>?>? listenToLiveSession(String sessionId) {
    if (_firestore == null) return null;
    return _firestore!
        .collection('live_sessions')
        .doc(sessionId)
        .snapshots()
        .map((snap) => snap.data());
  }
}
