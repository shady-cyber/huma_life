import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:huma_life/Data/model/loan.dart';
import 'package:huma_life/Data/repository/loan_repo.dart';
import 'package:huma_life/Data/repository/response_model.dart';
import '../../Common/screens/view/custom_snackbar.dart';
import '../model/loan_month.dart';
import '../model/loan_notify.dart';
import '../response/base/api_response.dart';
import 'package:mime/mime.dart';

class LoanProvider extends ChangeNotifier {
  final LoanRepo loanRepo;
  bool LoanHistoryIsLoading = true;
  bool ShowHistoryList = false;
  bool showBadge = false;

  LoanProvider({required this.loanRepo});

  dynamic loanType = "0";
  dynamic loanMonthType = "0";
  String? initialValue;
  List<Loan> loanList = [];
  List<LoanNotify> loanNotifyList = [];
  List<LoanMonth> loanMonthList = [];
  bool isLoading = true;
 // List<VacationHistory> vacationHistoryList = [];

  Future<String> selectFiles() async {
    String path = "";
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpeg', 'png', 'jpg', 'pdf', 'doc', 'docx'],
    );
    if (result != null) {
      File file = File(result.files.single.path.toString());
      path = file.path;
    }
    return path;
  }

  Future<void> getLoanList() async {
    ApiResponse apiresponse = (await loanRepo.getLoanList()) as ApiResponse;
    loanList.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          loanList.add(Loan.fromJson(apiresponse.response.data[i]));
        }
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          loanList.add(Loan.initial(apiresponse.response.data[i]));
          break;
        }
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



  Future<void> getLoanNotifiedList() async {
    ApiResponse apiresponse = (await loanRepo.getLoanNotifiedList()) as ApiResponse;
    loanNotifyList.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          loanNotifyList.add(LoanNotify.fromJson(apiresponse.response.data[i]));
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

  Future<void> updateLoan(BuildContext context, int i, String status, String? reason) async {
    ApiResponse apiResponse = (await loanRepo.updateLoan(loanNotifyList[i].LoanRequestID,
        loanNotifyList[i].FK_EmpCode, status, reason)) as ApiResponse;
    if (apiResponse.response.statusCode == 200) {
      loanNotifyList.removeAt(i);
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

  Future<void> getLoanMonthList() async {
    ApiResponse apiresponse = (await loanRepo.getLoanMonthList()) as ApiResponse;
    loanMonthList.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          loanMonthList.add(LoanMonth.fromJson(apiresponse.response.data[i]));
        }
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          loanMonthList.add(LoanMonth.initial(apiresponse.response.data[i]));
          break;
        }
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> uploadFile(String filePath, BuildContext context) async {
    Dio dio = new Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    int index = filePath.lastIndexOf('.');
    String fileName = filePath.substring(index + 1);
    final mimeType = lookupMimeType(filePath);
    FormData formData = new FormData.fromMap(
        {'file': await MultipartFile.fromFile(filePath, filename: fileName)});
    Response response = await dio
        .post(AppConstants.VACATION_REQUEST, data: formData)
        .catchError((e) => print(e.response.toString()));
    if (response.statusCode == 200) {
      showCustomSnackBar('File uploaded successfully', context, isError: false);
    }
  }

  Future<void> showSnackBarWithButtonChangeColor(
      {required BuildContext context,
      required String text,
      required bool pressAttentionChangeColor}) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ))
        .closed
        .then((value) => pressAttentionChangeColor);
    notifyListeners();
  }

  // Future<void> showLoanList(String vacationId) async {
  //   Future.delayed(Duration(milliseconds: 1)).then((value) async {
  //     await getVacationHistoryList(vacationId, ShowHistoryList);
  //     bool VacationShow = await getVacationHistoryList(vacationId, ShowHistoryList);
  //     if (VacationShow != true) {
  //       ShowHistoryList = false;
  //     } else {
  //       ShowHistoryList = true;
  //     }
  //   });
  // }

  // Future<bool> getVacationHistoryList(
  //     String vacId, bool ShowHistoryList) async {
  //  // vacationHistoryList.clear();
  //   ShowHistoryList = false;
  //   ApiResponse apiresponse = await vacationRepo.getVacationHistoryList(vacId);
  //
  //   if (apiresponse.response.statusCode == 200) {
  //     try {
  //       for (var i = 0; i < apiresponse.response.data.length; i++) {
  //         vacationHistoryList
  //             .add(VacationHistory.fromJson(apiresponse.response.data[i]));
  //         ShowHistoryList = true;
  //       }
  //       VacHistoryIsLoading = false;
  //       notifyListeners();
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  //   return ShowHistoryList;
  // }

  Future<ResponseModel> sendLoanRequest(
      {
        required String effectiveDate,
        required String amount,
        required String monthCount,
        required String loanReason,
        required String loanType,
      required BuildContext context}) async {
    //var x = DateTime.parse(fromDate).compareTo(DateTime.parse(toDate));
    ResponseModel responseModel;
    String errorMessage = 'error';
    //if (DateTime.parse(fromDate).compareTo(DateTime.parse(toDate)) <= 0) {
      ApiResponse apiResponse = (await loanRepo.sendLoanRequest(
          effectiveDate: effectiveDate,
          amount: amount,
          monthCount: monthCount,
          loanReason: loanReason,
          loanType: loanType)) as ApiResponse;
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        responseModel = ResponseModel('', true);
      } else {
        showCustomSnackBar(apiResponse.error.errors[0].message, context);
        responseModel = ResponseModel(errorMessage, false);
      }
    return responseModel;
    }
    // else {
    //   showCustomSnackBar('Date from must be less than date to', context);
    //   responseModel = ResponseModel(errorMessage, false);
   //  }

}
