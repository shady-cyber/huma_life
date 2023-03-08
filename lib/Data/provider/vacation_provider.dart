import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:huma_life/Data/model/vacations_history.dart';
import 'package:huma_life/Data/repository/response_model.dart';
import '../../Common/screens/view/custom_snackbar.dart';
import '../model/vacations.dart';
import '../repository/vacation_repo.dart';
import '../response/base/api_response.dart';
import 'package:mime/mime.dart';

class VacationProvider extends ChangeNotifier {
  final VacationRepo vacationRepo;
  bool VacHistoryIsLoading = true;
  bool ShowHistoryList = false;

  VacationProvider({required this.vacationRepo});

  int vacationType = 1;
  List<Vacation> vacationList = [];
  List<RequestHistory> vacationHistoryList = [];

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

  Future<void> getVacationList() async {
    ApiResponse apiresponse = await vacationRepo.getVacationList();
    vacationList.clear();
    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          vacationList.add(Vacation.fromJson(apiresponse.response.data[i]));
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
      duration: Duration(seconds: 1),
        ))
        .closed
        .then((value) => pressAttentionChangeColor);
    notifyListeners();
  }

  Future<void> showVacList(String vacationId, String type) async {
    Future.delayed(Duration(milliseconds: 1)).then((value) async {
      await getHistoryList(vacationId, ShowHistoryList, type);
      bool VacationShow = await getHistoryList(vacationId, ShowHistoryList, type);
      if (VacationShow != true) {
        ShowHistoryList = false;
      } else {
        ShowHistoryList = true;
      }
    });
  }

  Future<bool> getHistoryList(
      String requestId, bool ShowHistoryList, String type) async {
    vacationHistoryList.clear();
    ShowHistoryList = false;
    ApiResponse apiresponse = await vacationRepo.getHistoryList(requestId, type);

    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          vacationHistoryList.add(RequestHistory.fromJson(apiresponse.response.data[i]));
          ShowHistoryList = true;
        }
        VacHistoryIsLoading = false;
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
    return ShowHistoryList;
  }

  Future<ResponseModel> sendVacationRequest(
      {required String fromDate,
      required String toDate,
      String? reason,
      required BuildContext context}) async {
    var x = DateTime.parse(fromDate).compareTo(DateTime.parse(toDate));
    ResponseModel responseModel;
    String errorMessage = 'error';
    if (DateTime.parse(fromDate).compareTo(DateTime.parse(toDate)) <= 0) {
      ApiResponse apiResponse = await vacationRepo.sendVacationRequest(
          fromDate: fromDate,
          toDate: toDate,
          reason: reason,
          type: vacationType);
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        responseModel = ResponseModel('', true);
      } else {
        showCustomSnackBar(apiResponse.error.errors[0].message, context);
        responseModel = ResponseModel(errorMessage, false);
      }
    } else {
      showCustomSnackBar('Date from must be less than date to', context);
      responseModel = ResponseModel(errorMessage, false);
    }
    return responseModel;
  }
}
