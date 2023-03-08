import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/screens/Authentication/Sign_In.dart';
import 'package:huma_life/Data/provider/splash_provider.dart';
import 'package:huma_life/Data/response/base/api_response.dart';

class ApiChecker {
  static void checkApi(BuildContext context, ApiResponse apiResponse) {
    if (apiResponse.error is! String &&
        (apiResponse.error.errors[0].message == 'Unauthenticated.' ||
            apiResponse.error.errors[0].message == "Invalid token!")) {
      Provider.of<SplashProvider>(context, listen: false).removeSharedData();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => SignIn()), (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
            content: Text(
              'Please check the internet',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ))
          .closed
          .then((value) => exit(0));
    }
  }
}
