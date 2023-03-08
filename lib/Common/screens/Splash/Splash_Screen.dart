import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Admin/screens/Home/HomeScreenAdmin.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Common/screens/Authentication/Select_Type.dart';
import 'package:huma_life/Data/provider/connection_string_provider.dart';
import 'package:huma_life/Employee/screens/Home/HomeScreenEmployee.dart';
import '../../../Data/provider/account_provider.dart';
import '../../../Data/provider/splash_provider.dart';
import 'OnBoard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _route();
  }

  void _route() async {
    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<SplashProvider>(context, listen: false).initConfig(context);
    Provider.of<ConnectStringProvider>(context, listen: false).initConfig();

        Timer(Duration(seconds: 1), () async {
          if (Provider.of<AccountProvider>(context, listen: false)
              .isLoggedIn()) {
            Provider.of<AccountProvider>(context, listen: false).updateToken();
            if (await Provider.of<AccountProvider>(context, listen: false)
                .isAdmin()) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => HomeScreenAdmin()));
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => HomeScreenEmployee()));
            }
          } else {
            if (Provider.of<AccountProvider>(context, listen: false)
                .isWelcomeScreenAppear()) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => SelectType()));
            } else {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => OnBoard()));
            }
          }
        });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kDarkWhite,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 5,
            ),
            TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                curve: Curves.ease,
                duration: const Duration(seconds: 5),
                builder: (BuildContext context, double opacity, Widget? child) {
                  return Opacity(
                    opacity: opacity,
                    child: const Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  );
                }),
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'version'.tr(),
                  style: GoogleFonts.manrope(
                      color: kMainColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
