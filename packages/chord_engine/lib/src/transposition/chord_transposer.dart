import '../models/chord.dart';
import '../models/chord_line_segment.dart';
import '../models/key_signature.dart';
import '../models/parsed_song.dart';
import 'note_transposer.dart';

/// Transposes chords, song lines, sections, and full songs.
class ChordTransposer {
  /// Transpose a single chord by [semitones].
  /// Preserves chord quality and transposes bass note if present (slash chord).
  static Chord transpose(
    Chord chord,
    int semitones, {
    KeySignature? targetKey,
    bool? preferFlats,
  }) {
    final transposedRoot = NoteTransposer.transpose(
      chord.root,
      semitones,
      targetKey: targetKey,
      preferFlats: preferFlats,
    );

    final transposedBass = chord.bass != null
        ? NoteTransposer.transpose(
            chord.bass!,
            semitones,
            targetKey: targetKey,
            preferFlats: preferFlats,
          )
        : null;

    return chord.copyWith(
      root: transposedRoot,
      bass: transposedBass,
    );
  }

  /// Convert a sounding pitch chord to the shape to physically play when capo is at [capoFret].
  /// Example: Playing an A chord shape with Capo 2 sounds as B chord.
  /// Given sounding chord B and Capo 2 -> returns A chord shape.
  static Chord toPlayAsShape(
    Chord soundingChord,
    int capoFret, {
    KeySignature? targetKey,
    bool? preferFlats,
  }) {
    if (capoFret <= 0) return soundingChord;
    return transpose(
      soundingChord,
      -capoFret,
      targetKey: targetKey,
      preferFlats: preferFlats,
    );
  }

  /// Convert a played chord shape to its actual sounding concert pitch when capo is at [capoFret].
  /// Example: Playing G shape with Capo 3 -> sounds as Bb.
  static Chord toSoundingChord(
    Chord shapeChord,
    int capoFret, {
    KeySignature? targetKey,
    bool? preferFlats,
  }) {
    if (capoFret <= 0) return shapeChord;
    return transpose(
      shapeChord,
      capoFret,
      targetKey: targetKey,
      preferFlats: preferFlats,
    );
  }

  /// Transpose a single [SongLine]
  static SongLine transposeLine(
    SongLine line,
    int semitones, {
    KeySignature? targetKey,
    bool? preferFlats,
  }) {
    if (line.type != LineType.chordsAndLyrics) return line;

    final transposedSegments = line.segments.map((segment) {
      if (segment.chord == null) return segment;
      final transposedChord = transpose(
        segment.chord!,
        semitones,
        targetKey: targetKey,
        preferFlats: preferFlats,
      );
      return segment.copyWith(chord: transposedChord);
    }).toList();

    return SongLine.chordsAndLyrics(transposedSegments);
  }

  /// Transpose an entire [SongSection]
  static SongSection transposeSection(
    SongSection section,
    int semitones, {
    KeySignature? targetKey,
    bool? preferFlats,
  }) {
    final transposedLines = section.lines
        .map((line) => transposeLine(
              line,
              semitones,
              targetKey: targetKey,
              preferFlats: preferFlats,
            ))
        .toList();

    return section.copyWith(lines: transposedLines);
  }

  /// Transposes an entire [ParsedSong] to a target key or by a given number of semitones
  static ParsedSong transposeSong(
    ParsedSong song, {
    int? semitones,
    KeySignature? toKey,
    int? newCapo,
    bool? preferFlats,
  }) {
    int delta = 0;
    KeySignature? targetKey = toKey;

    if (semitones != null && semitones != 0) {
      delta = semitones;
      // If a toKey was passed alongside semitones, clear it so the semitone delta rules
      targetKey = null;
    } else if (toKey != null) {
      if (song.currentKey != null) {
        delta = NoteTransposer.semitonesBetween(song.currentKey!, toKey);
      } else if (song.originalKey != null) {
        delta = NoteTransposer.semitonesBetween(song.originalKey!, toKey);
      }
    }

    if (delta == 0 && targetKey == null && newCapo == null) {
      return song;
    }

    final transposedSections = song.sections
        .map((sec) => transposeSection(
              sec,
              delta,
              targetKey: targetKey,
              preferFlats: preferFlats,
            ))
        .toList();

    return song.copyWith(
      currentKey: targetKey ??
          (song.currentKey != null
              ? KeySignature.tryParse(NoteTransposer.transpose(
                    song.currentKey!.tonic,
                    delta,
                    preferFlats: preferFlats,
                  ).toString() +
                  (song.currentKey!.isMinor ? 'm' : ''))
              : null),
      capo: newCapo ?? song.capo,
      sections: transposedSections,
    );
  }
}
