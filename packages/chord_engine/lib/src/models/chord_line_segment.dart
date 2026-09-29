import 'chord.dart';

/// A segment of a line where a chord is associated with a specific piece of lyric text.
class ChordSegment {
  /// The musical chord placed above this segment of lyrics (or null if purely lyric extension)
  final Chord? chord;

  /// The syllable, word, or whitespace text directly under the chord
  final String lyrics;

  const ChordSegment({
    this.chord,
    required this.lyrics,
  });

  ChordSegment copyWith({
    Chord? chord,
    String? lyrics,
    bool clearChord = false,
  }) {
    return ChordSegment(
      chord: clearChord ? null : (chord ?? this.chord),
      lyrics: lyrics ?? this.lyrics,
    );
  }

  @override
  String toString() {
    if (chord != null) {
      return '[$chord]$lyrics';
    }
    return lyrics;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChordSegment &&
          runtimeType == other.runtimeType &&
          chord == other.chord &&
          lyrics == other.lyrics;

  @override
  int get hashCode => chord.hashCode ^ lyrics.hashCode;
}

enum LineType { chordsAndLyrics, comment, empty }

/// A single line in a song section
class SongLine {
  final LineType type;
  final List<ChordSegment> segments;
  final String? comment;

  const SongLine.chordsAndLyrics(this.segments)
      : type = LineType.chordsAndLyrics,
        comment = null;

  const SongLine.comment(this.comment)
      : type = LineType.comment,
        segments = const [];

  const SongLine.empty()
      : type = LineType.empty,
        comment = null,
        segments = const [];

  /// Helper to get plain lyrics for the line
  String get plainLyrics => segments.map((s) => s.lyrics).join('');

  /// Helper to check if line has any chords
  bool get hasChords => segments.any((s) => s.chord != null);
}
