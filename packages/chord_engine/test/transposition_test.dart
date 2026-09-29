import 'package:test/test.dart';
import 'package:chord_engine/chord_engine.dart';

void main() {
  group('Chord Transposition & Capo Tests', () {
    test('transposes basic chords up and down by semitones', () {
      final c = Chord.parse('C');
      expect(ChordTransposer.transpose(c, 2).toString(), equals('D'));
      expect(ChordTransposer.transpose(c, 5).toString(), equals('F'));
      expect(ChordTransposer.transpose(c, -2).toString(), equals('Bb'));

      final g = Chord.parse('G');
      expect(ChordTransposer.transpose(g, 1).toString(), equals('G#'));
      expect(ChordTransposer.transpose(g, -1).toString(), equals('F#'));
    });

    test('preserves chord qualities through transposition', () {
      final dm7 = Chord.parse('Dm7');
      final transposed = ChordTransposer.transpose(dm7, 3); // D + 3 = F
      expect(transposed.toString(), equals('Fm7'));
      expect(transposed.quality, equals('m7'));

      final cMaj7 = Chord.parse('Cmaj7');
      expect(ChordTransposer.transpose(cMaj7, 4).toString(), equals('Emaj7'));

      final bDim7 = Chord.parse('Bdim7');
      expect(ChordTransposer.transpose(bDim7, 1).toString(), equals('Cdim7'));

      final aSus4 = Chord.parse('Asus4');
      expect(ChordTransposer.transpose(aSus4, 2).toString(), equals('Bsus4'));
    });

    test('transposes with target key context for proper musical spelling', () {
      final chord = Chord.parse('A');
      // Transpose +1 into Key of Bb (targetKey: Bb) should spell root as Bb, not A#
      final inBb = ChordTransposer.transpose(chord, 1, targetKey: KeySignature.keyBFlat);
      expect(inBb.root.toString(), equals('Bb'));

      // Transpose +1 into Key of B (targetKey: B) should spell as A#
      final inB = ChordTransposer.transpose(chord, 1, targetKey: KeySignature.keyB);
      expect(inB.root.toString(), equals('A#'));
    });

    test('computes Capo "Play-As" shape correctly', () {
      // If sounding chord is B and Capo is at fret 2, guitarist plays A shape
      final soundingB = Chord.parse('B');
      final playAs = ChordTransposer.toPlayAsShape(soundingB, 2);
      expect(playAs.root.toString(), equals('A'));

      // If sounding chord is F and Capo is at fret 3, guitarist plays D shape
      final soundingF = Chord.parse('F');
      final playAsD = ChordTransposer.toPlayAsShape(soundingF, 3);
      expect(playAsD.root.toString(), equals('D'));

      // If sounding chord is G and Capo is 0 (no capo), play As G
      expect(ChordTransposer.toPlayAsShape(Chord.parse('G'), 0).toString(), equals('G'));
    });

    test('computes Capo "Sounds-As" concert pitch correctly', () {
      // Guitarist plays A shape with Capo 2 -> sounds as B
      final shapeA = Chord.parse('A');
      final sounding = ChordTransposer.toSoundingChord(shapeA, 2);
      expect(sounding.root.toString(), equals('B'));

      // Guitarist plays G shape with Capo 3 -> sounds as Bb
      final shapeG = Chord.parse('G');
      final soundingBb = ChordTransposer.toSoundingChord(shapeG, 3, preferFlats: true);
      expect(soundingBb.root.toString(), equals('Bb'));
    });

    test('transposes full song lines without disrupting text', () {
      final line = SongLine.chordsAndLyrics([
        ChordSegment(chord: Chord.parse('G'), lyrics: 'Amazing '),
        ChordSegment(chord: Chord.parse('C'), lyrics: 'grace how '),
        ChordSegment(chord: Chord.parse('G'), lyrics: 'sweet'),
      ]);

      final transposed = ChordTransposer.transposeLine(line, 2); // G->A, C->D
      expect(transposed.segments[0].chord.toString(), equals('A'));
      expect(transposed.segments[0].lyrics, equals('Amazing '));
      expect(transposed.segments[1].chord.toString(), equals('D'));
      expect(transposed.segments[1].lyrics, equals('grace how '));
      expect(transposed.segments[2].chord.toString(), equals('A'));
      expect(transposed.segments[2].lyrics, equals('sweet'));
    });
  });
}
