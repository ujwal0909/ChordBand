import 'note.dart';

/// Represents a musical chord with root note, quality, alterations, and optional slash bass note.
class Chord {
  final Note root;
  final String quality; // '', 'm', '7', 'maj7', 'm7', 'dim', 'dim7', 'aug', 'sus4', 'sus2', 'add9', 'm7b5', '5', etc.
  final Note? bass; // Optional bass note for slash chords like D/F#

  const Chord({
    required this.root,
    this.quality = '',
    this.bass,
  });

  /// Regex pattern to parse chords like "C", "F#m7", "Bbmaj7", "D/F#", "G#dim7/B", "Csus4"
  static final RegExp _chordRegex = RegExp(
    r'^([A-Ga-g](?:##|bb|x|𝄪|𝄫|[#b♯♭])?)(.*?)(?:\/([A-Ga-g](?:##|bb|x|𝄪|𝄫|[#b♯♭])?))?$',
  );

  /// Try parsing a chord string. Returns null if invalid.
  static Chord? tryParse(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    final match = _chordRegex.firstMatch(trimmed);
    if (match == null) return null;

    final rootStr = match.group(1);
    if (rootStr == null) return null;

    final rootNote = Note.tryParse(rootStr);
    if (rootNote == null) return null;

    final qualityStr = match.group(2) ?? '';
    final bassStr = match.group(3);

    Note? bassNote;
    if (bassStr != null && bassStr.isNotEmpty) {
      bassNote = Note.tryParse(bassStr);
      if (bassNote == null) return null; // Invalid bass note
    }

    return Chord(
      root: rootNote,
      quality: _normalizeQuality(qualityStr),
      bass: bassNote,
    );
  }

  /// Parse chord or throw [FormatException]
  static Chord parse(String text) {
    final chord = tryParse(text);
    if (chord == null) {
      throw FormatException('Invalid chord: "$text"');
    }
    return chord;
  }

  /// Normalize common variations into standard representations
  static String _normalizeQuality(String raw) {
    var q = raw.trim();
    if (q == 'minor') return 'm';
    if (q == 'major') return '';
    if (q == 'M') return '';
    if (q == 'min') return 'm';
    if (q == 'Δ' || q == '^') return 'maj7';
    if (q == 'ø' || q == 'Ø') return 'm7b5';
    if (q == 'o' || q == '°') return 'dim';
    if (q == 'o7' || q == '°7') return 'dim7';
    if (q == '+') return 'aug';
    return q;
  }

  bool get isMinor =>
      quality == 'm' ||
      quality.startsWith('m') &&
          !quality.startsWith('maj') &&
          !quality.startsWith('mMaj');

  bool get isMajor =>
      quality.isEmpty ||
      quality == 'maj' ||
      quality == 'maj7' ||
      quality == 'maj9' ||
      quality == '6';

  bool get isDominant =>
      quality == '7' ||
      quality == '9' ||
      quality == '11' ||
      quality == '13' ||
      quality == '7sus4' ||
      quality == '7b5' ||
      quality == '7#9';

  bool get isDiminished => quality.contains('dim') || quality == 'm7b5';
  bool get isAugmented => quality.contains('aug') || quality.contains('+');
  bool get isSuspended => quality.contains('sus');
  bool get isSlashChord => bass != null;

  /// Returns full formatted string representation (e.g. "D/F#")
  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write(root.toString());
    buffer.write(quality);
    if (bass != null) {
      buffer.write('/');
      buffer.write(bass.toString());
    }
    return buffer.toString();
  }

  Chord copyWith({
    Note? root,
    String? quality,
    Note? bass,
    bool clearBass = false,
  }) {
    return Chord(
      root: root ?? this.root,
      quality: quality ?? this.quality,
      bass: clearBass ? null : (bass ?? this.bass),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chord &&
          runtimeType == other.runtimeType &&
          root == other.root &&
          quality == other.quality &&
          bass == other.bass;

  @override
  int get hashCode => root.hashCode ^ quality.hashCode ^ (bass?.hashCode ?? 0);
}
