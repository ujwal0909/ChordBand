import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chord_engine/chord_engine.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/key_detector.dart';
import '../../providers/song_providers.dart';

class SongEditScreen extends ConsumerStatefulWidget {
  final String songId; // 'new' or existing UUID

  const SongEditScreen({
    super.key,
    required this.songId,
  });

  @override
  ConsumerState<SongEditScreen> createState() => _SongEditScreenState();
}

class _SongEditScreenState extends ConsumerState<SongEditScreen> {
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _keyController = TextEditingController(text: 'C');
  final _tempoController = TextEditingController();
  final _capoController = TextEditingController(text: '0');
  final _contentController = TextEditingController();
  bool _isInitialized = false;

  int _chordPitchIndex = 0; // Index into _chromaticRoots
  String _chordQuality = '';
  String? _autoDetectedKey;
  bool _manualKeyEdited = false;

  static const List<String> _chromaticRoots = [
    'C',
    'C#',
    'D',
    'Eb',
    'E',
    'F',
    'F#',
    'G',
    'Ab',
    'A',
    'Bb',
    'B'
  ];

  String get _currentChord =>
      '${_chromaticRoots[_chordPitchIndex]}$_chordQuality';

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_onContentChanged);
  }

  void _onContentChanged() {
    final text = _contentController.text;
    if (text.contains('[') || text.contains('\n')) {
      final detected = KeyDetector.detectKeyFromText(text);
      if (detected != null && detected != _autoDetectedKey) {
        setState(() {
          _autoDetectedKey = detected;
          if (!_manualKeyEdited ||
              _keyController.text.isEmpty ||
              _keyController.text == 'C') {
            _keyController.text = detected;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _contentController.removeListener(_onContentChanged);
    _titleController.dispose();
    _artistController.dispose();
    _keyController.dispose();
    _tempoController.dispose();
    _capoController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _stepChordPitch(int direction) {
    setState(() {
      _chordPitchIndex =
          (_chordPitchIndex + direction + _chromaticRoots.length) %
              _chromaticRoots.length;
    });
  }

  void _stepKeyPitch(int semitones) {
    final currentKey =
        KeySignature.tryParse(_keyController.text.trim()) ?? KeySignature.keyC;
    final newTonic = NoteTransposer.transpose(currentKey.tonic, semitones);
    final newKey =
        KeySignature.tryParse('$newTonic${currentKey.isMinor ? "m" : ""}');
    final newKeyName =
        newKey?.toString() ?? '$newTonic${currentKey.isMinor ? "m" : ""}';
    setState(() {
      _keyController.text = newKeyName;
      _manualKeyEdited = true;
    });
  }

  void _transposeAllSongChords(int semitones) {
    final text = _contentController.text;
    if (text.isEmpty) return;

    final chordRegex = RegExp(r'\[([A-Ga-g][b#]?[^\]\s]*)\]');
    final newText = text.replaceAllMapped(chordRegex, (match) {
      final chordStr = match.group(1);
      if (chordStr == null) return match.group(0)!;
      final chord = Chord.tryParse(chordStr);
      if (chord == null) return match.group(0)!;
      final transposed = ChordTransposer.transpose(chord, semitones);
      return '[$transposed]';
    });

    String? newKeyName;
    final currentKey = KeySignature.tryParse(_keyController.text.trim());
    if (currentKey != null) {
      final newTonic = NoteTransposer.transpose(currentKey.tonic, semitones);
      final newKey =
          KeySignature.tryParse('$newTonic${currentKey.isMinor ? "m" : ""}');
      newKeyName =
          newKey?.toString() ?? '$newTonic${currentKey.isMinor ? "m" : ""}';
    }

    setState(() {
      _contentController.text = newText;
      if (newKeyName != null) {
        _keyController.text = newKeyName;
        _manualKeyEdited = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Transposed chords ${semitones > 0 ? "+$semitones" : "$semitones"} semitone(s)${newKeyName != null ? " • Key is now $newKeyName" : ""}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _insertChordAtCursor(String chord) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final chordTag = '[$chord]';

    if (selection.isValid && selection.start >= 0) {
      final newText =
          text.replaceRange(selection.start, selection.end, chordTag);
      _contentController.value = TextEditingValue(
        text: newText,
        selection:
            TextSelection.collapsed(offset: selection.start + chordTag.length),
      );
    } else {
      _contentController.text += chordTag;
    }
  }

  void _insertSectionTag(String tag, String label) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final sectionText = '\n{start_of_$tag: $label}\n\n{end_of_$tag}\n';

    if (selection.isValid && selection.start >= 0) {
      final newText =
          text.replaceRange(selection.start, selection.end, sectionText);
      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
            offset: selection.start + sectionText.length - 15),
      );
    } else {
      _contentController.text += sectionText;
    }
  }

  void _autoFormatPlainTextChords() {
    final raw = _contentController.text;
    if (raw.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please paste or type lyrics and chords first.')),
      );
      return;
    }

    try {
      final parsed = PlainTextParser.parse(raw);
      setState(() {
        _contentController.text = parsed.toChordPro();
        final detected = KeyDetector.detectKeyFromText(_contentController.text);
        if (detected != null) {
          _autoDetectedKey = detected;
          _keyController.text = detected;
        } else if (parsed.originalKey != null) {
          _keyController.text = parsed.originalKey.toString();
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Converted chords & lyrics to ChordPro format!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Conversion note: $e')),
      );
    }
  }

  void _insertTemplate() {
    setState(() {
      _titleController.text = 'My New Song';
      _artistController.text = 'Artist Name';
      _keyController.text = 'G';
      _tempoController.text = '75';
      _contentController.text = '''{start_of_verse: Verse 1}
[G]This is the first line of the [C]verse with chords
[Em]Aligned precisely [D]over every word
{end_of_verse}

{start_of_chorus: Chorus}
[C]Singing the chorus loud and [G]free
[Am]Live on stage for all to [D]see
{end_of_chorus}''';
    });
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text != null && data!.text!.isNotEmpty) {
      final text = data.text!;
      // Auto-detect if it's plain text chords above lyrics or ChordPro
      if (!text.contains('[') && !text.contains('{')) {
        final parsed = PlainTextParser.parse(text);
        setState(() {
          _contentController.text = parsed.toChordPro();
          if (parsed.title.isNotEmpty && _titleController.text.isEmpty) {
            _titleController.text = parsed.title;
          }
          if (parsed.artist.isNotEmpty && _artistController.text.isEmpty) {
            _artistController.text = parsed.artist;
          }
          final detected =
              KeyDetector.detectKeyFromText(_contentController.text);
          if (detected != null) {
            _autoDetectedKey = detected;
            _keyController.text = detected;
          } else if (parsed.originalKey != null) {
            _keyController.text = parsed.originalKey.toString();
          }
        });
      } else {
        setState(() {
          _contentController.text = text;
          final detected = KeyDetector.detectKeyFromText(text);
          if (detected != null) {
            _autoDetectedKey = detected;
            _keyController.text = detected;
          }
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Pasted and detected chords from clipboard!')),
        );
      }
    }
  }

  Future<void> _saveSong() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a song title')),
      );
      return;
    }

    final repo = ref.read(songRepositoryProvider);
    final songId = widget.songId == 'new' ? null : widget.songId;

    final savedId = await repo.saveSong(
      id: songId,
      title: title,
      artist: _artistController.text.trim().isEmpty
          ? 'Unknown'
          : _artistController.text.trim(),
      originalKey:
          _keyController.text.trim().isEmpty ? 'C' : _keyController.text.trim(),
      capo: int.tryParse(_capoController.text.trim()) ?? 0,
      tempo: int.tryParse(_tempoController.text.trim()),
      chordProContent: _contentController.text.trim().isEmpty
          ? '[C]Sample lyrics'
          : _contentController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved "$title" to your songbook!')),
      );
      context.go('/song/$savedId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isStageMode = themeMode == AppThemeMode.stage;
    final primaryAccent =
        isStageMode ? AppColors.stageChord : AppColors.primary;

    // Load existing song data if editing
    if (widget.songId != 'new' && !_isInitialized) {
      final songAsync = ref.watch(singleSongStreamProvider(widget.songId));
      songAsync.whenData((song) {
        if (song != null && !_isInitialized) {
          _titleController.text = song.title;
          _artistController.text = song.artist;
          _keyController.text = song.originalKey ?? 'C';
          _tempoController.text = song.tempo?.toString() ?? '';
          _capoController.text = song.capo.toString();
          _contentController.text = song.chordProContent;
          _isInitialized = true;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.songId == 'new' ? 'Create New Song' : 'Edit Song'),
        actions: [
          TextButton.icon(
            onPressed: _insertTemplate,
            icon: const Icon(Icons.auto_stories, size: 18),
            label: const Text('Template'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: _saveSong,
            icon: const Icon(Icons.save, size: 18),
            label: const Text('Save Song'),
            style: FilledButton.styleFrom(
              backgroundColor: isStageMode ? AppColors.stageChord : null,
              foregroundColor: isStageMode ? Colors.black : null,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Metadata Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: _titleController,
                                  decoration: const InputDecoration(
                                    labelText: 'Song Title *',
                                    hintText: 'e.g. Amazing Grace',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.title),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: _artistController,
                                  decoration: const InputDecoration(
                                    labelText: 'Artist / Author',
                                    hintText: 'e.g. John Newton',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Key, Tempo, Capo Fields & Key Stepper
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: _keyController,
                                      onChanged: (_) => setState(
                                          () => _manualKeyEdited = true),
                                      decoration: InputDecoration(
                                        labelText: 'Musical Key',
                                        hintText: 'C, G, Am',
                                        border: const OutlineInputBorder(),
                                        prefixIcon: const Icon(Icons.vpn_key),
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove,
                                                  size: 16),
                                              tooltip:
                                                  'Lower Key by 1 Semitone (-1 ST)',
                                              visualDensity:
                                                  VisualDensity.compact,
                                              onPressed: () =>
                                                  _stepKeyPitch(-1),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add,
                                                  size: 16),
                                              tooltip:
                                                  'Raise Key by 1 Semitone (+1 ST)',
                                              visualDensity:
                                                  VisualDensity.compact,
                                              onPressed: () => _stepKeyPitch(1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (_autoDetectedKey != null) ...[
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.teal
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: Colors.teal
                                                  .withValues(alpha: 0.4)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.auto_awesome,
                                                size: 13, color: Colors.teal),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Detected: $_autoDetectedKey',
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal),
                                            ),
                                            if (_keyController.text !=
                                                _autoDetectedKey) ...[
                                              const SizedBox(width: 6),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _keyController.text =
                                                        _autoDetectedKey!;
                                                    _manualKeyEdited = false;
                                                  });
                                                },
                                                child: const Text(
                                                  'Apply',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.teal,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: _capoController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Capo Fret',
                                    hintText: '0',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: _tempoController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'BPM / Tempo',
                                    hintText: 'e.g. 74',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Quick Action Toolbar for Lyrics & Chords
                  Card(
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Chord & Transposition Controls',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: _pasteFromClipboard,
                                    icon: const Icon(Icons.paste, size: 14),
                                    label: const Text('Paste PDF/Doc',
                                        style: TextStyle(fontSize: 11)),
                                    style: OutlinedButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  FilledButton.tonalIcon(
                                    onPressed: _autoFormatPlainTextChords,
                                    icon: const Icon(Icons.auto_fix_high,
                                        size: 14),
                                    label: const Text('Auto-Format Chords',
                                        style: TextStyle(fontSize: 11)),
                                    style: FilledButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // 1. Transpose Song Chords Row (Increase / Decrease Semitone)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: primaryAccent.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: primaryAccent.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.tune, size: 18),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Transpose All Chords in Song',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        'Increase or decrease song pitch by semitones',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () => _transposeAllSongChords(-1),
                                  icon: const Icon(Icons.remove, size: 14),
                                  label: const Text('-1 ST'),
                                  style: OutlinedButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                FilledButton.icon(
                                  onPressed: () => _transposeAllSongChords(1),
                                  icon: const Icon(Icons.add, size: 14),
                                  label: const Text('+1 ST'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: primaryAccent,
                                    foregroundColor: isStageMode
                                        ? Colors.black
                                        : Colors.white,
                                    visualDensity: VisualDensity.compact,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // 2. Chord Stepper (Increase / Decrease Chord Pitch to Insert)
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Insert Chord at Cursor:',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Root: ${_chromaticRoots[_chordPitchIndex]}',
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    // Decrease Root
                                    IconButton.filledTonal(
                                      onPressed: () => _stepChordPitch(-1),
                                      icon: const Icon(Icons.remove),
                                      tooltip:
                                          'Decrease Chord Pitch (Step Root Down)',
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    const SizedBox(width: 8),
                                    // Current Chord Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: primaryAccent.withValues(
                                            alpha: 0.18),
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: primaryAccent),
                                      ),
                                      child: Text(
                                        _currentChord,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: primaryAccent,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Increase Root
                                    IconButton.filledTonal(
                                      onPressed: () => _stepChordPitch(1),
                                      icon: const Icon(Icons.add),
                                      tooltip:
                                          'Increase Chord Pitch (Step Root Up)',
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    const SizedBox(width: 12),
                                    // Insert Button
                                    Expanded(
                                      child: FilledButton.icon(
                                        onPressed: () =>
                                            _insertChordAtCursor(_currentChord),
                                        icon: const Icon(Icons.add_circle,
                                            size: 16),
                                        label: Text('Insert [$_currentChord]'),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: primaryAccent,
                                          foregroundColor: isStageMode
                                              ? Colors.black
                                              : Colors.white,
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Chord Quality Selector Chips
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      const Text('Quality: ',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey)),
                                      ...[
                                        ('', 'Maj'),
                                        ('m', 'Minor (m)'),
                                        ('7', '7'),
                                        ('m7', 'm7'),
                                        ('sus4', 'sus4'),
                                        ('add9', 'add9'),
                                        ('dim', 'dim'),
                                      ].map((q) {
                                        final isSel = _chordQuality == q.$1;
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4),
                                          child: ChoiceChip(
                                            label: Text(q.$2,
                                                style: const TextStyle(
                                                    fontSize: 11)),
                                            selected: isSel,
                                            visualDensity:
                                                VisualDensity.compact,
                                            onSelected: (_) => setState(
                                                () => _chordQuality = q.$1),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // 3. Section Structure Buttons
                          Row(
                            children: [
                              const Text('Sections: ',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey)),
                              Wrap(
                                spacing: 6,
                                children: [
                                  ActionChip(
                                    avatar: const Icon(Icons.tag, size: 14),
                                    label: const Text('Verse',
                                        style: TextStyle(fontSize: 11)),
                                    onPressed: () =>
                                        _insertSectionTag('verse', 'Verse 1'),
                                  ),
                                  ActionChip(
                                    avatar:
                                        const Icon(Icons.music_note, size: 14),
                                    label: const Text('Chorus',
                                        style: TextStyle(fontSize: 11)),
                                    onPressed: () =>
                                        _insertSectionTag('chorus', 'Chorus'),
                                  ),
                                  ActionChip(
                                    avatar: const Icon(Icons.compare_arrows,
                                        size: 14),
                                    label: const Text('Bridge',
                                        style: TextStyle(fontSize: 11)),
                                    onPressed: () =>
                                        _insertSectionTag('bridge', 'Bridge'),
                                  ),
                                  ActionChip(
                                    avatar: const Icon(Icons.logout, size: 14),
                                    label: const Text('Outro',
                                        style: TextStyle(fontSize: 11)),
                                    onPressed: () =>
                                        _insertSectionTag('outro', 'Outro'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ChordPro Editor Box
                  TextField(
                    controller: _contentController,
                    maxLines: 24,
                    style: const TextStyle(
                      fontFamily: 'NotoSansTelugu',
                      fontSize: 15,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      labelText:
                          'Song Chords & Lyrics (ChordPro format or Plain Text)',
                      hintText:
                          '[C]Amazing [F]grace how [C]sweet the sound\nThat [Em]saved a [D]wretch like [G]me...\n\n(Or paste chords on the line above lyrics and tap "Auto-Format Chords")',
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      fillColor: isStageMode ? AppColors.stageSurface : null,
                      filled: isStageMode,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Large Prominent Save Button at Bottom
                  FilledButton.icon(
                    onPressed: _saveSong,
                    icon: const Icon(Icons.check_circle, size: 22),
                    label: const Text('Save Song to Songbook',
                        style: TextStyle(fontSize: 16)),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: isStageMode
                          ? AppColors.stageChord
                          : AppColors.primary,
                      foregroundColor:
                          isStageMode ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
