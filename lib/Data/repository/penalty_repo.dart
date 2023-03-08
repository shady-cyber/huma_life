import 'package:dio/dio.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:huma_life/Data/model/penalty.dart';
import '../datasource/dio/dio_client.dart';
import '../datasource/exception/api_error_handler.dart';
import '../response/base/api_response.dart';

class PenaltyRepo {
  final DioClient dioClient;
  PenaltyRepo({required this.dioClient});

  Future<ApiResponse> sendPenaltyRequest(
      {required String RequestedEmpCode,
       required String penaltyType,
       required String affectiveDate,
       required String penaltyReason
      }) async {
    try {
      Response response = await dioClient.post(AppConstants.PENALTY_SEND_REQ,
          data: {
            'RequestedEmpCode': RequestedEmpCode,
            'penaltyType': penaltyType,
            'affectiveDate': affectiveDate,
            'penaltyReason': penaltyReason,
          });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getPenaltyNotifiedList() async {
    try {
      Response response = await dioClient.get(AppConstants.PENALTY_NOTIFICATION);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getEmpPenaltyNotifiedList() async {
    try {
      Response response = await dioClient.get(AppConstants.PENALTY_NOTIFICATION_SHOW);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updatePenalty(
      int penaltyId, String empCode, String status, String? reason) async {
    try {
      Response response = await dioClient.post(
        AppConstants.PENALTY_DECISION,
        data: {
          'transId': penaltyId,
          'empCode': empCode,
          'statusId': int.parse(status),
          'comment': reason,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getPenaltyList() async {
    try {
      Response response = await dioClient.get(AppConstants.PENALTY_INDEX_REQ);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getEmpCodeList(String vacId) async {
    try {
      Response response = await dioClient
          .get(AppConstants.LIST_HISTORY_VACATIONS + "/" + vacId);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
