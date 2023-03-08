import 'package:dio/dio.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import '../datasource/dio/dio_client.dart';
import '../datasource/exception/api_error_handler.dart';
import '../response/base/api_response.dart';

class LoanRepo {
  final DioClient dioClient;
  LoanRepo({required this.dioClient});

  Future<ApiResponse> sendLoanRequest(
      {
        required String effectiveDate,
        required String amount,
        required String monthCount,
        required String loanReason,
        required String loanType,
      }) async {
    try {
      Response response = await dioClient.post(AppConstants.LOAN_REQUEST,
          data: {
            'effectiveDate': effectiveDate,
            'amount': amount,
            'monthCount': monthCount,
            'loanReason': loanReason,
            'loanType': loanType
          });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateLoan(
      String loanId, String empCode, String status, String? reason) async {
    try {
      Response response = await dioClient.put(
        AppConstants.LOAN_UPDATE,
        data: {
          'transId': int.parse(loanId),
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

  Future<ApiResponse> getLoanList() async {
    try {
      Response response = await dioClient.get(AppConstants.LOAN_INDEX);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLoanNotifiedList() async {
    try {
      Response response = await dioClient.get(AppConstants.LOAN_NOTIFICATION);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLoanMonthList() async {
    try {
      Response response = await dioClient.get(AppConstants.LOAN_EFFECTIVE_MONTHS);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLoanHistoryList(String vacId) async {
    try {
      Response response = await dioClient
          .get(AppConstants.LIST_HISTORY_VACATIONS + "/" + vacId);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
