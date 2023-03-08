import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Common/screens/view/custom_snackbar.dart';
import 'package:huma_life/Data/database/db/attendanceDB.dart';
import 'package:huma_life/Data/database/helper/common.dart';
import 'package:huma_life/Data/database/model/attendance_model.dart';
import 'package:huma_life/Data/model/employee_model.dart';
import 'package:huma_life/Data/model/missed_attendance.dart';
import 'package:huma_life/Data/repository/attendance_repo.dart';
import 'package:huma_life/Data/repository/auth_repo.dart';
import 'package:huma_life/Data/repository/response_model.dart';
import 'package:huma_life/Data/response/base/error_response.dart';
import 'package:huma_life/Employee/screens/Attendance/check_out_custom_dialog.dart';
import 'package:huma_life/Common/Util/constant.dart';
import '../../Employee/screens/Attendance/missing-checkedout.dart';
import '../model/attendance_history.dart';
import '../response/base/api_response.dart';

class AttendanceProvider with ChangeNotifier {
  final AttendanceRepo attendanceRepo;
  final AuthRepo authRepo;

  Color main_button_color = kMainColor;
  bool AttendanceHistoryIsLoading = true;
  bool QrOptions = false;
  bool LocationOptions = false;
  bool _isLoading = false;
  bool enabled = true;
  int Empcode = 0;

  final AttendanceDB attendanceDB = AttendanceDB();

  List<AttendanceModel> attendanceList = [];
  List<MissedAttendance> MissedAttendanceList = [];
  List<AttendanceHistory> attendanceHistoryList = [];
  Map<String, dynamic> attendanceConfigList = new Map();

  bool get isLoading => _isLoading;
  static String otp = "";
  static String qr = "1234";
  String buttonText = "Check-In";
  String longitude = "";
  String latitude = "";
  String _loginErrorMessage = '';
  String get loginErrorMessage => _loginErrorMessage;

  AttendanceProvider({required this.attendanceRepo, required this.authRepo});

  /** location permission **/
  initPlatformState({required BuildContext context}) async {
    final detectLocation =
        await (attendanceRepo.requestPermissionGranted(Permission.location));
    if (!detectLocation) {
      Navigator.pop(context);
    }
  }

