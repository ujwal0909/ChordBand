# ChordBand 🎸🎵

**ChordBand** is a production-quality cross-platform application for musicians, worship leaders, and bands to follow chords and lyrics during rehearsals and performances, transpose songs dynamically, and collaborate on shared songbooks in real time.

Built with a unified Flutter codebase targeting **Android (Google Play)**, **Windows Desktop (Microsoft Store)**, and **Web**.

> 📖 **Full Application & Functionality Guide**: Read the in-depth documentation on how the app works, every screen, and its technical architecture in [docs/APPLICATION_GUIDE.md](docs/APPLICATION_GUIDE.md).

---

## 🌟 Key Features

1. **Syllable-Accurate Song Viewer**
   - Chords positioned precisely above the syllable/word they belong to.
   - Monospace and proportional text layout options.
   - Pinch-to-zoom & scalable font slider.
   - Smooth auto-scroll with speed multiplier (0.5x to 4.0x) and pause/resume.
   - **High-Contrast Stage Mode**: Pitch-black OLED background with anti-glare neon chord badges.
   - Hardware foot pedal & keyboard navigation (Space, Arrow keys, Page Up/Down, `[` and `]` for transposition).
   - Wakelock integration: keeps screen awake during stage use.
   - Section headers (Verse, Chorus, Bridge, Tag) with collapsible toggles and quick-jump drawer.
   - **External Display Mode**: Extended clean projection for stage monitors and audience displays.

