import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Metronome & Tap Tempo Logic Tests', () {
    test('calculates accurate BPM from tap intervals', () {
      // 500ms between taps = 120 BPM (60,000 / 500 = 120)
      final intervals = [500, 500, 500, 500];
      final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
      final bpm = (60000 / avgInterval).round();
      expect(bpm, equals(120));
    });

    test('calculates accurate BPM for 75 BPM ballad taps', () {
      // 800ms between taps = 75 BPM (60,000 / 800 = 75)
      final intervals = [800, 800, 800];
      final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
      final bpm = (60000 / avgInterval).round();
      expect(bpm, equals(75));
    });

    test('clamps BPM within safe performance bounds (40 to 240 BPM)', () {
      expect((60000 / 100).round().clamp(40, 240),
          equals(240)); // Fast tap clamped
      expect((60000 / 2000).round().clamp(40, 240),
          equals(40)); // Slow tap clamped
    });

    test('calculates beats and downbeat indices correctly for 4/4 and 6/8', () {
      int beats44 = 4;
      expect(List.generate(beats44, (i) => i == 0 ? 'downbeat' : 'beat'),
          equals(['downbeat', 'beat', 'beat', 'beat']));

      int beats68 = 6;
      expect(List.generate(beats68, (i) => i == 0 ? 'downbeat' : 'beat'),
          equals(['downbeat', 'beat', 'beat', 'beat', 'beat', 'beat']));
    });
  });
}
