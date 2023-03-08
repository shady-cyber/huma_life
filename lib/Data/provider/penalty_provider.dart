import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:huma_life/Data/provider/account_provider.dart';
import 'package:huma_life/Data/repository/response_model.dart';
import '../../Common/screens/view/custom_snackbar.dart';
import '../model/penalty.dart';
import '../model/penalty_emp_notify.dart';
import '../model/penalty_notify.dart';
import '../repository/penalty_repo.dart';
import '../response/base/api_response.dart';
import 'package:mime/mime.dart';

class PenaltyProvider extends ChangeNotifier {
  final PenaltyRepo penaltyRepo;
  bool isLoading = true;
  bool showBadge = false;
  List<PenaltyNotify> PenaltyNotifiedData = [];
  List<PenaltyEmpNotify> EmpPenaltyNotifiedData = [];

  PenaltyProvider({required this.penaltyRepo});

  static int penaltyType = 1;
  static String selectedValueSingleDialog = "Penalty Type";
  int vacationTypee = 1;
  static List<DropdownMenuItem> penaltyList = [];
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

  Future<void> getPenaltyList(BuildContext context) async {
    ApiResponse apiresponse = await penaltyRepo.getPenaltyList();
    penaltyList.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
         if(Provider.of<AccountProvider>(context, listen: false).authRepo.getLang() == 'ar') {
            selectedValueSingleDialog = apiresponse.response.data[i]['PenalityDescA'];
         }
          else {
            selectedValueSingleDialog = apiresponse.response.data[i]['PenalityDescE'];
          }
          penaltyList.add((DropdownMenuItem(
            value: Penalty.fromJson(apiresponse.response.data[i]),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0,),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Text(
                      textAlign: TextAlign.right,
                      selectedValueSingleDialog == "" ? 'Penalty Type': selectedValueSingleDialog,
                    ),
                  ),
                ),
                Divider(),
              ],
            )
          )),
          );
        }
        penaltyType = apiresponse.response.data[0]['PenalityID'];
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

  Future<void> getPenaltyNotifiedList() async {
    ApiResponse apiresponse = (await penaltyRepo.getPenaltyNotifiedList()) as ApiResponse;
    PenaltyNotifiedData.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          PenaltyNotifiedData.add(PenaltyNotify.fromJson(apiresponse.response.data[i]));
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

  Future<void> getEmpPenaltyNotifiedList() async {
    ApiResponse apiresponse = (await penaltyRepo.getEmpPenaltyNotifiedList()) as ApiResponse;
    EmpPenaltyNotifiedData.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          EmpPenaltyNotifiedData.add(PenaltyEmpNotify.fromJson(apiresponse.response.data[i]));
        }
        showBadge = true;
        isLoading = false;
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

  Future<void> updatePenalty(BuildContext context, int i, String status, String? reason) async {
    ApiResponse apiResponse = await penaltyRepo.updatePenalty(PenaltyNotifiedData[i].PenaltyRequestID,
        PenaltyNotifiedData[i].FK_EmpCode, status, reason);
    if (apiResponse.response.statusCode == 200) {
      PenaltyNotifiedData.removeAt(i);
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
          duration: Duration(seconds: 1),
        ))
        .closed
        .then((value) => pressAttentionChangeColor);
    notifyListeners();
  }

  Future<ResponseModel> sendPenaltyRequest(
      {required String RequestedEmpCode,
       required String penaltyType,
       required String affectiveDate,
       required penaltyReason,
       required BuildContext context}) async {
    ResponseModel responseModel;
    String errorMessage = 'error';
      ApiResponse apiResponse = await penaltyRepo.sendPenaltyRequest(
          RequestedEmpCode: RequestedEmpCode,
          penaltyType: penaltyType,
          affectiveDate: affectiveDate,
          penaltyReason: penaltyReason);
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
