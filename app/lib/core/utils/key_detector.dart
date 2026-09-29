import 'package:chord_engine/chord_engine.dart';

class KeyDetector {
  /// Analyzes text containing chords and automatically detects the most likely musical key
  static String? detectKeyFromText(String content) {
    if (content.trim().isEmpty) return null;

    // 1. Extract all chord strings from content
    final chords = <Chord>[];

    // Check for [Chord] tags
    final bracketRegex = RegExp(r'\[([A-G][b#]?[^\]\s]*)\]');
    final bracketMatches = bracketRegex.allMatches(content);

    if (bracketMatches.isNotEmpty) {
      for (final m in bracketMatches) {
        final chordStr = m.group(1);
        if (chordStr != null) {
          final c = Chord.tryParse(chordStr);
          if (c != null) chords.add(c);
        }
      }
    } else {
      // Plain text chords
      final parsed = PlainTextParser.parse(content);
      for (final sec in parsed.sections) {
        for (final line in sec.lines) {
          for (final seg in line.segments) {
            if (seg.chord != null) chords.add(seg.chord!);
          }
        }
      }
    }

    if (chords.isEmpty) return null;

    // Candidate keys to evaluate
    final candidateKeys = [
      // Major Keys
      'C', 'G', 'D', 'A', 'E', 'B', 'F#', 'Db', 'Ab', 'Eb', 'Bb', 'F',
      // Minor Keys
      'Am', 'Em', 'Bm', 'F#m', 'C#m', 'G#m', 'D#m', 'Bbm', 'Fm', 'Cm', 'Gm', 'Dm',
    ];

    // Diatonic chord maps for candidate keys
    final diatonicProfiles = <String, Map<String, int>>{
      // Key: map of chord name to weight
      'C': {'C': 4, 'G': 3, 'G7': 3, 'F': 3, 'Am': 2, 'Dm': 2, 'Em': 2},
      'G': {'G': 4, 'D': 3, 'D7': 3, 'C': 3, 'Em': 2, 'Am': 2, 'Bm': 2},
      'D': {'D': 4, 'A': 3, 'A7': 3, 'G': 3, 'Bm': 2, 'Em': 2, 'F#m': 2},
      'A': {'A': 4, 'E': 3, 'E7': 3, 'D': 3, 'F#m': 2, 'Bm': 2, 'C#m': 2},
      'E': {'E': 4, 'B': 3, 'B7': 3, 'A': 3, 'C#m': 2, 'F#m': 2, 'G#m': 2},
      'B': {'B': 4, 'F#': 3, 'F#7': 3, 'E': 3, 'G#m': 2, 'C#m': 2, 'D#m': 2},
      'F': {'F': 4, 'C': 3, 'C7': 3, 'Bb': 3, 'Dm': 2, 'Gm': 2, 'Am': 2},
      'Bb': {'Bb': 4, 'F': 3, 'F7': 3, 'Eb': 3, 'Gm': 2, 'Cm': 2, 'Dm': 2},
      'Eb': {'Eb': 4, 'Bb': 3, 'Bb7': 3, 'Ab': 3, 'Cm': 2, 'Fm': 2, 'Gm': 2},
      'Ab': {'Ab': 4, 'Eb': 3, 'Eb7': 3, 'Db': 3, 'Fm': 2, 'Bbm': 2, 'Cm': 2},

      // Minor Keys
      'Am': {'Am': 4, 'Em': 3, 'E7': 3, 'E': 3, 'Dm': 3, 'C': 2, 'F': 2, 'G': 2},
      'Em': {'Em': 4, 'Bm': 3, 'B7': 3, 'B': 3, 'Am': 3, 'G': 2, 'C': 2, 'D': 2},
      'Bm': {'Bm': 4, 'F#m': 3, 'F#7': 3, 'F#': 3, 'Em': 3, 'D': 2, 'G': 2, 'A': 2},
      'F#m': {'F#m': 4, 'C#m': 3, 'C#7': 3, 'C#': 3, 'Bm': 3, 'A': 2, 'D': 2, 'E': 2},
      'Dm': {'Dm': 4, 'Am': 3, 'A7': 3, 'A': 3, 'Gm': 3, 'F': 2, 'Bb': 2, 'C': 2},
      'Gm': {'Gm': 4, 'Dm': 3, 'D7': 3, 'D': 3, 'Cm': 3, 'Bb': 2, 'Eb': 2, 'F': 2},
      'Cm': {'Cm': 4, 'Gm': 3, 'G7': 3, 'G': 3, 'Fm': 3, 'Eb': 2, 'Ab': 2, 'Bb': 2},
    };

    String bestKey = 'C';
    int highestScore = -1;

    final firstChordRoot = chords.first.root.toString();
    final firstChordQuality = chords.first.isMinor ? 'm' : '';
    final firstChordName = '$firstChordRoot$firstChordQuality';

    final lastChordRoot = chords.last.root.toString();
    final lastChordQuality = chords.last.isMinor ? 'm' : '';
    final lastChordName = '$lastChordRoot$lastChordQuality';

    for (final candidate in candidateKeys) {
      final profile = diatonicProfiles[candidate];
      int score = 0;

      // Bonus for first chord matching candidate key
      if (firstChordName == candidate) {
        score += 5;
      }
      // Bonus for last chord matching candidate key
      if (lastChordName == candidate) {
        score += 4;
      }

      for (final chord in chords) {
        final root = chord.root.toString();
        final quality = chord.isMinor ? 'm' : '';
        final cleanName = '$root$quality';

        if (profile != null && profile.containsKey(cleanName)) {
          score += profile[cleanName]!;
        } else if (cleanName == candidate) {
          score += 4;
        }
      }

      if (score > highestScore) {
        highestScore = score;
        bestKey = candidate;
      }
    }

    return bestKey;
  }
}
