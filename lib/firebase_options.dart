import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
   // apiKey: 'AIzaSyAcodatEcQRpJW5aZu-_1kerHMXYAypZYM',
    apiKey: 'AIzaSyCdiG3Supm5BDfiv5D5nseDsFO8fvimaDI',
    //appId: '1:91613695560:android:075e0e7da1c9803b93d27d',
    appId: '1:631261611757:android:ef98f44ebd7bdfbcedeee4',
    //messagingSenderId: '91613695560',
    messagingSenderId: '631261611757',
  // projectId: 'huma_life-ceb23',
    projectId: 'huma_life-99c20',
    //storageBucket: 'huma_life-ceb23.appspot.com',
    storageBucket: 'huma_life-99c20.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    //apiKey: 'AIzaSyDT4ryFn-ZyBBkBXKPAgFU4-NWaqiI4gkQ',
    apiKey: 'AIzaSyDIHIN2kC3ZaKLttzU01lhmgOZe4Df6YDU',
    //appId: '1:91613695560:ios:a5fb6ef664220c6d93d27d',
    appId: '1:631261611757:ios:f6346d829bad5724edeee4',
    //messagingSenderId: '91613695560',
    messagingSenderId: '631261611757',
   // projectId: 'huma_life-ceb23',
    projectId: 'huma_life-99c20',
    //storageBucket: 'huma_life-ceb23.appspot.com',
    storageBucket: 'huma_life-99c20.appspot.com',
  //  iosClientId: '91613695560-q5dkhhcptnmr0il1v40s6fjf31vbtgc9.apps.googleusercontent.com',
    iosClientId: '631261611757-o2ujgl4pr8c0lrim40am45lnedvi6qe5.apps.googleusercontent.com',
    iosBundleId: 'com.hr.huma_life',
  );

}
