import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../providers/song_viewer_providers.dart';

class AutoScrollBar extends StatelessWidget {
  final SongViewerState state;
  final bool isStageMode;
  final VoidCallback onToggleScroll;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onScrollToTop;
  final VoidCallback onScrollToBottom;

  const AutoScrollBar({
    super.key,
    required this.state,
    this.isStageMode = false,
    required this.onToggleScroll,
    required this.onSpeedChanged,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onScrollToTop,
    required this.onScrollToBottom,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isStageMode
        ? AppColors.stageSurface.withOpacity(0.95)
        : Theme.of(context).cardColor.withOpacity(0.95);
    final borderColor = isStageMode ? AppColors.stageBorder : Theme.of(context).dividerColor;
    final primaryAccent = isStageMode ? AppColors.stageChord : AppColors.primary;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play / Pause auto scroll
          IconButton.filled(
            onPressed: onToggleScroll,
            icon: Icon(
              state.isAutoScrolling ? Icons.pause : Icons.play_arrow,
              color: isStageMode ? Colors.black : Colors.white,
            ),
            style: IconButton.styleFrom(
              backgroundColor: primaryAccent,
              minimumSize: const Size(40, 40),
            ),
            tooltip: state.isAutoScrolling ? 'Pause Auto-Scroll' : 'Start Auto-Scroll',
          ),
          const SizedBox(width: 8),

          // Speed slider
          SizedBox(
            width: 110,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: primaryAccent,
                thumbColor: primaryAccent,
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: state.autoScrollSpeed,
                min: 5.0,
                max: 100.0,
                onChanged: onSpeedChanged,
              ),
            ),
          ),

          // Speed indicator
          Text(
            '${(state.autoScrollSpeed / 25.0).toStringAsFixed(1)}x',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isStageMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 8),

          // Zoom Out
          IconButton(
            onPressed: onZoomOut,
            icon: const Icon(Icons.text_decrease, size: 20),
            tooltip: 'Decrease Font Size',
          ),

          // Zoom In
          IconButton(
            onPressed: onZoomIn,
            icon: const Icon(Icons.text_increase, size: 20),
            tooltip: 'Increase Font Size',
          ),

          const SizedBox(width: 4),

          // Scroll to top
          IconButton(
            onPressed: onScrollToTop,
            icon: const Icon(Icons.vertical_align_top, size: 18),
            tooltip: 'Scroll to Top',
          ),

          // Scroll to bottom
          IconButton(
            onPressed: onScrollToBottom,
            icon: const Icon(Icons.vertical_align_bottom, size: 18),
            tooltip: 'Scroll to Bottom',
          ),
        ],
      ),
    );
  }
}
