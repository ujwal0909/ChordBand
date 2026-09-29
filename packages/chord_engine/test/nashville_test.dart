import 'package:test/test.dart';
import 'package:chord_engine/chord_engine.dart';

void main() {
  group('Nashville Number & Roman Numeral Tests', () {
    final keyC = KeySignature.keyC;
    final keyG = KeySignature.keyG;

    test('converts diatonic chords to Nashville numbers in Key of C', () {
      expect(NashvilleConverter.toNashville(Chord.parse('C'), keyC), equals('1'));
      expect(NashvilleConverter.toNashville(Chord.parse('Dm'), keyC), equals('2m'));
      expect(NashvilleConverter.toNashville(Chord.parse('Em'), keyC), equals('3m'));
      expect(NashvilleConverter.toNashville(Chord.parse('F'), keyC), equals('4'));
      expect(NashvilleConverter.toNashville(Chord.parse('G'), keyC), equals('5'));
      expect(NashvilleConverter.toNashville(Chord.parse('Am'), keyC), equals('6m'));
      expect(NashvilleConverter.toNashville(Chord.parse('Bdim'), keyC), equals('7dim'));
    });

    test('converts slash chords to Nashville numbers', () {
      expect(NashvilleConverter.toNashville(Chord.parse('G/B'), keyC), equals('5/7'));
      expect(NashvilleConverter.toNashville(Chord.parse('C/E'), keyC), equals('1/3'));
      expect(NashvilleConverter.toNashville(Chord.parse('D/F#'), keyG), equals('5/7'));
    });

    test('converts non-diatonic / borrowed chords to Nashville numbers', () {
      expect(NashvilleConverter.toNashville(Chord.parse('Bb'), keyC), equals('b7'));
      expect(NashvilleConverter.toNashville(Chord.parse('Eb'), keyC), equals('b3'));
      expect(NashvilleConverter.toNashville(Chord.parse('Ab'), keyC), equals('b6'));
    });

    test('converts to Roman Numerals', () {
      expect(NashvilleConverter.toRoman(Chord.parse('C'), keyC), equals('I'));
      expect(NashvilleConverter.toRoman(Chord.parse('Dm'), keyC), equals('ii'));
      expect(NashvilleConverter.toRoman(Chord.parse('F'), keyC), equals('IV'));
      expect(NashvilleConverter.toRoman(Chord.parse('G'), keyC), equals('V'));
      expect(NashvilleConverter.toRoman(Chord.parse('Am'), keyC), equals('vi'));
      expect(NashvilleConverter.toRoman(Chord.parse('Bdim'), keyC), equals('vii°'));
      expect(NashvilleConverter.toRoman(Chord.parse('G/B'), keyC), equals('V/7'));
    });
  });
}
