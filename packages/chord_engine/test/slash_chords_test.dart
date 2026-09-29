import 'package:test/test.dart';
import 'package:chord_engine/chord_engine.dart';

void main() {
  group('Slash Chords Tests', () {
    test('parses slash chords with root and bass note', () {
      final dSlashFSharp = Chord.parse('D/F#');
      expect(dSlashFSharp.root, equals(const Note('D')));
      expect(dSlashFSharp.quality, equals(''));
      expect(dSlashFSharp.bass, equals(const Note('F', '#')));
      expect(dSlashFSharp.isSlashChord, isTrue);
      expect(dSlashFSharp.toString(), equals('D/F#'));

      final am7SlashG = Chord.parse('Am7/G');
      expect(am7SlashG.root, equals(const Note('A')));
      expect(am7SlashG.quality, equals('m7'));
      expect(am7SlashG.bass, equals(const Note('G')));
      expect(am7SlashG.isSlashChord, isTrue);
      expect(am7SlashG.toString(), equals('Am7/G'));
    });

    test('transposes both root and bass note simultaneously', () {
      final dSlashFSharp = Chord.parse('D/F#');
      // Transpose +2: D -> E, F# -> G#
      final transposed = ChordTransposer.transpose(dSlashFSharp, 2);
      expect(transposed.root, equals(const Note('E')));
      expect(transposed.bass, equals(const Note('G', '#')));
      expect(transposed.toString(), equals('E/G#'));

      // Transpose C/E by -2: C -> Bb, E -> D
      final cSlashE = Chord.parse('C/E');
      final transposedDown = ChordTransposer.transpose(cSlashE, -2);
      expect(transposedDown.root, equals(const Note('B', 'b')));
      expect(transposedDown.bass, equals(const Note('D')));
      expect(transposedDown.toString(), equals('Bb/D'));
    });

    test('preserves slash chords through Capo conversion', () {
      // Sounding chord is E/G#, capo is 2 -> play shape is D/F#
      final sounding = Chord.parse('E/G#');
      final playAs = ChordTransposer.toPlayAsShape(sounding, 2);
      expect(playAs.root, equals(const Note('D')));
      expect(playAs.bass, equals(const Note('F', '#')));
      expect(playAs.toString(), equals('D/F#'));
    });
  });
}
