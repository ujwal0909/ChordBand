// File generated and maintained for ChordBand.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDemoChordBandWebKey1234567890abcdef',
    appId: '1:103948572019:web:chordband0101web',
    messagingSenderId: '103948572019',
    projectId: 'chordband-app',
    authDomain: 'chordband-app.firebaseapp.com',
    storageBucket: 'chordband-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDemoChordBandAndroidKey1234567890abc',
    appId: '1:103948572019:android:chordband0101and',
    messagingSenderId: '103948572019',
    projectId: 'chordband-app',
    storageBucket: 'chordband-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDemoChordBandIosKey1234567890abcdef',
    appId: '1:103948572019:ios:chordband0101ios',
    messagingSenderId: '103948572019',
    projectId: 'chordband-app',
    storageBucket: 'chordband-app.appspot.com',
    iosBundleId: 'com.chordband.app.chordband',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDemoChordBandMacKey1234567890abcdef',
    appId: '1:103948572019:ios:chordband0101ios',
    messagingSenderId: '103948572019',
    projectId: 'chordband-app',
    storageBucket: 'chordband-app.appspot.com',
    iosBundleId: 'com.chordband.app.chordband',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDemoChordBandWinKey1234567890abcdef',
    appId: '1:103948572019:web:chordband0101win',
    messagingSenderId: '103948572019',
    projectId: 'chordband-app',
    authDomain: 'chordband-app.firebaseapp.com',
    storageBucket: 'chordband-app.appspot.com',
  );
}
