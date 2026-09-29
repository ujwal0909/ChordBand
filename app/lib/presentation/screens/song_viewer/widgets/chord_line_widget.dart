import 'package:flutter/material.dart';
import 'package:chord_engine/chord_engine.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../providers/song_viewer_providers.dart';
import 'chord_diagram_modal.dart';

class ChordLineWidget extends StatelessWidget {
  final SongLine line;
  final SongViewerState state;
  final KeySignature currentKey;
  final bool isStageMode;

  const ChordLineWidget({
    super.key,
    required this.line,
    required this.state,
    required this.currentKey,
    this.isStageMode = false,
  });

  @override
  Widget build(BuildContext context) {
    if (line.type == LineType.empty) {
      return SizedBox(height: state.fontSize * 1.0);
    }

    if (line.type == LineType.comment) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isStageMode
                ? AppColors.stageSurface
                : AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isStageMode ? AppColors.stageBorder : AppColors.primaryLight.withOpacity(0.3),
            ),
          ),
          child: Text(
            line.comment ?? '',
            style: TextStyle(
              fontSize: state.fontSize * 0.85,
              fontStyle: FontStyle.italic,
              color: isStageMode ? AppColors.stageChordAccent : AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    final hasAnyChord = line.hasChords;

    // Use Wrap with spacing for natural, responsive lyric wrapping
    return Padding(
      padding: EdgeInsets.symmetric(vertical: hasAnyChord ? 3 : 1),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        children: line.segments.map((segment) {
          return _buildSegmentWidget(context, segment);
        }).toList(),
      ),
    );
  }

  Widget _buildSegmentWidget(BuildContext context, ChordSegment segment) {
    final chord = segment.chord;
    final lyrics = segment.lyrics;

    String? displayChordText;
    if (chord != null) {
      switch (state.notation) {
        case ChordDisplayNotation.standard:
          displayChordText = chord.toString();
          break;
        case ChordDisplayNotation.nashville:
          displayChordText = NashvilleConverter.toNashville(chord, currentKey);
          break;
        case ChordDisplayNotation.roman:
          displayChordText = NashvilleConverter.toRoman(chord, currentKey);
          break;
      }
    }

    final chordColor = isStageMode ? AppColors.stageChord : AppColors.primary;
    final lyricColor = isStageMode ? AppColors.stageTextPrimary : null;

    final fontFamily = state.isMonospace ? 'Courier' : null;

    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Chord above
          if (displayChordText != null)
            GestureDetector(
              onTap: () => ChordDiagramModal.show(context, chord!, isStageMode: isStageMode),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                margin: const EdgeInsets.only(bottom: 2),
                decoration: BoxDecoration(
                  color: isStageMode ? Colors.transparent : AppColors.lightChordBadge,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  displayChordText,
                  style: TextStyle(
                    color: chordColor,
                    fontSize: state.fontSize * 0.95,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            )
          else if (line.hasChords)
            // Empty placeholder to preserve vertical alignment across segments
            SizedBox(height: state.fontSize * 1.15),

          // Lyric text directly below
          Text(
            lyrics.isEmpty ? ' ' : lyrics,
            style: TextStyle(
              fontSize: state.fontSize,
              color: lyricColor,
              fontFamily: fontFamily,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
