import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:huma_life/Data/model/Evaluated_Items.dart';
import 'package:huma_life/Data/model/clearance_emp_list.dart';
import 'package:huma_life/Data/model/clearance_main.dart';
import 'package:huma_life/Data/model/clearance_status.dart';
import 'package:huma_life/Data/repository/clearance_repo.dart';
import 'package:huma_life/Data/repository/response_model.dart';
import '../../Common/screens/view/custom_snackbar.dart';
import '../model/clearance _notification.dart';
import '../model/clearance_charge.dart';
import '../response/base/api_response.dart';

class ClearanceProvider extends ChangeNotifier {
  final ClearanceRepo clearanceRepo;
  String EmpClearanceRequestID = '';
  bool LoanHistoryIsLoading = true;
  bool ShowHistoryList = false;
  bool showList = false;
  bool isLoading = true;
  bool showBadge = false;
  bool Asset = false;
  bool Charge = false;
  bool visabl = false;

  ClearanceProvider({required this.clearanceRepo});

  dynamic selectedValue = 0;
  dynamic selectedChargeValue = 0;
  List<ClearanceStatus> clearanceStatusData = [];
  List<ClearanceMain> clearanceData = [];
  List<ClearanceMain> clearanceSubData = [];
  List<ClearanceCharge> clearanceChargeData = [];
  List<ClearanceEmpList> clearanceEmpData = [];
  List<ClearanceNotify> clearanceNotificationList = [];
  List<EvaluatedClearanceItems> EvaluatedItems = [];


  Future<void> getClearanceListStatusItems() async {
    ApiResponse apiresponse = (await clearanceRepo.getClearanceListStatusItems()) as ApiResponse;
    clearanceStatusData.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          clearanceStatusData.add(ClearanceStatus.fromJson(apiresponse.response.data[i]));
        }
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          clearanceStatusData.add(ClearanceStatus.initial(apiresponse.response.data[i]));
          break;
        }
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getClearanceList() async {
    ApiResponse apiresponse = (await clearanceRepo.getClearanceList()) as ApiResponse;
    clearanceData.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          clearanceData.add(ClearanceMain.fromJson(apiresponse.response.data[i]));
        }
        showBadge = true;
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

  Future<void> getSubClearanceList(String EmpCode) async {
    ApiResponse apiresponse = (await clearanceRepo.getSubClearanceList(EmpCode)) as ApiResponse;
    //clearanceSubData.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          clearanceSubData.add(ClearanceMain.fromJson(apiresponse.response.data[i]));
        }
        isLoading = false;
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool> ClearClearanceList() async {
    clearanceSubData.clear();
    return true;
  }

  Future<void> getClearanceChargeList() async {
    ApiResponse apiresponse = (await clearanceRepo.getClearanceChargeList()) as ApiResponse;
    clearanceChargeData.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          clearanceChargeData.add(ClearanceCharge.fromJson(apiresponse.response.data[i]));
        }
        isLoading = false;
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> updateClearance(BuildContext context, int i, String status,String empCode, String? reason) async {
    for(var index = 0; index < clearanceNotificationList.length; index++) {
      if (clearanceNotificationList[index].FK_EmpCode == empCode) {
        EmpClearanceRequestID = clearanceNotificationList[index].EmpClearanceRequestID;

        ApiResponse apiResponse = (await clearanceRepo.updateClearance(
            EmpClearanceRequestID,
            empCode, status, reason)) as ApiResponse;
        if (apiResponse.response.statusCode == 200) {
          clearanceEmpData.removeAt(i);
          if (status == "2" && reason != "Notified") {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(
              "Request Approved Successfully".tr(),
              style: TextStyle(color: Colors.white),
            ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            )).closed.then(
                  (value) => Navigator.pop(context),
            );
          }
          if (status == "3") {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(
                  "Request rejection sent Successfully".tr(),
                  style: TextStyle(color: Colors.white),
                ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 1),
                )).closed.then(
                  (value) => Navigator.pop(context),
            );
          }
          if (reason == "Notified") {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(
                  "Request Notified Successfully".tr(),
                  style: TextStyle(color: Colors.white),
                ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                )).closed.then(
                  (value) => Navigator.pop(context),
            );
          }
          notifyListeners();
        } else {
          showCustomSnackBar(apiResponse.response.errors[0].message, context,
              isError: true);
        }
      }
    }
  }

  Future<void> getClearanceNotificationList() async {
    ApiResponse apiresponse = (await clearanceRepo.getClearanceNotificationList()) as ApiResponse;
         clearanceNotificationList.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          clearanceNotificationList.add(ClearanceNotify.fromJson(apiresponse.response.data[i]));
        }
        isLoading = false;
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getSubClearanceChargeList(String EmpCode) async {
    ApiResponse apiresponse = (await clearanceRepo.getSubClearanceChargeList(EmpCode)) as ApiResponse;
   // clearanceSubData.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          clearanceSubData.add(ClearanceMain.fromJsonCharge(apiresponse.response.data[i]));
        }
        isLoading = false;
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool> getClearanceEmpList() async {
    ApiResponse apiresponse = (await clearanceRepo.getClearanceEmpList()) as ApiResponse;
    clearanceEmpData.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for(var ii = 0; ii < clearanceNotificationList.length; ii++) {
          for (var i = 0; i < apiresponse.response.data.length; i++) {
            int xx = int.parse(clearanceNotificationList[ii].FK_EmpCode);
            int yy = apiresponse.response.data[i]['EmpCode'];
            if (yy == xx) {
              clearanceEmpData.add(ClearanceEmpList.fromJson(apiresponse.response.data[i]));
            }
          }
        }
        if(apiresponse.response.data.length == 0){
          showList = false;
          showBadge = false;
        } else {
          showBadge = true;
          showList = true;
        }
        isLoading = false;
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
    return showList;
  }

  Future<ResponseModel> sendClearanceRequest({required BuildContext context}) async {
    ResponseModel responseModel;
    String errorMessage = 'error';
      ApiResponse apiResponse = (await clearanceRepo.sendClearanceRequest()) as ApiResponse;
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        responseModel = ResponseModel('', true);
      } else {
        showCustomSnackBar(apiResponse.error.errors[0].message, context);
        responseModel = ResponseModel(errorMessage, false);
      }
      return responseModel;
    }

  Future<ResponseModel> sendEvaluationClearanceItems({
    required int empCode,
    required String FK_ItemStatus,
    required String Remarks,
    required bool IsAsset,
    required bool IsCharge,
    required BuildContext context}) async {
    ResponseModel responseModel;
    String errorMessage = 'error';
    ApiResponse apiResponse = (await clearanceRepo.sendEvaluationClearanceItems(
      empCode: empCode,
      FK_ItemStatus: FK_ItemStatus,
      Remarks: Remarks,
      IsAsset: IsAsset,
      IsCharge: IsCharge,
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
