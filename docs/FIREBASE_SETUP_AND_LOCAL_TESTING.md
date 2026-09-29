# ChordBand: Complete Firebase Setup & Local Testing Guide

This guide details everything you need to **run and test the ChordBand application** locally, complete the **Firebase Cloud setup**, and prepare for Google Play and Microsoft Store submissions.

---

## 1. Running & Testing the Application Locally

ChordBand is built with a cross-platform architecture that supports **Android**, **Windows Desktop**, and **Web / Chrome**.

### Live Local Web Testing
The web build has been compiled and is currently being served locally:
- **Local URL**: [http://localhost:8085](http://localhost:8085)
- To open it in Google Chrome at any time:
  ```bash
  open -a "Google Chrome" http://localhost:8085
  ```

### What to Test in the Running App:
1. **Song Library & Seed Songs**:
   - Verify the pre-seeded songs are displayed: *Amazing Grace*, *Hotel California*, *Aanandhame Aanandhamu*, *Krupa Choopina Deva*, *Sthuthi Paadeda Ninne*.
   - Filter by language chip (English / తెలుగు) or search by title.
2. **Song Viewer & Dynamic Transposition**:
   - Click any song to open the sheet music viewer.
   - Use the `+` / `-` buttons to transpose keys on the fly.
   - Toggle **Nashville Number System** (1, 4, 5, 6m) or **Roman Numerals** (I, IV, V, vi).
   - Test **Capo** adjustment and see how fret calculation dynamically updates chords.
3. **Telugu Unicode Grapheme Alignment**:
   - Open *Krupa Choopina Deva* or *Aanandhame Aanandhamu*.
   - Confirm chords align strictly above syllable boundaries without splitting conjuncts (`కృ`, `స్త్రీ`).
4. **OLED Stage Mode**:
   - Tap the palette/brightness icon in the top bar to toggle between **Light**, **Dark**, and **Stage Mode** (pure `#000000` pitch black with neon mint `#00FFA3` chord badges).
5. **Interactive Chord Diagrams**:
   - Tap any chord badge to view the interactive diagram modal for **Guitar**, **Ukulele**, or **Piano** (with active keys highlighted).
6. **Auto-Scroll Engine**:
   - Tap the Play button on the floating bottom pill. Adjust scroll speed with `+` / `-`.
7. **Visual Stage Metronome**:
   - Open the Metronome tab from the bottom navigation or app drawer.
   - Test the visual beat flasher and use **Tap Tempo** to calculate ballad or uptempo BPM.

---

## 2. Complete Firebase Setup Walkthrough

ChordBand uses Firebase for **Authentication** (Anonymous guest mode + Email sign-in), **Cloud Firestore** (real-time band collaboration, live session broadcasting, and immutable audit logs), and **Cloud Functions** (ethical URL import).

### Step 2.1: Create Your Firebase Project
1. Visit the [Firebase Console](https://console.firebase.google.com/).
2. Click **Add Project** and name it (e.g., `chordband-production` or `chordband-app`).
3. (Optional) Disable Google Analytics (to keep ChordBand 100% analytics-free per privacy design) and click **Create Project**.

### Step 2.2: Enable Authentication
1. In your Firebase Console, navigate to **Build > Authentication**.
2. Click **Get Started**.
3. Under **Sign-in method**, enable:
   - **Anonymous**: Allows musicians to use the app immediately without forced registration.
   - **Email/Password**: For band leaders and collaborators managing cloud songbooks.

### Step 2.3: Create Cloud Firestore Database
1. In your Firebase Console, navigate to **Build > Firestore Database**.
2. Click **Create Database**.
3. Choose a server location closest to your band/users (e.g. `asia-south1` or `us-central1`).
4. Select **Start in production mode** and click **Create**.

### Step 2.4: Deploy Security Rules & Cloud Functions
Using the pre-installed Firebase CLI at `~/bin/firebase`:

1. **Log in to Firebase CLI**:
   ```bash
   ~/bin/firebase login
   ```
2. **Link Your Project**:
   ```bash
   cd /Users/ujwal/Desktop/ChordBand/backend
   ~/bin/firebase use --add
   ```
   *(Select your created Firebase project from the list and enter alias `default`)*.

3. **Deploy Firestore Rules & Cloud Functions**:
   ```bash
   ~/bin/firebase deploy --only firestore,functions
   ```
   This will deploy:
   - `firestore.rules`: Role-based access control (Owner, Admin, Editor, Viewer), self-service user deletion, and append-only audit logs.
   - `firestore.indexes.json`: Composite query indexes for songs and setlists.
   - `functions/lib/index.js`: The ethical single-URL import endpoint with robots.txt check.

---

## 3. Connecting Firebase to the Flutter App

All Flutter code is already wired to use Firebase with graceful offline fallback. To bind your specific live project credentials:

### Method A: Using FlutterFire CLI (Automated)
```bash
cd /Users/ujwal/Desktop/ChordBand/app
dart pub global activate flutterfire_cli
flutterfire configure --project=<YOUR_FIREBASE_PROJECT_ID>
```
This automatically updates `lib/firebase_options.dart` and downloads the official `google-services.json` for Android!

### Method B: Manual Configuration
1. **Android**:
   - In Firebase Console, go to **Project Settings > General > Your Apps > Add Android app**.
   - Package Name: `com.chordband.app.chordband`
   - Download `google-services.json` and place it in:
     `/Users/ujwal/Desktop/ChordBand/app/android/app/google-services.json`
2. **Web / Windows**:
   - Update `app/lib/firebase_options.dart` with your Web App `apiKey`, `appId`, and `projectId` from Firebase Console.

---

## 4. Pre-Store Submission Checklist

Before submitting to **Google Play** or **Microsoft Store**:

| Requirement | Status | Reference File |
|---|---|---|
| **Android Signed App Bundle (AAB)** | Ready for Keystore | [ANDROID_RELEASE_GUIDE.md](file:///Users/ujwal/Desktop/ChordBand/docs/ANDROID_RELEASE_GUIDE.md) |
| **Android ProGuard Rules** | Configured | `app/android/app/proguard-rules.pro` |
| **Windows MSIX Packaging** | Configured | [WINDOWS_STORE_RELEASE_GUIDE.md](file:///Users/ujwal/Desktop/ChordBand/docs/WINDOWS_STORE_RELEASE_GUIDE.md) |
| **Account Deletion (Play Store)** | Implemented | `FirebaseAuthService.deleteAccount()` in `firebase_auth_service.dart` |
| **Privacy Policy Screen** | Built-in | `app/lib/presentation/screens/settings/privacy_policy_screen.dart` |
| **Telugu Unicode Quality** | 100% Tested | `telugu_alignment_test.dart` (38/38 tests passed) |
| **Offline-First Drift DB** | Active | Multi-platform Drift SQLite with auto-seeding |
