// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SongsTableTable extends SongsTable
    with TableInfo<$SongsTableTable, SongsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
      'artist', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originalKeyMeta =
      const VerificationMeta('originalKey');
  @override
  late final GeneratedColumn<String> originalKey = GeneratedColumn<String>(
      'original_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currentKeyMeta =
      const VerificationMeta('currentKey');
  @override
  late final GeneratedColumn<String> currentKey = GeneratedColumn<String>(
      'current_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _capoMeta = const VerificationMeta('capo');
  @override
  late final GeneratedColumn<int> capo = GeneratedColumn<int>(
      'capo', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _tempoMeta = const VerificationMeta('tempo');
  @override
  late final GeneratedColumn<int> tempo = GeneratedColumn<int>(
      'tempo', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _timeSignatureMeta =
      const VerificationMeta('timeSignature');
  @override
  late final GeneratedColumn<String> timeSignature = GeneratedColumn<String>(
      'time_signature', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chordProContentMeta =
      const VerificationMeta('chordProContent');
  @override
  late final GeneratedColumn<String> chordProContent = GeneratedColumn<String>(
      'chord_pro_content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceUrlMeta =
      const VerificationMeta('sourceUrl');
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
      'source_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _attributionMeta =
      const VerificationMeta('attribution');
  @override
  late final GeneratedColumn<String> attribution = GeneratedColumn<String>(
      'attribution', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('synced'));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        artist,
        originalKey,
        currentKey,
        capo,
        tempo,
        timeSignature,
        chordProContent,
        sourceUrl,
        attribution,
        groupId,
        createdAt,
        updatedAt,
        syncStatus,
        version
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'songs_table';
  @override
  VerificationContext validateIntegrity(Insertable<SongsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('artist')) {
      context.handle(_artistMeta,
          artist.isAcceptableOrUnknown(data['artist']!, _artistMeta));
    } else if (isInserting) {
      context.missing(_artistMeta);
    }
    if (data.containsKey('original_key')) {
      context.handle(
          _originalKeyMeta,
          originalKey.isAcceptableOrUnknown(
              data['original_key']!, _originalKeyMeta));
    }
    if (data.containsKey('current_key')) {
      context.handle(
          _currentKeyMeta,
          currentKey.isAcceptableOrUnknown(
              data['current_key']!, _currentKeyMeta));
    }
    if (data.containsKey('capo')) {
      context.handle(
          _capoMeta, capo.isAcceptableOrUnknown(data['capo']!, _capoMeta));
    }
    if (data.containsKey('tempo')) {
      context.handle(
          _tempoMeta, tempo.isAcceptableOrUnknown(data['tempo']!, _tempoMeta));
    }
    if (data.containsKey('time_signature')) {
      context.handle(
          _timeSignatureMeta,
          timeSignature.isAcceptableOrUnknown(
              data['time_signature']!, _timeSignatureMeta));
    }
    if (data.containsKey('chord_pro_content')) {
      context.handle(
          _chordProContentMeta,
          chordProContent.isAcceptableOrUnknown(
              data['chord_pro_content']!, _chordProContentMeta));
    } else if (isInserting) {
      context.missing(_chordProContentMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(_sourceUrlMeta,
          sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta));
    }
    if (data.containsKey('attribution')) {
      context.handle(
          _attributionMeta,
          attribution.isAcceptableOrUnknown(
              data['attribution']!, _attributionMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SongsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SongsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      artist: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist'])!,
      originalKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}original_key']),
      currentKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_key']),
      capo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}capo'])!,
      tempo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tempo']),
      timeSignature: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time_signature']),
      chordProContent: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}chord_pro_content'])!,
      sourceUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_url']),
      attribution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attribution']),
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $SongsTableTable createAlias(String alias) {
    return $SongsTableTable(attachedDatabase, alias);
  }
}

class SongsTableData extends DataClass implements Insertable<SongsTableData> {
  final String id;
  final String title;
  final String artist;
  final String? originalKey;
  final String? currentKey;
  final int capo;
  final int? tempo;
  final String? timeSignature;
  final String chordProContent;
  final String? sourceUrl;
  final String? attribution;
  final String? groupId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  final int version;
  const SongsTableData(
      {required this.id,
      required this.title,
      required this.artist,
      this.originalKey,
      this.currentKey,
      required this.capo,
      this.tempo,
      this.timeSignature,
      required this.chordProContent,
      this.sourceUrl,
      this.attribution,
      this.groupId,
      required this.createdAt,
      required this.updatedAt,
      required this.syncStatus,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['artist'] = Variable<String>(artist);
    if (!nullToAbsent || originalKey != null) {
      map['original_key'] = Variable<String>(originalKey);
    }
    if (!nullToAbsent || currentKey != null) {
      map['current_key'] = Variable<String>(currentKey);
    }
    map['capo'] = Variable<int>(capo);
    if (!nullToAbsent || tempo != null) {
      map['tempo'] = Variable<int>(tempo);
    }
    if (!nullToAbsent || timeSignature != null) {
      map['time_signature'] = Variable<String>(timeSignature);
    }
    map['chord_pro_content'] = Variable<String>(chordProContent);
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    if (!nullToAbsent || attribution != null) {
      map['attribution'] = Variable<String>(attribution);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['sync_status'] = Variable<String>(syncStatus);
    map['version'] = Variable<int>(version);
    return map;
  }

  SongsTableCompanion toCompanion(bool nullToAbsent) {
    return SongsTableCompanion(
      id: Value(id),
      title: Value(title),
      artist: Value(artist),
      originalKey: originalKey == null && nullToAbsent
          ? const Value.absent()
          : Value(originalKey),
      currentKey: currentKey == null && nullToAbsent
          ? const Value.absent()
          : Value(currentKey),
      capo: Value(capo),
      tempo:
          tempo == null && nullToAbsent ? const Value.absent() : Value(tempo),
      timeSignature: timeSignature == null && nullToAbsent
          ? const Value.absent()
          : Value(timeSignature),
      chordProContent: Value(chordProContent),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      attribution: attribution == null && nullToAbsent
          ? const Value.absent()
          : Value(attribution),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncStatus: Value(syncStatus),
      version: Value(version),
    );
  }

  factory SongsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SongsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      artist: serializer.fromJson<String>(json['artist']),
      originalKey: serializer.fromJson<String?>(json['originalKey']),
      currentKey: serializer.fromJson<String?>(json['currentKey']),
      capo: serializer.fromJson<int>(json['capo']),
      tempo: serializer.fromJson<int?>(json['tempo']),
      timeSignature: serializer.fromJson<String?>(json['timeSignature']),
      chordProContent: serializer.fromJson<String>(json['chordProContent']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      attribution: serializer.fromJson<String?>(json['attribution']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'artist': serializer.toJson<String>(artist),
      'originalKey': serializer.toJson<String?>(originalKey),
      'currentKey': serializer.toJson<String?>(currentKey),
      'capo': serializer.toJson<int>(capo),
      'tempo': serializer.toJson<int?>(tempo),
      'timeSignature': serializer.toJson<String?>(timeSignature),
      'chordProContent': serializer.toJson<String>(chordProContent),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'attribution': serializer.toJson<String?>(attribution),
      'groupId': serializer.toJson<String?>(groupId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'version': serializer.toJson<int>(version),
    };
  }

  SongsTableData copyWith(
          {String? id,
          String? title,
          String? artist,
          Value<String?> originalKey = const Value.absent(),
          Value<String?> currentKey = const Value.absent(),
          int? capo,
          Value<int?> tempo = const Value.absent(),
          Value<String?> timeSignature = const Value.absent(),
          String? chordProContent,
          Value<String?> sourceUrl = const Value.absent(),
          Value<String?> attribution = const Value.absent(),
          Value<String?> groupId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          String? syncStatus,
          int? version}) =>
      SongsTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        artist: artist ?? this.artist,
        originalKey: originalKey.present ? originalKey.value : this.originalKey,
        currentKey: currentKey.present ? currentKey.value : this.currentKey,
        capo: capo ?? this.capo,
        tempo: tempo.present ? tempo.value : this.tempo,
        timeSignature:
            timeSignature.present ? timeSignature.value : this.timeSignature,
        chordProContent: chordProContent ?? this.chordProContent,
        sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
        attribution: attribution.present ? attribution.value : this.attribution,
        groupId: groupId.present ? groupId.value : this.groupId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncStatus: syncStatus ?? this.syncStatus,
        version: version ?? this.version,
      );
  SongsTableData copyWithCompanion(SongsTableCompanion data) {
    return SongsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      artist: data.artist.present ? data.artist.value : this.artist,
      originalKey:
          data.originalKey.present ? data.originalKey.value : this.originalKey,
      currentKey:
          data.currentKey.present ? data.currentKey.value : this.currentKey,
      capo: data.capo.present ? data.capo.value : this.capo,
      tempo: data.tempo.present ? data.tempo.value : this.tempo,
      timeSignature: data.timeSignature.present
          ? data.timeSignature.value
          : this.timeSignature,
      chordProContent: data.chordProContent.present
          ? data.chordProContent.value
          : this.chordProContent,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      attribution:
          data.attribution.present ? data.attribution.value : this.attribution,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SongsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('originalKey: $originalKey, ')
          ..write('currentKey: $currentKey, ')
          ..write('capo: $capo, ')
          ..write('tempo: $tempo, ')
          ..write('timeSignature: $timeSignature, ')
          ..write('chordProContent: $chordProContent, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('attribution: $attribution, ')
          ..write('groupId: $groupId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      artist,
      originalKey,
      currentKey,
      capo,
      tempo,
      timeSignature,
      chordProContent,
      sourceUrl,
      attribution,
      groupId,
      createdAt,
      updatedAt,
      syncStatus,
      version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.artist == this.artist &&
          other.originalKey == this.originalKey &&
          other.currentKey == this.currentKey &&
          other.capo == this.capo &&
          other.tempo == this.tempo &&
          other.timeSignature == this.timeSignature &&
          other.chordProContent == this.chordProContent &&
          other.sourceUrl == this.sourceUrl &&
          other.attribution == this.attribution &&
          other.groupId == this.groupId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncStatus == this.syncStatus &&
          other.version == this.version);
}

class SongsTableCompanion extends UpdateCompanion<SongsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> artist;
  final Value<String?> originalKey;
  final Value<String?> currentKey;
  final Value<int> capo;
  final Value<int?> tempo;
  final Value<String?> timeSignature;
  final Value<String> chordProContent;
  final Value<String?> sourceUrl;
  final Value<String?> attribution;
  final Value<String?> groupId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> syncStatus;
  final Value<int> version;
  final Value<int> rowid;
  const SongsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.originalKey = const Value.absent(),
    this.currentKey = const Value.absent(),
    this.capo = const Value.absent(),
    this.tempo = const Value.absent(),
    this.timeSignature = const Value.absent(),
    this.chordProContent = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.attribution = const Value.absent(),
    this.groupId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SongsTableCompanion.insert({
    required String id,
    required String title,
    required String artist,
    this.originalKey = const Value.absent(),
    this.currentKey = const Value.absent(),
    this.capo = const Value.absent(),
    this.tempo = const Value.absent(),
    this.timeSignature = const Value.absent(),
    required String chordProContent,
    this.sourceUrl = const Value.absent(),
    this.attribution = const Value.absent(),
    this.groupId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        artist = Value(artist),
        chordProContent = Value(chordProContent),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SongsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? artist,
    Expression<String>? originalKey,
    Expression<String>? currentKey,
    Expression<int>? capo,
    Expression<int>? tempo,
    Expression<String>? timeSignature,
    Expression<String>? chordProContent,
    Expression<String>? sourceUrl,
    Expression<String>? attribution,
    Expression<String>? groupId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncStatus,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (artist != null) 'artist': artist,
      if (originalKey != null) 'original_key': originalKey,
      if (currentKey != null) 'current_key': currentKey,
      if (capo != null) 'capo': capo,
      if (tempo != null) 'tempo': tempo,
      if (timeSignature != null) 'time_signature': timeSignature,
      if (chordProContent != null) 'chord_pro_content': chordProContent,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (attribution != null) 'attribution': attribution,
      if (groupId != null) 'group_id': groupId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SongsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? artist,
      Value<String?>? originalKey,
      Value<String?>? currentKey,
      Value<int>? capo,
      Value<int?>? tempo,
      Value<String?>? timeSignature,
      Value<String>? chordProContent,
      Value<String?>? sourceUrl,
      Value<String?>? attribution,
      Value<String?>? groupId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? syncStatus,
      Value<int>? version,
      Value<int>? rowid}) {
    return SongsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      originalKey: originalKey ?? this.originalKey,
      currentKey: currentKey ?? this.currentKey,
      capo: capo ?? this.capo,
      tempo: tempo ?? this.tempo,
      timeSignature: timeSignature ?? this.timeSignature,
      chordProContent: chordProContent ?? this.chordProContent,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      attribution: attribution ?? this.attribution,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (originalKey.present) {
      map['original_key'] = Variable<String>(originalKey.value);
    }
    if (currentKey.present) {
      map['current_key'] = Variable<String>(currentKey.value);
    }
    if (capo.present) {
      map['capo'] = Variable<int>(capo.value);
    }
    if (tempo.present) {
      map['tempo'] = Variable<int>(tempo.value);
    }
    if (timeSignature.present) {
      map['time_signature'] = Variable<String>(timeSignature.value);
    }
    if (chordProContent.present) {
      map['chord_pro_content'] = Variable<String>(chordProContent.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (attribution.present) {
      map['attribution'] = Variable<String>(attribution.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('originalKey: $originalKey, ')
          ..write('currentKey: $currentKey, ')
          ..write('capo: $capo, ')
          ..write('tempo: $tempo, ')
          ..write('timeSignature: $timeSignature, ')
          ..write('chordProContent: $chordProContent, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('attribution: $attribution, ')
          ..write('groupId: $groupId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LyricVersionsTableTable extends LyricVersionsTable
    with TableInfo<$LyricVersionsTableTable, LyricVersionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LyricVersionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
      'song_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageCodeMeta =
      const VerificationMeta('languageCode');
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
      'language_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageNameMeta =
      const VerificationMeta('languageName');
  @override
  late final GeneratedColumn<String> languageName = GeneratedColumn<String>(
      'language_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isPrimaryMeta =
      const VerificationMeta('isPrimary');
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
      'is_primary', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_primary" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, songId, languageCode, languageName, content, isPrimary];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lyric_versions_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<LyricVersionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(_songIdMeta,
          songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta));
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
          _languageCodeMeta,
          languageCode.isAcceptableOrUnknown(
              data['language_code']!, _languageCodeMeta));
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('language_name')) {
      context.handle(
          _languageNameMeta,
          languageName.isAcceptableOrUnknown(
              data['language_name']!, _languageNameMeta));
    } else if (isInserting) {
      context.missing(_languageNameMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_primary')) {
      context.handle(_isPrimaryMeta,
          isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LyricVersionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LyricVersionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      songId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}song_id'])!,
      languageCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language_code'])!,
      languageName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language_name'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      isPrimary: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_primary'])!,
    );
  }

  @override
  $LyricVersionsTableTable createAlias(String alias) {
    return $LyricVersionsTableTable(attachedDatabase, alias);
  }
}

class LyricVersionsTableData extends DataClass
    implements Insertable<LyricVersionsTableData> {
  final String id;
  final String songId;
  final String languageCode;
  final String languageName;
  final String content;
  final bool isPrimary;
  const LyricVersionsTableData(
      {required this.id,
      required this.songId,
      required this.languageCode,
      required this.languageName,
      required this.content,
      required this.isPrimary});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['song_id'] = Variable<String>(songId);
    map['language_code'] = Variable<String>(languageCode);
    map['language_name'] = Variable<String>(languageName);
    map['content'] = Variable<String>(content);
    map['is_primary'] = Variable<bool>(isPrimary);
    return map;
  }

  LyricVersionsTableCompanion toCompanion(bool nullToAbsent) {
    return LyricVersionsTableCompanion(
      id: Value(id),
      songId: Value(songId),
      languageCode: Value(languageCode),
      languageName: Value(languageName),
      content: Value(content),
      isPrimary: Value(isPrimary),
    );
  }

  factory LyricVersionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LyricVersionsTableData(
      id: serializer.fromJson<String>(json['id']),
      songId: serializer.fromJson<String>(json['songId']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      languageName: serializer.fromJson<String>(json['languageName']),
      content: serializer.fromJson<String>(json['content']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'songId': serializer.toJson<String>(songId),
      'languageCode': serializer.toJson<String>(languageCode),
      'languageName': serializer.toJson<String>(languageName),
      'content': serializer.toJson<String>(content),
      'isPrimary': serializer.toJson<bool>(isPrimary),
    };
  }

  LyricVersionsTableData copyWith(
          {String? id,
          String? songId,
          String? languageCode,
          String? languageName,
          String? content,
          bool? isPrimary}) =>
      LyricVersionsTableData(
        id: id ?? this.id,
        songId: songId ?? this.songId,
        languageCode: languageCode ?? this.languageCode,
        languageName: languageName ?? this.languageName,
        content: content ?? this.content,
        isPrimary: isPrimary ?? this.isPrimary,
      );
  LyricVersionsTableData copyWithCompanion(LyricVersionsTableCompanion data) {
    return LyricVersionsTableData(
      id: data.id.present ? data.id.value : this.id,
      songId: data.songId.present ? data.songId.value : this.songId,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      languageName: data.languageName.present
          ? data.languageName.value
          : this.languageName,
      content: data.content.present ? data.content.value : this.content,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LyricVersionsTableData(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('languageCode: $languageCode, ')
          ..write('languageName: $languageName, ')
          ..write('content: $content, ')
          ..write('isPrimary: $isPrimary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, songId, languageCode, languageName, content, isPrimary);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LyricVersionsTableData &&
          other.id == this.id &&
          other.songId == this.songId &&
          other.languageCode == this.languageCode &&
          other.languageName == this.languageName &&
          other.content == this.content &&
          other.isPrimary == this.isPrimary);
}

class LyricVersionsTableCompanion
    extends UpdateCompanion<LyricVersionsTableData> {
  final Value<String> id;
  final Value<String> songId;
  final Value<String> languageCode;
  final Value<String> languageName;
  final Value<String> content;
  final Value<bool> isPrimary;
  final Value<int> rowid;
  const LyricVersionsTableCompanion({
    this.id = const Value.absent(),
    this.songId = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.languageName = const Value.absent(),
    this.content = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LyricVersionsTableCompanion.insert({
    required String id,
    required String songId,
    required String languageCode,
    required String languageName,
    required String content,
    this.isPrimary = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        songId = Value(songId),
        languageCode = Value(languageCode),
        languageName = Value(languageName),
        content = Value(content);
  static Insertable<LyricVersionsTableData> custom({
    Expression<String>? id,
    Expression<String>? songId,
    Expression<String>? languageCode,
    Expression<String>? languageName,
    Expression<String>? content,
    Expression<bool>? isPrimary,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songId != null) 'song_id': songId,
      if (languageCode != null) 'language_code': languageCode,
      if (languageName != null) 'language_name': languageName,
      if (content != null) 'content': content,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LyricVersionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? songId,
      Value<String>? languageCode,
      Value<String>? languageName,
      Value<String>? content,
      Value<bool>? isPrimary,
      Value<int>? rowid}) {
    return LyricVersionsTableCompanion(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      languageCode: languageCode ?? this.languageCode,
      languageName: languageName ?? this.languageName,
      content: content ?? this.content,
      isPrimary: isPrimary ?? this.isPrimary,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (languageName.present) {
      map['language_name'] = Variable<String>(languageName.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LyricVersionsTableCompanion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('languageCode: $languageCode, ')
          ..write('languageName: $languageName, ')
          ..write('content: $content, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SetlistsTableTable extends SetlistsTable
    with TableInfo<$SetlistsTableTable, SetlistsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetlistsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, description, groupId, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'setlists_table';
  @override
  VerificationContext validateIntegrity(Insertable<SetlistsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetlistsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetlistsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SetlistsTableTable createAlias(String alias) {
    return $SetlistsTableTable(attachedDatabase, alias);
  }
}

class SetlistsTableData extends DataClass
    implements Insertable<SetlistsTableData> {
  final String id;
  final String title;
  final String? description;
  final String? groupId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SetlistsTableData(
      {required this.id,
      required this.title,
      this.description,
      this.groupId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SetlistsTableCompanion toCompanion(bool nullToAbsent) {
    return SetlistsTableCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SetlistsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetlistsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'groupId': serializer.toJson<String?>(groupId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SetlistsTableData copyWith(
          {String? id,
          String? title,
          Value<String?> description = const Value.absent(),
          Value<String?> groupId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SetlistsTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        groupId: groupId.present ? groupId.value : this.groupId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SetlistsTableData copyWithCompanion(SetlistsTableCompanion data) {
    return SetlistsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetlistsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('groupId: $groupId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, description, groupId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetlistsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.groupId == this.groupId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SetlistsTableCompanion extends UpdateCompanion<SetlistsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> groupId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SetlistsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.groupId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SetlistsTableCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.groupId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SetlistsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? groupId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (groupId != null) 'group_id': groupId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SetlistsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<String?>? groupId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SetlistsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetlistsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('groupId: $groupId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SetlistItemsTableTable extends SetlistItemsTable
    with TableInfo<$SetlistItemsTableTable, SetlistItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetlistItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _setlistIdMeta =
      const VerificationMeta('setlistId');
  @override
  late final GeneratedColumn<String> setlistId = GeneratedColumn<String>(
      'setlist_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
      'song_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _keyOverrideMeta =
      const VerificationMeta('keyOverride');
  @override
  late final GeneratedColumn<String> keyOverride = GeneratedColumn<String>(
      'key_override', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _capoOverrideMeta =
      const VerificationMeta('capoOverride');
  @override
  late final GeneratedColumn<int> capoOverride = GeneratedColumn<int>(
      'capo_override', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _estimatedDurationSecondsMeta =
      const VerificationMeta('estimatedDurationSeconds');
  @override
  late final GeneratedColumn<int> estimatedDurationSeconds =
      GeneratedColumn<int>('estimated_duration_seconds', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(240));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        setlistId,
        songId,
        sortOrder,
        keyOverride,
        capoOverride,
        notes,
        estimatedDurationSeconds
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'setlist_items_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SetlistItemsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('setlist_id')) {
      context.handle(_setlistIdMeta,
          setlistId.isAcceptableOrUnknown(data['setlist_id']!, _setlistIdMeta));
    } else if (isInserting) {
      context.missing(_setlistIdMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(_songIdMeta,
          songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta));
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('key_override')) {
      context.handle(
          _keyOverrideMeta,
          keyOverride.isAcceptableOrUnknown(
              data['key_override']!, _keyOverrideMeta));
    }
    if (data.containsKey('capo_override')) {
      context.handle(
          _capoOverrideMeta,
          capoOverride.isAcceptableOrUnknown(
              data['capo_override']!, _capoOverrideMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('estimated_duration_seconds')) {
      context.handle(
          _estimatedDurationSecondsMeta,
          estimatedDurationSeconds.isAcceptableOrUnknown(
              data['estimated_duration_seconds']!,
              _estimatedDurationSecondsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetlistItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetlistItemsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      setlistId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}setlist_id'])!,
      songId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}song_id'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      keyOverride: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key_override']),
      capoOverride: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}capo_override']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      estimatedDurationSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}estimated_duration_seconds'])!,
    );
  }

  @override
  $SetlistItemsTableTable createAlias(String alias) {
    return $SetlistItemsTableTable(attachedDatabase, alias);
  }
}

class SetlistItemsTableData extends DataClass
    implements Insertable<SetlistItemsTableData> {
  final String id;
  final String setlistId;
  final String songId;
  final int sortOrder;
  final String? keyOverride;
  final int? capoOverride;
  final String? notes;
  final int estimatedDurationSeconds;
  const SetlistItemsTableData(
      {required this.id,
      required this.setlistId,
      required this.songId,
      required this.sortOrder,
      this.keyOverride,
      this.capoOverride,
      this.notes,
      required this.estimatedDurationSeconds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['setlist_id'] = Variable<String>(setlistId);
    map['song_id'] = Variable<String>(songId);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || keyOverride != null) {
      map['key_override'] = Variable<String>(keyOverride);
    }
    if (!nullToAbsent || capoOverride != null) {
      map['capo_override'] = Variable<int>(capoOverride);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['estimated_duration_seconds'] = Variable<int>(estimatedDurationSeconds);
    return map;
  }

  SetlistItemsTableCompanion toCompanion(bool nullToAbsent) {
    return SetlistItemsTableCompanion(
      id: Value(id),
      setlistId: Value(setlistId),
      songId: Value(songId),
      sortOrder: Value(sortOrder),
      keyOverride: keyOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(keyOverride),
      capoOverride: capoOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(capoOverride),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      estimatedDurationSeconds: Value(estimatedDurationSeconds),
    );
  }

  factory SetlistItemsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetlistItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      setlistId: serializer.fromJson<String>(json['setlistId']),
      songId: serializer.fromJson<String>(json['songId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      keyOverride: serializer.fromJson<String?>(json['keyOverride']),
      capoOverride: serializer.fromJson<int?>(json['capoOverride']),
      notes: serializer.fromJson<String?>(json['notes']),
      estimatedDurationSeconds:
          serializer.fromJson<int>(json['estimatedDurationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'setlistId': serializer.toJson<String>(setlistId),
      'songId': serializer.toJson<String>(songId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'keyOverride': serializer.toJson<String?>(keyOverride),
      'capoOverride': serializer.toJson<int?>(capoOverride),
      'notes': serializer.toJson<String?>(notes),
      'estimatedDurationSeconds':
          serializer.toJson<int>(estimatedDurationSeconds),
    };
  }

  SetlistItemsTableData copyWith(
          {String? id,
          String? setlistId,
          String? songId,
          int? sortOrder,
          Value<String?> keyOverride = const Value.absent(),
          Value<int?> capoOverride = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          int? estimatedDurationSeconds}) =>
      SetlistItemsTableData(
        id: id ?? this.id,
        setlistId: setlistId ?? this.setlistId,
        songId: songId ?? this.songId,
        sortOrder: sortOrder ?? this.sortOrder,
        keyOverride: keyOverride.present ? keyOverride.value : this.keyOverride,
        capoOverride:
            capoOverride.present ? capoOverride.value : this.capoOverride,
        notes: notes.present ? notes.value : this.notes,
        estimatedDurationSeconds:
            estimatedDurationSeconds ?? this.estimatedDurationSeconds,
      );
  SetlistItemsTableData copyWithCompanion(SetlistItemsTableCompanion data) {
    return SetlistItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      setlistId: data.setlistId.present ? data.setlistId.value : this.setlistId,
      songId: data.songId.present ? data.songId.value : this.songId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      keyOverride:
          data.keyOverride.present ? data.keyOverride.value : this.keyOverride,
      capoOverride: data.capoOverride.present
          ? data.capoOverride.value
          : this.capoOverride,
      notes: data.notes.present ? data.notes.value : this.notes,
      estimatedDurationSeconds: data.estimatedDurationSeconds.present
          ? data.estimatedDurationSeconds.value
          : this.estimatedDurationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetlistItemsTableData(')
          ..write('id: $id, ')
          ..write('setlistId: $setlistId, ')
          ..write('songId: $songId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('keyOverride: $keyOverride, ')
          ..write('capoOverride: $capoOverride, ')
          ..write('notes: $notes, ')
          ..write('estimatedDurationSeconds: $estimatedDurationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, setlistId, songId, sortOrder, keyOverride,
      capoOverride, notes, estimatedDurationSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetlistItemsTableData &&
          other.id == this.id &&
          other.setlistId == this.setlistId &&
          other.songId == this.songId &&
          other.sortOrder == this.sortOrder &&
          other.keyOverride == this.keyOverride &&
          other.capoOverride == this.capoOverride &&
          other.notes == this.notes &&
          other.estimatedDurationSeconds == this.estimatedDurationSeconds);
}

class SetlistItemsTableCompanion
    extends UpdateCompanion<SetlistItemsTableData> {
  final Value<String> id;
  final Value<String> setlistId;
  final Value<String> songId;
  final Value<int> sortOrder;
  final Value<String?> keyOverride;
  final Value<int?> capoOverride;
  final Value<String?> notes;
  final Value<int> estimatedDurationSeconds;
  final Value<int> rowid;
  const SetlistItemsTableCompanion({
    this.id = const Value.absent(),
    this.setlistId = const Value.absent(),
    this.songId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.keyOverride = const Value.absent(),
    this.capoOverride = const Value.absent(),
    this.notes = const Value.absent(),
    this.estimatedDurationSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SetlistItemsTableCompanion.insert({
    required String id,
    required String setlistId,
    required String songId,
    required int sortOrder,
    this.keyOverride = const Value.absent(),
    this.capoOverride = const Value.absent(),
    this.notes = const Value.absent(),
    this.estimatedDurationSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        setlistId = Value(setlistId),
        songId = Value(songId),
        sortOrder = Value(sortOrder);
  static Insertable<SetlistItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? setlistId,
    Expression<String>? songId,
    Expression<int>? sortOrder,
    Expression<String>? keyOverride,
    Expression<int>? capoOverride,
    Expression<String>? notes,
    Expression<int>? estimatedDurationSeconds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (setlistId != null) 'setlist_id': setlistId,
      if (songId != null) 'song_id': songId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (keyOverride != null) 'key_override': keyOverride,
      if (capoOverride != null) 'capo_override': capoOverride,
      if (notes != null) 'notes': notes,
      if (estimatedDurationSeconds != null)
        'estimated_duration_seconds': estimatedDurationSeconds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SetlistItemsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? setlistId,
      Value<String>? songId,
      Value<int>? sortOrder,
      Value<String?>? keyOverride,
      Value<int?>? capoOverride,
      Value<String?>? notes,
      Value<int>? estimatedDurationSeconds,
      Value<int>? rowid}) {
    return SetlistItemsTableCompanion(
      id: id ?? this.id,
      setlistId: setlistId ?? this.setlistId,
      songId: songId ?? this.songId,
      sortOrder: sortOrder ?? this.sortOrder,
      keyOverride: keyOverride ?? this.keyOverride,
      capoOverride: capoOverride ?? this.capoOverride,
      notes: notes ?? this.notes,
      estimatedDurationSeconds:
          estimatedDurationSeconds ?? this.estimatedDurationSeconds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (setlistId.present) {
      map['setlist_id'] = Variable<String>(setlistId.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (keyOverride.present) {
      map['key_override'] = Variable<String>(keyOverride.value);
    }
    if (capoOverride.present) {
      map['capo_override'] = Variable<int>(capoOverride.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (estimatedDurationSeconds.present) {
      map['estimated_duration_seconds'] =
          Variable<int>(estimatedDurationSeconds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetlistItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('setlistId: $setlistId, ')
          ..write('songId: $songId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('keyOverride: $keyOverride, ')
          ..write('capoOverride: $capoOverride, ')
          ..write('notes: $notes, ')
          ..write('estimatedDurationSeconds: $estimatedDurationSeconds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSongSettingsTableTable extends UserSongSettingsTable
    with TableInfo<$UserSongSettingsTableTable, UserSongSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSongSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
      'song_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _preferredKeyMeta =
      const VerificationMeta('preferredKey');
  @override
  late final GeneratedColumn<String> preferredKey = GeneratedColumn<String>(
      'preferred_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _preferredCapoMeta =
      const VerificationMeta('preferredCapo');
  @override
  late final GeneratedColumn<int> preferredCapo = GeneratedColumn<int>(
      'preferred_capo', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _displayNashvilleMeta =
      const VerificationMeta('displayNashville');
  @override
  late final GeneratedColumn<bool> displayNashville = GeneratedColumn<bool>(
      'display_nashville', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("display_nashville" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _displayRomanMeta =
      const VerificationMeta('displayRoman');
  @override
  late final GeneratedColumn<bool> displayRoman = GeneratedColumn<bool>(
      'display_roman', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("display_roman" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _fontSizeMeta =
      const VerificationMeta('fontSize');
  @override
  late final GeneratedColumn<double> fontSize = GeneratedColumn<double>(
      'font_size', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(16.0));
  static const VerificationMeta _autoScrollSpeedMeta =
      const VerificationMeta('autoScrollSpeed');
  @override
  late final GeneratedColumn<double> autoScrollSpeed = GeneratedColumn<double>(
      'auto_scroll_speed', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _selectedLyricVersionIdMeta =
      const VerificationMeta('selectedLyricVersionId');
  @override
  late final GeneratedColumn<String> selectedLyricVersionId =
      GeneratedColumn<String>('selected_lyric_version_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        songId,
        preferredKey,
        preferredCapo,
        displayNashville,
        displayRoman,
        fontSize,
        autoScrollSpeed,
        selectedLyricVersionId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_song_settings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserSongSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('song_id')) {
      context.handle(_songIdMeta,
          songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta));
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('preferred_key')) {
      context.handle(
          _preferredKeyMeta,
          preferredKey.isAcceptableOrUnknown(
              data['preferred_key']!, _preferredKeyMeta));
    }
    if (data.containsKey('preferred_capo')) {
      context.handle(
          _preferredCapoMeta,
          preferredCapo.isAcceptableOrUnknown(
              data['preferred_capo']!, _preferredCapoMeta));
    }
    if (data.containsKey('display_nashville')) {
      context.handle(
          _displayNashvilleMeta,
          displayNashville.isAcceptableOrUnknown(
              data['display_nashville']!, _displayNashvilleMeta));
    }
    if (data.containsKey('display_roman')) {
      context.handle(
          _displayRomanMeta,
          displayRoman.isAcceptableOrUnknown(
              data['display_roman']!, _displayRomanMeta));
    }
    if (data.containsKey('font_size')) {
      context.handle(_fontSizeMeta,
          fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta));
    }
    if (data.containsKey('auto_scroll_speed')) {
      context.handle(
          _autoScrollSpeedMeta,
          autoScrollSpeed.isAcceptableOrUnknown(
              data['auto_scroll_speed']!, _autoScrollSpeedMeta));
    }
    if (data.containsKey('selected_lyric_version_id')) {
      context.handle(
          _selectedLyricVersionIdMeta,
          selectedLyricVersionId.isAcceptableOrUnknown(
              data['selected_lyric_version_id']!, _selectedLyricVersionIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {songId};
  @override
  UserSongSettingsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSongSettingsTableData(
      songId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}song_id'])!,
      preferredKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}preferred_key']),
      preferredCapo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}preferred_capo'])!,
      displayNashville: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}display_nashville'])!,
      displayRoman: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}display_roman'])!,
      fontSize: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}font_size'])!,
      autoScrollSpeed: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}auto_scroll_speed'])!,
      selectedLyricVersionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}selected_lyric_version_id']),
    );
  }

  @override
  $UserSongSettingsTableTable createAlias(String alias) {
    return $UserSongSettingsTableTable(attachedDatabase, alias);
  }
}

class UserSongSettingsTableData extends DataClass
    implements Insertable<UserSongSettingsTableData> {
  final String songId;
  final String? preferredKey;
  final int preferredCapo;
  final bool displayNashville;
  final bool displayRoman;
  final double fontSize;
  final double autoScrollSpeed;
  final String? selectedLyricVersionId;
  const UserSongSettingsTableData(
      {required this.songId,
      this.preferredKey,
      required this.preferredCapo,
      required this.displayNashville,
      required this.displayRoman,
      required this.fontSize,
      required this.autoScrollSpeed,
      this.selectedLyricVersionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['song_id'] = Variable<String>(songId);
    if (!nullToAbsent || preferredKey != null) {
      map['preferred_key'] = Variable<String>(preferredKey);
    }
    map['preferred_capo'] = Variable<int>(preferredCapo);
    map['display_nashville'] = Variable<bool>(displayNashville);
    map['display_roman'] = Variable<bool>(displayRoman);
    map['font_size'] = Variable<double>(fontSize);
    map['auto_scroll_speed'] = Variable<double>(autoScrollSpeed);
    if (!nullToAbsent || selectedLyricVersionId != null) {
      map['selected_lyric_version_id'] =
          Variable<String>(selectedLyricVersionId);
    }
    return map;
  }

  UserSongSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return UserSongSettingsTableCompanion(
      songId: Value(songId),
      preferredKey: preferredKey == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredKey),
      preferredCapo: Value(preferredCapo),
      displayNashville: Value(displayNashville),
      displayRoman: Value(displayRoman),
      fontSize: Value(fontSize),
      autoScrollSpeed: Value(autoScrollSpeed),
      selectedLyricVersionId: selectedLyricVersionId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedLyricVersionId),
    );
  }

  factory UserSongSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSongSettingsTableData(
      songId: serializer.fromJson<String>(json['songId']),
      preferredKey: serializer.fromJson<String?>(json['preferredKey']),
      preferredCapo: serializer.fromJson<int>(json['preferredCapo']),
      displayNashville: serializer.fromJson<bool>(json['displayNashville']),
      displayRoman: serializer.fromJson<bool>(json['displayRoman']),
      fontSize: serializer.fromJson<double>(json['fontSize']),
      autoScrollSpeed: serializer.fromJson<double>(json['autoScrollSpeed']),
      selectedLyricVersionId:
          serializer.fromJson<String?>(json['selectedLyricVersionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'songId': serializer.toJson<String>(songId),
      'preferredKey': serializer.toJson<String?>(preferredKey),
      'preferredCapo': serializer.toJson<int>(preferredCapo),
      'displayNashville': serializer.toJson<bool>(displayNashville),
      'displayRoman': serializer.toJson<bool>(displayRoman),
      'fontSize': serializer.toJson<double>(fontSize),
      'autoScrollSpeed': serializer.toJson<double>(autoScrollSpeed),
      'selectedLyricVersionId':
          serializer.toJson<String?>(selectedLyricVersionId),
    };
  }

  UserSongSettingsTableData copyWith(
          {String? songId,
          Value<String?> preferredKey = const Value.absent(),
          int? preferredCapo,
          bool? displayNashville,
          bool? displayRoman,
          double? fontSize,
          double? autoScrollSpeed,
          Value<String?> selectedLyricVersionId = const Value.absent()}) =>
      UserSongSettingsTableData(
        songId: songId ?? this.songId,
        preferredKey:
            preferredKey.present ? preferredKey.value : this.preferredKey,
        preferredCapo: preferredCapo ?? this.preferredCapo,
        displayNashville: displayNashville ?? this.displayNashville,
        displayRoman: displayRoman ?? this.displayRoman,
        fontSize: fontSize ?? this.fontSize,
        autoScrollSpeed: autoScrollSpeed ?? this.autoScrollSpeed,
        selectedLyricVersionId: selectedLyricVersionId.present
            ? selectedLyricVersionId.value
            : this.selectedLyricVersionId,
      );
  UserSongSettingsTableData copyWithCompanion(
      UserSongSettingsTableCompanion data) {
    return UserSongSettingsTableData(
      songId: data.songId.present ? data.songId.value : this.songId,
      preferredKey: data.preferredKey.present
          ? data.preferredKey.value
          : this.preferredKey,
      preferredCapo: data.preferredCapo.present
          ? data.preferredCapo.value
          : this.preferredCapo,
      displayNashville: data.displayNashville.present
          ? data.displayNashville.value
          : this.displayNashville,
      displayRoman: data.displayRoman.present
          ? data.displayRoman.value
          : this.displayRoman,
      fontSize: data.fontSize.present ? data.fontSize.value : this.fontSize,
      autoScrollSpeed: data.autoScrollSpeed.present
          ? data.autoScrollSpeed.value
          : this.autoScrollSpeed,
      selectedLyricVersionId: data.selectedLyricVersionId.present
          ? data.selectedLyricVersionId.value
          : this.selectedLyricVersionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSongSettingsTableData(')
          ..write('songId: $songId, ')
          ..write('preferredKey: $preferredKey, ')
          ..write('preferredCapo: $preferredCapo, ')
          ..write('displayNashville: $displayNashville, ')
          ..write('displayRoman: $displayRoman, ')
          ..write('fontSize: $fontSize, ')
          ..write('autoScrollSpeed: $autoScrollSpeed, ')
          ..write('selectedLyricVersionId: $selectedLyricVersionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      songId,
      preferredKey,
      preferredCapo,
      displayNashville,
      displayRoman,
      fontSize,
      autoScrollSpeed,
      selectedLyricVersionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSongSettingsTableData &&
          other.songId == this.songId &&
          other.preferredKey == this.preferredKey &&
          other.preferredCapo == this.preferredCapo &&
          other.displayNashville == this.displayNashville &&
          other.displayRoman == this.displayRoman &&
          other.fontSize == this.fontSize &&
          other.autoScrollSpeed == this.autoScrollSpeed &&
          other.selectedLyricVersionId == this.selectedLyricVersionId);
}

class UserSongSettingsTableCompanion
    extends UpdateCompanion<UserSongSettingsTableData> {
  final Value<String> songId;
  final Value<String?> preferredKey;
  final Value<int> preferredCapo;
  final Value<bool> displayNashville;
  final Value<bool> displayRoman;
  final Value<double> fontSize;
  final Value<double> autoScrollSpeed;
  final Value<String?> selectedLyricVersionId;
  final Value<int> rowid;
  const UserSongSettingsTableCompanion({
    this.songId = const Value.absent(),
    this.preferredKey = const Value.absent(),
    this.preferredCapo = const Value.absent(),
    this.displayNashville = const Value.absent(),
    this.displayRoman = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.autoScrollSpeed = const Value.absent(),
    this.selectedLyricVersionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSongSettingsTableCompanion.insert({
    required String songId,
    this.preferredKey = const Value.absent(),
    this.preferredCapo = const Value.absent(),
    this.displayNashville = const Value.absent(),
    this.displayRoman = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.autoScrollSpeed = const Value.absent(),
    this.selectedLyricVersionId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : songId = Value(songId);
  static Insertable<UserSongSettingsTableData> custom({
    Expression<String>? songId,
    Expression<String>? preferredKey,
    Expression<int>? preferredCapo,
    Expression<bool>? displayNashville,
    Expression<bool>? displayRoman,
    Expression<double>? fontSize,
    Expression<double>? autoScrollSpeed,
    Expression<String>? selectedLyricVersionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (songId != null) 'song_id': songId,
      if (preferredKey != null) 'preferred_key': preferredKey,
      if (preferredCapo != null) 'preferred_capo': preferredCapo,
      if (displayNashville != null) 'display_nashville': displayNashville,
      if (displayRoman != null) 'display_roman': displayRoman,
      if (fontSize != null) 'font_size': fontSize,
      if (autoScrollSpeed != null) 'auto_scroll_speed': autoScrollSpeed,
      if (selectedLyricVersionId != null)
        'selected_lyric_version_id': selectedLyricVersionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSongSettingsTableCompanion copyWith(
      {Value<String>? songId,
      Value<String?>? preferredKey,
      Value<int>? preferredCapo,
      Value<bool>? displayNashville,
      Value<bool>? displayRoman,
      Value<double>? fontSize,
      Value<double>? autoScrollSpeed,
      Value<String?>? selectedLyricVersionId,
      Value<int>? rowid}) {
    return UserSongSettingsTableCompanion(
      songId: songId ?? this.songId,
      preferredKey: preferredKey ?? this.preferredKey,
      preferredCapo: preferredCapo ?? this.preferredCapo,
      displayNashville: displayNashville ?? this.displayNashville,
      displayRoman: displayRoman ?? this.displayRoman,
      fontSize: fontSize ?? this.fontSize,
      autoScrollSpeed: autoScrollSpeed ?? this.autoScrollSpeed,
      selectedLyricVersionId:
          selectedLyricVersionId ?? this.selectedLyricVersionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (preferredKey.present) {
      map['preferred_key'] = Variable<String>(preferredKey.value);
    }
    if (preferredCapo.present) {
      map['preferred_capo'] = Variable<int>(preferredCapo.value);
    }
    if (displayNashville.present) {
      map['display_nashville'] = Variable<bool>(displayNashville.value);
    }
    if (displayRoman.present) {
      map['display_roman'] = Variable<bool>(displayRoman.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<double>(fontSize.value);
    }
    if (autoScrollSpeed.present) {
      map['auto_scroll_speed'] = Variable<double>(autoScrollSpeed.value);
    }
    if (selectedLyricVersionId.present) {
      map['selected_lyric_version_id'] =
          Variable<String>(selectedLyricVersionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSongSettingsTableCompanion(')
          ..write('songId: $songId, ')
          ..write('preferredKey: $preferredKey, ')
          ..write('preferredCapo: $preferredCapo, ')
          ..write('displayNashville: $displayNashville, ')
          ..write('displayRoman: $displayRoman, ')
          ..write('fontSize: $fontSize, ')
          ..write('autoScrollSpeed: $autoScrollSpeed, ')
          ..write('selectedLyricVersionId: $selectedLyricVersionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BandGroupsTableTable extends BandGroupsTable
    with TableInfo<$BandGroupsTableTable, BandGroupsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BandGroupsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('owner'));
  static const VerificationMeta _inviteCodeMeta =
      const VerificationMeta('inviteCode');
  @override
  late final GeneratedColumn<String> inviteCode = GeneratedColumn<String>(
      'invite_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, role, inviteCode, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'band_groups_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<BandGroupsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('invite_code')) {
      context.handle(
          _inviteCodeMeta,
          inviteCode.isAcceptableOrUnknown(
              data['invite_code']!, _inviteCodeMeta));
    } else if (isInserting) {
      context.missing(_inviteCodeMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BandGroupsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BandGroupsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      inviteCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invite_code'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BandGroupsTableTable createAlias(String alias) {
    return $BandGroupsTableTable(attachedDatabase, alias);
  }
}

class BandGroupsTableData extends DataClass
    implements Insertable<BandGroupsTableData> {
  final String id;
  final String name;
  final String role;
  final String inviteCode;
  final DateTime updatedAt;
  const BandGroupsTableData(
      {required this.id,
      required this.name,
      required this.role,
      required this.inviteCode,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    map['invite_code'] = Variable<String>(inviteCode);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BandGroupsTableCompanion toCompanion(bool nullToAbsent) {
    return BandGroupsTableCompanion(
      id: Value(id),
      name: Value(name),
      role: Value(role),
      inviteCode: Value(inviteCode),
      updatedAt: Value(updatedAt),
    );
  }

  factory BandGroupsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BandGroupsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      inviteCode: serializer.fromJson<String>(json['inviteCode']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'inviteCode': serializer.toJson<String>(inviteCode),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BandGroupsTableData copyWith(
          {String? id,
          String? name,
          String? role,
          String? inviteCode,
          DateTime? updatedAt}) =>
      BandGroupsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role ?? this.role,
        inviteCode: inviteCode ?? this.inviteCode,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BandGroupsTableData copyWithCompanion(BandGroupsTableCompanion data) {
    return BandGroupsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      inviteCode:
          data.inviteCode.present ? data.inviteCode.value : this.inviteCode,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BandGroupsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('inviteCode: $inviteCode, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, role, inviteCode, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BandGroupsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.role == this.role &&
          other.inviteCode == this.inviteCode &&
          other.updatedAt == this.updatedAt);
}

class BandGroupsTableCompanion extends UpdateCompanion<BandGroupsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> role;
  final Value<String> inviteCode;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BandGroupsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.inviteCode = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BandGroupsTableCompanion.insert({
    required String id,
    required String name,
    this.role = const Value.absent(),
    required String inviteCode,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        inviteCode = Value(inviteCode),
        updatedAt = Value(updatedAt);
  static Insertable<BandGroupsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? inviteCode,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (inviteCode != null) 'invite_code': inviteCode,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BandGroupsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? role,
      Value<String>? inviteCode,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BandGroupsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      inviteCode: inviteCode ?? this.inviteCode,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (inviteCode.present) {
      map['invite_code'] = Variable<String>(inviteCode.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BandGroupsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('inviteCode: $inviteCode, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTableTable extends AuditLogsTable
    with TableInfo<$AuditLogsTableTable, AuditLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userNameMeta =
      const VerificationMeta('userName');
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
      'user_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, entityType, entityId, action, userId, userName, timestamp, details];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs_table';
  @override
  VerificationContext validateIntegrity(Insertable<AuditLogsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('user_name')) {
      context.handle(_userNameMeta,
          userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta));
    } else if (isInserting) {
      context.missing(_userNameMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    } else if (isInserting) {
      context.missing(_detailsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      userName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_name'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details'])!,
    );
  }

  @override
  $AuditLogsTableTable createAlias(String alias) {
    return $AuditLogsTableTable(attachedDatabase, alias);
  }
}

class AuditLogsTableData extends DataClass
    implements Insertable<AuditLogsTableData> {
  final String id;
  final String entityType;
  final String entityId;
  final String action;
  final String userId;
  final String userName;
  final DateTime timestamp;
  final String details;
  const AuditLogsTableData(
      {required this.id,
      required this.entityType,
      required this.entityId,
      required this.action,
      required this.userId,
      required this.userName,
      required this.timestamp,
      required this.details});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['action'] = Variable<String>(action);
    map['user_id'] = Variable<String>(userId);
    map['user_name'] = Variable<String>(userName);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['details'] = Variable<String>(details);
    return map;
  }

  AuditLogsTableCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsTableCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      action: Value(action),
      userId: Value(userId),
      userName: Value(userName),
      timestamp: Value(timestamp),
      details: Value(details),
    );
  }

  factory AuditLogsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogsTableData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      userId: serializer.fromJson<String>(json['userId']),
      userName: serializer.fromJson<String>(json['userName']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      details: serializer.fromJson<String>(json['details']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'action': serializer.toJson<String>(action),
      'userId': serializer.toJson<String>(userId),
      'userName': serializer.toJson<String>(userName),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'details': serializer.toJson<String>(details),
    };
  }

  AuditLogsTableData copyWith(
          {String? id,
          String? entityType,
          String? entityId,
          String? action,
          String? userId,
          String? userName,
          DateTime? timestamp,
          String? details}) =>
      AuditLogsTableData(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        action: action ?? this.action,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        timestamp: timestamp ?? this.timestamp,
        details: details ?? this.details,
      );
  AuditLogsTableData copyWithCompanion(AuditLogsTableCompanion data) {
    return AuditLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      userId: data.userId.present ? data.userId.value : this.userId,
      userName: data.userName.present ? data.userName.value : this.userName,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      details: data.details.present ? data.details.value : this.details,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsTableData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('userId: $userId, ')
          ..write('userName: $userName, ')
          ..write('timestamp: $timestamp, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, entityType, entityId, action, userId, userName, timestamp, details);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogsTableData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.userId == this.userId &&
          other.userName == this.userName &&
          other.timestamp == this.timestamp &&
          other.details == this.details);
}

class AuditLogsTableCompanion extends UpdateCompanion<AuditLogsTableData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> action;
  final Value<String> userId;
  final Value<String> userName;
  final Value<DateTime> timestamp;
  final Value<String> details;
  final Value<int> rowid;
  const AuditLogsTableCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.userId = const Value.absent(),
    this.userName = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.details = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogsTableCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String action,
    required String userId,
    required String userName,
    required DateTime timestamp,
    required String details,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entityType = Value(entityType),
        entityId = Value(entityId),
        action = Value(action),
        userId = Value(userId),
        userName = Value(userName),
        timestamp = Value(timestamp),
        details = Value(details);
  static Insertable<AuditLogsTableData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<String>? userId,
    Expression<String>? userName,
    Expression<DateTime>? timestamp,
    Expression<String>? details,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (userId != null) 'user_id': userId,
      if (userName != null) 'user_name': userName,
      if (timestamp != null) 'timestamp': timestamp,
      if (details != null) 'details': details,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? action,
      Value<String>? userId,
      Value<String>? userName,
      Value<DateTime>? timestamp,
      Value<String>? details,
      Value<int>? rowid}) {
    return AuditLogsTableCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      timestamp: timestamp ?? this.timestamp,
      details: details ?? this.details,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('userId: $userId, ')
          ..write('userName: $userName, ')
          ..write('timestamp: $timestamp, ')
          ..write('details: $details, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SongsTableTable songsTable = $SongsTableTable(this);
  late final $LyricVersionsTableTable lyricVersionsTable =
      $LyricVersionsTableTable(this);
  late final $SetlistsTableTable setlistsTable = $SetlistsTableTable(this);
  late final $SetlistItemsTableTable setlistItemsTable =
      $SetlistItemsTableTable(this);
  late final $UserSongSettingsTableTable userSongSettingsTable =
      $UserSongSettingsTableTable(this);
  late final $BandGroupsTableTable bandGroupsTable =
      $BandGroupsTableTable(this);
  late final $AuditLogsTableTable auditLogsTable = $AuditLogsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        songsTable,
        lyricVersionsTable,
        setlistsTable,
        setlistItemsTable,
        userSongSettingsTable,
        bandGroupsTable,
        auditLogsTable
      ];
}

typedef $$SongsTableTableCreateCompanionBuilder = SongsTableCompanion Function({
  required String id,
  required String title,
  required String artist,
  Value<String?> originalKey,
  Value<String?> currentKey,
  Value<int> capo,
  Value<int?> tempo,
  Value<String?> timeSignature,
  required String chordProContent,
  Value<String?> sourceUrl,
  Value<String?> attribution,
  Value<String?> groupId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});
typedef $$SongsTableTableUpdateCompanionBuilder = SongsTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> artist,
  Value<String?> originalKey,
  Value<String?> currentKey,
  Value<int> capo,
  Value<int?> tempo,
  Value<String?> timeSignature,
  Value<String> chordProContent,
  Value<String?> sourceUrl,
  Value<String?> attribution,
  Value<String?> groupId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<String> syncStatus,
  Value<int> version,
  Value<int> rowid,
});

class $$SongsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SongsTableTable,
    SongsTableData,
    $$SongsTableTableFilterComposer,
    $$SongsTableTableOrderingComposer,
    $$SongsTableTableCreateCompanionBuilder,
    $$SongsTableTableUpdateCompanionBuilder> {
  $$SongsTableTableTableManager(_$AppDatabase db, $SongsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SongsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SongsTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> artist = const Value.absent(),
            Value<String?> originalKey = const Value.absent(),
            Value<String?> currentKey = const Value.absent(),
            Value<int> capo = const Value.absent(),
            Value<int?> tempo = const Value.absent(),
            Value<String?> timeSignature = const Value.absent(),
            Value<String> chordProContent = const Value.absent(),
            Value<String?> sourceUrl = const Value.absent(),
            Value<String?> attribution = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SongsTableCompanion(
            id: id,
            title: title,
            artist: artist,
            originalKey: originalKey,
            currentKey: currentKey,
            capo: capo,
            tempo: tempo,
            timeSignature: timeSignature,
            chordProContent: chordProContent,
            sourceUrl: sourceUrl,
            attribution: attribution,
            groupId: groupId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String artist,
            Value<String?> originalKey = const Value.absent(),
            Value<String?> currentKey = const Value.absent(),
            Value<int> capo = const Value.absent(),
            Value<int?> tempo = const Value.absent(),
            Value<String?> timeSignature = const Value.absent(),
            required String chordProContent,
            Value<String?> sourceUrl = const Value.absent(),
            Value<String?> attribution = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<String> syncStatus = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SongsTableCompanion.insert(
            id: id,
            title: title,
            artist: artist,
            originalKey: originalKey,
            currentKey: currentKey,
            capo: capo,
            tempo: tempo,
            timeSignature: timeSignature,
            chordProContent: chordProContent,
            sourceUrl: sourceUrl,
            attribution: attribution,
            groupId: groupId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncStatus: syncStatus,
            version: version,
            rowid: rowid,
          ),
        ));
}

class $$SongsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SongsTableTable> {
  $$SongsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get artist => $state.composableBuilder(
      column: $state.table.artist,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get originalKey => $state.composableBuilder(
      column: $state.table.originalKey,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get currentKey => $state.composableBuilder(
      column: $state.table.currentKey,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get capo => $state.composableBuilder(
      column: $state.table.capo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get tempo => $state.composableBuilder(
      column: $state.table.tempo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get timeSignature => $state.composableBuilder(
      column: $state.table.timeSignature,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get chordProContent => $state.composableBuilder(
      column: $state.table.chordProContent,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sourceUrl => $state.composableBuilder(
      column: $state.table.sourceUrl,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get attribution => $state.composableBuilder(
      column: $state.table.attribution,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get groupId => $state.composableBuilder(
      column: $state.table.groupId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get version => $state.composableBuilder(
      column: $state.table.version,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SongsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SongsTableTable> {
  $$SongsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get artist => $state.composableBuilder(
      column: $state.table.artist,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get originalKey => $state.composableBuilder(
      column: $state.table.originalKey,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get currentKey => $state.composableBuilder(
      column: $state.table.currentKey,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get capo => $state.composableBuilder(
      column: $state.table.capo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get tempo => $state.composableBuilder(
      column: $state.table.tempo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get timeSignature => $state.composableBuilder(
      column: $state.table.timeSignature,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get chordProContent => $state.composableBuilder(
      column: $state.table.chordProContent,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sourceUrl => $state.composableBuilder(
      column: $state.table.sourceUrl,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get attribution => $state.composableBuilder(
      column: $state.table.attribution,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get groupId => $state.composableBuilder(
      column: $state.table.groupId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get syncStatus => $state.composableBuilder(
      column: $state.table.syncStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get version => $state.composableBuilder(
      column: $state.table.version,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$LyricVersionsTableTableCreateCompanionBuilder
    = LyricVersionsTableCompanion Function({
  required String id,
  required String songId,
  required String languageCode,
  required String languageName,
  required String content,
  Value<bool> isPrimary,
  Value<int> rowid,
});
typedef $$LyricVersionsTableTableUpdateCompanionBuilder
    = LyricVersionsTableCompanion Function({
  Value<String> id,
  Value<String> songId,
  Value<String> languageCode,
  Value<String> languageName,
  Value<String> content,
  Value<bool> isPrimary,
  Value<int> rowid,
});

class $$LyricVersionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LyricVersionsTableTable,
    LyricVersionsTableData,
    $$LyricVersionsTableTableFilterComposer,
    $$LyricVersionsTableTableOrderingComposer,
    $$LyricVersionsTableTableCreateCompanionBuilder,
    $$LyricVersionsTableTableUpdateCompanionBuilder> {
  $$LyricVersionsTableTableTableManager(
      _$AppDatabase db, $LyricVersionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$LyricVersionsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$LyricVersionsTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> songId = const Value.absent(),
            Value<String> languageCode = const Value.absent(),
            Value<String> languageName = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<bool> isPrimary = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LyricVersionsTableCompanion(
            id: id,
            songId: songId,
            languageCode: languageCode,
            languageName: languageName,
            content: content,
            isPrimary: isPrimary,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String songId,
            required String languageCode,
            required String languageName,
            required String content,
            Value<bool> isPrimary = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LyricVersionsTableCompanion.insert(
            id: id,
            songId: songId,
            languageCode: languageCode,
            languageName: languageName,
            content: content,
            isPrimary: isPrimary,
            rowid: rowid,
          ),
        ));
}

class $$LyricVersionsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $LyricVersionsTableTable> {
  $$LyricVersionsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get songId => $state.composableBuilder(
      column: $state.table.songId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get languageCode => $state.composableBuilder(
      column: $state.table.languageCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get languageName => $state.composableBuilder(
      column: $state.table.languageName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isPrimary => $state.composableBuilder(
      column: $state.table.isPrimary,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$LyricVersionsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $LyricVersionsTableTable> {
  $$LyricVersionsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get songId => $state.composableBuilder(
      column: $state.table.songId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get languageCode => $state.composableBuilder(
      column: $state.table.languageCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get languageName => $state.composableBuilder(
      column: $state.table.languageName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isPrimary => $state.composableBuilder(
      column: $state.table.isPrimary,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SetlistsTableTableCreateCompanionBuilder = SetlistsTableCompanion
    Function({
  required String id,
  required String title,
  Value<String?> description,
  Value<String?> groupId,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SetlistsTableTableUpdateCompanionBuilder = SetlistsTableCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<String?> groupId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SetlistsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SetlistsTableTable,
    SetlistsTableData,
    $$SetlistsTableTableFilterComposer,
    $$SetlistsTableTableOrderingComposer,
    $$SetlistsTableTableCreateCompanionBuilder,
    $$SetlistsTableTableUpdateCompanionBuilder> {
  $$SetlistsTableTableTableManager(_$AppDatabase db, $SetlistsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SetlistsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SetlistsTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SetlistsTableCompanion(
            id: id,
            title: title,
            description: description,
            groupId: groupId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SetlistsTableCompanion.insert(
            id: id,
            title: title,
            description: description,
            groupId: groupId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$SetlistsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SetlistsTableTable> {
  $$SetlistsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get groupId => $state.composableBuilder(
      column: $state.table.groupId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SetlistsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SetlistsTableTable> {
  $$SetlistsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get groupId => $state.composableBuilder(
      column: $state.table.groupId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SetlistItemsTableTableCreateCompanionBuilder
    = SetlistItemsTableCompanion Function({
  required String id,
  required String setlistId,
  required String songId,
  required int sortOrder,
  Value<String?> keyOverride,
  Value<int?> capoOverride,
  Value<String?> notes,
  Value<int> estimatedDurationSeconds,
  Value<int> rowid,
});
typedef $$SetlistItemsTableTableUpdateCompanionBuilder
    = SetlistItemsTableCompanion Function({
  Value<String> id,
  Value<String> setlistId,
  Value<String> songId,
  Value<int> sortOrder,
  Value<String?> keyOverride,
  Value<int?> capoOverride,
  Value<String?> notes,
  Value<int> estimatedDurationSeconds,
  Value<int> rowid,
});

class $$SetlistItemsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SetlistItemsTableTable,
    SetlistItemsTableData,
    $$SetlistItemsTableTableFilterComposer,
    $$SetlistItemsTableTableOrderingComposer,
    $$SetlistItemsTableTableCreateCompanionBuilder,
    $$SetlistItemsTableTableUpdateCompanionBuilder> {
  $$SetlistItemsTableTableTableManager(
      _$AppDatabase db, $SetlistItemsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SetlistItemsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$SetlistItemsTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> setlistId = const Value.absent(),
            Value<String> songId = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<String?> keyOverride = const Value.absent(),
            Value<int?> capoOverride = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> estimatedDurationSeconds = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SetlistItemsTableCompanion(
            id: id,
            setlistId: setlistId,
            songId: songId,
            sortOrder: sortOrder,
            keyOverride: keyOverride,
            capoOverride: capoOverride,
            notes: notes,
            estimatedDurationSeconds: estimatedDurationSeconds,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String setlistId,
            required String songId,
            required int sortOrder,
            Value<String?> keyOverride = const Value.absent(),
            Value<int?> capoOverride = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> estimatedDurationSeconds = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SetlistItemsTableCompanion.insert(
            id: id,
            setlistId: setlistId,
            songId: songId,
            sortOrder: sortOrder,
            keyOverride: keyOverride,
            capoOverride: capoOverride,
            notes: notes,
            estimatedDurationSeconds: estimatedDurationSeconds,
            rowid: rowid,
          ),
        ));
}

class $$SetlistItemsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SetlistItemsTableTable> {
  $$SetlistItemsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get setlistId => $state.composableBuilder(
      column: $state.table.setlistId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get songId => $state.composableBuilder(
      column: $state.table.songId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get sortOrder => $state.composableBuilder(
      column: $state.table.sortOrder,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get keyOverride => $state.composableBuilder(
      column: $state.table.keyOverride,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get capoOverride => $state.composableBuilder(
      column: $state.table.capoOverride,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get estimatedDurationSeconds => $state.composableBuilder(
      column: $state.table.estimatedDurationSeconds,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SetlistItemsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SetlistItemsTableTable> {
  $$SetlistItemsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get setlistId => $state.composableBuilder(
      column: $state.table.setlistId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get songId => $state.composableBuilder(
      column: $state.table.songId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get sortOrder => $state.composableBuilder(
      column: $state.table.sortOrder,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get keyOverride => $state.composableBuilder(
      column: $state.table.keyOverride,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get capoOverride => $state.composableBuilder(
      column: $state.table.capoOverride,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get estimatedDurationSeconds => $state.composableBuilder(
      column: $state.table.estimatedDurationSeconds,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$UserSongSettingsTableTableCreateCompanionBuilder
    = UserSongSettingsTableCompanion Function({
  required String songId,
  Value<String?> preferredKey,
  Value<int> preferredCapo,
  Value<bool> displayNashville,
  Value<bool> displayRoman,
  Value<double> fontSize,
  Value<double> autoScrollSpeed,
  Value<String?> selectedLyricVersionId,
  Value<int> rowid,
});
typedef $$UserSongSettingsTableTableUpdateCompanionBuilder
    = UserSongSettingsTableCompanion Function({
  Value<String> songId,
  Value<String?> preferredKey,
  Value<int> preferredCapo,
  Value<bool> displayNashville,
  Value<bool> displayRoman,
  Value<double> fontSize,
  Value<double> autoScrollSpeed,
  Value<String?> selectedLyricVersionId,
  Value<int> rowid,
});

class $$UserSongSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserSongSettingsTableTable,
    UserSongSettingsTableData,
    $$UserSongSettingsTableTableFilterComposer,
    $$UserSongSettingsTableTableOrderingComposer,
    $$UserSongSettingsTableTableCreateCompanionBuilder,
    $$UserSongSettingsTableTableUpdateCompanionBuilder> {
  $$UserSongSettingsTableTableTableManager(
      _$AppDatabase db, $UserSongSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$UserSongSettingsTableTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$UserSongSettingsTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> songId = const Value.absent(),
            Value<String?> preferredKey = const Value.absent(),
            Value<int> preferredCapo = const Value.absent(),
            Value<bool> displayNashville = const Value.absent(),
            Value<bool> displayRoman = const Value.absent(),
            Value<double> fontSize = const Value.absent(),
            Value<double> autoScrollSpeed = const Value.absent(),
            Value<String?> selectedLyricVersionId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserSongSettingsTableCompanion(
            songId: songId,
            preferredKey: preferredKey,
            preferredCapo: preferredCapo,
            displayNashville: displayNashville,
            displayRoman: displayRoman,
            fontSize: fontSize,
            autoScrollSpeed: autoScrollSpeed,
            selectedLyricVersionId: selectedLyricVersionId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String songId,
            Value<String?> preferredKey = const Value.absent(),
            Value<int> preferredCapo = const Value.absent(),
            Value<bool> displayNashville = const Value.absent(),
            Value<bool> displayRoman = const Value.absent(),
            Value<double> fontSize = const Value.absent(),
            Value<double> autoScrollSpeed = const Value.absent(),
            Value<String?> selectedLyricVersionId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserSongSettingsTableCompanion.insert(
            songId: songId,
            preferredKey: preferredKey,
            preferredCapo: preferredCapo,
            displayNashville: displayNashville,
            displayRoman: displayRoman,
            fontSize: fontSize,
            autoScrollSpeed: autoScrollSpeed,
            selectedLyricVersionId: selectedLyricVersionId,
            rowid: rowid,
          ),
        ));
}

class $$UserSongSettingsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $UserSongSettingsTableTable> {
  $$UserSongSettingsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get songId => $state.composableBuilder(
      column: $state.table.songId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get preferredKey => $state.composableBuilder(
      column: $state.table.preferredKey,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get preferredCapo => $state.composableBuilder(
      column: $state.table.preferredCapo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get displayNashville => $state.composableBuilder(
      column: $state.table.displayNashville,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get displayRoman => $state.composableBuilder(
      column: $state.table.displayRoman,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get fontSize => $state.composableBuilder(
      column: $state.table.fontSize,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get autoScrollSpeed => $state.composableBuilder(
      column: $state.table.autoScrollSpeed,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get selectedLyricVersionId => $state.composableBuilder(
      column: $state.table.selectedLyricVersionId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$UserSongSettingsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $UserSongSettingsTableTable> {
  $$UserSongSettingsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get songId => $state.composableBuilder(
      column: $state.table.songId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get preferredKey => $state.composableBuilder(
      column: $state.table.preferredKey,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get preferredCapo => $state.composableBuilder(
      column: $state.table.preferredCapo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get displayNashville => $state.composableBuilder(
      column: $state.table.displayNashville,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get displayRoman => $state.composableBuilder(
      column: $state.table.displayRoman,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get fontSize => $state.composableBuilder(
      column: $state.table.fontSize,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get autoScrollSpeed => $state.composableBuilder(
      column: $state.table.autoScrollSpeed,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get selectedLyricVersionId =>
      $state.composableBuilder(
          column: $state.table.selectedLyricVersionId,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$BandGroupsTableTableCreateCompanionBuilder = BandGroupsTableCompanion
    Function({
  required String id,
  required String name,
  Value<String> role,
  required String inviteCode,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$BandGroupsTableTableUpdateCompanionBuilder = BandGroupsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> role,
  Value<String> inviteCode,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$BandGroupsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BandGroupsTableTable,
    BandGroupsTableData,
    $$BandGroupsTableTableFilterComposer,
    $$BandGroupsTableTableOrderingComposer,
    $$BandGroupsTableTableCreateCompanionBuilder,
    $$BandGroupsTableTableUpdateCompanionBuilder> {
  $$BandGroupsTableTableTableManager(
      _$AppDatabase db, $BandGroupsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BandGroupsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BandGroupsTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> inviteCode = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BandGroupsTableCompanion(
            id: id,
            name: name,
            role: role,
            inviteCode: inviteCode,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> role = const Value.absent(),
            required String inviteCode,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BandGroupsTableCompanion.insert(
            id: id,
            name: name,
            role: role,
            inviteCode: inviteCode,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$BandGroupsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BandGroupsTableTable> {
  $$BandGroupsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get role => $state.composableBuilder(
      column: $state.table.role,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get inviteCode => $state.composableBuilder(
      column: $state.table.inviteCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$BandGroupsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BandGroupsTableTable> {
  $$BandGroupsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get role => $state.composableBuilder(
      column: $state.table.role,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get inviteCode => $state.composableBuilder(
      column: $state.table.inviteCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$AuditLogsTableTableCreateCompanionBuilder = AuditLogsTableCompanion
    Function({
  required String id,
  required String entityType,
  required String entityId,
  required String action,
  required String userId,
  required String userName,
  required DateTime timestamp,
  required String details,
  Value<int> rowid,
});
typedef $$AuditLogsTableTableUpdateCompanionBuilder = AuditLogsTableCompanion
    Function({
  Value<String> id,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> action,
  Value<String> userId,
  Value<String> userName,
  Value<DateTime> timestamp,
  Value<String> details,
  Value<int> rowid,
});

class $$AuditLogsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditLogsTableTable,
    AuditLogsTableData,
    $$AuditLogsTableTableFilterComposer,
    $$AuditLogsTableTableOrderingComposer,
    $$AuditLogsTableTableCreateCompanionBuilder,
    $$AuditLogsTableTableUpdateCompanionBuilder> {
  $$AuditLogsTableTableTableManager(
      _$AppDatabase db, $AuditLogsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AuditLogsTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AuditLogsTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> userName = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<String> details = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditLogsTableCompanion(
            id: id,
            entityType: entityType,
            entityId: entityId,
            action: action,
            userId: userId,
            userName: userName,
            timestamp: timestamp,
            details: details,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entityType,
            required String entityId,
            required String action,
            required String userId,
            required String userName,
            required DateTime timestamp,
            required String details,
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditLogsTableCompanion.insert(
            id: id,
            entityType: entityType,
            entityId: entityId,
            action: action,
            userId: userId,
            userName: userName,
            timestamp: timestamp,
            details: details,
            rowid: rowid,
          ),
        ));
}

class $$AuditLogsTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AuditLogsTableTable> {
  $$AuditLogsTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get entityType => $state.composableBuilder(
      column: $state.table.entityType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get entityId => $state.composableBuilder(
      column: $state.table.entityId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get action => $state.composableBuilder(
      column: $state.table.action,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get userName => $state.composableBuilder(
      column: $state.table.userName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get details => $state.composableBuilder(
      column: $state.table.details,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AuditLogsTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AuditLogsTableTable> {
  $$AuditLogsTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get entityType => $state.composableBuilder(
      column: $state.table.entityType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get entityId => $state.composableBuilder(
      column: $state.table.entityId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get action => $state.composableBuilder(
      column: $state.table.action,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get userId => $state.composableBuilder(
      column: $state.table.userId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get userName => $state.composableBuilder(
      column: $state.table.userName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get timestamp => $state.composableBuilder(
      column: $state.table.timestamp,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get details => $state.composableBuilder(
      column: $state.table.details,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SongsTableTableTableManager get songsTable =>
      $$SongsTableTableTableManager(_db, _db.songsTable);
  $$LyricVersionsTableTableTableManager get lyricVersionsTable =>
      $$LyricVersionsTableTableTableManager(_db, _db.lyricVersionsTable);
  $$SetlistsTableTableTableManager get setlistsTable =>
      $$SetlistsTableTableTableManager(_db, _db.setlistsTable);
  $$SetlistItemsTableTableTableManager get setlistItemsTable =>
      $$SetlistItemsTableTableTableManager(_db, _db.setlistItemsTable);
  $$UserSongSettingsTableTableTableManager get userSongSettingsTable =>
      $$UserSongSettingsTableTableTableManager(_db, _db.userSongSettingsTable);
  $$BandGroupsTableTableTableManager get bandGroupsTable =>
      $$BandGroupsTableTableTableManager(_db, _db.bandGroupsTable);
  $$AuditLogsTableTableTableManager get auditLogsTable =>
      $$AuditLogsTableTableTableManager(_db, _db.auditLogsTable);
}
