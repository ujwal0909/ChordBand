import 'note.dart';

/// Represents a musical key signature with accurate diatonic scale spelling and enharmonic preferences.
class KeySignature {
  final Note tonic;
  final bool isMinor;
  final List<Note> scaleNotes;
  final bool prefersFlats;

  const KeySignature._({
    required this.tonic,
    required this.isMinor,
    required this.scaleNotes,
    required this.prefersFlats,
  });

  // Pre-defined Major Keys with exact diatonic spelling
  static final KeySignature keyC = KeySignature._(
    tonic: const Note('C'),
    isMinor: false,
    prefersFlats: false,
    scaleNotes: [
      const Note('C'),
      const Note('D'),
      const Note('E'),
      const Note('F'),
      const Note('G'),
      const Note('A'),
      const Note('B')
    ],
  );

  static final KeySignature keyG = KeySignature._(
    tonic: const Note('G'),
    isMinor: false,
    prefersFlats: false,
    scaleNotes: [
      const Note('G'),
      const Note('A'),
      const Note('B'),
      const Note('C'),
      const Note('D'),
      const Note('E'),
      const Note('F', '#')
    ],
  );

  static final KeySignature keyD = KeySignature._(
    tonic: const Note('D'),
    isMinor: false,
    prefersFlats: false,
    scaleNotes: [
      const Note('D'),
      const Note('E'),
      const Note('F', '#'),
      const Note('G'),
      const Note('A'),
      const Note('B'),
      const Note('C', '#')
    ],
  );

  static final KeySignature keyA = KeySignature._(
    tonic: const Note('A'),
    isMinor: false,
    prefersFlats: false,
    scaleNotes: [
      const Note('A'),
      const Note('B'),
      const Note('C', '#'),
      const Note('D'),
      const Note('E'),
      const Note('F', '#'),
      const Note('G', '#')
    ],
  );

  static final KeySignature keyE = KeySignature._(
    tonic: const Note('E'),
    isMinor: false,
    prefersFlats: false,
    scaleNotes: [
      const Note('E'),
      const Note('F', '#'),
      const Note('G', '#'),
      const Note('A'),
      const Note('B'),
      const Note('C', '#'),
      const Note('D', '#')
    ],
  );

  static final KeySignature keyB = KeySignature._(
    tonic: const Note('B'),
    isMinor: false,
    prefersFlats: false,
    scaleNotes: [
      const Note('B'),
      const Note('C', '#'),
      const Note('D', '#'),
      const Note('E'),
      const Note('F', '#'),
      const Note('G', '#'),
      const Note('A', '#')
    ],
  );

  static final KeySignature keyFSharp = KeySignature._(
    tonic: const Note('F', '#'),
    isMinor: false,
    prefersFlats: false,
    scaleNotes: [
      const Note('F', '#'),
      const Note('G', '#'),
      const Note('A', '#'),
      const Note('B'),
      const Note('C', '#'),
      const Note('D', '#'),
      const Note('E', '#')
    ],
  );

  static final KeySignature keyCSharp = KeySignature._(
    tonic: const Note('C', '#'),
    isMinor: false,
    prefersFlats: false,
    scaleNotes: [
      const Note('C', '#'),
      const Note('D', '#'),
      const Note('E', '#'),
      const Note('F', '#'),
      const Note('G', '#'),
      const Note('A', '#'),
      const Note('B', '#')
    ],
  );

  static final KeySignature keyF = KeySignature._(
    tonic: const Note('F'),
    isMinor: false,
    prefersFlats: true,
    scaleNotes: [
      const Note('F'),
      const Note('G'),
      const Note('A'),
      const Note('B', 'b'),
      const Note('C'),
      const Note('D'),
      const Note('E')
    ],
  );

