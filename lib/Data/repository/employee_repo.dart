import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:huma_life/Data/datasource/dio/dio_client.dart';
import 'package:huma_life/Data/datasource/exception/api_error_handler.dart';
import 'package:huma_life/Data/response/base/api_response.dart';

class EmployeeRepo {
  final DioClient dioClient;

  EmployeeRepo({required this.dioClient});

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

  Future<ApiResponse> getVacationsList() async {
    try {
      Response response = await dioClient.get(
        AppConstants.EMPLOYEE_VACATION_REQUESTS,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addEmpCards(List json) async {
    try {
      Response response = await dioClient.post(
        AppConstants.MARK_ATTENDANCE,
        data: {
          // 'signInDate': selectedDate,
          // "signInTime": selectedInTime,
          // "signOutTime": selectedOutTime,
          "empCode": json
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getEmployeeListForPrint() async {
    try {
      Response response = await dioClient.get(
        AppConstants.REPORTING_TO_ME,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> addMarkAttendance(String action, String selectedDate,
      String selectedInTime, String selectedOutTime, List json) async {
    try {
      Response response = await dioClient.post(
        AppConstants.MARK_ATTENDANCE,
        data: {
          'signInDate': selectedDate,
          "signInTime": selectedInTime,
          "signOutTime": selectedOutTime,
          "empCode": json
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateVacation(
      String vacationId, String empCode, String status, String? reason) async {
    try {
      Response response = await dioClient.put(
        AppConstants.UPDATE_VACATION_REQUEST,
        data: {
          'transId': int.parse(vacationId),
          'empCode': int.parse(empCode),
          'statusId': int.parse(status),
          'comment': reason,
        },
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
