import 'package:nb_utils/nb_utils.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import '../datasource/dio/dio_client.dart';

class ProfileRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  ProfileRepo({required this.dioClient, required this.sharedPreferences});

  String getToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }
}
