import '../models/chord.dart';
import '../models/chord_diagram.dart';

/// Provides ukulele chord diagrams in standard G-C-E-A tuning.
class UkuleleDiagrams {
  static const Map<String, ChordDiagram> _standardLibrary = {
    'C': ChordDiagram(
      chordName: 'C',
      instrument: InstrumentType.ukulele,
      frets: [0, 0, 0, 3],
      fingers: [0, 0, 0, 3],
    ),
    'D': ChordDiagram(
      chordName: 'D',
      instrument: InstrumentType.ukulele,
      frets: [2, 2, 2, 0],
      fingers: [1, 2, 3, 0],
    ),
    'E': ChordDiagram(
      chordName: 'E',
      instrument: InstrumentType.ukulele,
      frets: [4, 4, 4, 2],
      fingers: [2, 3, 4, 1],
    ),
    'F': ChordDiagram(
      chordName: 'F',
      instrument: InstrumentType.ukulele,
      frets: [2, 0, 1, 0],
      fingers: [2, 0, 1, 0],
    ),
    'G': ChordDiagram(
      chordName: 'G',
      instrument: InstrumentType.ukulele,
      frets: [0, 2, 3, 2],
      fingers: [0, 1, 3, 2],
    ),
    'A': ChordDiagram(
      chordName: 'A',
      instrument: InstrumentType.ukulele,
      frets: [2, 1, 0, 0],
      fingers: [2, 1, 0, 0],
    ),
    'B': ChordDiagram(
      chordName: 'B',
      instrument: InstrumentType.ukulele,
      frets: [4, 3, 2, 2],
      fingers: [3, 2, 1, 1],
      barreFret: 2,
    ),
    'Bb': ChordDiagram(
      chordName: 'Bb',
      instrument: InstrumentType.ukulele,
      frets: [3, 2, 1, 1],
      fingers: [3, 2, 1, 1],
      barreFret: 1,
    ),
    'Am': ChordDiagram(
      chordName: 'Am',
      instrument: InstrumentType.ukulele,
      frets: [2, 0, 0, 0],
      fingers: [2, 0, 0, 0],
    ),
    'Dm': ChordDiagram(
      chordName: 'Dm',
      instrument: InstrumentType.ukulele,
      frets: [2, 2, 1, 0],
      fingers: [2, 3, 1, 0],
    ),
    'Em': ChordDiagram(
      chordName: 'Em',
      instrument: InstrumentType.ukulele,
      frets: [0, 4, 3, 2],
      fingers: [0, 3, 2, 1],
    ),
    'Bm': ChordDiagram(
      chordName: 'Bm',
      instrument: InstrumentType.ukulele,
      frets: [4, 2, 2, 2],
      fingers: [3, 1, 1, 1],
      barreFret: 2,
    ),
    'F#m': ChordDiagram(
      chordName: 'F#m',
      instrument: InstrumentType.ukulele,
      frets: [2, 1, 2, 0],
      fingers: [2, 1, 3, 0],
    ),
    'C7': ChordDiagram(
      chordName: 'C7',
      instrument: InstrumentType.ukulele,
      frets: [0, 0, 0, 1],
      fingers: [0, 0, 0, 1],
    ),
    'G7': ChordDiagram(
      chordName: 'G7',
      instrument: InstrumentType.ukulele,
      frets: [0, 2, 1, 2],
      fingers: [0, 2, 1, 3],
    ),
  };

  static ChordDiagram getDiagram(Chord chord) {
    final direct = _standardLibrary[chord.toString()];
    if (direct != null) return direct;

    final key = '${chord.root}${chord.quality}';
    final match = _standardLibrary[key];
    if (match != null) return match;

    // Default ukulele fallback
    return ChordDiagram(
      chordName: chord.toString(),
      instrument: InstrumentType.ukulele,
      frets: [0, 0, 0, 0],
    );
  }
}
