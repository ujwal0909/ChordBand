import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ChordBand Privacy Policy',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Last updated: September 2026',
                style: TextStyle(color: Colors.grey)),
            Divider(height: 24),
            Text(
              '1. Data Collection & Offline-First Storage\n'
              'ChordBand is designed with an offline-first architecture. Your songs, setlists, and personal transpositions are stored locally on your device using an encrypted local SQLite database. We do not sell your personal data.\n\n'
              '2. Collaborative Features & Cloud Sync\n'
              'When you create a Band or share songbooks, your shared song sheets are synced via secure Google Cloud Firestore servers. Data in transit is encrypted using modern TLS.\n\n'
              '3. URL Import & Ethical Scraping\n'
              'All song imports are user-initiated on an individual basis. ChordBand does not perform automated mass scraping. Source attribution is maintained alongside your songs.\n\n'
              '4. Crashlytics & Analytics Opt-Out\n'
              'ChordBand is analytics-free by default. Optional anonymous crash reports help us identify bugs and can be fully disabled in Settings.\n\n'
              '5. Account & Data Deletion (Google Play Compliance)\n'
              'You have the unconditional right to delete your account and all associated cloud data at any time directly through the Settings screen. When you tap "Delete Account", all your cloud records, shared memberships, and personal data are permanently purged from our servers.',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
