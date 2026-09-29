import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';

class DocumentTextExtractor {
  /// Extracts plain text from various document formats (.pdf, .docx, .txt, etc.)
  static String extractText(Uint8List bytes, String filename) {
    final ext = filename.split('.').last.toLowerCase();

    if (ext == 'docx') {
      return extractFromDocx(bytes);
    } else if (ext == 'pdf') {
      return extractFromPdf(bytes);
    } else {
      // Plain text, ChordPro, CRD, Markdown
      return extractFromPlainText(bytes);
    }
  }

  /// Extracts text from Word .docx file (which is a ZIP containing word/document.xml)
  static String extractFromDocx(Uint8List bytes) {
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      for (final file in archive) {
        if (file.name == 'word/document.xml') {
          final content = utf8.decode(file.content as List<int>, allowMalformed: true);
          return _xmlToPlainText(content);
        }
      }
    } catch (_) {}
    return extractFromPlainText(bytes);
  }

  /// Extracts text from PDF files by finding content streams, decompressing FlateDecode,
  /// and extracting PDF text drawing operators.
  static String extractFromPdf(Uint8List bytes) {
    final buffer = StringBuffer();
    final latin1String = latin1.decode(bytes);

    // 1. Scan for all "stream ... endstream" segments in the PDF
    final streamRegex = RegExp(r'stream[\r\n]+([\s\S]*?)[\r\n]+endstream', multiLine: true);
    final matches = streamRegex.allMatches(latin1String);

    for (final match in matches) {
      final streamRaw = match.group(1);
      if (streamRaw == null || streamRaw.isEmpty) continue;

      List<int> streamBytes = latin1.encode(streamRaw);
      String decodedStream = '';

      // Try ZLib / Flate decompression
      try {
        final decompressed = ZLibDecoder().decodeBytes(streamBytes);
        decodedStream = utf8.decode(decompressed, allowMalformed: true);
      } catch (_) {
        try {
          decodedStream = utf8.decode(streamBytes, allowMalformed: true);
        } catch (_) {
          decodedStream = streamRaw;
        }
      }

      // Check if this stream contains PDF text drawing operators
      if (decodedStream.contains('BT') || decodedStream.contains('Tj') || decodedStream.contains('TJ')) {
        final extracted = _extractTextFromPdfStream(decodedStream);
        if (extracted.trim().isNotEmpty) {
          buffer.writeln(extracted);
          buffer.writeln();
        }
      }
    }

    final result = buffer.toString().trim();
    if (result.isNotEmpty) {
      return result;
    }

    // Fallback: If compressed stream extraction didn't yield text, extract printable strings
    return _extractPrintableStrings(latin1String);
  }

  /// Parses text from a decompressed PDF content stream sequentially
  static String _extractTextFromPdfStream(String stream) {
    final sb = StringBuffer();

    // Match text-showing operators and line breaks in sequential order
    final tokenRegex = RegExp(
      r'(\[[\s\S]*?\]\s*TJ|\([\s\S]*?\)\s*Tj|\([\s\S]*?\)\s*["\x27]|<[0-9a-fA-F\s]+>\s*Tj|T\*|ET|Td|TD)',
    );

    final matches = tokenRegex.allMatches(stream);
    for (final m in matches) {
      final token = m.group(0) ?? '';

      if (token == 'T*' || token == 'ET' || token == 'Td' || token == 'TD') {
        if (sb.isNotEmpty && !sb.toString().endsWith('\n')) {
          sb.writeln();
        }
        continue;
      }

      // 1. Array TJ: [(text) -10 (more)] TJ
      if (token.endsWith('TJ')) {
        final innerRegex = RegExp(r'\(([\s\S]*?)\)|<([0-9a-fA-F\s]+)>');
        final strParts = StringBuffer();
        for (final innerMatch in innerRegex.allMatches(token)) {
          if (innerMatch.group(1) != null) {
            strParts.write(_unescapePdfString(innerMatch.group(1)!));
          } else if (innerMatch.group(2) != null) {
            strParts.write(_decodePdfHexString(innerMatch.group(2)!));
          }
        }
        final text = strParts.toString().trim();
        if (text.isNotEmpty) {
          sb.writeln(text);
        }
        continue;
      }

      // 2. Hex string: <48656c6c6f> Tj
      if (token.startsWith('<') && token.endsWith('Tj')) {
        final hexContent = RegExp(r'<([0-9a-fA-F\s]+)>').firstMatch(token)?.group(1) ?? '';
        final decoded = _decodePdfHexString(hexContent).trim();
        if (decoded.isNotEmpty) {
          sb.writeln(decoded);
        }
        continue;
      }

      // 3. Literal string: (text) Tj or (text) '
      final literalMatch = RegExp(r'^\(([\s\S]*?)\)\s*(?:Tj|["\x27])').firstMatch(token);
      if (literalMatch != null) {
        final rawStr = literalMatch.group(1) ?? '';
        final unescaped = _unescapePdfString(rawStr);
        if (unescaped.trim().isNotEmpty) {
          sb.writeln(unescaped);
        }
      }
    }

    return sb.toString();
  }

  static String _unescapePdfString(String input) {
    // 1. Unescape octal values like \040 -> ' '
    final octalResolved = input.replaceAllMapped(
      RegExp(r'\\([0-7]{1,3})'),
      (m) => String.fromCharCode(int.parse(m.group(1)!, radix: 8)),
    );

    // 2. Standard escape sequences
    return octalResolved
        .replaceAll(r'\(', '(')
        .replaceAll(r'\)', ')')
        .replaceAll(r'\\', r'\')
        .replaceAll(r'\r', '')
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\t', '\t');
  }

  static String _decodePdfHexString(String hex) {
    final clean = hex.replaceAll(RegExp(r'\s+'), '');
    final bytes = <int>[];
    for (int i = 0; i < clean.length; i += 2) {
      if (i + 1 < clean.length) {
        final b = int.tryParse(clean.substring(i, i + 2), radix: 16);
        if (b != null) bytes.add(b);
      }
    }

    if (bytes.isEmpty) return '';

    // Check for UTF-16BE BOM
    if (bytes.length >= 2 && bytes[0] == 0xFE && bytes[1] == 0xFF) {
      final codeUnits = <int>[];
      for (int i = 2; i < bytes.length; i += 2) {
        if (i + 1 < bytes.length) {
          codeUnits.add((bytes[i] << 8) | bytes[i + 1]);
        }
      }
      return String.fromCharCodes(codeUnits);
    }

    try {
      return utf8.decode(bytes, allowMalformed: true);
    } catch (_) {
      return latin1.decode(bytes);
    }
  }

  static String _extractPrintableStrings(String raw) {
    final matches = RegExp(r'[\x20-\x7E\r\n]{4,}')
        .allMatches(raw)
        .map((m) => m.group(0))
        .where((s) => s != null && s.trim().length > 3 && !s.contains('obj') && !s.contains('endobj') && !s.contains('stream'))
        .join('\n');
    return matches;
  }

  static String _xmlToPlainText(String xml) {
    return xml
        .replaceAll(RegExp(r'</w:p>'), '\n')
        .replaceAll(RegExp(r'<w:tab/>'), '    ')
        .replaceAll(RegExp(r'<w:br/>'), '\n')
        .replaceAll(RegExp(r'<[^>]+>'), '')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'");
  }

  static String extractFromPlainText(Uint8List bytes) {
    try {
      return utf8.decode(bytes, allowMalformed: true);
    } catch (_) {
      return latin1.decode(bytes);
    }
  }
}
