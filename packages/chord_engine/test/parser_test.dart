import 'package:test/test.dart';
import 'package:chord_engine/chord_engine.dart';

void main() {
  group('ChordPro & PlainText Parser Tests', () {
    test('parses ChordPro metadata and directives', () {
      const sample = '''
{title: Amazing Grace}
{artist: John Newton}
{key: G}
{tempo: 72}
{time: 3/4}
{capo: 0}

{start_of_verse: Verse 1}
[G]Amazing grace how [C]sweet the [G]sound
That [G]saved a wretch like [D]me
{end_of_verse}

{start_of_chorus}
[G]I once was [C]lost, but now am [G]found
{end_of_chorus}
''';

      final song = ChordProParser.parse(sample);
      expect(song.title, equals('Amazing Grace'));
      expect(song.artist, equals('John Newton'));
      expect(song.originalKey, equals(KeySignature.keyG));
      expect(song.tempo, equals(72));
      expect(song.timeSignature, equals('3/4'));
      expect(song.sections.length, equals(2));

      expect(song.sections[0].title, equals('Verse 1'));
      expect(song.sections[0].sectionType, equals(SectionType.verse));

      expect(song.sections[1].title, equals('Chorus'));
      expect(song.sections[1].sectionType, equals(SectionType.chorus));

      final allChords = song.allChords.map((c) => c.toString()).toSet();
      expect(allChords, containsAll({'G', 'C', 'D'}));
    });

    test('serializes ParsedSong back to ChordPro format', () {
      final song = ParsedSong(
        title: 'Test Song',
        artist: 'Test Artist',
        originalKey: KeySignature.keyC,
        tempo: 120,
        sections: [
          SongSection(
            title: 'Verse 1',
            sectionType: SectionType.verse,
            lines: [
              SongLine.chordsAndLyrics([
                ChordSegment(chord: Chord.parse('C'), lyrics: 'Hello '),
                ChordSegment(chord: Chord.parse('G'), lyrics: 'World'),
              ])
            ],
          )
        ],
      );

      final chordPro = song.toChordPro();
      expect(chordPro, contains('{title: Test Song}'));
      expect(chordPro, contains('{artist: Test Artist}'));
      expect(chordPro, contains('{key: C}'));
      expect(chordPro, contains('{tempo: 120}'));
      expect(chordPro, contains('[C]Hello [G]World'));
    });

    test('parses plain text chord-over-lyrics format', () {
      const plainText = '''
Title: Simple Song
Artist: Singer
Key: D

[Verse 1]
D              G
Sun is rising high today
A              D
Music fills the air
''';

      final song = PlainTextParser.parse(plainText);
      expect(song.title, equals('Simple Song'));
      expect(song.artist, equals('Singer'));
      expect(song.originalKey, equals(KeySignature.keyD));
      expect(song.sections.length, equals(1));
      expect(song.sections.first.lines.where((l) => l.type != LineType.empty).length, equals(2));
      expect(song.sections.first.lines.firstWhere((l) => l.hasChords).hasChords, isTrue);
    });
  });
}
