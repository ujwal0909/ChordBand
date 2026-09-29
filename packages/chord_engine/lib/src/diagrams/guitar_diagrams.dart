import '../models/chord.dart';
import '../models/chord_diagram.dart';

/// Provides guitar chord diagrams for open and barre shapes.
class GuitarDiagrams {
  static const Map<String, ChordDiagram> _standardLibrary = {
    // Open Major Chords
    'C': ChordDiagram(
      chordName: 'C',
      instrument: InstrumentType.guitar,
      frets: [-1, 3, 2, 0, 1, 0],
      fingers: [0, 3, 2, 0, 1, 0],
    ),
    'D': ChordDiagram(
      chordName: 'D',
      instrument: InstrumentType.guitar,
      frets: [-1, -1, 0, 2, 3, 2],
      fingers: [0, 0, 0, 1, 3, 2],
    ),
    'E': ChordDiagram(
      chordName: 'E',
      instrument: InstrumentType.guitar,
      frets: [0, 2, 2, 1, 0, 0],
      fingers: [0, 2, 3, 1, 0, 0],
    ),
    'F': ChordDiagram(
      chordName: 'F',
      instrument: InstrumentType.guitar,
      frets: [1, 3, 3, 2, 1, 1],
      fingers: [1, 3, 4, 2, 1, 1],
      baseFret: 1,
      barreFret: 1,
    ),
    'G': ChordDiagram(
      chordName: 'G',
      instrument: InstrumentType.guitar,
      frets: [3, 2, 0, 0, 0, 3],
      fingers: [2, 1, 0, 0, 0, 3],
    ),
    'A': ChordDiagram(
      chordName: 'A',
      instrument: InstrumentType.guitar,
      frets: [-1, 0, 2, 2, 2, 0],
      fingers: [0, 0, 1, 2, 3, 0],
    ),
    'B': ChordDiagram(
      chordName: 'B',
      instrument: InstrumentType.guitar,
      frets: [-1, 2, 4, 4, 4, 2],
      fingers: [0, 1, 2, 3, 4, 1],
      baseFret: 2,
      barreFret: 2,
    ),

    // Minor Chords
    'Am': ChordDiagram(
      chordName: 'Am',
      instrument: InstrumentType.guitar,
      frets: [-1, 0, 2, 2, 1, 0],
      fingers: [0, 0, 2, 3, 1, 0],
    ),
    'Dm': ChordDiagram(
      chordName: 'Dm',
      instrument: InstrumentType.guitar,
      frets: [-1, -1, 0, 2, 3, 1],
      fingers: [0, 0, 0, 2, 3, 1],
    ),
    'Em': ChordDiagram(
      chordName: 'Em',
      instrument: InstrumentType.guitar,
      frets: [0, 2, 2, 0, 0, 0],
      fingers: [0, 2, 3, 0, 0, 0],
    ),
    'Bm': ChordDiagram(
      chordName: 'Bm',
      instrument: InstrumentType.guitar,
      frets: [-1, 2, 4, 4, 3, 2],
      fingers: [0, 1, 3, 4, 2, 1],
      baseFret: 2,
      barreFret: 2,
    ),
    'F#m': ChordDiagram(
      chordName: 'F#m',
      instrument: InstrumentType.guitar,
      frets: [2, 4, 4, 2, 2, 2],
      fingers: [1, 3, 4, 1, 1, 1],
      baseFret: 2,
      barreFret: 2,
    ),
    'C#m': ChordDiagram(
      chordName: 'C#m',
      instrument: InstrumentType.guitar,
      frets: [-1, 4, 6, 6, 5, 4],
      fingers: [0, 1, 3, 4, 2, 1],
      baseFret: 4,
      barreFret: 4,
    ),

    // Dominant 7th
    'C7': ChordDiagram(
      chordName: 'C7',
      instrument: InstrumentType.guitar,
      frets: [-1, 3, 2, 3, 1, 0],
      fingers: [0, 3, 2, 4, 1, 0],
    ),
    'D7': ChordDiagram(
      chordName: 'D7',
      instrument: InstrumentType.guitar,
      frets: [-1, -1, 0, 2, 1, 2],
      fingers: [0, 0, 0, 2, 1, 3],
    ),
    'E7': ChordDiagram(
      chordName: 'E7',
      instrument: InstrumentType.guitar,
      frets: [0, 2, 0, 1, 0, 0],
      fingers: [0, 2, 0, 1, 0, 0],
    ),
    'G7': ChordDiagram(
      chordName: 'G7',
      instrument: InstrumentType.guitar,
      frets: [3, 2, 0, 0, 0, 1],
      fingers: [3, 2, 0, 0, 0, 1],
    ),
    'A7': ChordDiagram(
      chordName: 'A7',
      instrument: InstrumentType.guitar,
      frets: [-1, 0, 2, 0, 2, 0],
      fingers: [0, 0, 2, 0, 3, 0],
    ),
    'B7': ChordDiagram(
      chordName: 'B7',
      instrument: InstrumentType.guitar,
      frets: [-1, 2, 1, 2, 0, 2],
      fingers: [0, 2, 1, 3, 0, 4],
    ),

    // Common Extensions
    'Cadd9': ChordDiagram(
      chordName: 'Cadd9',
      instrument: InstrumentType.guitar,
      frets: [-1, 3, 2, 0, 3, 0],
      fingers: [0, 2, 1, 0, 3, 0],
    ),
    'Dsus4': ChordDiagram(
      chordName: 'Dsus4',
      instrument: InstrumentType.guitar,
      frets: [-1, -1, 0, 2, 3, 3],
      fingers: [0, 0, 0, 1, 2, 3],
    ),
    'Asus4': ChordDiagram(
      chordName: 'Asus4',
      instrument: InstrumentType.guitar,
      frets: [-1, 0, 2, 2, 3, 0],
      fingers: [0, 0, 1, 2, 3, 0],
    ),
    'Gsus4': ChordDiagram(
      chordName: 'Gsus4',
      instrument: InstrumentType.guitar,
      frets: [3, 2, 0, 0, 1, 3],
      fingers: [3, 2, 0, 0, 1, 4],
    ),
  };

