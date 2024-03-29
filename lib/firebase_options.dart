// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyCHUHRmiy99WCyppRhfIhNf-ubscCsjXEI',
    appId: '1:120079819487:web:5fee7ccfe30b728587ff6a',
    messagingSenderId: '120079819487',
    projectId: 'yellow-chair',
    authDomain: 'yellow-chair.firebaseapp.com',
    storageBucket: 'yellow-chair.appspot.com',
    measurementId: 'G-N29ZV56CT3',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_5yASGEb5kyjfeX1RTDiV8crrYcsyvoU',
    appId: '1:120079819487:ios:717c4e0f079932d487ff6a',
    messagingSenderId: '120079819487',
    projectId: 'yellow-chair',
    storageBucket: 'yellow-chair.appspot.com',
    iosClientId: '120079819487-0f7cr9f6u29c64e8374ujgieo3f2a0og.apps.googleusercontent.com',
    iosBundleId: 'com.yellowChair.buyInPayOut',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA_5yASGEb5kyjfeX1RTDiV8crrYcsyvoU',
    appId: '1:120079819487:ios:717c4e0f079932d487ff6a',
    messagingSenderId: '120079819487',
    projectId: 'yellow-chair',
    storageBucket: 'yellow-chair.appspot.com',
    iosClientId: '120079819487-0f7cr9f6u29c64e8374ujgieo3f2a0og.apps.googleusercontent.com',
    iosBundleId: 'com.yellowChair.buyInPayOut',
  );
}
