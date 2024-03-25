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
        return android;
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
    apiKey: 'AIzaSyD5pXsgC3rF3jfaQU9-WtMKbgbqoWXrpxw',
    appId: '1:286382179918:web:2cd3428773d69f3226a51f',
    messagingSenderId: '286382179918',
    projectId: 'fir-a1538',
    authDomain: 'fir-a1538.firebaseapp.com',
    storageBucket: 'fir-a1538.appspot.com',
    measurementId: 'G-MQN9CLPPQE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzHbujlEOm_RjjwT6kaRuy2Z7xoiDcRbU',
    appId: '1:286382179918:android:aab79ff0c176e9fc26a51f',
    messagingSenderId: '286382179918',
    projectId: 'fir-a1538',
    storageBucket: 'fir-a1538.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-Inw-HGRmmNJ7bPYvrgqq_A6V6xh1_fw',
    appId: '1:286382179918:ios:7372d95b749f07c826a51f',
    messagingSenderId: '286382179918',
    projectId: 'fir-a1538',
    storageBucket: 'fir-a1538.appspot.com',
    iosBundleId: 'com.example.talenthub',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC-Inw-HGRmmNJ7bPYvrgqq_A6V6xh1_fw',
    appId: '1:286382179918:ios:a13eb127045e8e3226a51f',
    messagingSenderId: '286382179918',
    projectId: 'fir-a1538',
    storageBucket: 'fir-a1538.appspot.com',
    iosBundleId: 'com.example.talenthub.RunnerTests',
  );
}
