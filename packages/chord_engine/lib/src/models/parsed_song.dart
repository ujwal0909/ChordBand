import 'chord.dart';
import 'chord_line_segment.dart';
import 'key_signature.dart';

enum SectionType {
  intro,
  verse,
  preChorus,
  chorus,
  bridge,
  outro,
  instrumental,
  tag,
  other,
}

class SongSection {
  final String title;
  final SectionType sectionType;
  final List<SongLine> lines;

  const SongSection({
    required this.title,
    this.sectionType = SectionType.other,
    required this.lines,
  });

  SongSection copyWith({
    String? title,
    SectionType? sectionType,
    List<SongLine>? lines,
  }) {
    return SongSection(
      title: title ?? this.title,
      sectionType: sectionType ?? this.sectionType,
      lines: lines ?? this.lines,
    );
  }
}

/// Fully parsed song with structure, sections, chords, and metadata
class ParsedSong {
  final String title;
  final String artist;
  final KeySignature? originalKey;
  final KeySignature? currentKey;
  final int capo;
  final int? tempo;
  final String? timeSignature;
  final List<SongSection> sections;
  final Map<String, String> metadata;

  const ParsedSong({
    this.title = 'Untitled',
    this.artist = 'Unknown Artist',
    this.originalKey,
    this.currentKey,
    this.capo = 0,
    this.tempo,
    this.timeSignature,
    this.sections = const [],
    this.metadata = const {},
  });

  /// Extract all unique chords in the entire song
  Set<Chord> get allChords {
    final chords = <Chord>{};
    for (final section in sections) {
      for (final line in section.lines) {
        for (final segment in line.segments) {
          if (segment.chord != null) {
            chords.add(segment.chord!);
          }
        }
      }
    }
    return chords;
  }

  /// Convert the song back to canonical ChordPro string representation
  String toChordPro() {
    final buffer = StringBuffer();
    if (title.isNotEmpty) buffer.writeln('{title: $title}');
    if (artist.isNotEmpty) buffer.writeln('{artist: $artist}');
    if (currentKey != null) {
      buffer.writeln('{key: $currentKey}');
    } else if (originalKey != null) {
      buffer.writeln('{key: $originalKey}');
    }
    if (capo > 0) buffer.writeln('{capo: $capo}');
    if (tempo != null && tempo! > 0) buffer.writeln('{tempo: $tempo}');
    if (timeSignature != null && timeSignature!.isNotEmpty) {
      buffer.writeln('{time: $timeSignature}');
    }
    for (final entry in metadata.entries) {
      buffer.writeln('{${entry.key}: ${entry.value}}');
    }
    buffer.writeln();

    for (final section in sections) {
      final directive = _sectionDirective(section.sectionType);
      if (directive != null) {
        buffer.writeln('{start_of_$directive: ${section.title}}');
      } else if (section.title.isNotEmpty) {
        buffer.writeln('{comment: ${section.title}}');
      }

      for (final line in section.lines) {
        switch (line.type) {
          case LineType.chordsAndLyrics:
            final lineBuffer = StringBuffer();
            for (final seg in line.segments) {
              if (seg.chord != null) {
                lineBuffer.write('[${seg.chord}]');
              }
              lineBuffer.write(seg.lyrics);
            }
            buffer.writeln(lineBuffer.toString());
            break;
          case LineType.comment:
            buffer.writeln('{comment: ${line.comment}}');
            break;
          case LineType.empty:
            buffer.writeln();
            break;
        }
      }

      if (directive != null) {
        buffer.writeln('{end_of_$directive}');
      }
      buffer.writeln();
    }

    return buffer.toString().trimRight();
  }

  static String? _sectionDirective(SectionType type) {
    switch (type) {
      case SectionType.chorus:
        return 'chorus';
      case SectionType.bridge:
        return 'bridge';
      case SectionType.verse:
        return 'verse';
      default:
        return null;
    }
  }

  ParsedSong copyWith({
    String? title,
    String? artist,
    KeySignature? originalKey,
    KeySignature? currentKey,
    int? capo,
    int? tempo,
    String? timeSignature,
    List<SongSection>? sections,
    Map<String, String>? metadata,
  }) {
    return ParsedSong(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      originalKey: originalKey ?? this.originalKey,
      currentKey: currentKey ?? this.currentKey,
      capo: capo ?? this.capo,
      tempo: tempo ?? this.tempo,
      timeSignature: timeSignature ?? this.timeSignature,
      sections: sections ?? this.sections,
      metadata: metadata ?? this.metadata,
    );
  }
}
