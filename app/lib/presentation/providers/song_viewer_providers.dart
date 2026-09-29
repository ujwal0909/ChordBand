import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chord_engine/chord_engine.dart';
import '../../data/database/app_database.dart';

enum ChordDisplayNotation { standard, nashville, roman }

class SongViewerState {
  final int semitoneOffset;
  final KeySignature? targetKey;
  final int capoFret;
  final bool preferFlats;
  final double fontSize;
  final bool isMonospace;
  final ChordDisplayNotation notation;
  final bool isAutoScrolling;
  final double autoScrollSpeed; // pixels per second
  final String? activeLyricVersionId;
  final bool sideBySideMode;
  final int? activeSectionIndex;

  const SongViewerState({
    this.semitoneOffset = 0,
    this.targetKey,
    this.capoFret = 0,
    this.preferFlats = false,
    this.fontSize = 17.0,
    this.isMonospace = false,
    this.notation = ChordDisplayNotation.standard,
    this.isAutoScrolling = false,
    this.autoScrollSpeed = 25.0,
    this.activeLyricVersionId,
    this.sideBySideMode = false,
    this.activeSectionIndex,
  });

  SongViewerState copyWith({
    int? semitoneOffset,
    KeySignature? targetKey,
    bool clearTargetKey = false,
    int? capoFret,
    bool? preferFlats,
    double? fontSize,
    bool? isMonospace,
    ChordDisplayNotation? notation,
    bool? isAutoScrolling,
    double? autoScrollSpeed,
    String? activeLyricVersionId,
    bool? sideBySideMode,
    int? activeSectionIndex,
  }) {
    return SongViewerState(
      semitoneOffset: semitoneOffset ?? this.semitoneOffset,
      targetKey: clearTargetKey ? null : (targetKey ?? this.targetKey),
      capoFret: capoFret ?? this.capoFret,
      preferFlats: preferFlats ?? this.preferFlats,
      fontSize: fontSize ?? this.fontSize,
      isMonospace: isMonospace ?? this.isMonospace,
      notation: notation ?? this.notation,
      isAutoScrolling: isAutoScrolling ?? this.isAutoScrolling,
      autoScrollSpeed: autoScrollSpeed ?? this.autoScrollSpeed,
      activeLyricVersionId: activeLyricVersionId ?? this.activeLyricVersionId,
      sideBySideMode: sideBySideMode ?? this.sideBySideMode,
      activeSectionIndex: activeSectionIndex ?? this.activeSectionIndex,
    );
  }
}

class SongViewerNotifier extends FamilyNotifier<SongViewerState, String> {
  @override
  SongViewerState build(String arg) {
    return const SongViewerState();
  }

  void initFromSavedSettings(
      UserSongSettingsTableData? settings, SongsTableData? song) {
    if (settings != null) {
      final targetKey = settings.preferredKey != null
          ? KeySignature.tryParse(settings.preferredKey!)
          : null;
      ChordDisplayNotation not = ChordDisplayNotation.standard;
      if (settings.displayNashville) not = ChordDisplayNotation.nashville;
      if (settings.displayRoman) not = ChordDisplayNotation.roman;

      state = state.copyWith(
        targetKey: targetKey,
        capoFret: settings.preferredCapo,
        fontSize: settings.fontSize,
        notation: not,
        autoScrollSpeed: settings.autoScrollSpeed * 25.0,
        activeLyricVersionId: settings.selectedLyricVersionId,
      );
    } else if (song != null) {
      state = state.copyWith(
        capoFret: song.capo,
      );
    }
  }

  void transpose(int delta) {
    state = state.copyWith(
      semitoneOffset: state.semitoneOffset + delta,
      clearTargetKey: true,
    );
  }

  void resetTransposition() {
    state = state.copyWith(
      semitoneOffset: 0,
      clearTargetKey: true,
      capoFret: 0,
    );
  }

  void setTargetKey(KeySignature? key) {
    state = state.copyWith(targetKey: key, clearTargetKey: key == null);
  }

  void setCapo(int fret) {
    state = state.copyWith(capoFret: fret);
  }

  void togglePreferFlats() {
    state = state.copyWith(preferFlats: !state.preferFlats);
  }

  void setFontSize(double size) {
    state = state.copyWith(fontSize: size.clamp(10.0, 36.0));
  }

  void zoomFont(double scaleFactor) {
    state = state.copyWith(
        fontSize: (state.fontSize * scaleFactor).clamp(10.0, 36.0));
  }

  void toggleMonospace() {
    state = state.copyWith(isMonospace: !state.isMonospace);
  }

  void setNotation(ChordDisplayNotation notation) {
    state = state.copyWith(notation: notation);
  }

  void toggleAutoScroll() {
    state = state.copyWith(isAutoScrolling: !state.isAutoScrolling);
  }

  void setAutoScrollSpeed(double speed) {
    state = state.copyWith(autoScrollSpeed: speed.clamp(5.0, 150.0));
  }

  void setLyricVersion(String? versionId) {
    state = state.copyWith(activeLyricVersionId: versionId);
  }

  void toggleSideBySide() {
    state = state.copyWith(sideBySideMode: !state.sideBySideMode);
  }

  void setActiveSection(int? index) {
    state = state.copyWith(activeSectionIndex: index);
  }
}

final songViewerProvider =
    NotifierProvider.family<SongViewerNotifier, SongViewerState, String>(
  SongViewerNotifier.new,
);
