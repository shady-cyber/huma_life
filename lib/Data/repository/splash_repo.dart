import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../datasource/dio/dio_client.dart';
import '../datasource/exception/api_error_handler.dart';
import '../response/base/api_response.dart';

class SplashRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({required this.sharedPreferences, required this.dioClient});

  Future<ApiResponse> getConfig() async {
    try {
      final response = await dioClient.get(AppConstants.CONFIG_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e.toString()));
    }
  }

  Future<String?> getConnectionString() async{
    return sharedPreferences.getString(AppConstants.CONNECTION_STRING);
  }

  Future<bool> initSharedData() {
    if (!sharedPreferences.containsKey(AppConstants.THEME)) {
      return sharedPreferences.setBool(AppConstants.THEME, false);
    }

    if (!sharedPreferences.containsKey(AppConstants.LANGUAGE_CODE)) {
      return sharedPreferences.setString(AppConstants.LANGUAGE_CODE, 'en');
    }

    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }

  setLocation(String latitude, String longitude) {
    sharedPreferences.setString(AppConstants.LATITUDE, latitude);
    sharedPreferences.setString(AppConstants.LONGITUDE, longitude);
  }
}
