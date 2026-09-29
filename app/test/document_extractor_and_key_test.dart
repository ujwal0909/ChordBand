import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:chordband/core/utils/document_text_extractor.dart';
import 'package:chordband/core/utils/key_detector.dart';
import 'package:chordband/data/database/app_database.dart';
import 'package:chordband/data/repositories/song_repository.dart';

void main() {
  group('DocumentTextExtractor Tests', () {
    test('extracts plain text chords and lyrics correctly', () {
      const sampleText = '''
Amazing Grace
[G]Amazing grace how [C]sweet the [G]sound
That [Em]saved a wretch like [D]me
''';
      final bytes = Uint8List.fromList(utf8.encode(sampleText));
      final extracted = DocumentTextExtractor.extractText(bytes, 'song.txt');
      expect(extracted, contains('[G]Amazing grace'));
      expect(extracted, contains('[Em]saved a wretch'));
    });

    test('extracts text from Word .docx archive structure', () {
      final archive = Archive();
      const docXml = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    <w:p><w:r><w:t>[C]Krupa Choopina [G]Deva</w:t></w:r></w:p>
    <w:p><w:r><w:t>[F]Nanu preminchina [C]Yesa</w:t></w:r></w:p>
  </w:body>
</w:document>
''';
      final xmlBytes = utf8.encode(docXml);
      archive.addFile(ArchiveFile('word/document.xml', xmlBytes.length, xmlBytes));
      final zipBytes = ZipEncoder().encode(archive);

      final extracted = DocumentTextExtractor.extractText(
        Uint8List.fromList(zipBytes!),
        'WorshipSong.docx',
      );

      expect(extracted, contains('[C]Krupa Choopina [G]Deva'));
      expect(extracted, contains('[F]Nanu preminchina [C]Yesa'));
    });

    test('extracts text from simulated PDF with compressed FlateDecode stream', () {
      // Simulate PDF stream containing PDF text drawing operators
      const streamContent = '''
BT
/F1 12 Tf
100 700 Td
(Amazing Grace how sweet the sound) Tj
0 -20 Td
([G]   [C]   [D]) Tj
ET
''';
      final compressedStream = ZLibEncoder().encode(utf8.encode(streamContent));
      final latin1Compressed = latin1.decode(compressedStream);

      final pdfContent = '''
%PDF-1.4
1 0 obj
<<
  /Length ${compressedStream.length}
  /Filter /FlateDecode
>>
stream
$latin1Compressed
endstream
endobj
trailer
<< /Root 1 0 R >>
%%EOF
''';

      final pdfBytes = Uint8List.fromList(latin1.encode(pdfContent));
      final extracted = DocumentTextExtractor.extractText(pdfBytes, 'hymn.pdf');

      expect(extracted, contains('Amazing Grace how sweet the sound'));
      expect(extracted, contains('[G]   [C]   [D]'));
    });

    test('extracts text from PDF with TJ array operators', () {
      const streamContent = '''
BT
/F1 12 Tf
[(Hotel ) -10 (California ) -5 (intro)] TJ
ET
''';
      final compressedStream = ZLibEncoder().encode(utf8.encode(streamContent));
      final latin1Compressed = latin1.decode(compressedStream);

      final pdfContent = '''
%PDF-1.4
1 0 obj
<< /Filter /FlateDecode >>
stream
$latin1Compressed
endstream
endobj
''';

      final pdfBytes = Uint8List.fromList(latin1.encode(pdfContent));
      final extracted = DocumentTextExtractor.extractText(pdfBytes, 'chords.pdf');

      expect(extracted, contains('Hotel California intro'));
    });
  });

  group('KeyDetector Tests', () {
    test('accurately detects Key of G from chords', () {
      const content = '''
[G]Amazing grace how [C]sweet the [G]sound
That [Em]saved a wretch like [D]me
I [G]once was lost but [C]now am [G]found
Was [Em]blind but [D]now I [G]see
''';
      final key = KeyDetector.detectKeyFromText(content);
      expect(key, 'G');
    });

    test('accurately detects Key of C from chords', () {
      const content = '''
[C]Krupa choopina [G]Deva [Am]sthothramu
[F]Nanu preminchina [C]Yesa [G]vandhanam
[C]Krupa choopina [G]Deva [Am]sthothramu
[F]Nanu aadharinchina [G]Thandri [C]vandhanam
''';
      final key = KeyDetector.detectKeyFromText(content);
      expect(key, 'C');
    });

    test('accurately detects Key of D from chords', () {
      const content = '''
[D]Joy to the world the [G]Lord is [A]come
Let [D]earth receive her [A]King
[D]Let every heart prepare Him room
And [G]heaven and [A]nature sing [D]
''';
      final key = KeyDetector.detectKeyFromText(content);
      expect(key, 'D');
    });

    test('accurately detects minor keys like Am and Em', () {
      const amContent = '''
[Am]Intro verse [Dm]moving to [E7]dominant
[Am]Back to minor [F]cadence [E]chord [Am]
''';
      final keyAm = KeyDetector.detectKeyFromText(amContent);
      expect(keyAm, 'Am');

      const emContent = '''
[Em]Sound of silence [D]calling [Em]deep
[C]In the night [G]whispers [B7]soft [Em]
''';
      final keyEm = KeyDetector.detectKeyFromText(emContent);
      expect(keyEm, 'Em');
    });
  });

  group('Setlist Seeding Tests', () {
    test('seeds default setlists and associates them with songs', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final repo = SongRepository(db);

      await repo.saveSong(
        title: 'Amazing Grace',
        artist: 'John Newton',
        originalKey: 'G',
        chordProContent: '[G]Amazing [C]grace',
      );
      await repo.saveSong(
        title: 'Hotel California',
        artist: 'Eagles',
        originalKey: 'Bm',
        chordProContent: '[Bm]On a dark desert highway',
      );

      await repo.seedInitialSetlistsIfEmpty();

      final setlists = await db.getAllSetlists();
      expect(setlists.length, 2);
      expect(setlists.any((s) => s.title == 'Sunday Worship Gathering'), isTrue);
      expect(setlists.any((s) => s.title == 'Acoustic Band Rehearsal'), isTrue);

      final sundaySetlist = setlists.firstWhere((s) => s.title == 'Sunday Worship Gathering');
      final items = await db.watchSetlistItems(sundaySetlist.id).first;
      expect(items.isNotEmpty, isTrue);

      await db.close();
    });
  });
}
