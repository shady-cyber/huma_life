import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:huma_life/Common/Util/html_template.dart';
import 'package:huma_life/Common/screens/view/custom_snackbar.dart';
import 'package:huma_life/Data/model/employee_model.dart';
import 'package:huma_life/Data/model/print_card_model.dart';
import 'package:huma_life/Data/model/request_vacaiton_model.dart';
import 'package:huma_life/Data/repository/employee_repo.dart';
import 'package:huma_life/Data/response/base/api_response.dart';

class EmployeeProvider with ChangeNotifier {
  final EmployeeRepo employeeRepoRepo;

  EmployeeProvider({required this.employeeRepoRepo});

  bool mark = false;
  bool markCard = false;
  bool Approved_box_show = false;
  bool isLoading = true;
  bool isLoadingCards = true;
  bool removeCheckedCard = false;
  bool removeChecked = false;
  bool statusCancel = false;
  bool showList = false;
  bool showBadge = false;
  DateTime selectedDate = DateTime.now();
  List<EmployeeModel> employeeModel = [];
  List<CardModel> cardModel = [];
  List<CardModel> cardModelTemp = [];
  List<RequestVacationModel> requestVacationModel = [];
  List<int> userChecked = [];
  List<int> userCheckedCards = [];
  int counter = 0;
  dynamic initi = 0;

  void onSelected(bool selected, int empCode) {
    if (selected == true) {
      userChecked.add(empCode);
      removeChecked = false;
      notifyListeners();
    } else {
      userChecked.remove(empCode);
      if (userChecked.isEmpty) {
        removeChecked = true;
      } else {
        removeChecked = false;
      }
      notifyListeners();
    }
  }

  void onSelectedCards(bool selected, int empCode) {
    if (selected == true) {
      userCheckedCards.add(empCode);
      removeCheckedCard = false;
      notifyListeners();
    } else {
      userCheckedCards.remove(empCode);
      if (userCheckedCards.isEmpty) {
        removeCheckedCard = true;
      } else {
        removeCheckedCard = false;
      }
      notifyListeners();
    }
  }

  Future<bool> getEmployeeList(BuildContext context, String type) async {
    ApiResponse apiResponse = await employeeRepoRepo.getEmployeeList();
    if (apiResponse.response.statusCode == 200) {
      employeeModel.clear();

      apiResponse.response.data.forEach((element) {
          employeeModel.add(EmployeeModel.fromJson(element));
      });

      if(type == 'penalty') {
        for (final element in apiResponse.response.data) {
          employeeModel.add(EmployeeModel.initial(element));
          break;
        }
      }
      isLoading = false;
      isLoadingCards = false;
      showList = true;
      notifyListeners();
    }
    return showList;
  }

  Future<List<CardModel>> getEmployeeListForPrint() async {
    ApiResponse apiResponse = await employeeRepoRepo.getEmployeeListForPrint();
    if (apiResponse.response.statusCode == 200) {
      cardModel.clear();
      apiResponse.response.data.forEach((element) {
        cardModel.add(CardModel.fromJson(element));
      });
      isLoading = false;
      isLoadingCards = false;
      notifyListeners();
    } else {}
    return cardModel;
  }