  static final KeySignature keyBFlat = KeySignature._(
    tonic: const Note('B', 'b'),
    isMinor: false,
    prefersFlats: true,
    scaleNotes: [
      const Note('B', 'b'),
      const Note('C'),
      const Note('D'),
      const Note('E', 'b'),
      const Note('F'),
      const Note('G'),
      const Note('A')
    ],
  );

  static final KeySignature keyEFlat = KeySignature._(
    tonic: const Note('E', 'b'),
    isMinor: false,
    prefersFlats: true,
    scaleNotes: [
      const Note('E', 'b'),
      const Note('F'),
      const Note('G'),
      const Note('A', 'b'),
      const Note('B', 'b'),
      const Note('C'),
      const Note('D')
    ],
  );

  static final KeySignature keyAFlat = KeySignature._(
    tonic: const Note('A', 'b'),
    isMinor: false,
    prefersFlats: true,
    scaleNotes: [
      const Note('A', 'b'),
      const Note('B', 'b'),
      const Note('C'),
      const Note('D', 'b'),
      const Note('E', 'b'),
      const Note('F'),
      const Note('G')
    ],
  );

  static final KeySignature keyDFlat = KeySignature._(
    tonic: const Note('D', 'b'),
    isMinor: false,
    prefersFlats: true,
    scaleNotes: [
      const Note('D', 'b'),
      const Note('E', 'b'),
      const Note('F'),
      const Note('G', 'b'),
      const Note('A', 'b'),
      const Note('B', 'b'),
      const Note('C')
    ],
  );

  static final KeySignature keyGFlat = KeySignature._(
    tonic: const Note('G', 'b'),
    isMinor: false,
    prefersFlats: true,
    scaleNotes: [
      const Note('G', 'b'),
      const Note('A', 'b'),
      const Note('B', 'b'),
      const Note('C', 'b'),
      const Note('D', 'b'),
      const Note('E', 'b'),
      const Note('F')
    ],
  );

  // Pre-defined Minor Keys
  static final KeySignature keyAm = KeySignature._(
    tonic: const Note('A'),
    isMinor: true,
    prefersFlats: false,
    scaleNotes: [
      const Note('A'),
      const Note('B'),
      const Note('C'),
      const Note('D'),
      const Note('E'),
      const Note('F'),
      const Note('G')
    ],
  );

  static final KeySignature keyEm = KeySignature._(
    tonic: const Note('E'),
    isMinor: true,
    prefersFlats: false,
    scaleNotes: [
      const Note('E'),
      const Note('F', '#'),
      const Note('G'),
      const Note('A'),
      const Note('B'),
      const Note('C'),
      const Note('D')
    ],
  );

  static final KeySignature keyBm = KeySignature._(
    tonic: const Note('B'),
    isMinor: true,
    prefersFlats: false,
    scaleNotes: [
      const Note('B'),
      const Note('C', '#'),
      const Note('D'),
      const Note('E'),
      const Note('F', '#'),
      const Note('G'),
      const Note('A')
    ],
  );

  static final KeySignature keyFSharpM = KeySignature._(
    tonic: const Note('F', '#'),
    isMinor: true,
    prefersFlats: false,
    scaleNotes: [
      const Note('F', '#'),
      const Note('G', '#'),
      const Note('A'),
      const Note('B'),
      const Note('C', '#'),
      const Note('D'),
      const Note('E')
    ],
  );

  static final KeySignature keyCSharpM = KeySignature._(
    tonic: const Note('C', '#'),
    isMinor: true,
    prefersFlats: false,
    scaleNotes: [
      const Note('C', '#'),
      const Note('D', '#'),
      const Note('E'),
      const Note('F', '#'),
      const Note('G', '#'),
      const Note('A'),
      const Note('B')
    ],
  );

  static final KeySignature keyGSharpM = KeySignature._(
    tonic: const Note('G', '#'),
    isMinor: true,
    prefersFlats: false,
    scaleNotes: [
      const Note('G', '#'),
      const Note('A', '#'),
      const Note('B'),
      const Note('C', '#'),
      const Note('D', '#'),
      const Note('E'),
      const Note('F', '#')
    ],
  );

