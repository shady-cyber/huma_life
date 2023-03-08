import 'package:dio/dio.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import '../datasource/dio/dio_client.dart';
import '../datasource/exception/api_error_handler.dart';
import '../response/base/api_response.dart';

class ClearanceRepo {
  final DioClient dioClient;
  ClearanceRepo({required this.dioClient});

  Future<ApiResponse> sendClearanceRequest() async {
    try {
      Response response = await dioClient.post(AppConstants.CLEARANCE_REQ, data: {});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> sendEvaluationClearanceItems({
    required int empCode,
    required String FK_ItemStatus,
    required String Remarks,
    required bool IsAsset,
    required bool IsCharge,
  }) async {
    try {
      Response response = await dioClient.post(AppConstants.CLEARANCE_SEND, data: {
        'empCode': empCode,
        'FK_ItemStatus': FK_ItemStatus,
        'Remarks': Remarks,
        'IsAsset': IsAsset,
        'IsCharge': IsCharge,
      });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getClearanceListStatusItems() async {
    try {
      Response response = await dioClient.get(AppConstants.CLEARANCE_ITEM_STATUS);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getClearanceList() async {
    try {
      Response response = await dioClient.get(AppConstants.CLEARANCE_INDEX);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubClearanceList(String EmpCode) async {
    try {
      Response response = await dioClient.get(AppConstants.CLEARANCE_INDEX + '/' + EmpCode);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getClearanceChargeList() async {
    try {
      Response response = await dioClient.get(AppConstants.CLEARANCE_INDEX_CHARGE);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubClearanceChargeList(String EmpCode) async {
    try {
      Response response = await dioClient.get(AppConstants.CLEARANCE_INDEX_CHARGE + '/' + EmpCode);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getClearanceEmpList() async {
    try {
      Response response = await dioClient.get(AppConstants.CLEARANCE_EMP);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getClearanceNotificationList() async {
    try {
      Response response = await dioClient.get(AppConstants.CLEARANCE_NOTIFICATION_SHOW);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateClearance(
      String clearanceId, String empCode, String status, String? reason) async {
    try {
      Response response = await dioClient.post(
        AppConstants.CLEARANCE_DECISION,
        data: {
          'transId': int.parse(clearanceId),
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
