import 'package:dio/dio.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import '../datasource/dio/dio_client.dart';
import '../datasource/exception/api_error_handler.dart';
import '../response/base/api_response.dart';

class VacationRepo {
  final DioClient dioClient;
  VacationRepo({required this.dioClient});

  Future<ApiResponse> sendVacationRequest(
      {required String fromDate,
      required String toDate,
      String? reason,
      required int type}) async {
    try {
      Response response = await dioClient.post(
          AppConstants.VACATION_REQUEST,
          data: {
            'fromDate': fromDate,
            'toDate': toDate,
            'reason': reason,
            'type': type
          });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getVacationList() async {
    try {
      Response response = await dioClient.get(AppConstants.LIST_VACATIONS);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getHistoryList(String requestId, String type) async {
    try {
      late Response response;
      if(type == 'vacation') {
        response =
        await dioClient.get(AppConstants.LIST_HISTORY_VACATIONS + "/" + requestId);
      }
      else if(type == 'loan') {
        response =
        await dioClient.get(AppConstants.LOAN_DECISION_HISTORY + "/" + requestId);
      }
      else if(type == 'loan_delay') {
        response =
        await dioClient.get(AppConstants.LOAN_DELAY_DECISION_HISTORY + "/" + requestId);
      }
      else if(type == 'general') {
        response =
        await dioClient.get(AppConstants.GENERAL_DECISION_HISTORY + "/" + requestId);
      }
      else if(type == 'cash') {
        response =
        await dioClient.get(AppConstants.CASH_IN_ADVANCE_DECISION_HISTORY + "/" + requestId);
      }
      else if(type == 'penalty') {
        response =
        await dioClient.get(AppConstants.PENALTY_DECISION_HISTORY + "/" + requestId);
      }
      else if(type == 'clearance') {
        response =
        await dioClient.get(AppConstants.CLEARANCE_DECISION_HISTORY + "/" + requestId);
      }
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
