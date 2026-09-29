import 'package:test/test.dart';
import 'package:chord_engine/chord_engine.dart';

void main() {
  group('Chord & Note Parsing Tests', () {
    test('parses simple major and minor chords', () {
      final c = Chord.parse('C');
      expect(c.root, equals(const Note('C')));
      expect(c.quality, equals(''));
      expect(c.bass, isNull);
      expect(c.isMajor, isTrue);

      final am = Chord.parse('Am');
      expect(am.root, equals(const Note('A')));
      expect(am.quality, equals('m'));
      expect(am.isMinor, isTrue);
    });

    test('parses chords with accidentals (#, b)', () {
      final fSharp = Chord.parse('F#');
      expect(fSharp.root, equals(const Note('F', '#')));
      expect(fSharp.root.semitone, equals(6));

      final bFlat = Chord.parse('Bb');
      expect(bFlat.root, equals(const Note('B', 'b')));
      expect(bFlat.root.semitone, equals(10));
    });

    test('parses extended qualities: 7, maj7, min7, dim, dim7, m7b5, aug, sus2, sus4, add9', () {
      expect(Chord.parse('G7').isDominant, isTrue);
      expect(Chord.parse('Cmaj7').quality, equals('maj7'));
      expect(Chord.parse('Dm7').quality, equals('m7'));
      expect(Chord.parse('Bdim').isDiminished, isTrue);
      expect(Chord.parse('Bdim7').quality, equals('dim7'));
      expect(Chord.parse('Em7b5').quality, equals('m7b5'));
      expect(Chord.parse('Caug').isAugmented, isTrue);
      expect(Chord.parse('Dsus4').isSuspended, isTrue);
      expect(Chord.parse('Asus2').quality, equals('sus2'));
      expect(Chord.parse('Cadd9').quality, equals('add9'));
    });

    test('normalizes symbols like Δ, o, ø, + to standard quality strings', () {
      expect(Chord.parse('CΔ').quality, equals('maj7'));
      expect(Chord.parse('Co').quality, equals('dim'));
      expect(Chord.parse('Cø').quality, equals('m7b5'));
      expect(Chord.parse('C+').quality, equals('aug'));
    });

    test('handles edge case notes: E#, Fb, B#, Cb', () {
      final eSharp = Note.parse('E#');
      expect(eSharp.semitone, equals(5)); // Enharmonic with F
      expect(eSharp.enharmonicallyEquals(const Note('F')), isTrue);

      final fFlat = Note.parse('Fb');
      expect(fFlat.semitone, equals(4)); // Enharmonic with E
      expect(fFlat.enharmonicallyEquals(const Note('E')), isTrue);

      final bSharp = Note.parse('B#');
      expect(bSharp.semitone, equals(0)); // Enharmonic with C
      expect(bSharp.enharmonicallyEquals(const Note('C')), isTrue);

      final cFlat = Note.parse('Cb');
      expect(cFlat.semitone, equals(11)); // Enharmonic with B
      expect(cFlat.enharmonicallyEquals(const Note('B')), isTrue);
    });

    test('handles double sharps (x, ##) and double flats (bb)', () {
      final fDoubleSharp = Note.parse('Fx');
      expect(fDoubleSharp.semitone, equals(7)); // F=5, Fx=7 (G)
      expect(fDoubleSharp.enharmonicallyEquals(const Note('G')), isTrue);

      final bDoubleFlat = Note.parse('Bbb');
      expect(bDoubleFlat.semitone, equals(9)); // B=11, Bbb=9 (A)
      expect(bDoubleFlat.enharmonicallyEquals(const Note('A')), isTrue);
    });

    test('throws FormatException on invalid chords', () {
      expect(() => Chord.parse('Hmaj7'), throwsFormatException);
      expect(() => Chord.parse('XYZ'), throwsFormatException);
      expect(() => Chord.parse(''), throwsFormatException);
    });
  });
}
