import 'package:test/test.dart';
import 'package:chord_engine/chord_engine.dart';

void main() {
  group('Telugu Unicode Grapheme Cluster Alignment Tests', () {
    test(
        'treats Telugu base consonant + vowel signs as single atomic grapheme cluster',
        () {
      const text = 'కృప'; // Krupa
      final clusters = GraphemeChordAligner.getGraphemeClusters(text);

      // 'కృ' is Ka + Vocalic R sign (U+0C15 U+0C43) - must be 1 grapheme cluster
      // 'ప' is Pa (U+0C2A) - 1 grapheme cluster
      expect(clusters.length, equals(2));
      expect(clusters[0], equals('కృ'));
      expect(clusters[1], equals('ప'));
    });

    test(
        'treats complex Telugu conjuncts (e.g. స్త్రీ, క్ష) as single atomic grapheme clusters',
        () {
      const text =
          'స్త్రీ'; // Stree (Sa + Virama + Ta + Virama + Ra + Vowel II)
      final clusters = GraphemeChordAligner.getGraphemeClusters(text);
      expect(clusters.length, equals(1));
      expect(clusters[0], equals('స్త్రీ'));

      const ksha = 'క్షేమము';
      final kshaClusters = GraphemeChordAligner.getGraphemeClusters(ksha);
      expect(kshaClusters[0], equals('క్షే'));
      expect(kshaClusters[1], equals('మ'));
      expect(kshaClusters[2], equals('ము'));
    });

    test(
        'aligns plain text chords above Telugu lyrics without splitting conjuncts',
        () {
      const chordLine = 'C       G       Am';
      const lyricLine = 'కృప చూపిన దేవా';

      final segments = GraphemeChordAligner.alignPlainTextLine(
        chordLine: chordLine,
        lyricLine: lyricLine,
      );

      expect(segments.isNotEmpty, isTrue);
      // Verify no segment starts with an orphaned virama or vowel diacritic
      final virama = '\u0C4D';
      for (final segment in segments) {
        expect(segment.lyrics.startsWith(virama), isFalse,
            reason: 'Segment must never cleave between consonant and virama');
      }

      // Reconstructed lyrics must match original exactly
      final reconstructed = segments.map((s) => s.lyrics).join('');
      expect(reconstructed, equals(lyricLine));
    });

    test('parses and transposes ChordPro with Telugu lyrics', () {
      const chordProTelugu = '''
{title: Krupa Choopina Deva}
{artist: Telugu Worship}
{key: C}

{start_of_chorus}
[C]కృప [G]చూపిన [Am]దేవా [F]స్తోత్రము
{end_of_chorus}
''';

      final parsed = ChordProParser.parse(chordProTelugu);
      expect(parsed.title, equals('Krupa Choopina Deva'));
      expect(parsed.sections.length, equals(1));

      final chorus = parsed.sections.first;
      expect(chorus.sectionType, equals(SectionType.chorus));

      final line = chorus.lines.first;
      expect(line.segments.length, equals(4));
      expect(line.segments[0].chord.toString(), equals('C'));
      expect(line.segments[0].lyrics, equals('కృప '));
      expect(line.segments[1].chord.toString(), equals('G'));
      expect(line.segments[1].lyrics, equals('చూపిన '));
      expect(line.segments[2].chord.toString(), equals('Am'));
      expect(line.segments[2].lyrics, equals('దేవా '));
      expect(line.segments[3].chord.toString(), equals('F'));
      expect(line.segments[3].lyrics, equals('స్తోత్రము'));

      // Transpose from C (+2) to D
      final transposed = ChordTransposer.transposeSong(parsed, semitones: 2);
      final transposedLine = transposed.sections.first.lines.first;
      expect(transposedLine.segments[0].chord.toString(), equals('D'));
      expect(transposedLine.segments[0].lyrics, equals('కృప '));
      expect(transposedLine.segments[1].chord.toString(), equals('A'));
      expect(transposedLine.segments[1].lyrics, equals('చూపిన '));
      expect(transposedLine.segments[2].chord.toString(), equals('Bm'));
      expect(transposedLine.segments[2].lyrics, equals('దేవా '));
      expect(transposedLine.segments[3].chord.toString(), equals('G'));
      expect(transposedLine.segments[3].lyrics, equals('స్తోత్రము'));
    });
  });
}
