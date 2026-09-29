# ChordBand Application & Functionality Guide 🎸📖

Welcome to the comprehensive application guide for **ChordBand**. This guide details how the application works, its features and functions, user workflows, and the technology stack behind it.

---

## 📑 Table of Contents
1. [Overview & Purpose](#-overview--purpose)
2. [What Technologies Are Used (Tech Stack)](#-what-technologies-are-used-tech-stack)
3. [Architecture Overview](#-architecture-overview)
4. [Core Functions & Screens](#-core-functions--screens)
   - [1. Songbook & Home Feed](#1-songbook--home-feed)
   - [2. Interactive Song Viewer](#2-interactive-song-viewer)
   - [3. Song Editor with Key Detection & Pitch Steppers](#3-song-editor-with-key-detection--pitch-steppers)
   - [4. PDF, Word, & Document Importer](#4-pdf-word--document-importer)
   - [5. Setlists & Performance Playlists](#5-setlists--performance-playlists)
   - [6. Band Collaboration & Follow-the-Leader Live Stage](#6-band-collaboration--follow-the-leader-live-stage)
   - [7. Stage Mode & External Display Projection](#7-stage-mode--external-display-projection)
   - [8. Metronome & Tap Tempo](#8-metronome--tap-tempo)
5. [Music Theory Engine (chord_engine)](#-music-theory-engine-chord_engine)
6. [Multi-Language & Telugu Script Alignment](#-multi-language--telugu-script-alignment)
7. [Offline-First Local Storage & Cloud Sync](#-offline-first-local-storage--cloud-sync)

---

## 🎯 Overview & Purpose

**ChordBand** is an offline-first, real-time collaborative songbook and chord chart platform designed for solo musicians, church worship teams, and live performance bands. It allows musicians to:
* View chords aligned precisely above lyrics without monospace distortion.
* Transpose songs dynamically into any key, with support for Nashville Numbers, Roman Numerals, and Capo calculation.
* Import chord charts from PDF documents, Word `.docx` files, text files, or web pages.
* Organize setlists for rehearsals and live gigs.
* Synchronize song selection and live scrolling between band members in real time (*Follow the Leader* mode).
* Project lyrics and chords cleanly to external audience displays and stage monitors.

---

## 🛠️ What Technologies Are Used (Tech Stack)

ChordBand is engineered with a modern, high-performance tech stack:

### Frontend (Application)
* **Framework**: [Flutter](https://flutter.dev) (latest stable Dart 3)
  * Single codebase deployed to Android (Google Play), Windows Desktop (Microsoft Store), and Web.
* **State Management**: [Flutter Riverpod](https://riverpod.dev) (`2.6.1`)
  * Declarative, testable, and reactive state management across all providers, controllers, and streams.
* **Navigation & Routing**: [GoRouter](https://pub.dev/packages/go_router) (`14.8.1`)
  * Declarative URI-based routing with deep-link support and sub-routes.
* **Local Database**: [Drift](https://drift.simonbinder.eu/) (formerly Moor) with SQLite (`2.19.1`)
  * Fast, reactive local persistence providing full offline functionality.
* **Binary Document Extraction**: [Archive](https://pub.dev/packages/archive) (`4.3.0`)
  * Pure-Dart decompressor for extracting PDF `FlateDecode` zlib streams and Word `.docx` ZIP packages.
* **Unicode & Text Processing**: [characters](https://pub.dev/packages/characters)
  * Extended Grapheme Cluster analysis to align chords over complex Indian scripts (Telugu) without breaking conjuncts.
* **Screen Keep-Awake**: [wakelock_plus](https://pub.dev/packages/wakelock_plus) (`1.5.2`)
  * Prevents screen dimming or sleep while performing on stage.

### Pure-Dart Music Theory Engine (`packages/chord_engine`)
* Zero external dependencies.
* Parses ChordPro and plain-text chord sheets.
* Calculates diatonic scale degrees, enharmonics (e.g., E# vs F in F# major), transpositions, and Capo shapes.
* Generates chord fingering diagrams for **Guitar (6-string)**, **Ukulele (GCEA)**, and **Piano (2-octave keys)**.

### Backend & Cloud Infrastructure
* **Firebase Authentication**: Email/Password and Google Sign-In with offline cached credentials.
* **Cloud Firestore**: Real-time NoSQL cloud database for band songbooks, live stage sessions, and setlist sync.
* **Firebase Cloud Functions** (TypeScript / Node.js 20):
  * Headless URL parser with strict `robots.txt` compliance to import public chord sheets ethically.

---

## 🏛️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                 ChordBand Flutter Application               │
│  (Android • Windows Desktop • Web Browser)                 │
└──────────────┬───────────────────────────────┬──────────────┘
               │                               │
        Reactive Streams               Music Calculations
               ▼                               ▼
┌──────────────────────────────┐ ┌────────────────────────────┐
│      Drift Local SQLite      │ │  packages/chord_engine     │
│   (Offline First Storage)    │ │  • Transposer & Capo       │
│  • Songs & Lyric Versions    │ │  • Nashville & Roman       │
│  • Setlists & Setlist Items  │ │  • Chord Diagram Painter   │
│  • Band Groups & Audit Logs  │ │  • Telugu Grapheme Cluster │
└──────────────┬───────────────┘ └────────────────────────────┘
               │
      Cloud Synchronization
               ▼
┌──────────────────────────────┐ ┌────────────────────────────┐
│       Cloud Firestore        │ │  Firebase Cloud Functions  │
│  • Real-Time Group Sync      │ │  • Ethical URL Importer    │
│  • Live Follow-the-Leader    │ │  • robots.txt Checker      │
│  • Firestore Security Rules  │ └────────────────────────────┘
└──────────────────────────────┘
```

---

## 📱 Core Functions & Screens

### 1. Songbook & Home Feed
* **Search Header**: Live instant search across song titles, artists, lyrics, and ChordPro directives.
* **Unified Band Collaboration**: Access Live Stage Broadcasts and Band Groups with shareable invite codes and QR codes.
* **Setlists Shortcut**: Jump to performance setlists and repertoire orders.
* **Stage Mode Toggle**: Instant switch to high-contrast pitch-black theme with anti-glare neon chords.
* **Settings & Song Management**: Delete, edit, or project songs directly from the list.

### 2. Interactive Song Viewer
* **Syllable-Accurate Alignment**: Chords sit directly on top of the exact syllable they should be struck on.
* **Dynamic Transposition Bar**:
  * Tap `[-]` or `[+]` semitones to shift the pitch dynamically.
  * Tap **Key** to jump to any of the 24 major or minor keys.
  * Target key uses musically correct diatonic spelling.
* **Notation Formats**:
  * Standard Letter Chords (`C`, `G`, `Am`, `F`).
  * Nashville Number System (`1`, `4`, `5`, `6m`).
  * Roman Numeral System (`I`, `IV`, `V`, `vi`).
* **Capo Calculation**: Computes "Play As" shape vs "Sounds As" concert pitch.
* **Instrument Chord Diagrams**:
  * Guitar (barre & open chord frets), Ukulele, and Piano interactive keyboard visualizer.
* **Auto-Scroll Engine**:
  * Adjustable scroll speed multiplier (0.5x to 4.0x) with Play / Pause.
* **Section Quick Jump**: Drawer to jump directly to Verse 1, Chorus, Bridge, or Outro.
* **Parallel Lyric Tracks**: Seamless toggle between Telugu script and Latin transliteration.

### 3. Song Editor with Key Detection & Pitch Steppers
* **Automatic Key Detection**:
  * As you type or paste lyrics with chords, the built-in diatonic analyzer analyzes opening, cadential, and scale-degree chords to automatically detect the musical key (e.g. `Detected: G • Apply`).
* **Transpose All Chords in Song**:
  * `[-1 ST]` and `[+1 ST]` stepper buttons automatically transpose all `[Chord]` tags throughout the song text up or down by semitones, while adjusting the key metadata simultaneously.
* **Chord Pitch Stepper & Inserter**:
  * Replaces cluttered chord buttons with a single pitch adjuster:
    * `[-]` steps root down (`C` $\rightarrow$ `B` $\rightarrow$ `Bb` $\rightarrow$ `A`...).
    * `[+]` steps root up (`C` $\rightarrow$ `C#` $\rightarrow$ `D` $\rightarrow$ `Eb`...).
    * Chord quality selector: `Maj`, `Minor (m)`, `7`, `m7`, `sus4`, `add9`, `dim`.
    * One-tap `Insert [Chord] at Cursor` button.
* **Section Markers**: One-tap insertion for `{start_of_verse}`, `{start_of_chorus}`, `{start_of_bridge}`, and `{start_of_outro}`.
* **Plain-Text Auto-Formatter**: Automatically converts chords placed on lines above lyrics into standard ChordPro notation.

### 4. PDF, Word, & Document Importer
* **PDF FlateDecode Extraction**:
  * Extracts text from binary PDFs by decompressing internal zlib streams and decoding PDF text drawing operators (`Tj`, `TJ`, `'`, hex strings).
* **Word Document (`.docx`) Extraction**:
  * Unpacks Word XML packages and extracts clean text without needing external office software.
* **Text / ChordPro Files**: Supports `.pro`, `.chordpro`, `.crd`, `.txt`, and `.md`.
* **Automatic Title & Key Extraction**: Uses document filename for song naming and auto-detects the musical key from imported chords.
* **Live Editable Preview**: Inspect and tweak the extracted lyrics and chords before saving to the local database.

### 5. Setlists & Performance Playlists
* **Pre-Seeded Playlists**: Automatically comes pre-populated with demonstration playlists (*"Sunday Worship Gathering"* and *"Acoustic Band Rehearsal"*) showing songs, tempos, and performance notes.
* **Order & Key Overrides**: Custom key overrides per setlist item without modifying the master songbook.
* **Performance Notes**: Add specific performance cues (e.g., "Acoustic guitar intro", "12-string guitar with Capo 7").
* **Estimated Set Duration**: Automatic calculation of total performance duration.

### 6. Band Collaboration & Follow-the-Leader Live Stage
* **Role-Based Sharing**: Band owners can invite musicians as *Admins*, *Editors*, or *Viewers* via 6-digit invite codes and QR codes.
* **Follow-the-Leader Session**:
  * Leader broadcasts active song ID, section, scroll position, and key override.
  * Band members' devices automatically follow the leader's screen during live performance.
* **Offline-First Resilience**: If internet drops mid-performance, musicians continue playing from local SQLite storage without interruption.

### 7. Stage Mode & External Display Projection
* **Stage Mode**: Pitch-black OLED theme (`#000000`) with high-contrast amber/cyan chords designed to reduce eye strain and eliminate glare under stage lights.
* **External Display Mode**:
  * When connected to an external HDMI monitor or stage projector, ChordBand provides an extended clean view showing only chords and lyrics with large fonts, hiding all edit bars and menus.

### 8. Metronome & Tap Tempo
* **Visual Flashing Beat Indicator**: Silent stage-safe flashing indicator so musicians can lock tempo without audio bleed into microphones.
* **Tap Tempo Engine**: Tap the beat button to calculate real-time BPM using a moving-average interval algorithm.
* **Time Signatures**: Supports 4/4, 3/4, 6/8, and 2/4 time signatures.

---

## 🎶 Music Theory Engine (`chord_engine`)

The app includes an independent pure-Dart package located in `packages/chord_engine`:

1. **Diatonic Spelling Engine**:
   * Evaluates key signatures so notes are named correctly according to music theory rules (e.g. F# Major uses `E#` instead of `F`, and Gb Major uses `Cb` instead of `B`).
2. **Capo Sounds-As Calculator**:
   * Given sounding chord `B` with Capo 2 $\rightarrow$ calculates played shape `A`.
   * Given played shape `G` with Capo 3 $\rightarrow$ calculates sounding pitch `Bb`.
3. **Nashville Number & Roman Numeral Engine**:
   * Converts chromatic chords relative to tonic (e.g., in Key of C: `C` $\rightarrow$ `1` / `I`, `Am` $\rightarrow$ `6m` / `vi`, `F/A` $\rightarrow$ `4/6` / `IV/vi`).

---

## 🌐 Multi-Language & Telugu Script Alignment

* **The Problem**: In Indic scripts like Telugu, characters combine base consonants with viramas and vowel signs into complex conjuncts (e.g. `కృ`, `క్ష`, `స్త్రీ`). Naive string index operations split these clusters, resulting in corrupted text.
* **The Solution**: ChordBand's `GraphemeChordAligner` parses text using Unicode Extended Grapheme Clusters (`characters` package). Chords attach to full grapheme units, guaranteeing that chords never split vowels or matras.
* **Parallel Tracks**: Telugu worship songs include parallel tracks for original script and Latin transliteration (e.g. *కృప చూపిన దేవా* $\leftrightarrow$ *Krupa Choopina Deva*).

---

## 💾 Offline-First Local Storage & Cloud Sync

* **Local Database**: All songs, setlists, and settings are stored locally in SQLite using Drift. The app works 100% offline.
* **Sync Engine**: When an internet connection is detected, pending local changes (`pending_upload`) sync to Cloud Firestore.
* **Conflict Resolution**: Uses immutable version snapshots and timestamped audit logs.
