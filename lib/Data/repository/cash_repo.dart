import 'package:dio/dio.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import '../datasource/dio/dio_client.dart';
import '../datasource/exception/api_error_handler.dart';
import '../response/base/api_response.dart';

class CashRepo {
  final DioClient dioClient;
  CashRepo({required this.dioClient});

  Future<ApiResponse> getCashNotifiedList() async {
    try {
      Response response = await dioClient.get(AppConstants.CASH_IN_ADVANCE_MANAGER);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateCash(
      String vacationId, String empCode, String status, String? reason) async {
    try {
      Response response = await dioClient.put(
        AppConstants.CASH_IN_ADVANCE_UPDATE,
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

  Future<ApiResponse> sendCashRequest({required String amount}) async {
    try {
      Response response = await dioClient.post(AppConstants.CASH_IN_ADVANCE,
          data: {
            'amount': amount,
          });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
