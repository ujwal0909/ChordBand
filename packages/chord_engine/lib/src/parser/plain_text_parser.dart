import '../models/chord.dart';
import '../models/chord_line_segment.dart';
import '../models/key_signature.dart';
import '../models/parsed_song.dart';
import 'grapheme_chord_aligner.dart';

/// Parses traditional plain-text chord-over-lyrics documents
class PlainTextParser {
  static final RegExp _sectionHeaderRegex = RegExp(
    r'^\s*\[?(verse\s*\d*|chorus\s*\d*|bridge\s*\d*|pre-chorus\s*\d*|intro\s*\d*|outro\s*\d*|instrumental|tag|interlude|solo)\]?\s*:?\s*$',
    caseSensitive: false,
  );

  /// Parse plain text chords and lyrics into [ParsedSong]
  static ParsedSong parse(String content) {
    final rawLines = content.split(RegExp(r'\r?\n'));

    String title = 'Untitled';
    String artist = 'Unknown Artist';
    KeySignature? key;

    final sections = <SongSection>[];
    SongSection? currentSection;
    final currentLines = <SongLine>[];

    void commitCurrentSection() {
      if (currentLines.isNotEmpty || currentSection != null) {
        final secTitle = currentSection?.title ??
            (sections.isEmpty ? 'Main' : 'Section ${sections.length + 1}');
        final secType = currentSection?.sectionType ?? SectionType.other;
        sections.add(SongSection(
          title: secTitle,
          sectionType: secType,
          lines: List.unmodifiable(currentLines),
        ));
        currentLines.clear();
        currentSection = null;
      }
    }

    int i = 0;
    while (i < rawLines.length) {
      final line = rawLines[i];
      final trimmed = line.trim();

      if (trimmed.isEmpty) {
        if (currentLines.isNotEmpty) {
          currentLines.add(const SongLine.empty());
        }
        i++;
        continue;
      }

      // Check for Title / Artist / Key headers
      if (trimmed.toLowerCase().startsWith('title:')) {
        title = trimmed.substring(6).trim();
        i++;
        continue;
      }
      if (trimmed.toLowerCase().startsWith('artist:')) {
        artist = trimmed.substring(7).trim();
        i++;
        continue;
      }
      if (trimmed.toLowerCase().startsWith('key:')) {
        key = KeySignature.tryParse(trimmed.substring(4).trim());
        i++;
        continue;
      }

      // Check for Section Header
      final headerMatch = _sectionHeaderRegex.firstMatch(trimmed);
      if (headerMatch != null) {
        commitCurrentSection();
        final rawSectionName = headerMatch.group(1)!;
        final secType = _categorizeSection(rawSectionName);
        currentSection = SongSection(
          title: rawSectionName,
          sectionType: secType,
          lines: const [],
        );
        i++;
        continue;
      }

      // Check if current line is a chord line
      if (_isChordLine(line)) {
        // Look at the following line
        if (i + 1 < rawLines.length) {
          final nextLine = rawLines[i + 1];
          final nextTrimmed = nextLine.trim();

          // If next line is lyrics (not empty, not header, not chord line)
          if (nextTrimmed.isNotEmpty &&
              !_isChordLine(nextLine) &&
              !_sectionHeaderRegex.hasMatch(nextTrimmed)) {
            // Pair chords with lyrics
            final segments = GraphemeChordAligner.alignPlainTextLine(
              chordLine: line,
              lyricLine: nextLine,
            );
            currentLines.add(SongLine.chordsAndLyrics(segments));
            i += 2;
            continue;
          }
        }

        // Chord line without lyrics (instrumental or intro)
        final segments = GraphemeChordAligner.alignPlainTextLine(
          chordLine: line,
          lyricLine: '',
        );
        currentLines.add(SongLine.chordsAndLyrics(segments));
        i++;
        continue;
      }

      // Plain lyric line without chords
      currentLines.add(SongLine.chordsAndLyrics([ChordSegment(lyrics: line)]));
      i++;
    }

    commitCurrentSection();

    return ParsedSong(
      title: title,
      artist: artist,
      originalKey: key,
      currentKey: key,
      sections: sections,
    );
  }

  /// Evaluates whether a line is likely a chord line
  static bool _isChordLine(String line) {
    final tokens = line.trim().split(RegExp(r'\s+'));
    if (tokens.isEmpty || line.trim().isEmpty) return false;

    int validChords = 0;
    for (final token in tokens) {
      if (Chord.tryParse(token) != null) {
        validChords++;
      }
    }

    // If at least 70% of tokens are valid chords, treat as chord line
    return (validChords / tokens.length) >= 0.70;
  }

  static SectionType _categorizeSection(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('chorus')) return SectionType.chorus;
    if (lower.contains('verse')) return SectionType.verse;
    if (lower.contains('bridge')) return SectionType.bridge;
    if (lower.contains('pre')) return SectionType.preChorus;
    if (lower.contains('intro')) return SectionType.intro;
    if (lower.contains('outro')) return SectionType.outro;
    if (lower.contains('instrumental') || lower.contains('solo')) {
      return SectionType.instrumental;
    }
    return SectionType.other;
  }
}
