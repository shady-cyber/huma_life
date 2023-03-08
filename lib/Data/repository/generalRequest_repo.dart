import 'package:dio/dio.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import '../datasource/dio/dio_client.dart';
import '../datasource/exception/api_error_handler.dart';
import '../response/base/api_response.dart';

class GeneralRequestRepo {
  final DioClient dioClient;
  GeneralRequestRepo({required this.dioClient});

  Future<ApiResponse> getGeneralNotifiedList() async {
    try {
      Response response = await dioClient.get(AppConstants.GENERAL_REQ_NOTIFICATION);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> sendGeneralRequest(
      {
        required String title,
        required String description,
      }) async {
    try {
      Response response = await dioClient.post(AppConstants.GENERAL_REQ,
          data: {
            'title': title,
            'description': description,
          });
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateGeneral(
      int generalId, String empCode, String statusId, String? reason) async {
    try {
      Response response = await dioClient.put(
        AppConstants.GENERAL_UPDATE,
        data: {
          'transId': generalId,
          'empCode': int.parse(empCode),
          'statusId': int.parse(statusId),
          'comment': reason,
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
