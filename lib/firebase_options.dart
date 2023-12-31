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
    apiKey: 'AIzaSyAJgPf4ojJnKrNuoJN-bHl0alCX0wX726g',
    appId: '1:499146835326:web:f631e115057c7ce5efdf2f',
    messagingSenderId: '499146835326',
    projectId: 'brandquickquiz',
    authDomain: 'brandquickquiz.firebaseapp.com',
    storageBucket: 'brandquickquiz.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC907RMOF9njwQK5b3XiymlfWf5nGBAZg0',
    appId: '1:499146835326:android:60ac67a6d2b9363defdf2f',
    messagingSenderId: '499146835326',
    projectId: 'brandquickquiz',
    storageBucket: 'brandquickquiz.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAfFaMpDq7uBK4Bn_bn9hPqIg-in25WgoE',
    appId: '1:499146835326:ios:f9b7fab3caccd395efdf2f',
    messagingSenderId: '499146835326',
    projectId: 'brandquickquiz',
    storageBucket: 'brandquickquiz.appspot.com',
    iosBundleId: 'com.example.brandQuickQuiz',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAfFaMpDq7uBK4Bn_bn9hPqIg-in25WgoE',
    appId: '1:499146835326:ios:3753db9122f3df69efdf2f',
    messagingSenderId: '499146835326',
    projectId: 'brandquickquiz',
    storageBucket: 'brandquickquiz.appspot.com',
    iosBundleId: 'com.example.brandQuickQuiz.RunnerTests',
  );
}
