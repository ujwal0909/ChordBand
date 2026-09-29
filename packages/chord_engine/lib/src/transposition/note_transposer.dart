import '../models/note.dart';
import '../models/key_signature.dart';

/// Transposes notes while maintaining musical spelling and enharmonics
class NoteTransposer {
  /// Transpose a single [Note] by [semitones].
  /// If [targetKey] is provided, uses the target key's scale notes and enharmonic preferences.
  static Note transpose(
    Note note,
    int semitones, {
    KeySignature? targetKey,
    bool? preferFlats,
  }) {
    final newSemitone = (note.semitone + semitones) % 12;

    if (targetKey != null) {
      return targetKey.spellSemitone(newSemitone);
    }

    if (preferFlats != null) {
      return Note.fromSemitone(newSemitone, preferFlat: preferFlats);
    }

    if (note.isFlat) {
      return Note.fromSemitone(newSemitone, preferFlat: true);
    }
    if (note.isSharp) {
      return Note.fromSemitone(newSemitone, preferFlat: false);
    }

    // Natural note: standard music defaults (Bb, F#, Eb, C#)
    if (newSemitone == 10) return const Note('B', 'b');
    if (newSemitone == 6) return const Note('F', '#');
    if (newSemitone == 3) return const Note('E', 'b');
    if (newSemitone == 1) return const Note('C', '#');
    if (newSemitone == 8) return const Note('G', '#');

    return Note.fromSemitone(newSemitone, preferFlat: false);
  }

  /// Calculates semitone difference from [fromKey] to [toKey]
  static int semitonesBetween(KeySignature fromKey, KeySignature toKey) {
    int diff = toKey.tonic.semitone - fromKey.tonic.semitone;
    while (diff > 6) diff -= 12;
    while (diff < -6) diff += 12;
    return diff;
  }
}
