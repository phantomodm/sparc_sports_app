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
    apiKey: 'AIzaSyBNKObDLh52ZVNptuxEINojmgdC6zaO27s',
    appId: '1:901475463526:web:c378534b3ec8e42e2358a7',
    messagingSenderId: '901475463526',
    projectId: 'committ',
    authDomain: 'committ.firebaseapp.com',
    storageBucket: 'committ.appspot.com',
    measurementId: 'G-0YG35CNCLR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB7lI8xDHrQqhI_ia_yOgcjCBTBkx1Oto0',
    appId: '1:901475463526:android:c1b8932c529ff8302358a7',
    messagingSenderId: '901475463526',
    projectId: 'committ',
    storageBucket: 'committ.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6xGceEoODomMOqQirm6rAnZ-1INSSduc',
    appId: '1:901475463526:ios:927dbb9241629a282358a7',
    messagingSenderId: '901475463526',
    projectId: 'committ',
    storageBucket: 'committ.appspot.com',
    iosClientId:
    '901475463526-1flsqev8ug3fhnvabqgabrbgilcro1cc.apps.googleusercontent.com',
    iosBundleId: 'com.example.sparcCommunityApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB6xGceEoODomMOqQirm6rAnZ-1INSSduc',
    appId: '1:901475463526:ios:927dbb9241629a282358a7',
    messagingSenderId: '901475463526',
    projectId: 'committ',
    storageBucket: 'committ.appspot.com',
    iosClientId:
    '901475463526-1flsqev8ug3fhnvabqgabrbgilcro1cc.apps.googleusercontent.com',
    iosBundleId: 'com.example.sparcCommunityApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCM2Mq-zjz sparc_community_app37uZQv2AKcwLuWqCtcNyI',
    appId: '1:901475463526:web:83a2993dcdacb8bc2358a7',
    messagingSenderId: '901475463526',
    projectId: 'committ',
    authDomain: 'committ.firebaseapp.com',
    storageBucket: 'committ.appspot.com',
    measurementId: 'G-4GM4JZTNN3',
  );
}