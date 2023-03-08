import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:huma_life/Data/model/loan.dart';
import 'package:huma_life/Data/model/loansDelay.dart';
import 'package:huma_life/Data/repository/loan_delay_repo.dart';
import 'package:huma_life/Data/repository/response_model.dart';
import '../../Common/screens/view/custom_snackbar.dart';
import '../model/loan_delay_notify.dart';
import '../model/loan_month.dart';
import '../response/base/api_response.dart';

class LoanDelayProvider extends ChangeNotifier {
  final LoanDelayRepo loanDelayRepo;
  bool LoanHistoryIsLoading = true;
  bool ShowHistoryList = false;
  bool isLoading = true;
  bool showBadge = false;

  LoanDelayProvider({required this.loanDelayRepo});

  String monthId = "";
  String monthType = "";
  String loanMonthType = "";
  String EmpDetailsId = "";
  String amount = "";
  String loanId = "";
  String? initialValue;
  List<Loan> loanList = [];
  List<LoanMonth> loanMonthList = [];
  List<LoansDelay> loanDelayList = [];
  List<LoanDelayNotify> loanDelayNotifiedList = [];

  Future<void> getLoansDelayList() async {
    ApiResponse apiresponse = (await loanDelayRepo.getLoansDelayList()) as ApiResponse;
    loanDelayList.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          loanDelayList.add(LoansDelay.fromJson(apiresponse.response.data[i]));
        }
        monthType = loanDelayList[0].EmpLoanMainID;
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

  Future<void> getLoansDelayNotifiedList() async {
    ApiResponse apiresponse = (await loanDelayRepo.getLoansDelayNotifiedList()) as ApiResponse;
    loanDelayNotifiedList.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          loanDelayNotifiedList.add(LoanDelayNotify.fromJson(apiresponse.response.data[i]));
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

  Future<void> getLoanDelayMonthList(monthType) async {
    AppConstants.LOAN_MAIN_ID = monthType;
    ApiResponse apiresponse = (await loanDelayRepo.getLoanDelayMonthList(AppConstants.LOAN_MAIN_ID)) as ApiResponse;
    loanMonthList.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          loanMonthList.add(LoanMonth.fromJson(apiresponse.response.data[i]));
        }
        loanMonthType = loanMonthList[0].MonthName;
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> updateLoanDelay(BuildContext context, int i, String status, String? reason) async {
    ApiResponse apiResponse = (await loanDelayRepo.updateLoanDelay(loanDelayNotifiedList[i].EmployeeLoanDelayRequestID,
        loanDelayNotifiedList[i].FK_EmpCode, status, reason)) as ApiResponse;
    if (apiResponse.response.statusCode == 200) {
      loanDelayNotifiedList.removeAt(i);
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

  Future<ResponseModel> sendLoanDelayRequest(
      {
        required String FK_LoanID,
        required String amount,
        required String FK_EmpLoanMainID,
        required String FK_EmpLoanDetailID,
        required String FK_MonthID,
      required BuildContext context}) async {
    ResponseModel responseModel;
    String errorMessage = 'error';
      ApiResponse apiResponse = (await loanDelayRepo.sendLoanDelayRequest(
        FK_LoanID: FK_LoanID,
        amount: amount,
        FK_EmpLoanMainID: FK_EmpLoanMainID,
        FK_EmpLoanDetailID: FK_EmpLoanDetailID,
        FK_MonthID: FK_MonthID,
            )) as ApiResponse;
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        responseModel = ResponseModel('', true);
      } else {
        showCustomSnackBar(apiResponse.error.errors[0].message, context);
        responseModel = ResponseModel(errorMessage, false);
      }
    return responseModel;
    }

}