  Future<ResponseModel> HandleQrCardResponse(ApiResponse apiResponse, BuildContext context) async{
    ResponseModel responseModel = ResponseModel('', true);
      String responseMessage;
      if(apiResponse.response != "") {
        Map map = apiResponse.response.data;
        if (apiResponse.response.statusCode == 200) {
          responseModel = ResponseModel('', true);
          responseMessage = map['message'];
          showDialog(context: context,
              builder: (_) =>
                  AppWidget().showDialogQrCardState(
                      "success", responseMessage));
        }
        else if (apiResponse.response.statusCode == 404) {
          // employee not found
          responseModel = ResponseModel('', true);
          responseMessage = map['message'];
          showDialog(context: context,
              builder: (_) =>
                  AppWidget().showDialogQrCardState("failed", responseMessage));
        }
        else if (apiResponse.response.statusCode == 401) {
          // this employee not reporting to you
          responseModel = ResponseModel('', true);
          responseMessage = map['message'];
          showDialog(context: context,
              builder: (_) =>
                  AppWidget().showDialogQrCardState("failed", responseMessage));
        }
      }
      else {
        responseModel = ResponseModel('', true);
        ErrorResponse errorResponse = apiResponse.error;
        responseMessage = errorResponse.errors[0].message;
        showDialog(context: context,
            builder: (_) =>
                AppWidget().showDialogQrCardState("failed", responseMessage));
      }
      notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> ConfirmAttend(ApiResponse apiResponse, BuildContext context) async {
    _isLoading = false;
    ResponseModel responseModel;
    ErrorResponse errorResponse = apiResponse.error;
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      responseModel = ResponseModel('', true);
      showCustomSnackBar('Check-In Successfully'.tr(), context, isError: false);

      //save data into sqlite database
      await attendanceDB.insertAttendance(AttendanceModel(
        empCode: authRepo.getEmpCode(),
        empCheckInDate: DateTime.now().toString(),
        empCheckOutDate: '',
      ));
      attendanceRepo.setCheckInTime(DateTime.now());
      attendanceSwitcher();
    } else if ((errorResponse.errors[0].message == "You have missed check out")) {
      responseModel = ResponseModel('Miss CheckOut', false);
      getUnCheckedOutDate(context);
      return responseModel;
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
        showCustomSnackBar(errorMessage, context, isError: true);
      } else {
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
        showCustomSnackBar(errorMessage, context, isError: true);
      }
      _loginErrorMessage = errorMessage;
      responseModel = ResponseModel(errorMessage, false);
    }
    notifyListeners();
    return responseModel;
  }

  Future<String> getLocations(BuildContext context) async {
    String loc = "";

    if (await Permission.location.request().isGranted) {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(position.longitude); //Output: 80.24599079
      print(position.latitude);
      longitude = position.longitude.toString(); //Output: 29.6593457
      latitude = position.latitude.toString(); //Output: 29.6593457
      loc = longitude + " , " + latitude;
    } else {
      showCustomSnackBar('Please enable Location permission', context,
          isError: true);
    }
    return loc;
  }

  Future<void> checkIn({required BuildContext context}) async {
    _isLoading = true;
    _loginErrorMessage = '';

    String qrOp = "0";
    String check_date = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    attendanceConfigList.forEach((key, value) {
      if (key == "QROption") {
        qrOp = value;
      }
    });
    if (qrOp == "1") {
      otp = await Common().scanQR(context);
      await attendanceRepo.setLocation(latitude, longitude);
      ApiResponse apiResponse = (await attendanceRepo.checkIn(
          otp: otp, longitude: longitude, latitude: latitude, checkDate: check_date)) as ApiResponse;
      ConfirmAttend(apiResponse, context);
      // });
    } else {
      otp = "123456";
      await attendanceRepo.setLocation(latitude, longitude);
      ApiResponse apiResponse = (await attendanceRepo.checkIn(
          otp: otp, longitude: longitude, latitude: latitude, checkDate: check_date)) as ApiResponse;
      ConfirmAttend(apiResponse, context);
    }
  }

  Future<void> checkInWithQrCard({required BuildContext context}) async {
      qr = await Common().scanQR(context);
        qr = qr.toUpperCase();
      ApiResponse apiResponse = (await attendanceRepo.checkInWithQrCard(context: context, QRCode: qr)) as ApiResponse;
      HandleQrCardResponse(apiResponse, context);
  }

  Future<void> setLatLang(BuildContext context, double lat, double lang) async {
    setLatitude(attendanceRepo.getLatitude());
    setLongitude(attendanceRepo.getLatitude());
    int EmpCode = getEmpCode();
    bool QROption = getQrOption();
    bool LocationOption = getLocationOption();
    attendanceConfig(EmpCode, QROption, LocationOption, lat, lang);
    Navigator.pop(context);
    showCustomSnackBar("Employee Configuration Successfully Changed".tr(), context,
        isError: false);
  }

  Future<void> attendanceSwitcher() async {
    attendanceDB.getAttendanceByCurrentDay(authRepo.getEmpCode()).then((value) {
      if (value.length == 0) {
        buttonText = "Check-In".tr();
        main_button_color = kMainColor;
        notifyListeners();
      } else {
        attendanceList = value;
        buttonText = "Check-Out".tr();
        main_button_color = Colors.red;
      }
    });

    Future<void>.delayed(const Duration(milliseconds: 10), () {
      notifyListeners();
    });
  }

  Future<void> CheckedOutChoice(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CheckOutCustomDialog(),
    );
  }

  Future<void> getConfiguration() async {
    ApiResponse apiResponse =
        (await attendanceRepo.getConfiguration()) as ApiResponse;
    if (apiResponse.response.statusCode == 200) {
      attendanceConfigList = apiResponse.response!.data;
      notifyListeners();
    }
  }

  Future<void> getUnCheckedOutDate(BuildContext context) async {
    ApiResponse apiResponse =
        (await attendanceRepo.missedCheckOut()) as ApiResponse;
    List list = apiResponse.response!.data;
    List<AttendanceModel> attendanceModel = [];
    list.forEach((element) {
      attendanceModel.add(AttendanceModel.fromJson(element));
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AttendanceListCheckOut(attendanceModel, attendanceModel.length)),
    );
  }

  Future<void> updateAttendance(
      BuildContext context,
      int i,
      String status,
      int statusId,
      String? reason,
      String FK_InOutSignID,
      String? DateCheckout,
      String? CheckOutTime) async {
    ApiResponse apiResponse = (await attendanceRepo.updateAttendance(
        MissedAttendanceList[i].attendanceRequestID,
        MissedAttendanceList[i].EmployeeCode,
        status,
        MissedAttendanceList[i].RequestStatusID,
        reason,
        FK_InOutSignID,
        DateCheckout,
        CheckOutTime)) as ApiResponse;
    if (apiResponse.response.statusCode == 200) {
      MissedAttendanceList.removeAt(i);
      showCustomSnackBar("Missed Attendance Notified Successfully".tr(), context,
          isError: false);
      if (MissedAttendanceList.length == 0) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
              content: Text(
                'Missed Attendance Notified Successfully'.tr(),
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
            ))
            .closed
            .then((value) => Navigator.of(context));
      }
      notifyListeners();
    } else {
      showCustomSnackBar(apiResponse.response.errors[0].message, context,
          isError: true);
    }
  }

  Future<bool> getMissedAttendanceList(bool showList) async {
    ApiResponse apiResponse =
        (await attendanceRepo.getMissedAttendanceList()) as ApiResponse;
    if (apiResponse.response.statusCode == 200) {
      MissedAttendanceList.clear();
      apiResponse.response.data.forEach((element) {
        MissedAttendanceList.add(MissedAttendance.fromJson(element));
        showList = true;
      });
      _isLoading = false;
      notifyListeners();
    } else {}
    return showList;
  }

  Future<bool> checkAttendance() async {
    bool isCheckOut = false;
    attendanceDB.getAttendanceByCurrentDay(authRepo.getEmpCode()).then((value) {
      if (value.length == 0) {
        isCheckOut = false;
      } else {
        attendanceList = value;
        if (value[0].empCheckOutDate != "") {
          isCheckOut = true;
        } else {
          isCheckOut = false;
        }
      }
    });
    return isCheckOut;
  }

  Future<bool> CheckOutOldDay(
      String date, String reason, String signOutDate, int id) async {
    await attendanceRepo
        .checkOutOldDay(
            RequestDate: date,
            reason: reason,
            signOutDate: signOutDate,
            FK_InOutSignID: id)
        .then((value) {
      if (value.response!.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
    notifyListeners();
    return true;
  }

  Future<bool> attendanceConfig(int? EmpCode, bool? QROption,
      bool? LocationOption, double? Longitude, double? Latitude) async {
    await attendanceRepo
        .attendanceConfig(
            EmpCode: EmpCode,
            QROption: QROption,
            LocationOption: LocationOption,
            Longitude: Longitude,
            Latitude: Latitude)
        .then((value) {
      if (value.response!.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
    return true;
  }

  Future<bool> getAttendanceHistoryList(
      String attendanceId, bool ShowHistoryList) async {
    attendanceHistoryList.clear();
    ShowHistoryList = false;
    ApiResponse apiresponse = (await attendanceRepo
        .getAttendanceHistoryList(attendanceId)) as ApiResponse;

    if (apiresponse.response.statusCode == 200) {
      try {
        for (var i = 0; i < apiresponse.response.data.length; i++) {
          attendanceHistoryList
              .add(AttendanceHistory.fromJson(apiresponse.response.data[i]));
          ShowHistoryList = true;
        }
        AttendanceHistoryIsLoading = false;
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
    return ShowHistoryList;
  }

  Future<double> setLatitude(var lat) async {
    double Latitude = lat;
    return Latitude;
  }

  Future<double> setLongitude(var lng) async {
    double Longitude = lng;
    return Longitude;
  }

  Future<List<EmployeeModel>> getEmployeeList(BuildContext context) async {
    ApiResponse apiResponse =
        (await attendanceRepo.getEmployeeList()) as ApiResponse;
    List list = apiResponse.response!.data;
    List<EmployeeModel> employeeModel = [];
    list.forEach((element) {
      employeeModel.add(EmployeeModel.fromJson(element));
    });
    return employeeModel;
  }


  Future<void> selectInTimeMethod({required BuildContext context, required TimeOfDay selectedInTime, required bool inTimeSelected}) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedInTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedInTime) {(()=> {
        selectedInTime = timeOfDay,
      });
      inTimeSelected = true;
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  Future<void> selectOutTimeMethod({required BuildContext context, required TimeOfDay selectedOutTime, required bool outTimeSelected}) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedOutTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedOutTime) {
      (() => {
      selectedOutTime = timeOfDay,
      });
      outTimeSelected = true;
    }
  }


  Future<void> showAttList({required String attendanceId, required bool ShowHistoryList}) async {
      Future.delayed(Duration(milliseconds: 1)).then((value) async {
      await getAttendanceHistoryList(attendanceId, ShowHistoryList);
      bool VacationShow =
          await getAttendanceHistoryList(attendanceId, ShowHistoryList);
      if (VacationShow != true) {
      ShowHistoryList = false;
      } else {
      ShowHistoryList = true;
      }
    });
  }

  void checkOut(BuildContext context) async {
    Object? lastCheckInTime = attendanceRepo.getLastCheckInTime();
    String qrOp = "0";
    attendanceConfigList.forEach((key, value) {
      if (key == "QROption") {
        qrOp = value;
      }
    });

    if (qrOp == "1") {
      otp = await Common().scanQR(context);
    } else if (qrOp == "0") {
      otp == "123456";
    } else {
      otp == "";
      return;
    }

    if (lastCheckInTime != null) {
      DateTime lastCheckIn = DateTime.parse(lastCheckInTime.toString());
      String checkDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
      DateTime currentTime = DateTime.now();
      Duration difference = currentTime.difference(lastCheckIn);
      if (difference.inMinutes > 5) {
        _isLoading = true;
        _loginErrorMessage = '';
        ApiResponse apiResponse = (await attendanceRepo.checkOut(
            token: attendanceRepo.getToken(),
            checkDate: checkDate)) as ApiResponse;
        if (apiResponse.response == null) {
          showCustomSnackBar('Please check internet connection'.tr(), context,
              isError: true);
        } else if (apiResponse.response.statusCode == 200) {
          int id = attendanceList[0].id?.toInt() ?? 0;
          attendanceDB.deleteAttendance(id);
        }
        _isLoading = false;
        attendanceSwitcher();
        notifyListeners();
      } else {
        showCustomSnackBar(
            'Please wait at least 5 minutes to check-out'.tr(), context,
            isError: true);
        notifyListeners();
      }
    }
  }

  void showMessage(String message, BuildContext context) {
    showCustomSnackBar(message, context, isError: true);
  }

  int setEmpCode(int empCode) {
    Empcode = empCode;
    return empCode;
  }

  int getEmpCode() {
    return Empcode;
  }

  bool setQROption(bool QrOption) {
    QrOptions = QrOption;
    return QrOption;
  }

  bool setLocationOption(bool LocationOption) {
    LocationOptions = LocationOption;
    return LocationOption;
  }

  bool getQrOption() {
    return QrOptions;
  }

  bool getLocationOption() {
    return LocationOptions;
  }
}
