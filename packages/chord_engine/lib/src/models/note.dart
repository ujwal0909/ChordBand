/// Represents a musical note with exact name and accidental.
class Note {
  final String baseName; // 'A', 'B', 'C', 'D', 'E', 'F', 'G'
  final String accidental; // '', '#', 'b', '##', 'x', 'bb'

  const Note(this.baseName, [this.accidental = '']);

  static const Map<String, int> _baseSemitones = {
    'C': 0,
    'D': 2,
    'E': 4,
    'F': 5,
    'G': 7,
    'A': 9,
    'B': 11,
  };

  static const List<String> _sharpNotes = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  static const List<String> _flatNotes = [
    'C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab', 'A', 'Bb', 'B'
  ];

  /// The pitch class / semitone value in range [0, 11] where C = 0.
  int get semitone {
    final base = _baseSemitones[baseName.toUpperCase()] ?? 0;
    int acc = 0;
    if (accidental == '#' || accidental == '♯') {
      acc = 1;
    } else if (accidental == '##' || accidental == 'x' || accidental == '𝄪') {
      acc = 2;
    } else if (accidental == 'b' || accidental == '♭') {
      acc = -1;
    } else if (accidental == 'bb' || accidental == '𝄫') {
      acc = -2;
    }
    return (base + acc) % 12 >= 0 ? (base + acc) % 12 : ((base + acc) % 12) + 12;
  }

  /// Parse note string like 'C', 'F#', 'Bb', 'G##', 'Dbb', 'E#', 'Cb'
  static Note? tryParse(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    final firstChar = trimmed[0].toUpperCase();
    if (!_baseSemitones.containsKey(firstChar)) return null;

    final rest = trimmed.substring(1);
    if (rest.isEmpty) {
      return Note(firstChar, '');
    }

    if (rest == '#' || rest == '♯') {
      return Note(firstChar, '#');
    } else if (rest == '##' || rest == 'x' || rest == '𝄪') {
      return Note(firstChar, '##');
    } else if (rest == 'b' || rest == '♭') {
      return Note(firstChar, 'b');
    } else if (rest == 'bb' || rest == '𝄫') {
      return Note(firstChar, 'bb');
    }

    return null;
  }

  static Note parse(String text) {
    final note = tryParse(text);
    if (note == null) {
      throw FormatException('Invalid musical note: "$text"');
    }
    return note;
  }

  /// Create a standard note from a semitone [0, 11]
  factory Note.fromSemitone(int semitone, {bool preferFlat = false}) {
    final normalized = (semitone % 12 + 12) % 12;
    final noteStr = preferFlat ? _flatNotes[normalized] : _sharpNotes[normalized];
    return Note.parse(noteStr);
  }

  bool get isSharp => accidental == '#' || accidental == '##' || accidental == 'x';
  bool get isFlat => accidental == 'b' || accidental == 'bb';
  bool get isNatural => accidental.isEmpty;

  /// Compares pitch class regardless of spelling (e.g. C# == Db)
  bool enharmonicallyEquals(Note other) => semitone == other.semitone;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          baseName.toUpperCase() == other.baseName.toUpperCase() &&
          accidental == other.accidental;

  @override
  int get hashCode => baseName.toUpperCase().hashCode ^ accidental.hashCode;

  @override
  String toString() => '$baseName$accidental';
}
