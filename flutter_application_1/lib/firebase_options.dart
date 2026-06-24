import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyB5VAgxVkdQT28tfVKxMOlZ7JyZxqCfStk',
    appId: '1:302517051609:web:c858c4a404929f0ead9ec8',
    messagingSenderId: '302517051609',
    projectId: 'horizon-hotels-app',
    authDomain: 'horizon-hotels-app.firebaseapp.com',
    storageBucket: 'horizon-hotels-app.firebasestorage.app',
    measurementId: 'G-GYJWJP685Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAUYp16hmTH36BrNRjApgfhaWodcwu6vEc',
    appId: '1:302517051609:android:3de192d12bfc351fad9ec8',
    messagingSenderId: '302517051609',
    projectId: 'horizon-hotels-app',
    storageBucket: 'horizon-hotels-app.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB5VAgxVkdQT28tfVKxMOlZ7JyZxqCfStk',
    appId: '1:302517051609:web:83538a49ba95eb5aad9ec8',
    messagingSenderId: '302517051609',
    projectId: 'horizon-hotels-app',
    authDomain: 'horizon-hotels-app.firebaseapp.com',
    storageBucket: 'horizon-hotels-app.firebasestorage.app',
    measurementId: 'G-J2KVPQHS4F',
  );
}
