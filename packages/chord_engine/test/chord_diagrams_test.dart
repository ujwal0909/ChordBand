import 'package:test/test.dart';
import 'package:chord_engine/chord_engine.dart';

void main() {
  group('Chord Diagrams Tests', () {
    test('retrieves accurate guitar open and barre diagrams', () {
      final cChord = Chord.parse('C');
      final cDiagram = GuitarDiagrams.getDiagram(cChord);
      expect(cDiagram.instrument, equals(InstrumentType.guitar));
      expect(cDiagram.frets, equals([-1, 3, 2, 0, 1, 0]));

      final fChord = Chord.parse('F');
      final fDiagram = GuitarDiagrams.getDiagram(fChord);
      expect(fDiagram.frets, equals([1, 3, 3, 2, 1, 1]));
      expect(fDiagram.barreFret, equals(1));
    });

    test('synthesizes moveable barre shapes for unlisted guitar chords', () {
      final gSharpMinor = Chord.parse('G#m');
      final diagram = GuitarDiagrams.getDiagram(gSharpMinor);
      expect(diagram.instrument, equals(InstrumentType.guitar));
      expect(diagram.baseFret, equals(4)); // G# on 6th string is fret 4
      expect(diagram.barreFret, equals(4));
    });

    test('retrieves ukulele chord diagrams', () {
      final cChord = Chord.parse('C');
      final ukeC = UkuleleDiagrams.getDiagram(cChord);
      expect(ukeC.instrument, equals(InstrumentType.ukulele));
      expect(ukeC.frets, equals([0, 0, 0, 3]));

      final amChord = Chord.parse('Am');
      final ukeAm = UkuleleDiagrams.getDiagram(amChord);
      expect(ukeAm.frets, equals([2, 0, 0, 0]));
    });

    test('calculates piano active keys for major, minor, and slash chords', () {
      // C major: C(0), E(4), G(7)
      final pianoC = PianoDiagrams.getDiagram(Chord.parse('C'));
      expect(pianoC.instrument, equals(InstrumentType.piano));
      expect(pianoC.pianoKeys, containsAll([0, 4, 7]));

      // C/E slash chord: bass note E (4) + C chord tones (0, 4, 7)
      final pianoSlash = PianoDiagrams.getDiagram(Chord.parse('C/E'));
      expect(pianoSlash.pianoKeys, contains(4)); // Bass E
    });
  });
}
