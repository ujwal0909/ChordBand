enum InstrumentType { guitar, ukulele, piano }

/// Represents a chord diagram for string instruments (Guitar, Ukulele) or Keyboard (Piano)
class ChordDiagram {
  final String chordName;
  final InstrumentType instrument;

  // String instruments (Guitar: 6 strings, Ukulele: 4 strings)
  // String index 0 is lowest pitch string (e.g. 6th string for guitar = low E)
  // -1 indicates muted ('x'), 0 indicates open ('o'), >0 is fret number
  final List<int> frets;
  final List<int>?
      fingers; // 1: Index, 2: Middle, 3: Ring, 4: Pinky, 0/null: None
  final int
      baseFret; // Fret position for diagram (usually 1, higher for barre chords)
  final int? barreFret;
  final int? barreFromString;
  final int? barreToString;

  // Piano: List of pitch offsets (0 = C, 1 = C#, ..., 11 = B) or MIDI note numbers
  final List<int>? pianoKeys;

  const ChordDiagram({
    required this.chordName,
    required this.instrument,
    this.frets = const [],
    this.fingers,
    this.baseFret = 1,
    this.barreFret,
    this.barreFromString,
    this.barreToString,
    this.pianoKeys,
  });

  bool get isMutedAll => frets.isNotEmpty && frets.every((f) => f == -1);
}
