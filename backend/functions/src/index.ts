import * as functions from 'firebase-functions';
import axios from 'axios';
import { isUrlAllowedByRobots } from './utils/robots_checker';
import { parseChordPro } from './parsers/chordpro.parser';
import { parsePlainTextChords } from './parsers/plain_text.parser';
import { parseHtmlHeuristically } from './parsers/html_heuristic.parser';

export const importSongFromUrl = functions.https.onCall(async (data, context) => {
  // Authentication check (optional: allows guest users with rate limit)
  const url = data.url;

  if (!url || typeof url !== 'string' || !url.startsWith('http')) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'A valid HTTP or HTTPS URL must be provided.'
    );
  }

  // 1. Robots.txt Compliance Check
  const isAllowed = await isUrlAllowedByRobots(url);
  if (!isAllowed) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'The requested website disallows automated importing via its robots.txt policy.'
    );
  }

  try {
    // 2. Fetch the target URL content
    const response = await axios.get(url, {
      timeout: 8000,
      headers: {
        'User-Agent': 'ChordBandImporter/1.0 (Ethical Musician Sheet Reader; +https://chordband.app)',
        'Accept': 'text/html,text/plain,application/xhtml+xml',
      },
      maxContentLength: 2 * 1024 * 1024, // 2MB limit
    });

    const rawData = response.data;
    const contentType = String(response.headers['content-type'] || '');

    let parsedResult;

    if (contentType.includes('text/plain') || url.endsWith('.chordpro') || url.endsWith('.pro') || url.endsWith('.txt')) {
      const text = typeof rawData === 'string' ? rawData : String(rawData);
      if (/\{title|\{key|\[[A-G]/.test(text)) {
        parsedResult = parseChordPro(text, url);
      } else {
        parsedResult = parsePlainTextChords(text, url);
      }
    } else {
      // HTML Page
      const html = typeof rawData === 'string' ? rawData : String(rawData);
      parsedResult = parseHtmlHeuristically(html, url);
    }

    return {
      ...parsedResult,
      legalNotice: 'User-initiated import. Users are responsible for having the right to store and share content. Attribution recorded.',
    };
  } catch (error: any) {
    if (error instanceof functions.https.HttpsError) throw error;
    throw new functions.https.HttpsError(
      'internal',
      `Failed to fetch or parse the song from URL: ${error.message}`
    );
  }
});
