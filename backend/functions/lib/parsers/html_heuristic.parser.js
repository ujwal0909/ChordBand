"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseHtmlHeuristically = parseHtmlHeuristically;
const cheerio = __importStar(require("cheerio"));
const chordpro_parser_1 = require("./chordpro.parser");
const plain_text_parser_1 = require("./plain_text.parser");
function parseHtmlHeuristically(html, sourceUrl) {
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
    let key;
    const keyEl = $('*:contains("Key:"), *:contains("key:")').first();
    if (keyEl.length > 0) {
        const keyMatch = keyEl.text().match(/Key:\s*([A-Ga-g][#b]?m?)/i);
        if (keyMatch)
            key = keyMatch[1];
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
        const res = (0, chordpro_parser_1.parseChordPro)(rawChordSheet, sourceUrl);
        return {
            ...res,
            title: title || res.title,
            artist: artist || res.artist,
            key: key || res.key,
        };
    }
    // Otherwise, use plain text chord-over-lyrics parser
    const res = (0, plain_text_parser_1.parsePlainTextChords)(rawChordSheet, sourceUrl);
    return {
        ...res,
        title: title || res.title,
        artist: artist || res.artist,
        key: key || res.key,
    };
}
//# sourceMappingURL=html_heuristic.parser.js.map