  Future<void> getVacationsList() async {
    ApiResponse apiResponse = await employeeRepoRepo.getVacationsList();
    if (apiResponse.response.statusCode == 200) {
      requestVacationModel.clear();
      for(var v in apiResponse.response.data.values) {
        v.asMap().forEach((i, value) {
          requestVacationModel.add(RequestVacationModel.fromJson(value));
        });
      }

      if(apiResponse.response.data.values.toString() == "([])"){
        showBadge = false;
      } else {
        showBadge = true;
      }
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    showBadge = false;
    notifyListeners();
  }

  void notifyAll(){
    notifyListeners();
  }

  Future<void> addEmpCards(BuildContext context) async {
    List<CardModel> cardModelList = await getEmployeeListForPrint();
    List json = userCheckedCards.map((e) => e.toString()).toList();
    for (var m in json) {
      for (int i = 0; i < cardModelList.length; i++) {
        for (CardModel items in cardModelList) {
          if (m == items.employeeId.toString()) {
            cardModelTemp.add(items);
            i++;
            break;
          }
        }
        break;
      }
    }
  }

  Future<void> addAttendance(BuildContext context, bool isHolding,
      bool isPresent, TimeOfDay selectedInTime,
      TimeOfDay selectedOutTime) async {
    var json = userChecked.map((e) => e.toString()).toList();
    DateTime inTime = DateTime(this.selectedDate.year, this.selectedDate.month,
        this.selectedDate.day, selectedInTime.hour, selectedInTime.minute);
    DateTime outTime = DateTime(this.selectedDate.year, this.selectedDate.month,
        this.selectedDate.day, selectedOutTime.hour, selectedOutTime.minute);
    String selectedDate =
        "${this.selectedDate.year}-${this.selectedDate.month}-${this
        .selectedDate.day}";
    ApiResponse apiResponse = await employeeRepoRepo.addMarkAttendance(
        "signIn", selectedDate, inTime.toString(), outTime.toString(), json);
    if (apiResponse.response.statusCode == 200) {
      ScaffoldMessenger
          .of(context)
          .showSnackBar(SnackBar(
        content: Text(
          "Attendance Successfully for Selected staff",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ))
          .closed
          .then((value) => Navigator.pop(context));
      mark = false;
      userChecked.clear();
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.response.errors[0].message, context,
          isError: true);
    }
    mark = false;
    userChecked.clear();
    notifyListeners();
  }

  Future<bool> clearData() async {
    mark = false;
    markCard = false;
    userChecked.clear();
    userCheckedCards.clear();
    cardModel.clear();
    cardModelTemp.clear();
    notifyListeners();
    return true;
  }

  Future<void> updateVacation(BuildContext context, int i, String status, String? reason) async {
    ApiResponse apiResponse = await employeeRepoRepo.updateVacation(requestVacationModel[i].VacRequestID,
        requestVacationModel[i].VacEmpCode, status, reason);
    if (apiResponse.response.statusCode == 200) {
      requestVacationModel.removeAt(i);
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
    }
    else {
      showCustomSnackBar(apiResponse.response.errors[0].message, context,
          isError: true);
    }
  }

  String EncryptSHAQr(String data) {
    var data1 = data + "Rrkn7hUrbQGJZNOq";
    var bytes1 = utf8.encode(data1); // data being hashed
    var digest1 = sha256.convert(bytes1);
    String result = digest1.toString();
    return result;
  }

  void printEmpCard() async {
    String htmlTemplate = HtmlTemplate.htmlCode;
    int indexer = 0;
    for (int i = 0; i < userCheckedCards.length; i++) {
       String imgPath = "";
      if(cardModelTemp[i].employeeImage.startsWith("http")){
        imgPath = cardModelTemp[i].employeeImage;
      }else{
      var imageBytes = base64Decode(cardModelTemp[i].employeeImage);
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = File('$path/employeeImage' + i.toString() + '.png');
      await file.writeAsBytes(imageBytes);
        imgPath = "file:///" + file.path;
      }
      htmlTemplate +=
      ' <div class="card"> <div class="row"> <div class="img-section">';
      htmlTemplate += '<img src="' + imgPath +
          '" alt="Avatar"></div>';
      htmlTemplate +=
          '<div class="data-section"><p>Name: ' + cardModelTemp[i].employeeNameE +
              '</p> <p>Location: ' + cardModelTemp[i].employeeLocationEn +
              '</p><p> Position: ' + cardModelTemp[i].employeePositionE + '</p>'
              '<p>EmpCode: ' + cardModelTemp[i].employeeId.toString() +
              '</p> </div> </div>';
      htmlTemplate += '<div class="qr-section">';
      htmlTemplate +=
          '<img src="https://api.qrserver.com/v1/create-qr-code/?size=80x80&data=' +
              EncryptSHAQr(cardModelTemp[i].employeeId.toString()) +
              '" alt="Avatar"></div>';
      htmlTemplate +=
          '<div class="footer"><p>' + cardModelTemp[i].employeeCompanyName +
              ' <br> ' + cardModelTemp[i].employeeIqamaNo + '</p></div></div>';

      if (indexer == 5) {
        htmlTemplate += '</div><div class="line-break"></div><div class="container">';
        indexer = -1;
      }
      indexer++;
    }
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    final targetFileName = "employeeCards";

    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlTemplate, targetPath, targetFileName);

     OpenFilex.open(generatedPdfFile.path);
  }


}
