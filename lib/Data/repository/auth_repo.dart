import 'package:dio/dio.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../datasource/dio/dio_client.dart';
import '../datasource/exception/api_error_handler.dart';
import '../response/base/api_response.dart';

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> login(
      {required String empCode,
      required String password}) async {
    try {
      Response response = await dioClient.post(
        AppConstants.LOGIN_URI,
        data: {"empcode": empCode, "password": password},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateToken() async {
    try {
      Response response = await dioClient.post(
        AppConstants.REFRESH_TOKEN,
        data: {
          "_method": "post",
          "token": sharedPreferences.get(AppConstants.TOKEN)
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.EMP_CODE);
    return await sharedPreferences.remove(AppConstants.EMP_PASSWORD);
  }

  Future<bool> clearSharedData() async {
    return sharedPreferences.remove(AppConstants.TOKEN);
  }

  Future<bool> clearSharedType() async {
    return sharedPreferences.setString(AppConstants.ISADMIN, "");
  }

  Future<bool> clearSharedUserName() async {
    return sharedPreferences.remove(AppConstants.EMP_ENGLISH_NAME);
  }

  Future<bool> clearSharedUserNameA() async {
    return sharedPreferences.remove(AppConstants.EMP_ARABIC_NAME);
  }

  Future<bool> clearSharedEmpPhoto() async {
    return sharedPreferences.remove(AppConstants.EMP_IMAGE);
  }

  Future<void> saveUserType(String type) async {
    await sharedPreferences.setString(AppConstants.ISADMIN, type);
  }

  Future<void> saveUserToken(String token, String type) async {
    dioClient.token = token;
    dioClient.dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    try {
      await sharedPreferences.setString(AppConstants.TOKEN, token);
      await sharedPreferences.setString(AppConstants.WELCOME, "ok");
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveUserNumberAndPassword(
      String empCode, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.EMP_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.EMP_CODE, empCode);
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveUserName(String arabicName, String englishName) async {
    try {
      await sharedPreferences.setString(
          AppConstants.EMP_ARABIC_NAME, arabicName);
      await sharedPreferences.setString(
          AppConstants.EMP_ENGLISH_NAME, englishName);
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveEmpAddress(
      String addressArabic, String addressEnglish) async {
    try {
      await sharedPreferences.setString(
          AppConstants.EMP_ADDRESSA, addressArabic);
      await sharedPreferences.setString(
          AppConstants.EMP_ADDRESSE, addressEnglish);
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveEmpMobileNo(String number) async {
    try {
      await sharedPreferences.setString(AppConstants.EMP_MOBILE, number);
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveEmpEmail(String email) async {
    try {
      await sharedPreferences.setString(AppConstants.EMP_EMAIL, email);
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveEmpManager(String email) async {
    try {
      await sharedPreferences.setString(AppConstants.EMP_MANAGER, email);
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveEmpBirthDate(String birthday) async {
    try {
      await sharedPreferences.setString(AppConstants.EMP_BIRTHDAY, birthday);
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveEmpGender(String gender) async {
    try {
      await sharedPreferences.setString(AppConstants.EMP_GENDER, gender);
    } catch (e) {
      throw e;
    }
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  bool isAdmin() {
    return (sharedPreferences.getString(AppConstants.ISADMIN)) == "admin"
        ? true
        : (sharedPreferences.getString(AppConstants.ISADMIN)) == "HR"
            ? true
            : false;
  }

  bool isWelcomeScreenAppear() {
    return sharedPreferences.containsKey(AppConstants.WELCOME);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  String getLang() {
    String? lang = sharedPreferences.getString(AppConstants.Lang);
    return lang ?? "";
  }

  void reloadEmpUsername() {
    sharedPreferences.reload();
  }

  String getEmpUsername() {
    return sharedPreferences.getString(AppConstants.EMP_ENGLISH_NAME) ?? "Employee Name";
  }

  String getEmpUsernameA() {
    return sharedPreferences.getString(AppConstants.EMP_ARABIC_NAME) ?? "اسم الموظف";
  }

  Future<String> getEmpUsernameFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString(AppConstants.EMP_ENGLISH_NAME) ?? "Employee Name";
    return username;
  }

  String getEmpCode() {
    return sharedPreferences.getString(AppConstants.EMP_CODE) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.EMP_PASSWORD) ?? "";
  }

  String getEmpAddressA() {
    return sharedPreferences.getString(AppConstants.EMP_ADDRESSA) ?? "";
  }

  String getEmpAddressE() {
    return sharedPreferences.getString(AppConstants.EMP_ADDRESSE) ?? "";
  }

  String getEmpMobileNo() {
    return sharedPreferences.getString(AppConstants.EMP_MOBILE) ?? "";
  }

  String getEmpEmail() {
    return sharedPreferences.getString(AppConstants.EMP_EMAIL) ?? "";
  }

  String getEmpManager() {
    return sharedPreferences.getString(AppConstants.EMP_MANAGER) ?? "";
  }

  String getEmpBirthDate() {
    return sharedPreferences.getString(AppConstants.EMP_BIRTHDAY) ?? "";
  }

  String getEmpGender() {
    return sharedPreferences.getString(AppConstants.EMP_GENDER) ?? "";
  }

  String getEmpIqamaNo() {
    return sharedPreferences.getString(AppConstants.EMP_IQAMANO) ?? "";
  }

  String getEmpPositionE() {
    return sharedPreferences.getString(AppConstants.EMP_POSITIONE) ?? "";
  }

  String getEmpPositionA() {
    return sharedPreferences.getString(AppConstants.EMP_POSITIONA) ?? "";
  }

  String getEmpLocationE() {
    return sharedPreferences.getString(AppConstants.EMP_LOCATIONE) ?? "";
  }

  String getEmpLocationA() {
    return sharedPreferences.getString(AppConstants.EMP_LOCATIONA) ?? "";
  }

  String getEmpCompanyName() {
    return sharedPreferences.getString(AppConstants.EMP_COMPNAME) ?? "";
  }

  String getEmpProfilePhoto() {
    return sharedPreferences.getString(AppConstants.EMP_IMAGE) ?? "";
  }

  int getShared(int EmpCode) {
    return sharedPreferences.getInt(EmpCode.toString()) ?? 0;
  }


  void putShared(int EmpCode, int val) {
    try {
      sharedPreferences.setInt(EmpCode.toString(), val);
    } catch (e) {
      throw e;
    }
  }

  void saveUserLocation(String locationE, String locationA) async{
    try {
      await sharedPreferences.setString(
          AppConstants.EMP_LOCATIONA, locationA);
      await sharedPreferences.setString(
          AppConstants.EMP_LOCATIONE, locationE);
    } catch (e) {
      throw e;
    }
  }

  void saveUserIqamaNo(String iqamaNo) async{
    try {
      await sharedPreferences.setString(AppConstants.EMP_IQAMANO, iqamaNo);
    } catch (e) {
      throw e;
    }
  }

  void saveUserPosition(String positionDescE, String positionDescA) async{
    try {
      await sharedPreferences.setString(
          AppConstants.EMP_POSITIONA, positionDescA);
      await sharedPreferences.setString(
          AppConstants.EMP_POSITIONE, positionDescE);
    } catch (e) {
      throw e;
    }
  }

  void saveUserCompanyName(String companyName) async{
    try {
      await sharedPreferences.setString(AppConstants.EMP_COMPNAME, companyName);
    } catch (e) {
      throw e;
    }
  }

  void saveUserEmpProfilePhoto(String empProfilePhoto) async{
    try {
      await sharedPreferences.setString(AppConstants.EMP_IMAGE, empProfilePhoto);
    } catch (e) {
      throw e;
    }
  }

  void saveConnectionString(String connectionString) async{
    try {
      await sharedPreferences.setString(AppConstants.CONNECTION_STRING, connectionString);
    } catch (e) {
      throw e;
    }
  }

  String getConnectionString() {
    return sharedPreferences.getString(AppConstants.CONNECTION_STRING) ?? "";
  }




  // void saveEmpCode(String employeeCode) {
  //   sharedPreferences.setString(AppConstants.EMP_CODE, employeeCode);
  // }
  //
  // void getEmpCode() {
  //   sharedPreferences.getString(AppConstants.EMP_CODE);
  // }

}
