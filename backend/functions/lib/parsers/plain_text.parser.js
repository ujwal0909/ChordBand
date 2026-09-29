"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.parsePlainTextChords = parsePlainTextChords;
const CHORD_REGEX = /^[A-Ga-g][#b♯♭]?(?:maj|min|m|M|dim|aug|sus[24]|add9|[0-9])*(?:\/[A-Ga-g][#b♯♭]?)?$/;
function isChordToken(token) {
    return CHORD_REGEX.test(token.trim());
}
function isChordLine(line) {
    const tokens = line.trim().split(/\s+/).filter(Boolean);
    if (tokens.length === 0)
        return false;
    const valid = tokens.filter(isChordToken).length;
    return (valid / tokens.length) >= 0.70;
}
function parsePlainTextChords(content, sourceUrl) {
    const lines = content.split(/\r?\n/);
    let title = 'Imported Song';
    let artist = 'Unknown Artist';
    let key;
    const chordProLines = [];
    let i = 0;
    while (i < lines.length) {
        const line = lines[i];
        const trimmed = line.trim();
        if (!trimmed) {
            chordProLines.push('');
            i++;
            continue;
        }
        if (trimmed.toLowerCase().startsWith('title:')) {
            title = trimmed.substring(6).trim();
            i++;
            continue;
        }
        if (trimmed.toLowerCase().startsWith('artist:')) {
            artist = trimmed.substring(7).trim();
            i++;
            continue;
        }
        if (trimmed.toLowerCase().startsWith('key:')) {
            key = trimmed.substring(4).trim();
            i++;
            continue;
        }
        // Section header [Chorus], Verse 1:
        const headerMatch = trimmed.match(/^\[?(Verse\s*\d*|Chorus\s*\d*|Bridge\s*\d*|Intro|Outro)\]?\s*:?$/i);
        if (headerMatch) {
            const secName = headerMatch[1];
            if (/chorus/i.test(secName)) {
                chordProLines.push(`{start_of_chorus: ${secName}}`);
            }
            else {
                chordProLines.push(`{comment: ${secName}}`);
            }
            i++;
            continue;
        }
        // Chord line detection
        if (isChordLine(line)) {
            // Check next line for lyrics
            if (i + 1 < lines.length && !isChordLine(lines[i + 1]) && lines[i + 1].trim().length > 0) {
                const lyricLine = lines[i + 1];
                chordProLines.push(inlineChords(line, lyricLine));
                i += 2;
                continue;
            }
            else {
                // Instrumental chord line
                const tokens = line.trim().split(/\s+/);
                chordProLines.push(tokens.map(t => `[${t}]`).join(' '));
                i++;
                continue;
            }
        }
        // Regular lyric line
        chordProLines.push(line);
        i++;
    }
    return {
        title,
        artist,
        key,
        chordProContent: chordProLines.join('\n'),
        sourceUrl,
        attribution: sourceUrl ? `Imported from ${sourceUrl}` : undefined,
    };
}
function inlineChords(chordLine, lyricLine) {
    const matches = [];
    const regex = /\S+/g;
    let m;
    while ((m = regex.exec(chordLine)) !== null) {
        if (isChordToken(m[0])) {
            matches.push({ chord: m[0], index: m.index });
        }
    }
    if (matches.length === 0)
        return lyricLine;
    let result = '';
    let lyricCursor = 0;
    for (let idx = 0; idx < matches.length; idx++) {
        const item = matches[idx];
        const targetIdx = Math.min(item.index, lyricLine.length);
        if (targetIdx > lyricCursor) {
            result += lyricLine.substring(lyricCursor, targetIdx);
            lyricCursor = targetIdx;
        }
        result += `[${item.chord}]`;
    }
    if (lyricCursor < lyricLine.length) {
        result += lyricLine.substring(lyricCursor);
    }
    return result;
}
//# sourceMappingURL=plain_text.parser.js.map