  /// Get diagram from standard library or synthesize via moveable barre shapes
  static ChordDiagram getDiagram(Chord chord) {
    final direct = _standardLibrary[chord.toString()];
    if (direct != null) return direct;

    // Check with normalized name
    final rootName = chord.root.toString();
    final key = '$rootName${chord.quality}';
    final match = _standardLibrary[key];
    if (match != null) return match;

    // Moveable barre shape generator (Root on 6th string or 5th string)
    final semitone = chord.root.semitone;
    // 6th string (Low E): E=4 -> F=5 -> F#=6 -> G=7 -> G#=8 -> A=9 -> Bb=10 -> B=11 -> C=0 -> C#=1 -> D=2 -> Eb=3
    final fret6 = (semitone - 4 + 12) % 12;
    if (fret6 > 0 && fret6 <= 11) {
      if (chord.isMinor) {
        // Em shape shifted
        return ChordDiagram(
          chordName: chord.toString(),
          instrument: InstrumentType.guitar,
          frets: [fret6, fret6 + 2, fret6 + 2, fret6, fret6, fret6],
          baseFret: fret6,
          barreFret: fret6,
        );
      } else {
        // E shape shifted
        return ChordDiagram(
          chordName: chord.toString(),
          instrument: InstrumentType.guitar,
          frets: [fret6, fret6 + 2, fret6 + 2, fret6 + 1, fret6, fret6],
          baseFret: fret6,
          barreFret: fret6,
        );
      }
    }

    // Fallback: A shape shifted
    final fret5 = (semitone - 9 + 12) % 12;
    return ChordDiagram(
      chordName: chord.toString(),
      instrument: InstrumentType.guitar,
      frets: [-1, fret5, fret5 + 2, fret5 + 2, fret5 + 2, fret5],
      baseFret: fret5 > 0 ? fret5 : 1,
      barreFret: fret5 > 0 ? fret5 : null,
    );
  }
}
