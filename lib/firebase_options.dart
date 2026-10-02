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
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB-7k0NgJaJlPo-eOES3MyL4T-6fN4i62A',
    appId: '1:235951078021:web:9bcf1e9d4e67de27acc7ec',
    messagingSenderId: '235951078021',
    projectId: 'skillconnect-a7c70',
    authDomain: 'skillconnect-a7c70.firebaseapp.com',
    storageBucket: 'skillconnect-a7c70.firebasestorage.app',
    measurementId: 'G-TG0BB8FQ3F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCqom8DPYhKH0bANtqV67r6Xgn0EnlojAk',
    appId: '1:235951078021:android:3359da782f01df70acc7ec',
    messagingSenderId: '235951078021',
    projectId: 'skillconnect-a7c70',
    storageBucket: 'skillconnect-a7c70.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDYe_jG4-GQh31iBIMJPhXbUfmBg9P3JLI',
    appId: '1:235951078021:ios:e598e40a633d638aacc7ec',
    messagingSenderId: '235951078021',
    projectId: 'skillconnect-a7c70',
    storageBucket: 'skillconnect-a7c70.firebasestorage.app',
    iosClientId: '235951078021-oakrt769hu8re99ig2jlgakg1l67bm16.apps.googleusercontent.com',
    iosBundleId: 'com.skillconnect.app',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDYe_jG4-GQh31iBIMJPhXbUfmBg9P3JLI',
    appId: '1:235951078021:ios:e598e40a633d638aacc7ec',
    messagingSenderId: '235951078021',
    projectId: 'skillconnect-a7c70',
    storageBucket: 'skillconnect-a7c70.firebasestorage.app',
    iosClientId: '235951078021-oakrt769hu8re99ig2jlgakg1l67bm16.apps.googleusercontent.com',
    iosBundleId: 'com.skillconnect.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB-7k0NgJaJlPo-eOES3MyL4T-6fN4i62A',
    appId: '1:235951078021:web:1537e2ff39543301acc7ec',
    messagingSenderId: '235951078021',
    projectId: 'skillconnect-a7c70',
    authDomain: 'skillconnect-a7c70.firebaseapp.com',
    storageBucket: 'skillconnect-a7c70.firebasestorage.app',
    measurementId: 'G-LK5P4RTNR7',
  );
}
