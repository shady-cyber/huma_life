import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:huma_life/Data/repository/cash_repo.dart';
import 'package:huma_life/Data/repository/response_model.dart';
import '../../Common/screens/view/custom_snackbar.dart';
import '../model/cash_notification.dart';
import '../response/base/api_response.dart';

class CashProvider extends ChangeNotifier {
  final CashRepo cashRepo;
  bool isLoading = true;
  bool showBadge = false;
  List<CashNotify> cashNotifiedList = [];
  CashProvider({required this.cashRepo});

  Future<void> updateCash(BuildContext context, int i, String status, String? reason) async {
    ApiResponse apiResponse = (await cashRepo.updateCash(cashNotifiedList[i].EmpCashRequestID,
        cashNotifiedList[i].FK_EmpCode, status, reason)) as ApiResponse;
    if (apiResponse.response.statusCode == 200) {
      cashNotifiedList.removeAt(i);
      if (status == "2" && reason != "Notified") {
        showCustomSnackBar("Request Approved Successfully".tr(), context,
            isError: false);
      }
      if (status == "3") {
        showCustomSnackBar("Request rejection sent Successfully".tr(), context,
            isError: true);
      }
      if (reason == "Notified") {
        showCustomSnackBar("Request Notified Successfully".tr(), context,
            isError: false);
      }
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.response.errors[0].message, context,
          isError: true);
    }
  }

  Future<void> getCashNotifiedList() async {
    ApiResponse apiresponse = (await cashRepo.getCashNotifiedList()) as ApiResponse;
    cashNotifiedList.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          cashNotifiedList.add(CashNotify.fromJson(apiresponse.response.data[i]));
        }
        if(apiresponse.response.data.length == 0){
          showBadge = false;
        } else {
          showBadge = true;
        }
        isLoading = false;
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  void clear() {
    showBadge = false;
    notifyListeners();
  }

  Future<ResponseModel> sendCashRequest(
      {required String amount,
        required BuildContext context}) async {
    ResponseModel responseModel;
    String errorMessage = 'error';
    ApiResponse apiResponse = (await cashRepo.sendCashRequest(amount: amount)) as ApiResponse;
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      responseModel = ResponseModel('', true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
        apiResponse.error.errors[0].message,
        style: TextStyle(color: Colors.white),
      ),
        backgroundColor: Colors.red,
      )).closed.then(
            (value) => Navigator.pop(context),
      );
      responseModel = ResponseModel(errorMessage, false);
    }
    return responseModel;
  }
}
