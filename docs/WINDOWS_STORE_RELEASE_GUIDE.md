# Microsoft Store Release Guide: ChordBand (Windows Desktop)

This guide walks through configuring, packaging into an `.msix` container, and submitting **ChordBand** to the Microsoft Store.

---

## 1. Prerequisites
- A Windows 10/11 development machine (or Windows CI runner via GitHub Actions).
- Microsoft Partner Center Developer Account ($19 one-time for individuals, $99 for companies).
- Flutter SDK configured with Windows desktop support (`flutter config --enable-windows-desktop`).
- Visual Studio 2022 with "Desktop development with C++" workload installed.

---

## 2. Reserve App Name in Partner Center
1. Navigate to [Partner Center Dashboard](https://partner.microsoft.com/dashboard).
2. Go to **Apps & Games** > **New Product** > **MSIX or PWA app**.
3. Reserve your app name (e.g., `ChordBand`).
4. In **Product management** > **Product Identity**, note down the following values:
   - **Package/Identity/Name**: e.g., `12345YourName.ChordBand`
   - **Package/Identity/Publisher**: e.g., `CN=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX`
   - **Package/Properties/PublisherDisplayName**: e.g., `Your Studio Name`

---

## 3. Configure `pubspec.yaml` for Microsoft Store Submission

In `app/pubspec.yaml`, update the `msix_config` section with your exact Partner Center credentials:

```yaml
msix_config:
  display_name: ChordBand
  publisher_display_name: Your Studio Name # Matches Partner Center
  identity_name: 12345YourName.ChordBand   # Matches Partner Center
  publisher: CN=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX # Matches Partner Center
  msix_version: 1.0.0.0
  logo_path: assets/icons/store_logo.png
  capabilities: internetClient
  architecture: x64
  store: true                              # Crucial: enables Microsoft Store submission flag
```

---

## 4. Building the Release MSIX Package

Run the following commands in the `app/` directory:

```bash
cd app
flutter clean
flutter pub get
flutter build windows --release
flutter pub run msix:create
```

The resulting package will be created in:
```
app/build/windows/runner/Release/chordband.msix
```

---

## 5. Microsoft Store Submission Checklist

### A. Packages Section
- [ ] Upload the generated `chordband.msix` package to Partner Center.
- [ ] Verify that package validation completes with zero manifest warnings.

### B. Store Listing Details
- [ ] **Description**: Highlight real-time transposition, ChordPro editing, Stage Mode for low-glare visibility, Telugu Unicode support, and live band Follow-the-Leader sync.
- [ ] **Release Notes**: Initial production release.
- [ ] **Search Terms / Keywords**: `chords`, `lyrics`, `songbook`, `musician`, `transpose`, `band`, `telugu songs`, `stage mode`.
- [ ] **Product Features (Bullets)**:
  - Monospace & proportional chord-over-word rendering
  - Instant transposition with Capo math and Nashville numbers
  - Multi-language lyrics with first-class Telugu conjunct alignment
  - Offline-first storage with Drift SQLite
  - Stage metronome with tap tempo
- [ ] **Privacy Policy URL**: Valid HTTPS URL pointing to your privacy policy.

### C. Visual Assets (Store Logos & Screenshots)
- [ ] **Store Logo**: 300 x 300 PNG (1:1 aspect ratio).
- [ ] **Square Logo**: 150 x 150 PNG.
- [ ] **Wide Logo**: 358 x 173 PNG (optional but recommended for spotlight features).
- [ ] **Desktop Screenshots**: Minimum 1 screenshot (1920 x 1080 recommended, maximum 10).

### D. Age Rating & Pricing
- [ ] Complete the IARC questionnaire (appropriate for all ages).
- [ ] Pricing: Select Free (or your preferred price tier).
- [ ] Publish: Click **Submit to the Store**. Review turnaround typically takes 24 to 48 hours.
