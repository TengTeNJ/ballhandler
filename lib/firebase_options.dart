// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDyqPG_JbmS7TaEtDAmitgfsVImxzqNRaQ',
    appId: '1:940248126378:android:b35d853f703f61b10291d3',
    messagingSenderId: '940248126378',
    projectId: 'potent-hockey',
    storageBucket: 'potent-hockey.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD59tyeZi3ufBqFdMQ18BYadY24eSOSdD0',
    appId: '1:940248126378:ios:69bd04177de840060291d3',
    messagingSenderId: '940248126378',
    projectId: 'potent-hockey',
    storageBucket: 'potent-hockey.appspot.com',
    androidClientId: '940248126378-0qgcr7uodv3k55hg39o2br2tn3afn2hk.apps.googleusercontent.com',
    iosClientId: '940248126378-21i2rjscftt3ph9qne0p2dvbhpt72ov6.apps.googleusercontent.com',
    iosBundleId: 'com.potent.dangleios',
  );

}