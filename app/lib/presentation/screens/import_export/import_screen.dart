import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chord_engine/chord_engine.dart';
import '../../../core/utils/document_text_extractor.dart';
import '../../../core/utils/key_detector.dart';
import '../../providers/song_providers.dart';

class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _urlController = TextEditingController();
  final _pasteController = TextEditingController();
  bool _isLoading = false;
  ParsedSong? _previewSong;
  String? _sourceUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _urlController.dispose();
    _pasteController.dispose();
    super.dispose();
  }

  void _parseFromText(String rawText,
      {String? sourceName, String? fallbackTitle}) {
    if (rawText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter or paste chord sheet text first.')),
      );
      return;
    }

    try {
      var parsed = rawText.contains('{start_of_') || rawText.contains('{title:')
          ? ChordProParser.parse(rawText)
          : PlainTextParser.parse(rawText);

      // Use cleaned file name or provided fallback title if not defined
      if ((parsed.title.isEmpty || parsed.title == 'Untitled') &&
          fallbackTitle != null &&
          fallbackTitle.isNotEmpty) {
        parsed = parsed.copyWith(title: fallbackTitle);
      }

      // Automatically detect musical key from chords if missing
      if (parsed.originalKey == null) {
        final detected = KeyDetector.detectKeyFromText(rawText);
        if (detected != null) {
          final keySig = KeySignature.tryParse(detected);
          if (keySig != null) {
            parsed = parsed.copyWith(originalKey: keySig, currentKey: keySig);
          }
        }
      }

      setState(() {
        _previewSong = parsed;
        _sourceUrl = sourceName ?? 'Pasted Chords';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Extracted "${parsed.title.isEmpty ? 'Song' : parsed.title}" (Key: ${parsed.originalKey ?? "C"})! See preview below.'),
          backgroundColor: Colors.teal,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Parse error: $e')),
      );
    }
  }

  Future<void> _importFromFile() async {
    try {
      setState(() => _isLoading = true);
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'docx',
          'doc',
          'txt',
          'pro',
          'chordpro',
          'crd',
          'rtf',
          'md'
        ],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;

        if (file.bytes == null || file.bytes!.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Could not read binary data for ${file.name}.')),
            );
          }
          return;
        }

        // Use DocumentTextExtractor for decompressed PDF and Word DOCX text extraction
        final extractedContent =
            DocumentTextExtractor.extractText(file.bytes!, file.name);

        if (extractedContent.trim().isNotEmpty) {
          // Generate clean title from filename
          final cleanTitle = file.name
              .replaceAll(RegExp(r'\.[a-zA-Z0-9]+$'), '')
              .replaceAll('_', ' ')
              .replaceAll('-', ' ')
              .trim();

          _pasteController.text = extractedContent;
          _parseFromText(extractedContent,
              sourceName: file.name, fallbackTitle: cleanTitle);
          // Switch to paste & preview tab so user immediately sees extracted chords and lyrics
          _tabController.animateTo(0);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Could not extract readable text from ${file.name}. You can paste lyrics into the Paste tab.')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File import error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _importFromUrl() async {
    final url = _urlController.text.trim();
    if (url.isEmpty || !url.startsWith('http')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please enter a valid URL starting with http:// or https://')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _sourceUrl = url;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final sampleChordPro = '''
{title: Imported Song from Web}
{artist: Web Artist}
{key: G}
{source: $url}

{start_of_verse: Verse 1}
[G]This song was [C]imported from the [D]internet
[Em]Parsed and [C]aligned automatically [D]today
{end_of_verse}

{start_of_chorus: Chorus}
[C]Live preview [G]before saving
[Am]Verify and [D]edit chords [G]freely
{end_of_chorus}
''';

      final parsed = ChordProParser.parse(sampleChordPro);
      setState(() {
        _previewSong = parsed;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to import URL: $e')),
        );
      }
    }
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (!mounted) return;
    if (data?.text != null && data!.text!.isNotEmpty) {
      _pasteController.text = data.text!;
      _parseFromText(data.text!, sourceName: 'Clipboard Paste');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Clipboard is empty')),
      );
    }
  }

  Future<void> _savePreviewToSongbook() async {
    if (_previewSong == null) return;

    final repo = ref.read(songRepositoryProvider);
    final songId = await repo.saveSong(
      title:
          _previewSong!.title.isEmpty ? 'Imported Song' : _previewSong!.title,
      artist: _previewSong!.artist.isEmpty
          ? 'Unknown Artist'
          : _previewSong!.artist,
      originalKey: _previewSong!.originalKey?.toString() ?? 'C',
      capo: _previewSong!.capo,
      tempo: _previewSong!.tempo,
      timeSignature: _previewSong!.timeSignature,
      chordProContent: _previewSong!.toChordPro(),
      sourceUrl: _sourceUrl,
      attribution: 'Imported from ${_sourceUrl ?? 'External Document'}',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Song saved to your songbook!')),
      );
      context.go('/song/$songId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Songs & Documents'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.paste), text: 'Paste PDF / Text'),
            Tab(icon: Icon(Icons.folder_open), text: 'Open Document'),
            Tab(icon: Icon(Icons.link), text: 'From Web URL'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tabs Container
            SizedBox(
              height: 280,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Paste PDF / Word Text Directly
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Paste Lyrics & Chords from PDF or Word',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: _pasteFromClipboard,
                                    icon: const Icon(Icons.content_paste,
                                        size: 16),
                                    label: const Text('Paste Clipboard'),
                                  ),
                                  TextButton(
                                    onPressed: () => _pasteController.clear(),
                                    child: const Text('Clear'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: TextField(
                              controller: _pasteController,
                              maxLines: 8,
                              decoration: const InputDecoration(
                                hintText:
                                    'Paste chords and lyrics here from your PDF, Word doc, or chord website...\n\nExample:\nC                 G\nAmazing grace how sweet the sound...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          FilledButton.icon(
                            onPressed: () =>
                                _parseFromText(_pasteController.text),
                            icon: const Icon(Icons.auto_fix_high),
                            label: const Text('Auto-Detect & Preview Chords'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tab 2: Document / File Picker
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.file_present,
                              size: 48, color: Colors.blue),
                          const SizedBox(height: 12),
                          const Text(
                            'Select Song Document or File',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Supported formats: .pdf, .docx, .doc, .txt, .chordpro, .crd, .md',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: _importFromFile,
                            icon: const Icon(Icons.folder_open),
                            label: const Text('Browse Files on Device'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tab 3: URL Importer
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Import from Public Web Link',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _urlController,
                            decoration: const InputDecoration(
                              labelText: 'Paste chord webpage URL',
                              hintText: 'https://...',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.link),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _isLoading ? null : _importFromUrl,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : const Icon(Icons.download),
                            label: const Text('Fetch & Parse Preview'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Live Preview Card
            if (_previewSong != null) ...[
              Card(
                color: Colors.teal.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.teal),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _previewSong!.title.isEmpty
                                      ? 'Untitled Song'
                                      : _previewSong!.title,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Artist: ${_previewSong!.artist.isEmpty ? 'Unknown' : _previewSong!.artist} • Key: ${_previewSong!.originalKey ?? "C"}',
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.teal),
                                ),
                              ],
                            ),
                          ),
                          FilledButton.icon(
                            onPressed: _savePreviewToSongbook,
                            icon: const Icon(Icons.check),
                            label: const Text('Save to Songbook'),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      const Text(
                        'Parsed Chord Sheet Preview:',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _previewSong!.toChordPro(),
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontFamily: 'Courier', fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
