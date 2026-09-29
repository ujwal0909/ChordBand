import '../models/chord.dart';
import '../models/chord_diagram.dart';

/// Calculates active keys on a piano keyboard for any chord
class PianoDiagrams {
  /// Returns a [ChordDiagram] configured with keys to highlight across 2 octaves (0 to 23).
  /// Semitone 0 = Middle C (C4).
  static ChordDiagram getDiagram(Chord chord) {
    final rootSemi = chord.root.semitone;
    final intervals = _getIntervalsForQuality(chord.quality);

    final activeKeys = <int>{};

    // Add chord tones in upper octave
    for (final interval in intervals) {
      final keyIndex = rootSemi + interval;
      // Map into 2-octave range [0, 23]
      final normalized = keyIndex < 24 ? keyIndex : (keyIndex % 12) + 12;
      activeKeys.add(normalized);
    }

    // Add slash bass note if present (placed in lower octave [0, 11])
    if (chord.bass != null) {
      final bassSemi = chord.bass!.semitone;
      activeKeys.add(bassSemi);
    }

    final sortedKeys = activeKeys.toList()..sort();

    return ChordDiagram(
      chordName: chord.toString(),
      instrument: InstrumentType.piano,
      pianoKeys: sortedKeys,
    );
  }

  static List<int> _getIntervalsForQuality(String quality) {
    final q = quality.toLowerCase();
    if (q == 'm' || q == 'min') {
      return [0, 3, 7]; // Minor triad
    } else if (q == '7') {
      return [0, 4, 7, 10]; // Dominant 7th
    } else if (q == 'maj7' || q == 'm7' && quality.startsWith('maj')) {
      return [0, 4, 7, 11]; // Major 7th
    } else if (q == 'm7' || q == 'min7') {
      return [0, 3, 7, 10]; // Minor 7th
    } else if (q == 'dim') {
      return [0, 3, 6]; // Diminished triad
    } else if (q == 'dim7') {
      return [0, 3, 6, 9]; // Diminished 7th
    } else if (q == 'm7b5') {
      return [0, 3, 6, 10]; // Half-diminished
    } else if (q == 'aug' || q == '+') {
      return [0, 4, 8]; // Augmented triad
    } else if (q == 'sus2') {
      return [0, 2, 7]; // Suspended 2nd
    } else if (q == 'sus4' || q == 'sus') {
      return [0, 5, 7]; // Suspended 4th
    } else if (q == 'add9') {
      return [0, 4, 7, 14]; // Add 9
    } else if (q == '6') {
      return [0, 4, 7, 9]; // Major 6th
    } else if (q == 'm6') {
      return [0, 3, 7, 9]; // Minor 6th
    } else if (q == '5') {
      return [0, 7]; // Power chord
    }

    // Default: Major triad
    return [0, 4, 7];
  }
}
