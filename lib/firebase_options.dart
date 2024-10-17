import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBTSdyx0QvysbGw8_4T6NZnoB3bUfCAy-w',
    appId: '1:201347336283:web:ddb4659977687ac2ad177e',
    messagingSenderId: '201347336283',
    projectId: 'mdev-x',
    authDomain: 'mdev-x.firebaseapp.com',
    databaseURL: 'https://mdev-x-default-rtdb.firebaseio.com',
    storageBucket: 'mdev-x.appspot.com',
    measurementId: 'G-QW2Y0R1DYT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAauRNhB3psCQmCvO5JZSUmz0ijPtKPf44',
    appId: '1:201347336283:android:e249ada463d6d0bbad177e',
    messagingSenderId: '201347336283',
    projectId: 'mdev-x',
    databaseURL: 'https://mdev-x-default-rtdb.firebaseio.com',
    storageBucket: 'mdev-x.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBCqBxThTv0XkIIBTab_WstYVWlo-VGtjs',
    appId: '1:201347336283:ios:a91e6e34a10465c4ad177e',
    messagingSenderId: '201347336283',
    projectId: 'mdev-x',
    databaseURL: 'https://mdev-x-default-rtdb.firebaseio.com',
    storageBucket: 'mdev-x.appspot.com',
    iosClientId: '201347336283-6lu2qd8l8ftdgitf90a4gig7jiqv0g4s.apps.googleusercontent.com',
    iosBundleId: 'com.mdev.saver',
  );
}
