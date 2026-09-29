import 'package:test/test.dart';
import 'package:chord_engine/chord_engine.dart';

void main() {
  group('Enharmonics & Key Signatures Tests', () {
    test('enharmonic equality recognizes equivalent pitches', () {
      expect(const Note('C', '#').enharmonicallyEquals(const Note('D', 'b')),
          isTrue);
      expect(const Note('F', '#').enharmonicallyEquals(const Note('G', 'b')),
          isTrue);
      expect(
          const Note('E', '#').enharmonicallyEquals(const Note('F')), isTrue);
      expect(
          const Note('B', '#').enharmonicallyEquals(const Note('C')), isTrue);
      expect(
          const Note('F', 'b').enharmonicallyEquals(const Note('E')), isTrue);
      expect(
          const Note('C', 'b').enharmonicallyEquals(const Note('B')), isTrue);
    });

    test('exact note equality differentiates enharmonic spellings', () {
      expect(const Note('C', '#') == const Note('D', 'b'), isFalse);
      expect(const Note('E', '#') == const Note('F'), isFalse);
      expect(const Note('C', '#') == const Note('C', '#'), isTrue);
    });

    test('F# Major correctly spells 7th degree as E# (not F)', () {
      final keyFSharp = KeySignature.keyFSharp;
      expect(keyFSharp.tonic, equals(const Note('F', '#')));
      // 7th scale degree of F# is semitone 5 (E#)
      final degree7 = keyFSharp.spellSemitone(5);
      expect(degree7, equals(const Note('E', '#')));
      expect(degree7.toString(), equals('E#'));
    });

    test('Gb Major correctly spells 4th degree as Cb (not B)', () {
      final keyGFlat = KeySignature.keyGFlat;
      expect(keyGFlat.tonic, equals(const Note('G', 'b')));
      // 4th scale degree of Gb is semitone 11 (Cb)
      final degree4 = keyGFlat.spellSemitone(11);
      expect(degree4, equals(const Note('C', 'b')));
      expect(degree4.toString(), equals('Cb'));
    });

    test('C# Major correctly spells 7th degree as B# (not C)', () {
      final keyCSharp = KeySignature.keyCSharp;
      final degree7 = keyCSharp.spellSemitone(0);
      expect(degree7, equals(const Note('B', '#')));
      expect(degree7.toString(), equals('B#'));
    });

    test('Minor key diatonic spelling: Dm, Bm, and Bbm', () {
      final keyDm = KeySignature.keyDm;
      expect(keyDm.spellSemitone(10),
          equals(const Note('B', 'b'))); // Bb in D minor

      final keyBm = KeySignature.keyBm;
      expect(keyBm.spellSemitone(1),
          equals(const Note('C', '#'))); // C# in B minor

      final keyBbm = KeySignature.keyBbm;
      expect(keyBbm.spellSemitone(1),
          equals(const Note('D', 'b'))); // Db in Bb minor
    });

    test('parses key signatures by name', () {
      expect(KeySignature.tryParse('C'), equals(KeySignature.keyC));
      expect(KeySignature.tryParse('F#'), equals(KeySignature.keyFSharp));
      expect(KeySignature.tryParse('Bb'), equals(KeySignature.keyBFlat));
      expect(KeySignature.tryParse('Am'), equals(KeySignature.keyAm));
      expect(KeySignature.tryParse('F#m'), equals(KeySignature.keyFSharpM));
    });
  });
}
