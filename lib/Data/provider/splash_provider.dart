import 'package:flutter/material.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:huma_life/Data/database/helper/api_checker.dart';
import 'package:huma_life/Data/repository/splash_repo.dart';
import 'package:huma_life/Data/response/base/api_response.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo splashRepo;

  SplashProvider({required this.splashRepo});
  final CodeController = TextEditingController();

  Future<bool> initConfig(BuildContext context) async {
   AppConstants.BASE_URL = await splashRepo.getConnectionString() ?? "";

    if(AppConstants.BASE_URL == ""){

      return false;
    }
    // ApiResponse apiResponse = await splashRepo.getConfig();
    // bool isSuccess = false;
    // if (apiResponse.response != null &&
    //     apiResponse.response.statusCode == 200) {
    //   isSuccess = true;
    //   notifyListeners();
    // } else {
    //   isSuccess = false;
    //   ApiChecker.checkApi(context, apiResponse);
    // }
    return true;
  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo.removeSharedData();
  }

  // Future<void> setLocation(String latitude, String longitude) {
  //   return splashRepo.setLocation(latitude, longitude);
  // }
}
