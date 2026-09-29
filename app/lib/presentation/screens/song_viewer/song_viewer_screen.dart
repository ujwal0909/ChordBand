import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:chord_engine/chord_engine.dart';
import '../../../data/database/app_database.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/song_providers.dart';
import '../../providers/song_viewer_providers.dart';
import 'widgets/chord_line_widget.dart';
import 'widgets/transposition_bar.dart';
import 'widgets/auto_scroll_bar.dart';
import 'widgets/section_jump_sheet.dart';

class SongViewerScreen extends ConsumerStatefulWidget {
  final String songId;

  const SongViewerScreen({
    super.key,
    required this.songId,
  });

  @override
  ConsumerState<SongViewerScreen> createState() => _SongViewerScreenState();
}

class _SongViewerScreenState extends ConsumerState<SongViewerScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  Timer? _scrollTimer;
  final Set<int> _collapsedSectionIndices = {};
  double _baseFontSize = 17.0;
  bool _isPresentationMode = false;

  @override
  void initState() {
    super.initState();
    // Keep screen awake while viewing songs on stage
    WakelockPlus.enable();
    _startOrStopAutoScroll();
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    _focusNode.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  void _startOrStopAutoScroll() {
    _scrollTimer?.cancel();
    final state = ref.read(songViewerProvider(widget.songId));
    if (state.isAutoScrolling) {
      // 60 FPS smooth scrolling
      _scrollTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
        if (!_scrollController.hasClients) return;
        final maxScroll = _scrollController.position.maxScrollExtent;
        final current = _scrollController.offset;
        final step = (state.autoScrollSpeed * 0.016);

        if (current + step >= maxScroll) {
          _scrollController.jumpTo(maxScroll);
          ref.read(songViewerProvider(widget.songId).notifier).toggleAutoScroll();
          timer.cancel();
        } else {
          _scrollController.jumpTo(current + step);
        }
      });
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final notifier = ref.read(songViewerProvider(widget.songId).notifier);

    // Foot pedal / keyboard navigation
    if (event.logicalKey == LogicalKeyboardKey.escape && _isPresentationMode) {
      setState(() => _isPresentationMode = false);
      return;
    }

    if (event.logicalKey == LogicalKeyboardKey.space) {
      notifier.toggleAutoScroll();
      _startOrStopAutoScroll();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.pageDown) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.offset + 250,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.pageUp) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.offset - 250,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    } else if (event.logicalKey == LogicalKeyboardKey.bracketLeft) {
      notifier.transpose(-1);
    } else if (event.logicalKey == LogicalKeyboardKey.bracketRight) {
      notifier.transpose(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final songAsync = ref.watch(singleSongStreamProvider(widget.songId));
    final lyricVersionsAsync = ref.watch(lyricVersionsStreamProvider(widget.songId));
    final viewerState = ref.watch(songViewerProvider(widget.songId));
    final viewerNotifier = ref.read(songViewerProvider(widget.songId).notifier);
    final themeMode = ref.watch(themeModeProvider);
    final isStageMode = themeMode == AppThemeMode.stage;

    // React to auto-scroll state change
    ref.listen<SongViewerState>(songViewerProvider(widget.songId), (prev, next) {
      if (prev?.isAutoScrolling != next.isAutoScrolling ||
          prev?.autoScrollSpeed != next.autoScrollSpeed) {
        _startOrStopAutoScroll();
      }
    });

    return songAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error loading song: $err'))),
      data: (song) {
        if (song == null) {
          return const Scaffold(body: Center(child: Text('Song not found')));
        }

        // Determine which content to parse: primary or selected lyric version
        final lyricVersions = lyricVersionsAsync.value ?? [];
        String activeContent = song.chordProContent;
        if (viewerState.activeLyricVersionId != null) {
          final matched = lyricVersions
              .where((v) => v.id == viewerState.activeLyricVersionId)
              .firstOrNull;
          if (matched != null) {
            activeContent = matched.content;
          }
        }

        // Parse song content through chord_engine
        final originalSong = ChordProParser.parse(activeContent);
        final effectiveKey = originalSong.originalKey ??
            KeySignature.tryParse(song.originalKey ?? 'C') ??
            KeySignature.keyC;

        // Perform active transposition
        final transposedSong = ChordTransposer.transposeSong(
          originalSong,
          semitones: viewerState.semitoneOffset,
          toKey: viewerState.targetKey,
          preferFlats: viewerState.preferFlats,
        );

        final displayKey = transposedSong.currentKey ?? effectiveKey;

        // External Display / Presentation Mode
        if (_isPresentationMode) {
          return KeyboardListener(
            focusNode: _focusNode,
            autofocus: true,
            onKeyEvent: _handleKeyEvent,
            child: Scaffold(
              backgroundColor: isStageMode ? Colors.black : const Color(0xFF111418),
              body: Stack(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 56),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      song.title,
                                      style: const TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      song.artist,
                                      style: const TextStyle(fontSize: 18, color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.stageChord,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Key: ${displayKey.toString()}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white24, height: 36),
                          ...transposedSong.sections.asMap().entries.map((entry) {
                            return _buildSectionWidget(
                              section: entry.value,
                              index: entry.key,
                              isCollapsed: false,
                              viewerState: viewerState.copyWith(fontSize: 22.0),
                              displayKey: displayKey,
                              isStageMode: true,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 24,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton.filledTonal(
                          icon: Icon(viewerState.isAutoScrolling ? Icons.pause : Icons.play_arrow),
                          tooltip: viewerState.isAutoScrolling ? 'Pause Auto-Scroll' : 'Play Auto-Scroll',
                          onPressed: () => viewerNotifier.toggleAutoScroll(),
                        ),
                        const SizedBox(width: 10),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white24,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.fullscreen_exit, size: 20),
                          label: const Text('Exit Presentation (Esc)'),
                          onPressed: () => setState(() => _isPresentationMode = false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: _handleKeyEvent,
          child: Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isStageMode ? AppColors.stageTextPrimary : null,
                    ),
                  ),
                  Text(
                    song.artist,
                    style: TextStyle(
                      fontSize: 12,
                      color: isStageMode ? AppColors.stageTextSecondary : null,
                    ),
                  ),
                ],
              ),
              actions: [
                // Lyric Version Selector Dropdown (Telugu, English, Transliterated)
                if (lyricVersions.isNotEmpty)
                  PopupMenuButton<String?>(
                    tooltip: 'Switch Lyric Version',
                    icon: const Icon(Icons.translate),
                    initialValue: viewerState.activeLyricVersionId,
                    onSelected: (id) => viewerNotifier.setLyricVersion(id),
                    itemBuilder: (ctx) {
                      return [
                        const PopupMenuItem<String?>(
                          value: null,
                          child: Text('Original Lyrics'),
                        ),
                        ...lyricVersions.map((v) => PopupMenuItem<String?>(
                              value: v.id,
                              child: Text(v.languageName),
                            )),
                      ];
                    },
                  ),

                // Section List Jump Drawer
                IconButton(
                  icon: const Icon(Icons.menu_book),
                  tooltip: 'Song Sections',
                  onPressed: () {
                    SectionJumpSheet.show(
                      context: context,
                      sections: transposedSong.sections,
                      collapsedSectionIndices: _collapsedSectionIndices,
                      isStageMode: isStageMode,
                      onToggleCollapse: (idx) {
                        setState(() {
                          if (_collapsedSectionIndices.contains(idx)) {
                            _collapsedSectionIndices.remove(idx);
                          } else {
                            _collapsedSectionIndices.add(idx);
                          }
                        });
                      },
                      onJumpToSection: (idx) {
                        // Section jumping
                      },
                    );
                  },
                ),

                // External Display Presentation Mode
                IconButton(
                  icon: const Icon(Icons.cast_connected),
                  tooltip: 'External Display Presentation Mode\n(Fullscreen stage monitor displaying only large lyrics & chords)',
                  onPressed: () {
                    setState(() => _isPresentationMode = true);
                  },
                ),

                // Share Song Button
                IconButton(
                  icon: const Icon(Icons.share),
                  tooltip: 'Share Song / Export Chords',
                  onPressed: () => _showShareDialog(context, song, transposedSong, displayKey),
                ),

                // Stage Mode Switch
                IconButton(
                  icon: Icon(
                    isStageMode ? Icons.nightlife : Icons.nightlife_outlined,
                    color: isStageMode ? AppColors.stageChordAccent : null,
                  ),
                  tooltip: isStageMode ? 'Exit Stage Mode' : 'Enter Stage Mode',
                  onPressed: () {
                    ref.read(themeModeProvider.notifier).state =
                        isStageMode ? AppThemeMode.dark : AppThemeMode.stage;
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                // Top Transposition Bar
                TranspositionBar(
                  state: viewerState,
                  originalKey: effectiveKey,
                  effectiveKey: displayKey,
                  isStageMode: isStageMode,
                  onTranspose: (d) => viewerNotifier.transpose(d),
                  onReset: () => viewerNotifier.resetTransposition(),
                  onSelectKey: (k) => viewerNotifier.setTargetKey(k),
                  onSelectCapo: (f) => viewerNotifier.setCapo(f),
                  onToggleFlats: () => viewerNotifier.togglePreferFlats(),
                  onSelectNotation: (n) => viewerNotifier.setNotation(n),
                  onToggleMonospace: () => viewerNotifier.toggleMonospace(),
                ),

                // Main Scrollable Song Area with Pinch-to-Zoom
                Expanded(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onScaleStart: (_) {
                          _baseFontSize = viewerState.fontSize;
                        },
                        onScaleUpdate: (details) {
                          if (details.scale != 1.0) {
                            viewerNotifier.setFontSize(_baseFontSize * details.scale);
                          }
                        },
                        child: ListView(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                          children: [
                            // Song Metadata Header Card
                            _buildHeaderCard(song, transposedSong, displayKey, isStageMode),
                            const SizedBox(height: 16),

                            // Sections and Lines
                            ...transposedSong.sections.asMap().entries.map((entry) {
                              final index = entry.key;
                              final section = entry.value;
                              final isCollapsed = _collapsedSectionIndices.contains(index);

                              return _buildSectionWidget(
                                section: section,
                                index: index,
                                isCollapsed: isCollapsed,
                                viewerState: viewerState,
                                displayKey: displayKey,
                                isStageMode: isStageMode,
                              );
                            }),
                          ],
                        ),
                      ),

                      // Floating Auto-Scroll Controls
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: AutoScrollBar(
                            state: viewerState,
                            isStageMode: isStageMode,
                            onToggleScroll: () => viewerNotifier.toggleAutoScroll(),
                            onSpeedChanged: (s) => viewerNotifier.setAutoScrollSpeed(s),
                            onZoomIn: () => viewerNotifier.zoomFont(1.1),
                            onZoomOut: () => viewerNotifier.zoomFont(0.9),
                            onScrollToTop: () {
                              _scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                            onScrollToBottom: () {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOut,
                              );
                            },
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
      },
    );
  }

  Widget _buildHeaderCard(
    SongsTableData song,
    ParsedSong parsed,
    KeySignature currentKey,
    bool isStageMode,
  ) {
    final capoSuffix = parsed.capo > 0 ? ' • Capo: ${parsed.capo}' : '';
    final tempoSuffix = parsed.tempo != null ? ' • ${parsed.tempo} BPM' : '';
    final timeSuffix = parsed.timeSignature != null ? ' • ${parsed.timeSignature}' : '';

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 48), // Padding below top transposition bar
      decoration: BoxDecoration(
        color: isStageMode ? AppColors.stageSurface : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isStageMode ? AppColors.stageBorder : Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Key: $currentKey$capoSuffix$tempoSuffix$timeSuffix',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isStageMode ? AppColors.stageChordAccent : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionWidget({
    required SongSection section,
    required int index,
    required bool isCollapsed,
    required SongViewerState viewerState,
    required KeySignature displayKey,
    required bool isStageMode,
  }) {
    final sectionBadgeColor = isStageMode ? AppColors.stageSectionBadge : AppColors.secondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          InkWell(
            onTap: () {
              setState(() {
                if (isCollapsed) {
                  _collapsedSectionIndices.remove(index);
                } else {
                  _collapsedSectionIndices.add(index);
                }
              });
            },
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: sectionBadgeColor.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: sectionBadgeColor.withOpacity(0.4)),
                    ),
                    child: Text(
                      section.title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: sectionBadgeColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isCollapsed ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                    size: 18,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Section Lines
          if (!isCollapsed)
            ...section.lines.map((line) => ChordLineWidget(
                  line: line,
                  state: viewerState,
                  currentKey: displayKey,
                  isStageMode: isStageMode,
                )),
        ],
      ),
    );
  }

  void _showShareDialog(
    BuildContext context,
    SongsTableData song,
    ParsedSong transposedSong,
    KeySignature displayKey,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Share "${song.title}"',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy Chords & Lyrics to Clipboard'),
                subtitle: Text('Current Key: ${displayKey.toString()} • Formatted with brackets'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: transposedSong.toChordPro()));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chords & lyrics copied to clipboard!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.podcasts),
                title: const Text('Broadcast to Live Stage Session'),
                subtitle: const Text('Follow-the-Leader: Band members follow your key & song'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/live');
                },
              ),
              ListTile(
                leading: const Icon(Icons.playlist_add),
                title: const Text('Add to Setlist'),
                subtitle: const Text('Include in Sunday service or rehearsal setlist'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/setlists');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

