import '../models/chord.dart';
import '../models/key_signature.dart';

/// Converts chords to and from Nashville Number System and Roman Numerals
class NashvilleConverter {
  static const List<int> _majorScaleIntervals = [0, 2, 4, 5, 7, 9, 11];

  static const List<String> _scaleDegrees = ['1', '2', '3', '4', '5', '6', '7'];
  static const List<String> _romanDegrees = [
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII'
  ];

  /// Convert a [Chord] to its Nashville Number System representation in [key].
  /// Example: C in Key C -> "1", Am in Key C -> "6m", G/B in Key C -> "5/7", Bb in Key C -> "b7"
  static String toNashville(Chord chord, KeySignature key) {
    final tonicSemitone = key.tonic.semitone;
    final chordSemitone = chord.root.semitone;

    final semitoneOffset = (chordSemitone - tonicSemitone + 12) % 12;
    final scaleDegreeInfo = _getScaleDegree(semitoneOffset);

    final buffer = StringBuffer();
    if (scaleDegreeInfo.accidental.isNotEmpty) {
      buffer.write(scaleDegreeInfo.accidental);
    }
    buffer.write(scaleDegreeInfo.degree);

    // Add quality if non-standard major
    if (chord.quality.isNotEmpty) {
      buffer.write(chord.quality);
    }

    // Slash bass note
    if (chord.bass != null) {
      final bassSemitone = chord.bass!.semitone;
      final bassOffset = (bassSemitone - tonicSemitone + 12) % 12;
      final bassDegreeInfo = _getScaleDegree(bassOffset);
      buffer.write('/');
      if (bassDegreeInfo.accidental.isNotEmpty) {
        buffer.write(bassDegreeInfo.accidental);
      }
      buffer.write(bassDegreeInfo.degree);
    }

    return buffer.toString();
  }

  /// Convert a [Chord] to Roman Numeral representation.
  /// Example: C -> "I", Dm -> "ii", Em -> "iii", F -> "IV", G -> "V", Am -> "vi", Bdim -> "vii°"
  static String toRoman(Chord chord, KeySignature key) {
    final tonicSemitone = key.tonic.semitone;
    final chordSemitone = chord.root.semitone;

    final semitoneOffset = (chordSemitone - tonicSemitone + 12) % 12;
    final scaleDegreeInfo = _getScaleDegree(semitoneOffset);
    final degreeIndex = scaleDegreeInfo.degreeIndex;

    final romanBase = _romanDegrees[degreeIndex];
    final isMinor = chord.isMinor || chord.isDiminished;
    final formattedRoman = isMinor ? romanBase.toLowerCase() : romanBase;

    final buffer = StringBuffer();
    if (scaleDegreeInfo.accidental.isNotEmpty) {
      buffer.write(scaleDegreeInfo.accidental);
    }
    buffer.write(formattedRoman);

    // Append alterations / quality
    if (chord.quality == 'dim') {
      buffer.write('°');
    } else if (chord.quality == 'dim7') {
      buffer.write('°7');
    } else if (chord.quality == 'm7b5') {
      buffer.write('ø7');
    } else if (chord.quality == '7') {
      buffer.write('7');
    } else if (chord.quality == 'maj7') {
      buffer.write('M7');
    } else if (chord.quality == 'm7') {
      buffer.write('7');
    } else if (chord.quality.isNotEmpty && chord.quality != 'm') {
      buffer.write(chord.quality);
    }

    // Slash bass
    if (chord.bass != null) {
      final bassSemitone = chord.bass!.semitone;
      final bassOffset = (bassSemitone - tonicSemitone + 12) % 12;
      final bassDegreeInfo = _getScaleDegree(bassOffset);
      buffer.write('/');
      if (bassDegreeInfo.accidental.isNotEmpty) {
        buffer.write(bassDegreeInfo.accidental);
      }
      buffer.write(bassDegreeInfo.degree);
    }

    return buffer.toString();
  }

  static _DegreeInfo _getScaleDegree(int semitoneOffset) {
    // Check direct diatonic match
    for (int i = 0; i < _majorScaleIntervals.length; i++) {
      if (_majorScaleIntervals[i] == semitoneOffset) {
        return _DegreeInfo(
          degree: _scaleDegrees[i],
          degreeIndex: i,
          accidental: '',
        );
      }
    }

    // Check flats
    for (int i = 0; i < _majorScaleIntervals.length; i++) {
      if ((_majorScaleIntervals[i] - 1 + 12) % 12 == semitoneOffset) {
        return _DegreeInfo(
          degree: _scaleDegrees[i],
          degreeIndex: i,
          accidental: 'b',
        );
      }
    }

    // Check sharps
    for (int i = 0; i < _majorScaleIntervals.length; i++) {
      if ((_majorScaleIntervals[i] + 1) % 12 == semitoneOffset) {
        return _DegreeInfo(
          degree: _scaleDegrees[i],
          degreeIndex: i,
          accidental: '#',
        );
      }
    }

    return _DegreeInfo(degree: '1', degreeIndex: 0, accidental: '');
  }
}

class _DegreeInfo {
  final String degree;
  final int degreeIndex;
  final String accidental;

  const _DegreeInfo({
    required this.degree,
    required this.degreeIndex,
    required this.accidental,
  });
}
