# Google Play Store Release Guide: ChordBand (Android)

This guide provides step-by-step instructions for signing, building, and submitting the **ChordBand** Android App Bundle (`.aab`) to the Google Play Console.

---

## 1. Prerequisites
- Android Studio or JDK 17 installed.
- Flutter SDK (latest stable) in your `PATH`.
- A Google Play Developer account ($25 one-time registration fee).

---

## 2. Keystore Generation

If you don't already have an upload keystore, generate one using `keytool`:

```bash
keytool -genkey -v -keystore chordband-upload-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias chordband
```

> [!CAUTION]
> Back up your `chordband-upload-key.jks` in a secure password manager. If you lose this key, you cannot update your app on Google Play without contacting Google Play Developer Support.

---

## 3. Configuring `key.properties`

Create a file named `android/key.properties` (this file is ignored by Git):

```properties
storePassword=YOUR_SECURE_STORE_PASSWORD
keyPassword=YOUR_SECURE_KEY_PASSWORD
keyAlias=chordband
storeFile=/absolute/path/to/chordband-upload-key.jks
```

Verify that `android/app/build.gradle.kts` references `key.properties` for the release build type:
```kotlin
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = java.util.Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(java.io.FileInputStream(keystorePropertiesFile))
}
```

---

## 4. Building the Signed Android App Bundle

Run the following command in the `app/` directory:

```bash
cd app
flutter clean
flutter pub get
flutter build appbundle --release
```

The resulting signed bundle will be generated at:
```
app/build/app/outputs/bundle/release/app-release.aab
```

---

## 5. Google Play Console Submission Checklist

### A. Store Listing & Metadata
- [ ] **App Name**: ChordBand - Chords & Songbook
- [ ] **Short Description** (80 chars): Real-time chords, transposition, stage mode & collaborative band songbooks.
- [ ] **Full Description**: Detail features including syllable-accurate chord alignment, Telugu Unicode support, offline-first SQLite storage, live Follow-the-Leader sync, and stage metronome.
- [ ] **Hi-res App Icon**: 512 x 512 PNG, 32-bit color, max 1024KB.
- [ ] **Feature Graphic**: 1024 x 500 PNG/JPEG.
- [ ] **Screenshots**:
  - Minimum 4 phone screenshots (1080 x 1920 or 1080 x 2400).
  - Minimum 1 7-inch tablet screenshot.
  - Minimum 1 10-inch tablet screenshot.

### B. Privacy Policy & Data Safety (Mandatory)
- [ ] **Privacy Policy URL**: Host `privacy_policy_screen.dart` content on a public HTTPS URL (e.g. GitHub Pages or Firebase Hosting).
- [ ] **Data Safety Questionnaire**:
  - *Data collected*: No personal data sold. Crash logs (Crashlytics) collected anonymously for diagnostics with in-app opt-out.
  - *Data encrypted in transit*: Yes (TLS 1.3).
  - *Data deletion request*: Yes, users can unconditionally delete their account and cloud data directly inside Settings (`/settings`).

### C. Target API & Content Rating
- [ ] **Target API Level**: Android 14 / 15 (API 34+).
- [ ] **Content Rating**: Complete IARC questionnaire (rated PEGI 3 / Everyone).
- [ ] **App Integrity**: Opt-in to Google Play App Signing.