2. **Music Theory, Transposition & Pitch Controls**
   - Transpose up/down by semitones (-11 to +11) or select target key directly.
   - Dynamic diatonic analysis: correct enharmonic spelling per key (e.g. E# in F# major, Cb in Gb major).
   - Capo support: "Play As" shape vs "Sounds As" concert pitch calculation.
   - Nashville Number System (`1 - 4 - 5 - 6m - 5/7`) & Roman Numeral (`I - IV - V - vi - V/7`) modes.
   - Interactive chord diagrams for **Guitar (6 strings)**, **Ukulele (GCEA)**, and **Piano (2-octave keyboard)**.
   - Per-user and per-setlist transposition storage without altering original songs.

3. **Intelligent Song Editor with Auto-Key Detection & Pitch Steppers**
   - **Automatic Key Detection**: Dynamically detects the musical key from chords as you type or paste lyrics.
   - **Transpose Song Chords**: Instant `[-1 ST]` and `[+1 ST]` stepper buttons to shift all chords across the song text by semitones while adjusting key metadata.
   - **Chord Inserter with Pitch Stepper**: Single chord root adjuster with `[-]` and `[+]` root steppers, chord quality chips (`Maj`, `m`, `7`, `m7`, `sus4`, `add9`, `dim`), and one-tap chord insertion at cursor.
   - Plain-text auto-formatter: converts chords above lyrics into standard ChordPro directives.

4. **Multi-Format Document & PDF Importer**
   - **PDF Import**: Decompresses PDF FlateDecode streams and extracts chords and lyrics from PDF text operators (`Tj`, `TJ`, `'`, hex strings).
   - **Word Document (`.docx`) Import**: Direct XML package extraction without requiring desktop office software.
   - Plain-text and ChordPro import (`.pro`, `.chordpro`, `.crd`, `.txt`, `.md`).
   - Ethical URL import: robots.txt compliance checker and single-URL rate limiting.
   - Live editable preview before committing to the local songbook.

5. **Setlists & Repertoire Playlists**
   - Pre-seeded default setlists (*"Sunday Worship Gathering"* and *"Acoustic Band Rehearsal"*) with song orders, tempos, and performance notes.
   - Custom key and capo overrides per setlist item.
   - Drag-to-reorder items with estimated total set duration.

6. **Multi-Language Lyrics with First-Class Telugu Support**
   - Bundled Unicode `Noto Sans Telugu` font (Regular & Bold) with script fallbacks.
   - Extended Grapheme Cluster segmentation (`characters` package) guaranteeing Telugu conjuncts (e.g. `కృ`, `క్ష`, `స్త్రీ`) and vowel diacritics are never split or corrupted during chord alignment.
   - Parallel multi-language lyric tracks (e.g., Telugu script, English translation, Latin transliteration) with instant switching or side-by-side view.
   - Full UI localization in English (`en`) and Telugu (`te`).

7. **Groups, Sharing & Real-Time Live Stage Sync**
   - Band/Group creation with roles: `Owner`, `Admin`, `Editor`, and `Viewer`.
   - QR code and 6-digit invite code sharing.
   - **Follow the Leader** live session protocol: leader broadcasts song, section, key, and scroll position to all band devices in real time.
   - Offline-first local storage (Drift SQLite) + Cloud Firestore synchronization with conflict resolution and version history snapshots.

8. **Stage Metronome & Privacy Compliance**
   - Visual flashing beat indicator (silent, stage-friendly) + Tap Tempo calculator (moving average BPM).
   - Configurable time signatures (4/4, 3/4, 6/8, 2/4).
   - Analytics-free by default; self-service account and cloud data deletion for store compliance.

## 🏗️ Repository Architecture

```
ChordBand/
├── packages/
│   └── chord_engine/               # Pure-Dart engine (zero Flutter dependencies)
│       ├── lib/
│       │   ├── src/models/         # Note, Chord, KeySignature, ChordDiagram, ParsedSong
│       │   ├── src/transposition/  # NoteTransposer, ChordTransposer, NashvilleConverter
│       │   ├── src/diagrams/       # Guitar, Ukulele, Piano diagrams
│       │   └── src/parser/         # GraphemeChordAligner, ChordProParser, PlainTextParser
│       └── test/                   # 38 pure-Dart unit tests (All passing)
├── app/                            # Flutter Application
│   ├── assets/
│   │   ├── fonts/                  # NotoSansTelugu-Regular.ttf, NotoSansTelugu-Bold.ttf
│   │   └── seed_songs/             # 5 English & Telugu demonstration songs
│   ├── lib/
│   │   ├── core/                   # Theme (Light, Dark, Stage), Router, Localization
│   │   ├── data/                   # Drift SQLite Database, Sync Engine, Repositories
│   │   └── presentation/           # Riverpod Providers, Screens, Custom Painters
│   └── test/                       # Widget tests & Metronome logic tests
├── backend/
│   ├── functions/                  # Cloud Functions (TypeScript) for URL Import
│   │   ├── src/parsers/            # Pluggable URL & HTML parsers
│   │   └── src/utils/              # robots.txt compliance checker
│   └── firestore/
│       ├── firestore.rules         # Role-based security rules
│       ├── firestore.indexes.json  # Compound query indexes
│       └── tests/                  # Rules emulator test suite
└── docs/
    ├── ANDROID_RELEASE_GUIDE.md    # Signed AAB build & Google Play Store checklist
    └── WINDOWS_STORE_RELEASE_GUIDE.md # MSIX packaging & Microsoft Store checklist
```

---

## 🚀 Getting Started

### 1. Run Pure-Dart Chord Engine Tests
```bash
cd packages/chord_engine
dart pub get
dart test
```

### 2. Run Flutter App Locally
```bash
cd app
flutter pub get
flutter run
```

### 3. Run Flutter App Tests
```bash
cd app
flutter test
```

### 4. Build Cloud Functions
```bash
cd backend/functions
npm install
npm run build
```

### 5. Run Firebase Emulators
```bash
cd backend
firebase emulators:start
```

---

## 📱 Release & Store Packaging

- **Android (Google Play)**: Follow [docs/ANDROID_RELEASE_GUIDE.md](docs/ANDROID_RELEASE_GUIDE.md) to generate the signed `.aab` bundle and complete the Google Play Data Safety declaration.
- **Windows (Microsoft Store)**: Follow [docs/WINDOWS_STORE_RELEASE_GUIDE.md](docs/WINDOWS_STORE_RELEASE_GUIDE.md) to build the `.msix` package and submit to Microsoft Partner Center.

---

## 📄 License
ChordBand is released under the MIT License.
