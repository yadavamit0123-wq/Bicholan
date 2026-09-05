// File generated for Bicholan Firebase project.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0aZbyTj6kMeJppL4NnuyfU4n7qWeICJI',
    appId: '1:1029452495675:android:56c239b4b14995c349d51e',
    messagingSenderId: '1029452495675',
    projectId: 'bicholan',
    storageBucket: 'bicholan.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0aZbyTj6kMeJppL4NnuyfU4n7qWeICJI',
    appId: '1:1029452495675:android:56c239b4b14995c349d51e',
    messagingSenderId: '1029452495675',
    projectId: 'bicholan',
    storageBucket: 'bicholan.firebasestorage.app',
    iosBundleId: 'com.pt.bicholan',
  );
}
