import 'package:flutter/material.dart';
import 'package:chord_engine/chord_engine.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../providers/song_viewer_providers.dart';

class TranspositionBar extends StatelessWidget {
  final SongViewerState state;
  final KeySignature originalKey;
  final KeySignature effectiveKey;
  final bool isStageMode;
  final ValueChanged<int> onTranspose;
  final VoidCallback? onReset;
  final ValueChanged<KeySignature?> onSelectKey;
  final ValueChanged<int> onSelectCapo;
  final VoidCallback onToggleFlats;
  final ValueChanged<ChordDisplayNotation> onSelectNotation;
  final VoidCallback onToggleMonospace;

  const TranspositionBar({
    super.key,
    required this.state,
    required this.originalKey,
    required this.effectiveKey,
    this.isStageMode = false,
    required this.onTranspose,
    this.onReset,
    required this.onSelectKey,
    required this.onSelectCapo,
    required this.onToggleFlats,
    required this.onSelectNotation,
    required this.onToggleMonospace,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isStageMode ? AppColors.stageSurface : Theme.of(context).cardColor;
    final borderColor =
        isStageMode ? AppColors.stageBorder : Theme.of(context).dividerColor;
    final primaryAccent =
        isStageMode ? AppColors.stageChord : AppColors.primary;

    final isTransposed = state.semitoneOffset != 0 ||
        state.targetKey != null ||
        state.capoFret != 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Prominent Transpose Stepper Control
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              decoration: BoxDecoration(
                color: isStageMode
                    ? Colors.white10
                    : Colors.grey.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: isStageMode
                        ? Colors.white24
                        : Colors.grey.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => onTranspose(-1),
                    icon: const Icon(Icons.remove_circle, size: 22),
                    tooltip: 'Transpose Down (-1 Semitone)\nHotkey: [',
                    color:
                        isStageMode ? AppColors.stageChord : AppColors.primary,
                    style: IconButton.styleFrom(
                      minimumSize: const Size(36, 36),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'TRANSPOSE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: isStageMode
                                ? AppColors.stageTextSecondary
                                : Colors.grey[700],
                          ),
                        ),
                        Text(
                          state.semitoneOffset == 0
                              ? '0 (Original)'
                              : '${state.semitoneOffset > 0 ? "+" : ""}${state.semitoneOffset} ST',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: state.semitoneOffset != 0
                                ? primaryAccent
                                : (isStageMode ? Colors.white : Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => onTranspose(1),
                    icon: const Icon(Icons.add_circle, size: 22),
                    tooltip: 'Transpose Up (+1 Semitone)\nHotkey: ]',
                    color:
                        isStageMode ? AppColors.stageChord : AppColors.primary,
                    style: IconButton.styleFrom(
                      minimumSize: const Size(36, 36),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Key Display & Selector Dropdown
            PopupMenuButton<KeySignature>(
              tooltip: 'Choose Specific Target Key',
              initialValue: effectiveKey,
              onSelected: onSelectKey,
              itemBuilder: (ctx) {
                return KeySignature.allKeys.map((k) {
                  final isCurrent = k == effectiveKey;
                  final isOrig = k == originalKey;
                  return PopupMenuItem(
                    value: k,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Key: ${k.toString()}',
                          style: TextStyle(
                              fontWeight: isCurrent
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                        if (isOrig)
                          const Text(' (Orig)',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  );
                }).toList();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryAccent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: primaryAccent.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Key: ${effectiveKey.toString()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: primaryAccent,
                      ),
                    ),
                    if (effectiveKey != originalKey) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(was ${originalKey.toString()})',
                        style: TextStyle(
                          fontSize: 11,
                          color: isStageMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down, size: 18, color: primaryAccent),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Reset Transposition Button (visible if altered)
            if (isTransposed && onReset != null) ...[
              OutlinedButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.refresh, size: 15),
                label: const Text('Reset', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
              const SizedBox(width: 8),
            ],

            // Capo Stepper
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              decoration: BoxDecoration(
                color: isStageMode
                    ? Colors.white10
                    : Colors.grey.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: state.capoFret > 0
                        ? () => onSelectCapo(state.capoFret - 1)
                        : null,
                    icon: const Icon(Icons.remove, size: 16),
                    tooltip: 'Decrease Capo',
                    style: IconButton.styleFrom(
                        minimumSize: const Size(28, 28),
                        padding: EdgeInsets.zero),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      state.capoFret == 0
                          ? 'Capo: Off'
                          : 'Capo ${state.capoFret}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  IconButton(
                    onPressed: state.capoFret < 12
                        ? () => onSelectCapo(state.capoFret + 1)
                        : null,
                    icon: const Icon(Icons.add, size: 16),
                    tooltip: 'Increase Capo',
                    style: IconButton.styleFrom(
                        minimumSize: const Size(28, 28),
                        padding: EdgeInsets.zero),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Notation Selector (Standard, Nashville, Roman)
            SegmentedButton<ChordDisplayNotation>(
              segments: const [
                ButtonSegment(
                  value: ChordDisplayNotation.standard,
                  label: Text('Chords'),
                  tooltip: 'Standard Letter Chords (C, G, Am, F)',
                ),
                ButtonSegment(
                  value: ChordDisplayNotation.nashville,
                  label: Text('1-4-5'),
                  tooltip: 'Nashville Number System (1, 4, 5, 6m)',
                ),
                ButtonSegment(
                  value: ChordDisplayNotation.roman,
                  label: Text('I-IV-V'),
                  tooltip: 'Roman Numerals (I, IV, V, vi)',
                ),
              ],
              selected: {state.notation},
              onSelectionChanged: (set) {
                if (set.isNotEmpty) onSelectNotation(set.first);
              },
              showSelectedIcon: false,
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),

            // Sharps / Flats Preference Toggle
            IconButton(
              onPressed: onToggleFlats,
              icon: Text(
                state.preferFlats ? '♭' : '♯',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              tooltip: state.preferFlats
                  ? 'Currently Flats (♭) - Click for Sharps (♯)'
                  : 'Currently Sharps (♯) - Click for Flats (♭)',
            ),

            // Monospace Toggle
            IconButton(
              onPressed: onToggleMonospace,
              icon: Icon(
                state.isMonospace
                    ? Icons.font_download
                    : Icons.font_download_outlined,
                size: 20,
              ),
              tooltip: state.isMonospace
                  ? 'Switch to Proportional Font'
                  : 'Switch to Monospace Font',
            ),
          ],
        ),
      ),
    );
  }
}