  static final KeySignature keyDm = KeySignature._(
    tonic: const Note('D'),
    isMinor: true,
    prefersFlats: true,
    scaleNotes: [
      const Note('D'),
      const Note('E'),
      const Note('F'),
      const Note('G'),
      const Note('A'),
      const Note('B', 'b'),
      const Note('C')
    ],
  );

  static final KeySignature keyGm = KeySignature._(
    tonic: const Note('G'),
    isMinor: true,
    prefersFlats: true,
    scaleNotes: [
      const Note('G'),
      const Note('A'),
      const Note('B', 'b'),
      const Note('C'),
      const Note('D'),
      const Note('E', 'b'),
      const Note('F')
    ],
  );

  static final KeySignature keyCm = KeySignature._(
    tonic: const Note('C'),
    isMinor: true,
    prefersFlats: true,
    scaleNotes: [
      const Note('C'),
      const Note('D'),
      const Note('E', 'b'),
      const Note('F'),
      const Note('G'),
      const Note('A', 'b'),
      const Note('B', 'b')
    ],
  );

  static final KeySignature keyFm = KeySignature._(
    tonic: const Note('F'),
    isMinor: true,
    prefersFlats: true,
    scaleNotes: [
      const Note('F'),
      const Note('G'),
      const Note('A', 'b'),
      const Note('B', 'b'),
      const Note('C'),
      const Note('D', 'b'),
      const Note('E', 'b')
    ],
  );

  static final KeySignature keyBbm = KeySignature._(
    tonic: const Note('B', 'b'),
    isMinor: true,
    prefersFlats: true,
    scaleNotes: [
      const Note('B', 'b'),
      const Note('C'),
      const Note('D', 'b'),
      const Note('E', 'b'),
      const Note('F'),
      const Note('G', 'b'),
      const Note('A', 'b')
    ],
  );

  static final List<KeySignature> allKeys = [
    keyC,
    keyG,
    keyD,
    keyA,
    keyE,
    keyB,
    keyFSharp,
    keyCSharp,
    keyF,
    keyBFlat,
    keyEFlat,
    keyAFlat,
    keyDFlat,
    keyGFlat,
    keyAm,
    keyEm,
    keyBm,
    keyFSharpM,
    keyCSharpM,
    keyGSharpM,
    keyDm,
    keyGm,
    keyCm,
    keyFm,
    keyBbm,
  ];

  /// Find key signature by name (e.g. "C", "G", "F#m", "Bb", "Abm")
  static KeySignature? tryParse(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;

    final isMinorKey = trimmed.endsWith('m') && !trimmed.endsWith('maj');
    final rootPart =
        isMinorKey ? trimmed.substring(0, trimmed.length - 1) : trimmed;
    final rootNote = Note.tryParse(rootPart);
    if (rootNote == null) return null;

    for (final k in allKeys) {
      if (k.isMinor == isMinorKey && k.tonic == rootNote) {
        return k;
      }
    }

    // Fallback: match by enharmonic root
    for (final k in allKeys) {
      if (k.isMinor == isMinorKey && k.tonic.enharmonicallyEquals(rootNote)) {
        return k;
      }
    }

    return null;
  }

  /// Returns the most musically correct spelling for a note in this key context.
  Note spellSemitone(int semitone) {
    final normalized = (semitone % 12 + 12) % 12;

    // First check diatonic scale degrees
    for (final scaleNote in scaleNotes) {
      if (scaleNote.semitone == normalized) {
        return scaleNote;
      }
    }

    // Chromatic note: fallback based on key preference
    return Note.fromSemitone(normalized, preferFlat: prefersFlats);
  }

  @override
  String toString() => '${tonic.toString()}${isMinor ? "m" : ""}';
}
