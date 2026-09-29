import 'package:characters/characters.dart';
import '../models/chord.dart';
import '../models/chord_line_segment.dart';

/// Aligns chords with lyrics using Unicode Extended Grapheme Clusters.
/// Essential for Indic scripts (especially Telugu) where conjuncts and vowel modifiers
/// must never be split or separated from their base consonant.
class GraphemeChordAligner {
  /// Split string into atomic visual grapheme clusters (UAX #29 compliant)
  static List<String> getGraphemeClusters(String text) {
    return text.characters.toList();
  }

  /// Calculates visual display length in grapheme clusters
  static int graphemeLength(String text) {
    return text.characters.length;
  }

  /// Takes a raw chord line (e.g. "G      C      D") and a lyric line
  /// (e.g. "కృప చూపిన దేవా" or "Amazing grace"), and produces aligned [ChordSegment]s
  /// without ever slicing a Telugu/Indic conjunct or combining vowel sign.
  static List<ChordSegment> alignPlainTextLine({
    required String chordLine,
    required String lyricLine,
  }) {
    final chordMatches = RegExp(r'\S+').allMatches(chordLine).toList();
    if (chordMatches.isEmpty) {
      return [ChordSegment(lyrics: lyricLine)];
    }

    final lyricClusters = getGraphemeClusters(lyricLine);
    final segments = <ChordSegment>[];

    int lastLyricClusterIndex = 0;

    for (int i = 0; i < chordMatches.length; i++) {
      final match = chordMatches[i];
      final chordText = match.group(0)!;
      final chord = Chord.tryParse(chordText);

      // The character column in the chord line
      final chordCol = match.start;

      // Map chord column to the nearest grapheme cluster in lyric line
      final targetClusterIndex = chordCol.clamp(0, lyricClusters.length);

      // If there are lyrics before this chord, emit them as a segment
      if (targetClusterIndex > lastLyricClusterIndex) {
        final precedingLyrics = lyricClusters
            .sublist(lastLyricClusterIndex, targetClusterIndex)
            .join('');

        // If this is the very first segment before any chords
        if (segments.isEmpty) {
          segments.add(ChordSegment(lyrics: precedingLyrics));
        } else {
          // Append to previous chord segment or add neutral segment
          segments.add(ChordSegment(lyrics: precedingLyrics));
        }
        lastLyricClusterIndex = targetClusterIndex;
      }

      // Determine how many lyric clusters belong to this chord
      // Up until the next chord's column or end of lyrics
      int nextChordCol = lyricClusters.length;
      if (i + 1 < chordMatches.length) {
        nextChordCol = chordMatches[i + 1].start.clamp(0, lyricClusters.length);
      }

      final segmentLyrics = lastLyricClusterIndex < lyricClusters.length
          ? lyricClusters.sublist(lastLyricClusterIndex, nextChordCol).join('')
          : '';

      segments.add(ChordSegment(
        chord: chord,
        lyrics: segmentLyrics,
      ));

      lastLyricClusterIndex = nextChordCol;
    }

    // Append any trailing lyrics
    if (lastLyricClusterIndex < lyricClusters.length) {
      final trailing = lyricClusters.sublist(lastLyricClusterIndex).join('');
      segments.add(ChordSegment(lyrics: trailing));
    }

    return segments;
  }
}
