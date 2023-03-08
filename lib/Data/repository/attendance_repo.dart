import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import '../datasource/dio/dio_client.dart';
import '../datasource/exception/api_error_handler.dart';
import '../response/base/api_response.dart';

class AttendanceRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AttendanceRepo({required this.dioClient, required this.sharedPreferences});

  Future<bool> requestPermissionGranted(Permission setting) async {
    final _result = await setting.request();
    switch (_result) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.denied:
        return false;
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        return false;
    }
  }

  Future<ApiResponse> checkIn(
      {required String otp,
      required String longitude,
      required String latitude,
      required String checkDate}) async {
    try {
      Response response = await dioClient.post(
        AppConstants.ATTENDANCE_CHECK_IN,
        data: {
          "otp": otp,
          "longitude": longitude,
          "latitude": latitude,
          "check_date": checkDate
        }
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> checkInWithQrCard(
      {required BuildContext context, required String QRCode}) async {
    try {
      Response response = await dioClient.post(
        AppConstants.ATTENDANCE_CHECK_IN_QR_CARD,
        data: {"QRCode": QRCode},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> checkOut({required String token, required String checkDate}) async {
    try {
      Response response = await dioClient.post(
        AppConstants.ATTENDANCE_CHECK_OUT,
        data: {
          "token": token,
          "check_date": checkDate
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> missedCheckOut() async {
    try {
      Response response = await dioClient.get(
        AppConstants.ATTENDANCE_MISSED_CHECK_OUT,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> checkOutOldDay(
      {String? RequestDate,
      String? signOutDate,
      String? reason,
      int? FK_InOutSignID}) async {
    try {
      Response response = await dioClient.post(
        AppConstants.ATTENDANCE_MISSED_CHECK_OUT_REQUEST,
        data: {
          "requestDate": RequestDate,
          "signOutDate": signOutDate,
          "reason": reason,
          'FK_InOutSignID': FK_InOutSignID
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  //get vacation history list
  Future<ApiResponse> getAttendanceHistoryList(String attendanceId) async {
    try {
      Response response = await dioClient
          .get(AppConstants.LIST_HISTORY_VACATIONS + "/" + attendanceId);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getConfiguration() async {
    try {
      Response response =
          await dioClient.get(AppConstants.GET_CONFIG_ATTENDANCE);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  String getToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  Object? getLastCheckInTime() {
    return sharedPreferences.get(AppConstants.LAST_CHECK_IN_TIME);
  }

  setCheckInTime(DateTime time) {
    sharedPreferences.setString(
        AppConstants.LAST_CHECK_IN_TIME, time.toString());
  }

  Future<void> setLocation(String latitude, String longitude) async {
    sharedPreferences.setString(AppConstants.LATITUDE, latitude);
    sharedPreferences.setString(AppConstants.LONGITUDE, longitude);
  }

  String getLatitude() {
    return sharedPreferences.getString(AppConstants.LATITUDE) ?? "";
  }

  String getLongitude() {
    return sharedPreferences.getString(AppConstants.LONGITUDE) ?? "";
  }

  Future<ApiResponse> getEmployeeList() async {
    try {
      Response response = await dioClient.get(
        AppConstants.REPORTING_TO_ME,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getMissedAttendanceList() async {
    try {
      Response response = await dioClient.get(
        AppConstants.ATTENDANCE_MISSED_DECISION,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> attendanceConfig(
      {int? EmpCode,
      bool? QROption,
      bool? LocationOption,
      double? Longitude,
      double? Latitude}) async {
    try {
      Response response = await dioClient.post(
        AppConstants.CONFIG_ATTENDANCE,
        data: {
          "FK_EmpCode": EmpCode,
          "QROption": QROption,
          "LocationOption": LocationOption,
          'Longitude': Longitude,
          'Latitude': Latitude
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateAttendance(
      String attendanceReqId,
      String empCode,
      String status,
      int RequestStatusID,
      String? reason,
      String FK_InOutSignID,
      String? DateCheckout,
      String? CheckOutTime) async {
    try {
      Response response = await dioClient.put(
        AppConstants.REQUEST_ATTENDANCE_MISSED_DECISION,
        data: {
          'transId': int.parse(attendanceReqId),
          'empCode': int.parse(empCode),
          'statusId': RequestStatusID,
          'comment': reason,
          'FK_InOutSignID': FK_InOutSignID,
          'DateCheckout': DateCheckout,
          'CheckOutTime': CheckOutTime
        },
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
