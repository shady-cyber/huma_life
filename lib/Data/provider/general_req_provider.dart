import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:huma_life/Data/repository/generalRequest_repo.dart';
import 'package:huma_life/Data/repository/response_model.dart';
import '../../Common/screens/view/custom_snackbar.dart';
import '../model/general_notification.dart';
import '../response/base/api_response.dart';
import 'package:mime/mime.dart';

class GeneralRequestProvider extends ChangeNotifier {
  final GeneralRequestRepo generalRequestRepo;
  bool LoanHistoryIsLoading = true;
  bool ShowHistoryList = false;
  bool isLoading = true;
  bool showBadge = false;
  List<GeneralNotify> generalNotifiedList = [];

  GeneralRequestProvider({required this.generalRequestRepo});

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

  Future<void> getGeneralNotifiedList() async {
    ApiResponse apiresponse = (await generalRequestRepo.getGeneralNotifiedList()) as ApiResponse;
    generalNotifiedList.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          generalNotifiedList.add(GeneralNotify.fromJson(apiresponse.response.data[i]));
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

  Future<ResponseModel> sendGeneralRequest(
      {
        required String title,
        required String description,
      required BuildContext context}) async {
    ResponseModel responseModel;
    String errorMessage = 'error';
      ApiResponse apiResponse = (await generalRequestRepo.sendGeneralRequest(
          title: title,
          description: description)) as ApiResponse;
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        responseModel = ResponseModel('', true);
      } else {
        showCustomSnackBar(apiResponse.error.errors[0].message, context);
        responseModel = ResponseModel(errorMessage, false);
      }
    return responseModel;
    }

  Future<void> updateGeneral(BuildContext context, int i, String status, String? reason) async {
    ApiResponse apiResponse = (await generalRequestRepo.updateGeneral(generalNotifiedList[i].RequestID,
        generalNotifiedList[i].FK_EmpCode, status, reason)) as ApiResponse;
    if (apiResponse.response.statusCode == 200) {
      generalNotifiedList.removeAt(i);
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

}
