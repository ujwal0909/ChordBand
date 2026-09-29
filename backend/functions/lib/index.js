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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.importSongFromUrl = void 0;
const functions = __importStar(require("firebase-functions"));
const axios_1 = __importDefault(require("axios"));
const robots_checker_1 = require("./utils/robots_checker");
const chordpro_parser_1 = require("./parsers/chordpro.parser");
const plain_text_parser_1 = require("./parsers/plain_text.parser");
const html_heuristic_parser_1 = require("./parsers/html_heuristic.parser");
exports.importSongFromUrl = functions.https.onCall(async (data, context) => {
    // Authentication check (optional: allows guest users with rate limit)
    const url = data.url;
    if (!url || typeof url !== 'string' || !url.startsWith('http')) {
        throw new functions.https.HttpsError('invalid-argument', 'A valid HTTP or HTTPS URL must be provided.');
    }
    // 1. Robots.txt Compliance Check
    const isAllowed = await (0, robots_checker_1.isUrlAllowedByRobots)(url);
    if (!isAllowed) {
        throw new functions.https.HttpsError('permission-denied', 'The requested website disallows automated importing via its robots.txt policy.');
    }
    try {
        // 2. Fetch the target URL content
        const response = await axios_1.default.get(url, {
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
                parsedResult = (0, chordpro_parser_1.parseChordPro)(text, url);
            }
            else {
                parsedResult = (0, plain_text_parser_1.parsePlainTextChords)(text, url);
            }
        }
        else {
            // HTML Page
            const html = typeof rawData === 'string' ? rawData : String(rawData);
            parsedResult = (0, html_heuristic_parser_1.parseHtmlHeuristically)(html, url);
        }
        return {
            ...parsedResult,
            legalNotice: 'User-initiated import. Users are responsible for having the right to store and share content. Attribution recorded.',
        };
    }
    catch (error) {
        if (error instanceof functions.https.HttpsError)
            throw error;
        throw new functions.https.HttpsError('internal', `Failed to fetch or parse the song from URL: ${error.message}`);
    }
});
//# sourceMappingURL=index.js.map