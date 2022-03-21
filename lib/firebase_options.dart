// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDwyrjRBIdhu3kKcTo-z6M8GVYjrBgk5EQ',
    appId: '1:277800976688:web:8559fbab1012faa95548f5',
    messagingSenderId: '277800976688',
    projectId: 'agrargo-2571b',
    authDomain: 'agrargo-2571b.firebaseapp.com',
    databaseURL: 'https://agrargo-2571b-default-rtdb.firebaseio.com',
    storageBucket: 'agrargo-2571b.appspot.com',
    measurementId: 'G-TMJGDFZQ9M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBPC_U30espYWEXBr7ZIFczm47_gxRgJgw',
    appId: '1:277800976688:android:cafa0389050464f25548f5',
    messagingSenderId: '277800976688',
    projectId: 'agrargo-2571b',
    databaseURL: 'https://agrargo-2571b-default-rtdb.firebaseio.com',
    storageBucket: 'agrargo-2571b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBCrNFqXOEg_Jw1t6iyWKPCCePoLccW0TE',
    appId: '1:277800976688:ios:da2db9d68f438d4b5548f5',
    messagingSenderId: '277800976688',
    projectId: 'agrargo-2571b',
    databaseURL: 'https://agrargo-2571b-default-rtdb.firebaseio.com',
    storageBucket: 'agrargo-2571b.appspot.com',
    iosClientId: '277800976688-81n8c9mpulo66kf31kgjm42qcjos7lmq.apps.googleusercontent.com',
    iosBundleId: 'com.example-agrargo',
  );
}
