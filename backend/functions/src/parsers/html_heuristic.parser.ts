import * as cheerio from 'cheerio';
import { ParsedSongResult, parseChordPro } from './chordpro.parser';
import { parsePlainTextChords } from './plain_text.parser';

export function parseHtmlHeuristically(html: string, sourceUrl?: string): ParsedSongResult {
  const $ = cheerio.load(html);

  // Extract Title from <title>, <h1>, or meta tags
  let title = $('meta[property="og:title"]').attr('content') ||
              $('h1').first().text().trim() ||
              $('title').text().trim() ||
              'Imported Song';

  // Clean title (remove "Chords", "Lyrics", "Tabs", etc.)
  title = title.replace(/\s*(?:Chords|Lyrics|Tab|Tabs|by\s+.*|ChordPro)$/i, '').trim();

  // Extract Artist
  let artist = $('meta[property="music:musician"]').attr('content') ||
               $('.artist-name, .artist, .subtitle').first().text().trim() ||
               'Unknown Artist';

  // Extract Key from metadata if present
  let key: string | undefined;
  const keyEl = $('*:contains("Key:"), *:contains("key:")').first();
  if (keyEl.length > 0) {
    const keyMatch = keyEl.text().match(/Key:\s*([A-Ga-g][#b]?m?)/i);
    if (keyMatch) key = keyMatch[1];
  }

  // Look for <pre> blocks or elements containing chords/lyrics
  let rawChordSheet = '';

  const preBlocks = $('pre');
  if (preBlocks.length > 0) {
    // Pick the longest <pre> block
    let maxLength = 0;
    preBlocks.each((_, el) => {
      const text = $(el).text();
      if (text.length > maxLength) {
        maxLength = text.length;
        rawChordSheet = text;
      }
    });
  }

  // If no <pre>, search for .chords, .tab-content, #song-content
  if (!rawChordSheet) {
    rawChordSheet = $('.tab-content, .chord-sheet, .song-text, .lyrics-body, #chords').text();
  }

  // Fallback to body text
  if (!rawChordSheet) {
    rawChordSheet = $('body').text();
  }

  // If text already has [Chord] format, use ChordPro parser
  if (/\[[A-G][#b]?[^\]]*\]/.test(rawChordSheet)) {
    const res = parseChordPro(rawChordSheet, sourceUrl);
    return {
      ...res,
      title: title || res.title,
      artist: artist || res.artist,
      key: key || res.key,
    };
  }

  // Otherwise, use plain text chord-over-lyrics parser
  const res = parsePlainTextChords(rawChordSheet, sourceUrl);
  return {
    ...res,
    title: title || res.title,
    artist: artist || res.artist,
    key: key || res.key,
  };
}
