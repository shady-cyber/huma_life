import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huma_life/Common/screens/Splash/Splash_Screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:huma_life/Common/screens/notification/SVNotificationFragment.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const SplashScreen(),
      //   '/second': (context) => const SVNotificationFragment(),
      // },
      home: SplashScreen(),
    );
  }
}
