import 'package:flutter/material.dart';
import 'package:chord_engine/chord_engine.dart';
import '../../../../core/theme/app_colors.dart';

class ChordDiagramModal extends StatefulWidget {
  final Chord chord;
  final bool isStageMode;

  const ChordDiagramModal({
    super.key,
    required this.chord,
    this.isStageMode = false,
  });

  static Future<void> show(BuildContext context, Chord chord, {bool isStageMode = false}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: isStageMode ? AppColors.stageSurface : null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => ChordDiagramModal(chord: chord, isStageMode: isStageMode),
    );
  }

  @override
  State<ChordDiagramModal> createState() => _ChordDiagramModalState();
}

class _ChordDiagramModalState extends State<ChordDiagramModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guitarDiagram = GuitarDiagrams.getDiagram(widget.chord);
    final ukuleleDiagram = UkuleleDiagrams.getDiagram(widget.chord);
    final pianoDiagram = PianoDiagrams.getDiagram(widget.chord);

    final titleColor = widget.isStageMode ? AppColors.stageChord : AppColors.primary;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            // Chord Title
            Text(
              widget.chord.toString(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 12),
            // Instrument Tabs
            TabBar(
              controller: _tabController,
              labelColor: titleColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: titleColor,
              tabs: const [
                Tab(icon: Icon(Icons.music_note), text: 'Guitar'),
                Tab(icon: Icon(Icons.queue_music), text: 'Ukulele'),
                Tab(icon: Icon(Icons.piano), text: 'Piano'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 230,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Center(
                    child: CustomPaint(
                      size: const Size(180, 200),
                      painter: FretboardPainter(
                        diagram: guitarDiagram,
                        stringCount: 6,
                        isStageMode: widget.isStageMode,
                      ),
                    ),
                  ),
                  Center(
                    child: CustomPaint(
                      size: const Size(150, 200),
                      painter: FretboardPainter(
                        diagram: ukuleleDiagram,
                        stringCount: 4,
                        isStageMode: widget.isStageMode,
                      ),
                    ),
                  ),
                  Center(
                    child: CustomPaint(
                      size: const Size(300, 150),
                      painter: PianoKeyboardPainter(
                        activeKeys: pianoDiagram.pianoKeys ?? [],
                        isStageMode: widget.isStageMode,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws guitar or ukulele fretboards
class FretboardPainter extends CustomPainter {
  final ChordDiagram diagram;
  final int stringCount;
  final bool isStageMode;

  FretboardPainter({
    required this.diagram,
    required this.stringCount,
    this.isStageMode = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = isStageMode ? Colors.white70 : Colors.black87
      ..strokeWidth = 1.5;

    final nutPaint = Paint()
      ..color = isStageMode ? AppColors.stageChordAccent : Colors.black
      ..strokeWidth = diagram.baseFret == 1 ? 4.0 : 1.5;

    final dotPaint = Paint()
      ..color = isStageMode ? AppColors.stageChord : AppColors.primary
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    const int fretCount = 5;
    final double fretHeight = (size.height - 40) / fretCount;
    final double stringSpacing = (size.width - 40) / (stringCount - 1);
    const double leftMargin = 30;
    const double topMargin = 35;

    // Draw base fret label if > 1
    if (diagram.baseFret > 1) {
      textPainter.text = TextSpan(
        text: '${diagram.baseFret}fr',
        style: TextStyle(
          color: isStageMode ? Colors.white : Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(2, topMargin + 4));
    }

    // Draw Nut / Top fret
    canvas.drawLine(
      Offset(leftMargin, topMargin),
      Offset(leftMargin + (stringCount - 1) * stringSpacing, topMargin),
      nutPaint,
    );

    // Draw horizontal frets
    for (int f = 1; f <= fretCount; f++) {
      final y = topMargin + f * fretHeight;
      canvas.drawLine(
        Offset(leftMargin, y),
        Offset(leftMargin + (stringCount - 1) * stringSpacing, y),
        linePaint,
      );
    }

    // Draw vertical strings
    for (int s = 0; s < stringCount; s++) {
      final x = leftMargin + s * stringSpacing;
      canvas.drawLine(
        Offset(x, topMargin),
        Offset(x, topMargin + fretCount * fretHeight),
        linePaint,
      );
    }

    // Draw string markers (open 'O', muted 'X', or fretted dots)
    for (int s = 0; s < stringCount && s < diagram.frets.length; s++) {
      final fret = diagram.frets[s];
      final x = leftMargin + s * stringSpacing;

      if (fret == -1) {
        // Muted 'X'
        textPainter.text = TextSpan(
          text: '✕',
          style: TextStyle(
            color: isStageMode ? Colors.redAccent : Colors.red,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, topMargin - 22));
      } else if (fret == 0) {
        // Open 'O'
        textPainter.text = TextSpan(
          text: '○',
          style: TextStyle(
            color: isStageMode ? Colors.white : Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, topMargin - 24));
      } else {
        // Fretted dot
        final relativeFret = fret - (diagram.baseFret - 1);
        if (relativeFret >= 1 && relativeFret <= fretCount) {
          final y = topMargin + (relativeFret - 0.5) * fretHeight;
          canvas.drawCircle(Offset(x, y), 8, dotPaint);

          // Finger number if provided
          if (diagram.fingers != null && s < diagram.fingers!.length && diagram.fingers![s] > 0) {
            textPainter.text = TextSpan(
              text: '${diagram.fingers![s]}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            );
            textPainter.layout();
            textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant FretboardPainter oldDelegate) =>
      oldDelegate.diagram != diagram || oldDelegate.isStageMode != isStageMode;
}

/// Draws an interactive 2-octave piano keyboard with active chord tones highlighted
class PianoKeyboardPainter extends CustomPainter {
  final List<int> activeKeys; // Semitone offsets [0..23]
  final bool isStageMode;

  PianoKeyboardPainter({
    required this.activeKeys,
    this.isStageMode = false,
  });

  static const List<int> _whiteKeySemitones = [
    0, 2, 4, 5, 7, 9, 11, // Octave 1: C, D, E, F, G, A, B
    12, 14, 16, 17, 19, 21, 23 // Octave 2
  ];

  static const List<int> _blackKeySemitones = [
    1, 3, 6, 8, 10, // Octave 1: C#, D#, F#, G#, A#
    13, 15, 18, 20, 22 // Octave 2
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const int whiteKeyCount = 14; // 2 octaves
    final double whiteKeyWidth = size.width / whiteKeyCount;
    final double whiteKeyHeight = size.height;
    final double blackKeyWidth = whiteKeyWidth * 0.65;
    final double blackKeyHeight = size.height * 0.62;

    final whiteKeyBorder = Paint()
      ..color = Colors.black45
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final highlightPaint = Paint()
      ..color = isStageMode ? AppColors.stageChord : AppColors.primary
      ..style = PaintingStyle.fill;

    // Draw White Keys
    for (int i = 0; i < whiteKeyCount; i++) {
      final semitone = _whiteKeySemitones[i];
      final rect = Rect.fromLTWH(i * whiteKeyWidth, 0, whiteKeyWidth, whiteKeyHeight);
      final isPressed = activeKeys.contains(semitone);

      final fillPaint = Paint()
        ..color = isPressed ? highlightPaint.color : (isStageMode ? const Color(0xFF222222) : Colors.white)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(3)), fillPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(3)), whiteKeyBorder);
    }

    // Draw Black Keys
    // Positions corresponding to: C#(1), D#(2), F#(4), G#(5), A#(6), C#(8), D#(9), F#(11), G#(12), A#(13)
    final blackKeyWhiteOffsets = [1, 2, 4, 5, 6, 8, 9, 11, 12, 13];

    for (int k = 0; k < _blackKeySemitones.length; k++) {
      final semitone = _blackKeySemitones[k];
      final whiteIndex = blackKeyWhiteOffsets[k];
      final x = whiteIndex * whiteKeyWidth - (blackKeyWidth / 2);
      final rect = Rect.fromLTWH(x, 0, blackKeyWidth, blackKeyHeight);
      final isPressed = activeKeys.contains(semitone);

      final fillPaint = Paint()
        ..color = isPressed ? (isStageMode ? AppColors.stageChordAccent : AppColors.secondary) : Colors.black
        ..style = PaintingStyle.fill;

      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(2)), fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PianoKeyboardPainter oldDelegate) =>
      oldDelegate.activeKeys != activeKeys || oldDelegate.isStageMode != isStageMode;
}
