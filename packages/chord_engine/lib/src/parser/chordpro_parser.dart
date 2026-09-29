import '../models/chord.dart';
import '../models/chord_line_segment.dart';
import '../models/key_signature.dart';
import '../models/parsed_song.dart';

/// Parses ChordPro formatted strings into structured [ParsedSong] instances.
class ChordProParser {
  static final RegExp _tagRegex =
      RegExp(r'\{([a-zA-Z0-9_\-]+)(?::\s*(.*?))?\}');
  static final RegExp _inlineChordRegex = RegExp(r'\[([^\]]+)\]');

  /// Parse ChordPro text into [ParsedSong]
  static ParsedSong parse(String content) {
    String title = 'Untitled';
    String artist = 'Unknown Artist';
    KeySignature? key;
    int capo = 0;
    int? tempo;
    String? timeSignature;
    final metadata = <String, String>{};

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

    final rawLines = content.split(RegExp(r'\r?\n'));

    for (final rawLine in rawLines) {
      final trimmed = rawLine.trim();

      // Empty line
      if (trimmed.isEmpty) {
        if (currentLines.isNotEmpty) {
          currentLines.add(const SongLine.empty());
        }
        continue;
      }

      // Check for directive {tag: value} or {tag}
      final tagMatch = _tagRegex.firstMatch(trimmed);
      if (tagMatch != null && tagMatch.group(0) == trimmed) {
        final directive = tagMatch.group(1)!.toLowerCase();
        final value = tagMatch.group(2)?.trim() ?? '';

        switch (directive) {
          case 'title':
          case 't':
            title = value;
            break;
          case 'artist':
          case 'a':
            artist = value;
            break;
          case 'key':
          case 'k':
            key = KeySignature.tryParse(value);
            break;
          case 'capo':
            capo = int.tryParse(value) ?? 0;
            break;
          case 'tempo':
          case 'bpm':
            tempo = int.tryParse(value);
            break;
          case 'time':
            timeSignature = value;
            break;
          case 'start_of_chorus':
          case 'soc':
            commitCurrentSection();
            currentSection = SongSection(
              title: value.isNotEmpty ? value : 'Chorus',
              sectionType: SectionType.chorus,
              lines: const [],
            );
            break;
          case 'end_of_chorus':
          case 'eoc':
            commitCurrentSection();
            break;
          case 'start_of_bridge':
          case 'sob':
            commitCurrentSection();
            currentSection = SongSection(
              title: value.isNotEmpty ? value : 'Bridge',
              sectionType: SectionType.bridge,
              lines: const [],
            );
            break;
          case 'end_of_bridge':
          case 'eob':
            commitCurrentSection();
            break;
          case 'start_of_verse':
          case 'sov':
            commitCurrentSection();
            currentSection = SongSection(
              title: value.isNotEmpty ? value : 'Verse',
              sectionType: SectionType.verse,
              lines: const [],
            );
            break;
          case 'end_of_verse':
          case 'eov':
            commitCurrentSection();
            break;
          case 'comment':
          case 'c':
            currentLines.add(SongLine.comment(value));
            break;
          default:
            metadata[directive] = value;
            break;
        }
        continue;
      }

      // Standard Chord & Lyric Line
      final parsedLine = _parseLineSegments(rawLine);
      currentLines.add(parsedLine);
    }

    commitCurrentSection();

    return ParsedSong(
      title: title,
      artist: artist,
      originalKey: key,
      currentKey: key,
      capo: capo,
      tempo: tempo,
      timeSignature: timeSignature,
      sections: sections,
      metadata: metadata,
    );
  }

  /// Parses a single line with inline chords like: "[G]Amazing [C]grace [G]how sweet"
  static SongLine _parseLineSegments(String line) {
    final matches = _inlineChordRegex.allMatches(line).toList();

    if (matches.isEmpty) {
      // Plain lyrics without chords
      return SongLine.chordsAndLyrics([ChordSegment(lyrics: line)]);
    }

    final segments = <ChordSegment>[];
    int cursor = 0;

    for (int i = 0; i < matches.length; i++) {
      final match = matches[i];
      final chordString = match.group(1)!;
      final chord = Chord.tryParse(chordString);

      // Text before this chord
      if (match.start > cursor) {
        final precedingText = line.substring(cursor, match.start);
        if (segments.isEmpty) {
          segments.add(ChordSegment(lyrics: precedingText));
        } else {
          // Append to previous segment lyrics
          final last = segments.removeLast();
          segments.add(last.copyWith(lyrics: last.lyrics + precedingText));
        }
      }

      // Text following this chord (up to next match or end of line)
      final textStart = match.end;
      final textEnd =
          (i + 1 < matches.length) ? matches[i + 1].start : line.length;
      final segmentLyrics = line.substring(textStart, textEnd);

      segments.add(ChordSegment(
        chord: chord,
        lyrics: segmentLyrics,
      ));

      cursor = textEnd;
    }

    return SongLine.chordsAndLyrics(segments);
  }
}
