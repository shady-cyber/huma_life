import 'package:dio/dio.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import '../datasource/dio/dio_client.dart';
import '../datasource/exception/api_error_handler.dart';
import '../response/base/api_response.dart';

class LoanDelayRepo {
  final DioClient dioClient;
  LoanDelayRepo({required this.dioClient});

  Future<ApiResponse> sendLoanDelayRequest({required String FK_LoanID, required String amount, required String FK_EmpLoanMainID, required String FK_EmpLoanDetailID,
  required String FK_MonthID}) async {
    try {
      Response response = await dioClient.post(AppConstants.LOAN_DELAY_SEND,
          data: {
            'FK_LoanID': FK_LoanID,
            'Amount': amount,
            'FK_EmpLoanMainID': FK_EmpLoanMainID,
            'FK_EmpLoanDetailID': FK_EmpLoanDetailID,
            'FK_MonthID': FK_MonthID,
          });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLoansDelayList() async {
    try {
      Response response = await dioClient.get(AppConstants.LOAN_DELAY_VIEW);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLoansDelayNotifiedList() async {
    try {
      Response response = await dioClient.get(AppConstants.LOAN_DELAY_NOTIFICATION);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLoanDelayMonthList(String link_id) async {
    try {
      link_id = AppConstants.LOAN_MAIN_ID;
       Response response = await dioClient.get(AppConstants.LOAN_DELAY_REQ + link_id);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateLoanDelay(
      String loanDelayId, String empCode, String status, String? reason) async {
    try {
      Response response = await dioClient.post(
        AppConstants.LOAN_DELAY_DECISION,
        data: {
          'transId': int.parse(loanDelayId),
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
