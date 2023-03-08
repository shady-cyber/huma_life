import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Admin/screens/Home/HomeScreenAdmin.dart';
import 'package:huma_life/Admin/screens/Management/ClearanceManagement.dart';
import 'package:huma_life/Admin/screens/Management/ClearanceSubManagement.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:huma_life/Common/screens/Authentication/Sign_In.dart';
import 'package:huma_life/Common/screens/CashInAdvance/CashInAdvanceScreen.dart';
import 'package:huma_life/Common/screens/Clearance/EmployeeClearance.dart';
import 'package:huma_life/Common/screens/GeneralRequest/GeneralRequestScreen.dart';
import 'package:huma_life/Common/screens/LanguageSelection/Language.dart';
import 'package:huma_life/Common/screens/Loan/EmployeeLoan.dart';
import 'package:huma_life/Common/screens/LoanDelay/EmployeeLoanDelay.dart';
import 'package:huma_life/Common/screens/Penalty/EmployeePenalty.dart';
import 'package:huma_life/Common/screens/Vacation/RequestVacationScreen.dart';
import 'package:huma_life/Data/provider/clearance_provider.dart';
import 'package:huma_life/Data/provider/connection_string_provider.dart';
import 'package:huma_life/Data/provider/general_req_provider.dart';
import 'package:huma_life/Data/provider/penalty_provider.dart';
import 'package:huma_life/Employee/screens/Home/HomeScreenEmployee.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:huma_life/Admin/screens/Management/AttendanceEmployeeList.dart';
import 'package:huma_life/Admin/screens/Management/AttendanceLocationMap.dart';
import 'package:huma_life/Admin/screens/Management/DecisionAttendanceHistoryList.dart';
import 'package:huma_life/Admin/screens/Management/DecisionHistoryList.dart';
import 'package:huma_life/Admin/screens/Management/DesisionAttendanceHistory.dart';
import 'package:huma_life/Admin/screens/Management/DesisionHistory.dart';
import 'package:huma_life/Admin/screens/Management/EmployeeManagement.dart';
import 'package:huma_life/Admin/screens/Management/LeaveManagement.dart';
import 'package:huma_life/Admin/screens/Management/MissingAttendanceManagement.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Common/Util/shimmer.dart';
import 'package:huma_life/Common/screens/Authentication/Select_Type.dart';
import 'package:huma_life/Common/screens/GlobalComponents/button_global.dart';
import 'package:huma_life/Common/screens/PersonalInfo/EmployeeCard.dart';
import 'package:huma_life/Common/screens/PersonalInfo/ProfileScreen.dart';
import 'package:huma_life/Common/screens/PersonalInfo/SettingScreen.dart';
import 'package:huma_life/Common/screens/TermsAndConditions//PrivacyPolicy.dart';
import 'package:huma_life/Common/screens/TermsAndConditions//TermsOfServices.dart';
import 'package:huma_life/Common/screens/view/custom_snackbar.dart';
import 'package:huma_life/Data/provider/account_provider.dart';
import 'package:huma_life/Data/provider/attendance_provider.dart';
import 'package:huma_life/Data/provider/employee_provider.dart';
import 'package:huma_life/Data/provider/profile_provider.dart';
import 'package:huma_life/Data/provider/vacation_provider.dart';
import 'package:huma_life/Employee/screens/Attendance/attendance.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

import '../../Admin/screens/Management/CashRequestManagement.dart';
import '../../Admin/screens/Management/GeneralRequestManagement.dart';
import '../../Admin/screens/Management/LoanDelayManagement.dart';
import '../../Admin/screens/Management/LoanManagement.dart';
import '../../Admin/screens/Management/PenaltyManagement.dart';
import '../../Admin/screens/Management/PenaltyNotification.dart';
import '../../Data/provider/cash_provider.dart';
import '../../Data/provider/loan_delay_provider.dart';
import '../../Data/provider/loan_provider.dart';

class AppWidget extends ChangeNotifier {
  BoxDecoration boxDecoration(
      {double radius = 2,
      Color color = Colors.transparent,
      Color? bgColor,
      var showShadow = false}) {
    return BoxDecoration(
      color: bgColor,
      boxShadow: showShadow
          ? defaultBoxShadow(shadowColor: shadowColorGlobal)
          : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    );
  }

  Widget text(
    String? text, {
    var fontSize = 18.0,
    Color? textColor,
    var fontFamily,
    var isCentered = false,
    var maxLine = 1,
    var latterSpacing = 0.5,
    bool textAllCaps = false,
    var isLongText = false,
    bool lineThrough = false,
  }) {
    return Text(
      textAllCaps ? text!.toUpperCase() : text!,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      maxLines: isLongText ? null : maxLine,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: fontFamily ?? null,
        fontSize: fontSize,
        color: textColor,
        height: 1.5,
        letterSpacing: latterSpacing,
        decoration:
            lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    );
  }

  BoxDecoration boxDecorations(
      {double radius = 2,
      Color color = Colors.transparent,
      Color? bgColor,
      var showShadow = false}) {
    return BoxDecoration(
      color: bgColor ?? Colors.white,
      boxShadow: showShadow
          ? defaultBoxShadow(shadowColor: shadowColorGlobal)
          : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    );
  }

  void changeStatusColor(Color color) async {
    setStatusBarColor(color);
  }

  Padding editTextStyle(var hintText, {var line = 1}) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: TextFormField(
          maxLines: line,
          style: TextStyle(
            fontSize: textSizeMedium,
            fontFamily: fontRegular,
          ),
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.fromLTRB(spacing_standard_new, 16, 4, 16),
            hintText: hintText,
            filled: true,
            fillColor: kDarkWhite,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(spacing_middle),
              borderSide: BorderSide(color: kDarkWhite, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(spacing_middle),
              borderSide: BorderSide(color: kDarkWhite, width: 0.0),
            ),
          ),
        ));
  }

  Widget svCommonCachedNetworkImage(
    String? url, {
    double? height,
    double? width,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    bool usePlaceholderIfUrlEmpty = true,
    double? radius,
    Color? color,
  }) {
    if (url!.validate().isEmpty) {
      return placeHolderWidget(
          height: height,
          width: width,
          fit: fit,
          alignment: alignment,
          radius: radius);
    } else if (url.validate().startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        fit: fit,
        color: color,
        alignment: alignment as Alignment? ?? Alignment.center,
        errorWidget: (_, s, d) {
          return placeHolderWidget(
              height: height,
              width: width,
              fit: fit,
              alignment: alignment,
              radius: radius);
        },
        placeholder: (_, s) {
          if (!usePlaceholderIfUrlEmpty) return SizedBox();
          return placeHolderWidget(
              height: height,
              width: width,
              fit: fit,
              alignment: alignment,
              radius: radius);
        },
      );
    } else {
      return svCommonCachedNetworkImage(url,
              height: height,
              width: width,
              fit: fit,
              alignment: alignment ?? Alignment.center)
          .cornerRadiusWithClipRRect(radius ?? defaultRadius);
    }
  }

  Widget placeHolderWidget(
      {double? height,
      double? width,
      BoxFit? fit,
      AlignmentGeometry? alignment,
      double? radius}) {
    return Image.asset('assets/images/emp2.png',
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            alignment: alignment ?? Alignment.center)
        .cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }

  Future<void> showSheet(BuildContext aContext, int index, int EmpCode) async {
    int return_shared = Provider.of<AccountProvider>(aContext, listen: false)
        .authRepo
        .getShared(EmpCode);

    int Config = 0;
    if (return_shared != 0) {
      Config = return_shared;
    } else {
      Config = 2;
    }

    showModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: aContext,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Consumer<AttendanceProvider>(
            builder: (context, attendanceProvider, child) => Form(
              child: SafeArea(
                child: DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    maxChildSize: 1,
                    minChildSize: 0.4,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        padding: EdgeInsets.only(top: 20),
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                            color: context.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(26),
                                topRight: Radius.circular(26))),
                        child: Column(
                          children: [
                            Container(
                                color: Color(0XFFB4BBC2), width: 50, height: 3),
                            SizedBox(height: 20),
                            Expanded(
                              child: Container(
                                //create confirm dialog with text box
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text(
                                          "Select The Employee Attendance Config"
                                              .tr(),
                                          style: boldTextStyle(
                                              size: 18, color: kMainColor)),
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: EdgeInsets.only(left: 25),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Radio(
                                                      value: 0,
                                                      groupValue: Config,
                                                      onChanged: (index) {
                                                        Config = 0;
                                                        attendanceProvider
                                                            .notifyListeners();
                                                      }),
                                                  Expanded(
                                                    child: Text('Qr'.tr()),
                                                  )
                                                ],
                                              ),
                                              flex: 1,
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Radio(
                                                      value: 1,
                                                      groupValue: Config,
                                                      onChanged: (index) {
                                                        // _update(_count);
                                                        Config = 1;
                                                        attendanceProvider
                                                            .notifyListeners();
                                                      }),
                                                  Expanded(
                                                      child:
                                                          Text('Location'.tr()))
                                                ],
                                              ),
                                              flex: 1,
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Radio(
                                                      value: 2,
                                                      groupValue: Config,
                                                      onChanged: (index) {
                                                        Config = 2;
                                                        attendanceProvider
                                                            .notifyListeners();
                                                      }),
                                                  Expanded(
                                                      child: Text('Any'.tr()))
                                                ],
                                              ),
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      ButtonGlobal(
                                          buttontext: 'SAVE'.tr(),
                                          buttonDecoration: kButtonDecoration
                                              .copyWith(color: kMainColor),
                                          onPressed: () {
                                            Provider.of<AccountProvider>(
                                                    context,
                                                    listen: false)
                                                .authRepo
                                                .putShared(EmpCode, Config);

                                            bool QROption = true;
                                            bool LocationOption = true;
                                            // int xx = Config;
                                            if (Config == 0) {
                                              QROption;
                                              LocationOption = false;
                                            } else if (Config == 1) {
                                              LocationOption;
                                              QROption = false;
                                              attendanceProvider
                                                  .setEmpCode(EmpCode);
                                              attendanceProvider
                                                  .setQROption(QROption);
                                              attendanceProvider
                                                  .setLocationOption(
                                                      LocationOption);
                                            } else if (Config == 2) {
                                              QROption = false;
                                              LocationOption = false;
                                              attendanceProvider
                                                  .setEmpCode(EmpCode);
                                              attendanceProvider
                                                  .setQROption(QROption);
                                              attendanceProvider
                                                  .setLocationOption(
                                                      LocationOption);
                                            }

                                            if (LocationOption) {
                                              Navigator.pop(context);

                                              Future.delayed(
                                                  Duration(milliseconds: 500),
                                                  () => {
                                                        const AttendanceLocationMap()
                                                            .launch(aContext)
                                                      });
                                            } else if (QROption) {
                                              attendanceProvider
                                                  .attendanceConfig(
                                                      EmpCode,
                                                      QROption,
                                                      LocationOption,
                                                      0.0,
                                                      0.0);
                                              Navigator.pop(context);
                                              showCustomSnackBar(
                                                  "Employee Configuration Successfully Changed"
                                                      .tr(),
                                                  context,
                                                  isError: false);
                                            } else {
                                              attendanceProvider
                                                  .attendanceConfig(
                                                      EmpCode,
                                                      QROption,
                                                      LocationOption,
                                                      0.0,
                                                      0.0);
                                              Navigator.pop(context);
                                              showCustomSnackBar(
                                                  "Employee Configuration Successfully Changed"
                                                      .tr(),
                                                  context,
                                                  isError: false);
                                            }
                                            //Navigator.pop(context);
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          );
        });
  }

  Future<void> showLeaveSheet(BuildContext aContext, int index, String status,
      TextEditingController reasonController) async {
    showModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: aContext,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 1,
              minChildSize: 0.7,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(26))),
                  child: Column(
                    children: [
                      Container(color: Color(0XFFB4BBC2), width: 50, height: 3),
                      SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          //create confirm dialog with text box
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: [
                                status == "2"
                                    ? Text(
                                        "Are you sure approving this request"
                                            .tr(),
                                        style: boldTextStyle(
                                            size: 18, color: kMainColor))
                                    : Text(
                                        "Are you sure rejecting this request"
                                            .tr(),
                                        style: boldTextStyle(
                                            size: 18, color: kMainColor)),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: boxDecorationWithRoundedCorners(
                                      borderRadius: radius(20),
                                      backgroundColor: Colors.white70,
                                      border: Border.all(color: kAlertColor)),
                                  child: TextField(
                                    controller: reasonController,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Enter reason here".tr()),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: kAlertColor.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Cancel'.tr(),
                                            style: kTextStyle.copyWith(
                                              color: kAlertColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (status == "2") {
                                          Provider.of<EmployeeProvider>(context,
                                                  listen: false)
                                              .updateVacation(
                                                  aContext,
                                                  index,
                                                  status,
                                                  reasonController.text);
                                          Navigator.pop(context);
                                        } else if (status != "2" &&
                                            reasonController.text != "") {
                                          Provider.of<EmployeeProvider>(context,
                                                  listen: false)
                                              .updateVacation(
                                                  aContext,
                                                  index,
                                                  status,
                                                  reasonController.text);
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pop(context);
                                          showCustomSnackBar(
                                              "Please put your reason of rejection"
                                                  .tr(),
                                              context,
                                              isError: true);
                                        }
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: kMainColor),
                                        child: Center(
                                          child: Text(
                                            'Confirm'.tr(),
                                            style: kTextStyle.copyWith(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  Future<void> showGeneralSheet(BuildContext aContext, int index, String status,
      TextEditingController reasonController) async {
    showModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: aContext,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 1,
              minChildSize: 0.7,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(26))),
                  child: Column(
                    children: [
                      Container(color: Color(0XFFB4BBC2), width: 50, height: 3),
                      SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          //create confirm dialog with text box
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: [
                                status == "2"
                                    ? Text(
                                        "Are you sure approving this request"
                                            .tr(),
                                        style: boldTextStyle(
                                            size: 18, color: kMainColor))
                                    : Text(
                                        "Are you sure rejecting this request"
                                            .tr(),
                                        style: boldTextStyle(
                                            size: 18, color: kMainColor)),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: boxDecorationWithRoundedCorners(
                                      borderRadius: radius(20),
                                      backgroundColor: Colors.white70,
                                      border: Border.all(color: kAlertColor)),
                                  child: TextField(
                                    controller: reasonController,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Enter reason here".tr()),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: kAlertColor.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Cancel'.tr(),
                                            style: kTextStyle.copyWith(
                                              color: kAlertColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (status == "2") {
                                          Provider.of<GeneralRequestProvider>(
                                                  context,
                                                  listen: false)
                                              .updateGeneral(
                                                  aContext,
                                                  index,
                                                  status,
                                                  reasonController.text);
                                          Navigator.pop(context);
                                        } else if (status != "2" &&
                                            reasonController.text != "") {
                                          Provider.of<GeneralRequestProvider>(
                                                  context,
                                                  listen: false)
                                              .updateGeneral(
                                                  aContext,
                                                  index,
                                                  status,
                                                  reasonController.text);
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pop(context);
                                          showCustomSnackBar(
                                              "Please put your reason of rejection"
                                                  .tr(),
                                              context,
                                              isError: true);
                                        }
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: kMainColor),
                                        child: Center(
                                          child: Text(
                                            'Confirm'.tr(),
                                            style: kTextStyle.copyWith(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  Future<void> showLoanDelaySheet(BuildContext aContext, int index,
      String status, TextEditingController reasonController) async {
    showModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: aContext,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 1,
              minChildSize: 0.7,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(26))),
                  child: Column(
                    children: [
                      Container(color: Color(0XFFB4BBC2), width: 50, height: 3),
                      SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          //create confirm dialog with text box
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: [
                                status == "2"
                                    ? Text(
                                        "Are you sure approving this request"
                                            .tr(),
                                        style: boldTextStyle(
                                            size: 18, color: kMainColor))
                                    : Text(
                                        "Are you sure rejecting this request"
                                            .tr(),
                                        style: boldTextStyle(
                                            size: 18, color: kMainColor)),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: boxDecorationWithRoundedCorners(
                                      borderRadius: radius(20),
                                      backgroundColor: Colors.white70,
                                      border: Border.all(color: kAlertColor)),
                                  child: TextField(
                                    controller: reasonController,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Enter reason here".tr()),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: kAlertColor.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Cancel'.tr(),
                                            style: kTextStyle.copyWith(
                                              color: kAlertColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (status == "2") {
                                          Provider.of<LoanDelayProvider>(
                                                  context,
                                                  listen: false)
                                              .updateLoanDelay(
                                                  aContext,
                                                  index,
                                                  status,
                                                  reasonController.text);
                                          Navigator.pop(context);
                                        } else if (status != "2" &&
                                            reasonController.text != "") {
                                          Provider.of<EmployeeProvider>(context,
                                                  listen: false)
                                              .updateVacation(
                                                  aContext,
                                                  index,
                                                  status,
                                                  reasonController.text);
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pop(context);
                                          showCustomSnackBar(
                                              "Please put your reason of rejection"
                                                  .tr(),
                                              context,
                                              isError: true);
                                        }
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: kMainColor),
                                        child: Center(
                                          child: Text(
                                            'Confirm'.tr(),
                                            style: kTextStyle.copyWith(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  Future<void> showCashSheet(BuildContext aContext, int index, String status,
      TextEditingController reasonController) async {
    showModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: aContext,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 1,
              minChildSize: 0.7,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(26))),
                  child: Column(
                    children: [
                      Container(color: Color(0XFFB4BBC2), width: 50, height: 3),
                      SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          //create confirm dialog with text box
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: [
                                status == "2"
                                    ? Text(
                                        "Are you sure approving this request"
                                            .tr(),
                                        style: boldTextStyle(
                                            size: 18, color: kMainColor))
                                    : Text(
                                        "Are you sure rejecting this request"
                                            .tr(),
                                        style: boldTextStyle(
                                            size: 18, color: kMainColor)),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: boxDecorationWithRoundedCorners(
                                      borderRadius: radius(20),
                                      backgroundColor: Colors.white70,
                                      border: Border.all(color: kAlertColor)),
                                  child: TextField(
                                    controller: reasonController,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Enter reason here".tr()),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: kAlertColor.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Cancel'.tr(),
                                            style: kTextStyle.copyWith(
                                              color: kAlertColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (status == "2") {
                                          Provider.of<CashProvider>(context,
                                                  listen: false)
                                              .updateCash(
                                                  aContext,
                                                  index,
                                                  status,
                                                  reasonController.text);
                                          Navigator.pop(context);
                                        } else if (status != "2" &&
                                            reasonController.text != "") {
                                          Provider.of<CashProvider>(context,
                                                  listen: false)
                                              .updateCash(
                                                  aContext,
                                                  index,
                                                  status,
                                                  reasonController.text);
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pop(context);
                                          showCustomSnackBar(
                                              "Please put your reason of rejection"
                                                  .tr(),
                                              context,
                                              isError: true);
                                        }
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: kMainColor),
                                        child: Center(
                                          child: Text(
                                            'Confirm'.tr(),
                                            style: kTextStyle.copyWith(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  Future<void> showClearanceSheet(BuildContext aContext, int index, String status, String empCode,
      TextEditingController reasonController) async {
    showModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: aContext,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 1,
              minChildSize: 0.7,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(26))),
                  child: Column(
                    children: [
                      Container(color: Color(0XFFB4BBC2), width: 50, height: 3),
                      SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          //create confirm dialog with text box
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: [
                                status == "2"
                                    ? Text(
                                    "Are you sure approving this request"
                                        .tr(),
                                    style: boldTextStyle(
                                        size: 18, color: kMainColor))
                                    : Text(
                                    "Are you sure rejecting this request"
                                        .tr(),
                                    style: boldTextStyle(
                                        size: 18, color: kMainColor)),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: boxDecorationWithRoundedCorners(
                                      borderRadius: radius(20),
                                      backgroundColor: Colors.white70,
                                      border: Border.all(color: kAlertColor)),
                                  child: TextField(
                                    controller: reasonController,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Enter reason here".tr()),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15.0),
                                          color: kAlertColor.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Cancel'.tr(),
                                            style: kTextStyle.copyWith(
                                              color: kAlertColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (status == "2") {
                                          Provider.of<ClearanceProvider>(context,
                                              listen: false)
                                              .updateClearance(
                                              aContext,
                                              0,
                                              status,
                                              empCode,
                                              reasonController.text);
                                          Navigator.pop(context);
                                        } else if (status != "2" &&
                                            reasonController.text != "") {
                                          Provider.of<ClearanceProvider>(context,
                                              listen: false)
                                              .updateClearance(
                                              aContext,
                                              0,
                                              status,
                                              empCode,
                                              reasonController.text);
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pop(context);
                                          showCustomSnackBar(
                                              "Please put your reason of rejection"
                                                  .tr(),
                                              context,
                                              isError: true);
                                        }
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(15.0),
                                            color: kMainColor),
                                        child: Center(
                                          child: Text(
                                            'Confirm'.tr(),
                                            style: kTextStyle.copyWith(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  Future<void> showLoanSheet(BuildContext aContext, int index, String status,
      TextEditingController reasonController) async {
    showModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: aContext,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 1,
              minChildSize: 0.7,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(26))),
                  child: Column(
                    children: [
                      Container(color: Color(0XFFB4BBC2), width: 50, height: 3),
                      SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          //create confirm dialog with text box
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: [
                                status == "2"
                                    ? Text(
                                        "Are you sure approving this request"
                                            .tr(),
                                        style: boldTextStyle(
                                            size: 18, color: kMainColor))
                                    : Text(
                                        "Are you sure rejecting this request"
                                            .tr(),
                                        style: boldTextStyle(
                                            size: 18, color: kMainColor)),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: boxDecorationWithRoundedCorners(
                                      borderRadius: radius(20),
                                      backgroundColor: Colors.white70,
                                      border: Border.all(color: kAlertColor)),
                                  child: TextField(
                                    controller: reasonController,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Enter reason here".tr()),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: kAlertColor.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Cancel'.tr(),
                                            style: kTextStyle.copyWith(
                                              color: kAlertColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (status == "2") {
                                          Provider.of<LoanProvider>(context,
                                                  listen: false)
                                              .updateLoan(
                                                  aContext,
                                                  index,
                                                  status,
                                                  reasonController.text);
                                          Navigator.pop(context);
                                        } else if (status != "2" &&
                                            reasonController.text != "") {
                                          Provider.of<LoanProvider>(context,
                                                  listen: false)
                                              .updateLoan(
                                                  aContext,
                                                  index,
                                                  status,
                                                  reasonController.text);
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pop(context);
                                          showCustomSnackBar(
                                              "Please put your reason of rejection"
                                                  .tr(),
                                              context,
                                              isError: true);
                                        }
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: kMainColor),
                                        child: Center(
                                          child: Text(
                                            'Confirm'.tr(),
                                            style: kTextStyle.copyWith(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  Future<void> showPenaltySheet(BuildContext aContext, int index, String status,
      TextEditingController reasonController) async {
    showModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: aContext,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 1,
              minChildSize: 0.7,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(26))),
                  child: Column(
                    children: [
                      Container(color: Color(0XFFB4BBC2), width: 50, height: 3),
                      SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          //create confirm dialog with text box
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: [
                                status == "2"
                                    ? Text(
                                        "Are you sure approving this request"
                                            .tr(),
                                        style: boldTextStyle(
                                            size: 18, color: kMainColor))
                                    : Text(
                                        "Are you sure rejecting this request"
                                            .tr(),
                                        style: boldTextStyle(
                                            size: 18, color: kMainColor)),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: boxDecorationWithRoundedCorners(
                                      borderRadius: radius(20),
                                      backgroundColor: Colors.white70,
                                      border: Border.all(color: kAlertColor)),
                                  child: TextField(
                                    controller: reasonController,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Enter reason here".tr()),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: kAlertColor.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Cancel'.tr(),
                                            style: kTextStyle.copyWith(
                                              color: kAlertColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (status == "2") {
                                          Provider.of<PenaltyProvider>(context,
                                                  listen: false)
                                              .updatePenalty(
                                                  aContext,
                                                  index,
                                                  status,
                                                  reasonController.text);
                                          Navigator.pop(context);
                                        } else if (status != "2" &&
                                            reasonController.text != "") {
                                          Provider.of<PenaltyProvider>(context,
                                                  listen: false)
                                              .updatePenalty(
                                                  aContext,
                                                  index,
                                                  status,
                                                  reasonController.text);
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pop(context);
                                          showCustomSnackBar(
                                              "Please put your reason of rejection"
                                                  .tr(),
                                              context,
                                              isError: true);
                                        }
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: kMainColor),
                                        child: Center(
                                          child: Text(
                                            'Confirm'.tr(),
                                            style: kTextStyle.copyWith(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  Future<void> showSheetForMissingAttendance(
      BuildContext aContext,
      int index,
      String status,
      int statusId,
      String isDecision,
      String chechInDate,
      String checkOutTime,
      String FK_InOutSignID,
      TimeOfDay selectedOutTime,
      bool outTimeSelected,
      TimeOfDay selectedTime,
      DateTime selectedDate,
      TextEditingController TimeToController,
      TextEditingController dateToController,
      TextEditingController reasonController) async {
    showModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.transparent,
        context: aContext,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 1,
              minChildSize: 0.7,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(26))),
                  child: Column(
                    children: [
                      Container(color: Color(0XFFB4BBC2), width: 50, height: 3),
                      SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          //create confirm dialog with text box
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: [
                                status == "2"
                                    ? Text(
                                        "Are you sure approving this attendance request"
                                            .tr(),
                                        style: boldTextStyle(
                                            size: 18, color: kMainColor))
                                    : Text(
                                        "Are you sure rejecting this attendance request"
                                            .tr(),
                                        style: boldTextStyle(
                                            size: 18, color: kMainColor)),
                                SizedBox(height: 20),
                                isDecision == "1"
                                    ? Row(
                                        children: [
                                          Container(
                                            width: 160,
                                            height: 50.0,
                                            child: AppTextField(
                                              textFieldType: TextFieldType.NAME,
                                              textAlignVertical:
                                                  TextAlignVertical.bottom,
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                                Provider.of<AttendanceProvider>(
                                                        context,
                                                        listen: false)
                                                    .selectOutTimeMethod(
                                                        context: context,
                                                        selectedOutTime:
                                                            selectedOutTime,
                                                        outTimeSelected:
                                                            outTimeSelected);
                                              },
                                              controller: TimeToController,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  suffixIcon: Icon(
                                                    Icons.access_time,
                                                    color: kGreyTextColor,
                                                  ),
                                                  labelText: 'Time'.tr(),
                                                  hintText: ("${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period.toString().substring(10, 12)}" ==
                                                          "")
                                                      ? DateFormat("HH:mm:ss")
                                                          .format(
                                                              DateTime.parse(
                                                                  checkOutTime))
                                                      : "${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period.toString().substring(10, 12)}"),
                                            ),
                                          ),
                                          const Spacer(),
                                          //const SizedBox(width: 20,),
                                          Container(
                                            width: 160,
                                            height: 50.0,
                                            child: AppTextField(
                                                textFieldType:
                                                    TextFieldType.NAME,
                                                textAlignVertical:
                                                    TextAlignVertical.bottom,
                                                readOnly: true,
                                                onTap: () async {
                                                  final DateTime? date =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime(1900),
                                                          lastDate:
                                                              DateTime(2100));
                                                  selectedDate = date!;
                                                  dateToController.text = date
                                                      .toString()
                                                      .substring(0, 10);
                                                },
                                                controller: dateToController,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .always,
                                                    suffixIcon: Icon(
                                                      Icons.date_range_rounded,
                                                      color: kGreyTextColor,
                                                    ),
                                                    labelText: 'Date'.tr(),
                                                    hintText: chechInDate)),
                                          ),
                                        ],
                                      )
                                    : Offstage(),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: boxDecorationWithRoundedCorners(
                                      borderRadius: radius(5),
                                      backgroundColor: Colors.white70,
                                      border: Border.all(color: kAlertColor)),
                                  child: TextField(
                                    controller: reasonController,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Enter reason here".tr()),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: kAlertColor.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Cancel'.tr(),
                                            style: kTextStyle.copyWith(
                                              color: kAlertColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        DateTime? checkInSelectedDate =
                                            DateTime(
                                                selectedDate.year,
                                                selectedDate.month,
                                                selectedDate.day);
                                        DateTime? checkOutSelectedTime =
                                            DateTime(selectedTime.hour,
                                                selectedTime.minute);
                                        String checkInSelectedDateFormat =
                                            DateFormat("yyyy-MM-dd")
                                                .format(checkInSelectedDate);
                                        String checkOutSelectedDateFormat =
                                            DateFormat("hh:mm:ss")
                                                .format(checkOutSelectedTime);

                                        if (isDecision == "1" &&
                                            checkInSelectedDateFormat != "" &&
                                            checkOutSelectedDateFormat != "") {
                                          Provider.of<AttendanceProvider>(
                                                  context,
                                                  listen: false)
                                              .updateAttendance(
                                                  aContext,
                                                  index,
                                                  status,
                                                  statusId,
                                                  reasonController.text,
                                                  FK_InOutSignID,
                                                  checkInSelectedDateFormat,
                                                  checkOutSelectedDateFormat);
                                          Navigator.pop(context);
                                          showCustomSnackBar(
                                              "Request approved successfully"
                                                  .tr(),
                                              context,
                                              isError: false);
                                        } else if (isDecision == "1" &&
                                            checkInSelectedDateFormat == "" &&
                                            checkOutSelectedDateFormat == "") {
                                          Provider.of<AttendanceProvider>(
                                                  context,
                                                  listen: false)
                                              .updateAttendance(
                                                  aContext,
                                                  index,
                                                  status,
                                                  statusId,
                                                  reasonController.text,
                                                  FK_InOutSignID,
                                                  chechInDate,
                                                  checkOutTime);
                                          Navigator.pop(context);
                                          showCustomSnackBar(
                                              "Request approved successfully"
                                                  .tr(),
                                              context,
                                              isError: false);
                                        } else if (isDecision == "1" &&
                                            checkInSelectedDateFormat == "" &&
                                            checkOutSelectedDateFormat != "") {
                                          Provider.of<AttendanceProvider>(
                                                  context,
                                                  listen: false)
                                              .updateAttendance(
                                                  aContext,
                                                  index,
                                                  status,
                                                  statusId,
                                                  reasonController.text,
                                                  FK_InOutSignID,
                                                  chechInDate,
                                                  checkOutSelectedDateFormat);
                                          Navigator.pop(context);
                                          showCustomSnackBar(
                                              "Request approved successfully"
                                                  .tr(),
                                              context,
                                              isError: false);
                                        } else if (isDecision == "1" &&
                                            checkInSelectedDateFormat != "" &&
                                            checkOutSelectedDateFormat == "") {
                                          Provider.of<AttendanceProvider>(
                                                  context,
                                                  listen: false)
                                              .updateAttendance(
                                                  aContext,
                                                  index,
                                                  status,
                                                  statusId,
                                                  reasonController.text,
                                                  FK_InOutSignID,
                                                  checkInSelectedDateFormat,
                                                  checkOutTime);
                                          Navigator.pop(context);
                                          showCustomSnackBar(
                                              "Request approved successfully"
                                                  .tr(),
                                              context,
                                              isError: false);
                                        } else if (isDecision == "0") {
                                          Provider.of<AttendanceProvider>(
                                                  context,
                                                  listen: false)
                                              .updateAttendance(
                                                  aContext,
                                                  index,
                                                  status,
                                                  statusId,
                                                  reasonController.text,
                                                  FK_InOutSignID,
                                                  chechInDate,
                                                  checkOutTime);
                                          Navigator.pop(context);
                                          showCustomSnackBar(
                                              "Request approved successfully"
                                                  .tr(),
                                              context,
                                              isError: false);
                                        } else {
                                          Navigator.pop(context);
                                          showCustomSnackBar(
                                              "Please put the date time".tr(),
                                              context,
                                              isError: true);
                                        }
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: kMainColor),
                                        child: Center(
                                          child: Text(
                                            'Confirm'.tr(),
                                            style: kTextStyle.copyWith(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  Widget ShowEmpCard({Key? key, required BuildContext context, required String Qr_code}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              color: kBgColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: context.height(),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Consumer<ProfileProvider>(
                          builder: (context, profileProvider, child) {
                        String base = profileProvider.getEmpUsername();
                        String baseA = profileProvider.getEmpUsernameA();
                        String firstWord = base.substring(0, base.indexOf(" "));
                        String firstWordA =
                            baseA.substring(0, baseA.indexOf(" "));
                        String lastWord = base.substring(base.indexOf(' ') + 1);
                        String lastWordA =
                            baseA.substring(baseA.indexOf(' ') + 1);
                        Uint8List EmpImg =
                            Uint8List.fromList([0, 2, 5, 7, 42, 255]);
                        String EmpImgOrig =
                            profileProvider.getEmpProfilePhoto();
                        if (EmpImgOrig == "") {
                          EmpImgOrig =
                              'https://www.w3schools.com/howto/img_avatar.png';
                        }
                        if (!EmpImgOrig.startsWith("https")) {
                          EmpImg = base64Decode(
                              profileProvider.getEmpProfilePhoto());
                          //profileProvider.notifyAll();
                        }
                        return Container(
                          padding: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: kTitleColor,
                                width: 0.8,
                              )),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                children: [
                                  // SizedBox(
                                  //   width: 5.0,
                                  // ),
                                  SizedBox(
                                    width: 120,
                                    child: EmpImgOrig.startsWith("http")
                                        ? CachedNetworkImage(
                                            imageUrl: EmpImgOrig,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 120,
                                            height: 120,
                                            //padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(9.0),
                                                border: Border.all(
                                                    color: Colors.white)),
                                            child: Image.memory(
                                              Uint8List.fromList(EmpImg),
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                    // SizedBox(
                                    //   width: 5.0,
                                  ),
                                  Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'FirstName :  '.tr(),
                                                style: kTextStyle.copyWith(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              Text(
                                                profileProvider.authRepo
                                                            .getLang() ==
                                                        'ar'
                                                    ? firstWordA
                                                    : firstWord,
                                                style: kTextStyle.copyWith(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'LastName :  '.tr(),
                                                style: kTextStyle.copyWith(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              Text(
                                                profileProvider.authRepo
                                                            .getLang() ==
                                                        'ar'
                                                    ? lastWordA
                                                    : lastWord,
                                                style: kTextStyle.copyWith(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Location :     '.tr(),
                                                style: kTextStyle.copyWith(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              Text(
                                                profileProvider.authRepo
                                                            .getLang() ==
                                                        'ar'
                                                    ? profileProvider
                                                        .getEmpLocationA()
                                                    : profileProvider
                                                        .getEmpLocationE(),
                                                style: kTextStyle.copyWith(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Position :      '.tr(),
                                                style: kTextStyle.copyWith(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              Text(
                                                profileProvider.authRepo
                                                            .getLang() ==
                                                        'ar'
                                                    ? profileProvider
                                                        .getEmpPositionA()
                                                    : profileProvider
                                                        .getEmpPositionE(),
                                                style: kTextStyle.copyWith(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Code :             '.tr(),
                                                style: kTextStyle.copyWith(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              Text(
                                                profileProvider.getEmpCode(),
                                                style: kTextStyle.copyWith(
                                                    color: kRedColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              const Divider(
                                thickness: 1.0,
                                color: kGreyTextColor,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              //  Expanded(
                              Center(
                                child: SfBarcodeGenerator(
                                  value: Qr_code,
                                  symbology: QRCode(),
                                  showValue: false,
                                ),
                              ),

                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(19.0),
                                        bottomRight: Radius.circular(19.0)),
                                    color: kMainCard),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          profileProvider.getEmpCompanyName(),
                                          style: kTextStyle.copyWith(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Expanded(
                                        Text(
                                          'ID / Iqama No'.tr(),
                                          style: kTextStyle.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          profileProvider.getEmpIqamaNo(),
                                          style: kTextStyle.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget showDialogExit({required BuildContext context}) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      // ignore: sized_box_for_whitespace
      child: SizedBox(
        height: 310.0,
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            const Image(
              image: AssetImage('assets/images/exit.png'),
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Exit'.tr(),
              style: kTextStyle.copyWith(
                  fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              'Are you sure?'.tr(),
              style: kTextStyle.copyWith(
                color: kGreyTextColor,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              'You want to exit.'.tr(),
              style: kTextStyle.copyWith(
                color: kGreyTextColor,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            ButtonGlobal(
                buttontext: 'YES'.tr(),
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                onPressed: () {
                  // Navigator.pop(context);
                  exit(0);
                }),
          ],
        ),
      ),
    );
  }

  Widget showCodeVerifyDialog(
      {required BuildContext context,
      required TextEditingController CodeController}) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      // ignore: sized_box_for_whitespace
      child: SizedBox(
        height: 310.0,
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            const Image(
              image: AssetImage('assets/images/warning.png'),
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Verify'.tr(),
              style: kTextStyle.copyWith(
                  fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              'Enter Company Code'.tr(),
              style: kTextStyle.copyWith(
                fontSize: 18,
                color: kGreyTextColor,
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            AppTextField(
              textFieldType: TextFieldType.NAME,
              controller: CodeController,
              decoration: InputDecoration(
                labelText: 'Code'.tr(),
                labelStyle: kTextStyle,
                hintText: 'Enter code'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                ButtonGlobal(
                    buttontext: 'Confirm'.tr(),
                    buttonDecoration:
                        kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: () {
                      Provider.of<ConnectStringProvider>(context, listen: false)
                          .getConnectionUrl(CodeController.text)
                          .then(
                            (value) => value
                                ? Navigator.pop(context)
                                : CodeController.text = "",
                          );
                    }),
                ButtonGlobal(
                  buttontext: 'Cancel'.tr(),
                  buttonDecoration:
                      kButtonDecoration.copyWith(color: kMainColor),
                  onPressed: () => exit(0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget appDrawerWidgets({required BuildContext context, required String type}) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 120,
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Consumer<AttendanceProvider>(
                    builder: (context, attendanceProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 40.0,
                      ),
                      type == "admin"
                          ? Visibility(
                              visible: true,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          const EmployeeManagement()
                                              .launch(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Image(
                                                  image: AssetImage(
                                                    'assets/images/attendanceicon.png',
                                                  ),
                                                  width: 130,
                                                  height: 150,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(12),
                                              ),
                                              Container(
                                                width: 160,
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                    color: Color(0xfffa47b2),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight: Radius
                                                                .circular(15),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15))),
                                                child: Center(
                                                  child: Text(
                                                    "Employee Management".tr(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),

                                                //  padding: const EdgeInsets.all(12),
                                                //  padding: const EdgeInsets.all(12),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          attendanceProvider.checkInWithQrCard(
                                              context: context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Image(
                                                  image: AssetImage(
                                                    'assets/images/qr_scanner.png',
                                                  ),
                                                  width: 130,
                                                  height: 150,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(12),
                                              ),
                                              Container(
                                                width: 160,
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                    color: Color(0xff474788),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight: Radius
                                                                .circular(15),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15))),
                                                child: Center(
                                                  child: Text(
                                                    "Employee Card Scanner"
                                                        .tr(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),

                                                // padding: const EdgeInsets.all(12),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          const attendance().launch(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Image(
                                                  image: AssetImage(
                                                    'assets/images/attendance1.png',
                                                  ),
                                                  width: 130,
                                                  height: 150,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(12),
                                              ),
                                              Container(
                                                width: 160,
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                    color: Color(0xFF9972b3),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight: Radius
                                                                .circular(15),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15))),
                                                child: Center(
                                                  child: Text(
                                                    "Employee Attendance".tr(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),

                                                //  padding: const EdgeInsets.all(12),
                                                //  padding: const EdgeInsets.all(12),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          const RequestVacationScreen()
                                              .launch(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Image(
                                                  image: AssetImage(
                                                    'assets/images/leave1.png',
                                                  ),
                                                  width: 130,
                                                  height: 150,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(12),
                                              ),
                                              Container(
                                                width: 160,
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                    color: Color(0xFF47bab7),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight: Radius
                                                                .circular(15),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15))),
                                                child: Center(
                                                  child: Text(
                                                    "Request Vacation".tr(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),

                                                // padding: const EdgeInsets.all(12),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        const attendance().launch(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Image(
                                                image: AssetImage(
                                                  'assets/images/attendance1.png',
                                                ),
                                                width: 130,
                                                height: 150,
                                              ),
                                              padding: const EdgeInsets.all(12),
                                            ),
                                            Container(
                                              width: 160,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFF9972b3),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  15),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15))),
                                              child: Center(
                                                child: Text(
                                                  "Employee Attendance".tr(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),

                                              //  padding: const EdgeInsets.all(12),
                                              //  padding: const EdgeInsets.all(12),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        const RequestVacationScreen()
                                            .launch(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Image(
                                                image: AssetImage(
                                                  'assets/images/leave1.png',
                                                ),
                                                width: 130,
                                                height: 150,
                                              ),
                                              padding: const EdgeInsets.all(12),
                                            ),
                                            Container(
                                              width: 160,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFF47bab7),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  15),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15))),
                                              child: Center(
                                                child: Text(
                                                  "Request Vacation".tr(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),

                                              // padding: const EdgeInsets.all(12),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              const EmployeeLoan().launch(context);
                              //showCustomSnackBar('Under Development!', context, isError: true);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    child: Image(
                                      image: AssetImage(
                                        'assets/images/loanemp.png',
                                      ),
                                      width: 130,
                                      height: 150,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  Container(
                                    width: 160,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFF246E91),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15))),
                                    child: Center(
                                      child: Text(
                                        "Employee Loan".tr(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              const GeneralRequestScreen().launch(context);
                              //showCustomSnackBar('Under Development!', context, isError: true);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    child: Image(
                                      image: AssetImage(
                                        'assets/images/bounceemp.png',
                                      ),
                                      width: 130,
                                      height: 150,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  Container(
                                    width: 160,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        color: Color(0xff12ae6e),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15))),
                                    child: Center(
                                      child: Text(
                                        "General Request".tr(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              const EmployeeLoanDelay().launch(context);
                              // showCustomSnackBar('Under Development!', context, isError: true);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    child: Image(
                                      image: AssetImage(
                                        'assets/images/loandelay.png',
                                      ),
                                      width: 130,
                                      height: 150,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  Container(
                                    width: 160,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        color: Color(0xff7e3f01),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15))),
                                    child: Center(
                                      child: Text(
                                        "LoanDelay Request".tr(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              const CashInAdvanceScreen().launch(context);
                              // showCustomSnackBar('Under Development!', context, isError: true);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    child: Image(
                                      image: AssetImage(
                                        'assets/images/cashmoney.png',
                                      ),
                                      width: 130,
                                      height: 150,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  Container(
                                    width: 160,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        color: Color(0xff84990d),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15))),
                                    child: Center(
                                      child: Text(
                                        "Cash Requests".tr(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              const EmployeeClearance().launch(context);
                              // showCustomSnackBar('Under Development!', context, isError: true);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    child: Image(
                                      image: AssetImage(
                                        'assets/images/clearance.png',
                                      ),
                                      width: 130,
                                      height: 150,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                  Container(
                                    width: 160,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFc30808),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15))),
                                    child: Center(
                                      child: Text(
                                        "Employee Clearance".tr(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          type == "Employee"
                              ? Visibility(
                                  visible: true,
                                  maintainSize: true,
                                  maintainState: true,
                                  maintainAnimation: true,
                                  child: GestureDetector(
                                    onTap: () {
                                      const PenaltyNotification()
                                          .launch(context);
                                      // showCustomSnackBar('Under Development!', context, isError: true);
                                    },
                                    child: Stack(children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Image(
                                                image: AssetImage(
                                                  'assets/images/penalty.png',
                                                ),
                                                width: 130,
                                                height: 150,
                                              ),
                                              padding: const EdgeInsets.all(12),
                                            ),
                                            Container(
                                              width: 160,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFF505050),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  15),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15))),
                                              child: Center(
                                                child: Text(
                                                  "Employee Penalty".tr(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Consumer(builder: (context,
                                          PenaltyProvider provider, child) {
                                        return Badge(
                                          showBadge: provider.showBadge,
                                          position: BadgePosition.bottomEnd(
                                              bottom: 8, end: 8),
                                          badgeContent: Text(
                                            provider
                                                .EmpPenaltyNotifiedData.length
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          child: IconButton(
                                            padding:
                                                EdgeInsets.only(right: 10.0),
                                            icon: Icon(
                                              FontAwesomeIcons.bell,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              // provider.clear();
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => SVNotificationFragment()));
                                            },
                                          ),
                                        );
                                      }),
                                    ]),
                                  ),
                                )
                              : type == "admin"
                                  ? Visibility(
                                      visible: true,
                                      maintainSize: true,
                                      maintainState: true,
                                      maintainAnimation: true,
                                      child: GestureDetector(
                                        onTap: () {
                                          const EmployeePenalty()
                                              .launch(context);
                                          // showCustomSnackBar('Under Development!', context, isError: true);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Image(
                                                  image: AssetImage(
                                                    'assets/images/penalty.png',
                                                  ),
                                                  width: 130,
                                                  height: 150,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(12),
                                              ),
                                              Container(
                                                width: 160,
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                    color: Color(0xFF505050),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight: Radius
                                                                .circular(15),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15))),
                                                child: Center(
                                                  child: Text(
                                                    "Employee Penalty".tr(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 160,
                                      height: 40,
                                    ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appDrawerEmployee({required BuildContext context}) {
    return Drawer(
      child:
          Consumer<AccountProvider>(builder: (context, accountProvider, child) {
        return ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: context.height() / 2.5,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
                color: kMainColor,
              ),
              child: Consumer<AccountProvider>(
                  builder: (context, accountProvider, child) {
                Uint8List EmpImg = Uint8List.fromList([0, 2, 5, 7, 42, 255]);
                String EmpImgOrig =
                    accountProvider.authRepo.getEmpProfilePhoto();
                if (EmpImgOrig == "") {
                  EmpImgOrig = 'https://www.w3schools.com/howto/img_avatar.png';
                }
                if (!EmpImgOrig.startsWith("https")) {
                  EmpImg = base64Decode(
                      accountProvider.authRepo.getEmpProfilePhoto());
                  // accountProvider.notifyAll();
                }
                return Column(
                  children: [
                    Container(
                      height: context.height() / 3.4,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0)),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2, top: 12),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 100,
                                child: EmpImgOrig.startsWith("http")
                                    ? CachedNetworkImage(
                                        imageUrl: EmpImgOrig,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 120,
                                        height: 120,
                                        padding:
                                            EdgeInsets.only(bottom: 2, top: 12),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: Image.memory(
                                          Uint8List.fromList(EmpImg),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                              ),
                              Text(
                                accountProvider.authRepo.getLang() == 'ar'
                                    ? accountProvider.ArabicName
                                    : accountProvider.EnglishName,
                                style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Employee'.tr(),
                                style:
                                    kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ],
                          ).onTap(() {
                            const ProfileScreen().launch(context);
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              '00',
                              style: kTextStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Presents'.tr(),
                              style: kTextStyle.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '00',
                              style: kTextStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Late'.tr(),
                              style: kTextStyle.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '00',
                              style: kTextStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Absent'.tr(),
                              style: kTextStyle.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ListTile(
              onTap: () {
                const ProfileScreen().launch(context);
              },
              leading: const Icon(
                Icons.person,
                color: kGreyTextColor,
              ),
              title: Text(
                'Employee Profile'.tr(),
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                const EmployeeCard().launch(context);
              },
              leading: const Icon(
                Icons.credit_card,
                color: kGreyTextColor,
              ),
              title: Text(
                'Employee Card'.tr(),
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                const TermsOfServices().launch(context);
              },
              leading: const Icon(
                FontAwesomeIcons.infoCircle,
                color: kGreyTextColor,
              ),
              title: Text(
                'Terms of Services'.tr(),
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                const PrivacyPolicy().launch(context);
              },
              leading: const Icon(
                Icons.dangerous_sharp,
                color: kGreyTextColor,
              ),
              title: Text(
                'Privacy Policy'.tr(),
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                const Language().launch(context);
              },
              leading: const Icon(
                Icons.language,
                color: kGreyTextColor,
              ),
              title: Text(
                'Language'.tr(),
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                accountProvider.clearSharedData().then((condition) {
                  accountProvider.clearSharedType();
                  accountProvider.clearSharedUserName();
                  accountProvider.clearSharedEmpPhoto();

                  Navigator.pop(context);
                  if (accountProvider.authRepo.getConnectionString() == "") {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SelectType()),
                        (route) => false);
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SignIn()),
                        (route) => false);
                  }
                });
              },
              leading: const Icon(
                FontAwesomeIcons.signOutAlt,
                color: kGreyTextColor,
              ),
              title: Text(
                'Logout'.tr(),
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget appDrawerAdmin({required BuildContext context}) {
    return Drawer(
      child:
          Consumer<AccountProvider>(builder: (context, accountProvider, child) {
        return ListView(
          children: [
            Container(
              height: context.height() / 2.5,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
                color: kMainColor,
              ),
              child: Consumer<AccountProvider>(
                  builder: (context, accountProvider, child) {
                Uint8List EmpImg = Uint8List.fromList([0, 2, 5, 7, 42, 255]);
                String EmpImgOrig =
                    accountProvider.authRepo.getEmpProfilePhoto();
                if (EmpImgOrig == "") {
                  EmpImgOrig = 'https://www.w3schools.com/howto/img_avatar.png';
                }
                if (!EmpImgOrig.startsWith("https")) {
                  EmpImg = base64Decode(
                      accountProvider.authRepo.getEmpProfilePhoto());
                  //accountProvider.notifyAll();
                }
                return Column(
                  children: [
                    Container(
                      height: context.height() / 3.4,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0)),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 1, top: 20),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 160,
                                child: EmpImgOrig.startsWith("http")
                                    ? CachedNetworkImage(
                                        imageUrl: EmpImgOrig,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 160.0,
                                          height: 160.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 160,
                                        height: 160,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: Image.memory(
                                          Uint8List.fromList(EmpImg),
                                          // width: 130,
                                          // height: 130,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                              ),
                              Text(
                                accountProvider.authRepo.getLang() == 'ar'
                                    ? accountProvider.ArabicName
                                    : accountProvider.EnglishName,
                                style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Admin'.tr(),
                                style:
                                    kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ],
                          ).onTap(() {
                            const ProfileScreen().launch(context);
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              '0',
                              style: kTextStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Employees'.tr(),
                              style: kTextStyle.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '0',
                              style: kTextStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Absent'.tr(),
                              style: kTextStyle.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '0',
                              style: kTextStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Presents'.tr(),
                              style: kTextStyle.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ListTile(
              onTap: () {
                const ProfileScreen().launch(context);
              },
              leading: const Icon(
                Icons.person,
                color: kGreyTextColor,
              ),
              title: Text(
                'Employee Profile'.tr(),
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                const EmployeeCard().launch(context);
              },
              leading: const Icon(
                Icons.credit_card,
                color: kGreyTextColor,
              ),
              title: Text(
                'Employee Card'.tr(),
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                const SettingScreen().launch(context);
              },
              leading: const Icon(
                Icons.settings,
                color: kGreyTextColor,
              ),
              title: Text(
                'Settings'.tr(),
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () => Share.share('Google Play Store Link'.tr()),
              leading: const Icon(
                FontAwesomeIcons.userFriends,
                color: kGreyTextColor,
              ),
              title: Text(
                'Share App'.tr(),
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                const TermsOfServices().launch(context);
              },
              leading: const Icon(
                FontAwesomeIcons.infoCircle,
                color: kGreyTextColor,
              ),
              title: Text(
                'Terms of Services'.tr(),
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                const PrivacyPolicy().launch(context);
              },
              leading: const Icon(
                Icons.dangerous_sharp,
                color: kGreyTextColor,
              ),
              title: Text(
                'Privacy Policy'.tr(),
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                const Language().launch(context);
              },
              leading: const Icon(
                Icons.language,
                color: kGreyTextColor,
              ),
              title: Text(
                'Language'.tr(),
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                accountProvider.clearSharedData().then((condition) {
                  accountProvider.clearSharedType();
                  accountProvider.clearSharedUserName();
                  accountProvider.clearSharedUserNameA();
                  accountProvider.clearSharedEmpPhoto();

                  Navigator.pop(context);
                  if (accountProvider.authRepo.getConnectionString() == "") {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SelectType()),
                        (route) => false);
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SignIn()),
                        (route) => false);
                  }
                });
              },
              leading: const Icon(
                FontAwesomeIcons.signOutAlt,
                color: kGreyTextColor,
              ),
              title: Text(
                'Logout'.tr(),
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget ShowLeaveList(
      {required bool isApproved,
      required TextEditingController reasonController}) {
    return Consumer<EmployeeProvider>(
        builder: (context, employeeProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: kBgColor,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  employeeProvider.isLoading
                      ? Expanded(
                          child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.grey[100],
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black, width: 1.0))),
                              margin: EdgeInsets.only(top: 15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 15, right: 10),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          height: 8,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                        margin: EdgeInsets.only(right: 10),
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 15),
                                    height: 200,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                      : Visibility(
                          visible: true,
                          child:
                              employeeProvider.requestVacationModel.length != 0
                                  ? Expanded(
                                      child: SingleChildScrollView(
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              150,
                                          child: ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            itemCount: employeeProvider
                                                .requestVacationModel.length,
                                            itemBuilder: (context, i) {
                                              Uint8List EmpImg =
                                                  Uint8List.fromList(
                                                      [0, 2, 5, 7, 42, 255]);
                                              String EmpImgOrig =
                                                  employeeProvider
                                                      .requestVacationModel[i]
                                                      .employeeImage;
                                              if (!EmpImgOrig.startsWith(
                                                  "https")) {
                                                EmpImg = base64Decode(
                                                    employeeProvider
                                                        .requestVacationModel[i]
                                                        .employeeImage);
                                              }
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    DecisionHistory(
                                                            vacationId:
                                                                employeeProvider
                                                                    .requestVacationModel[
                                                                        i]
                                                                    .VacRequestID,
                                                            type: 'vacation')
                                                        .launch(context);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5.0,
                                                            right: 5,
                                                            top: 10,
                                                            bottom: 20),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        border: Border.all(
                                                          color: kTitleColor,
                                                          width: 0.5,
                                                        )),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        ListTile(
                                                          onTap: () {},
                                                          leading: SizedBox(
                                                            width: 50,
                                                            child: EmpImgOrig
                                                                    .startsWith(
                                                                        "http")
                                                                ? CachedNetworkImage(
                                                                    imageUrl:
                                                                        EmpImgOrig,
                                                                    imageBuilder:
                                                                        (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                      width:
                                                                          50.0,
                                                                      height:
                                                                          50.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    width: 50,
                                                                    height: 50,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                9.0),
                                                                        border: Border.all(
                                                                            color: Colors
                                                                                .white)),
                                                                    child: Image.memory(
                                                                        Uint8List.fromList(
                                                                            EmpImg),
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                        fit: BoxFit
                                                                            .fill)),
                                                          ),
                                                          title: Text(
                                                            Provider.of<AccountProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .authRepo
                                                                        .getLang() ==
                                                                    'ar'
                                                                ? employeeProvider
                                                                    .requestVacationModel[
                                                                        i]
                                                                    .employeeNameA
                                                                : employeeProvider
                                                                    .requestVacationModel[
                                                                        i]
                                                                    .employeeNameE,
                                                            style: kTextStyle,
                                                          ),
                                                          subtitle: Text(
                                                            'Employee'.tr(),
                                                            style: kTextStyle
                                                                .copyWith(
                                                                    color:
                                                                        kGreyTextColor),
                                                          ),
                                                          trailing: Container(
                                                            height: 50.0,
                                                            width: 90.0,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              color: kMainColor
                                                                  .withOpacity(
                                                                      0.08),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                Provider.of<AccountProvider>(context, listen: false)
                                                                            .authRepo
                                                                            .getLang() ==
                                                                        'ar'
                                                                    ? employeeProvider
                                                                        .requestVacationModel[
                                                                            i]
                                                                        .VacationReasonA
                                                                    : employeeProvider
                                                                        .requestVacationModel[
                                                                            i]
                                                                        .VacationReasonE,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color:
                                                                        VacColor,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20.0,
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                    'From Day'
                                                                        .tr(),
                                                                    style: kTextStyle.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    'To Day'
                                                                        .tr(),
                                                                    style: kTextStyle.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    'Leave day'
                                                                        .tr(),
                                                                    style: kTextStyle.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(
                                                              thickness: 1.0,
                                                              color:
                                                                  kGreyTextColor,
                                                            ),
                                                            const SizedBox(
                                                              height: 20.0,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                    employeeProvider
                                                                        .requestVacationModel[
                                                                            i]
                                                                        .VacationFrom,
                                                                    style: kTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            25.0,
                                                                        right:
                                                                            25.0),
                                                                    child: Text(
                                                                      employeeProvider
                                                                          .requestVacationModel[
                                                                              i]
                                                                          .VacationTo,
                                                                      style: kTextStyle.copyWith(
                                                                          color:
                                                                              kGreyTextColor),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    employeeProvider
                                                                        .requestVacationModel[
                                                                            i]
                                                                        .VacationFrom,
                                                                    style: kTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 20.0,
                                                        ),
                                                        employeeProvider
                                                                    .requestVacationModel[
                                                                        i]
                                                                    .IsApproved ==
                                                                "1"
                                                            ? Visibility(
                                                                visible:
                                                                    !isApproved,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        AppWidget().showLeaveSheet(
                                                                            context,
                                                                            i,
                                                                            "2",
                                                                            reasonController);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            120,
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0,
                                                                            top:
                                                                                10.0,
                                                                            bottom:
                                                                                10.0),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15.0),
                                                                            color: kMainColor),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Approve'.tr(),
                                                                            style:
                                                                                kTextStyle.copyWith(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10.0),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        AppWidget().showLeaveSheet(
                                                                            context,
                                                                            i,
                                                                            "3",
                                                                            reasonController);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            120,
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0,
                                                                            top:
                                                                                10.0,
                                                                            bottom:
                                                                                10.0),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15.0),
                                                                          color:
                                                                              kAlertColor.withOpacity(0.1),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Reject'.tr(),
                                                                            style:
                                                                                kTextStyle.copyWith(color: kAlertColor),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  employeeProvider
                                                                              .requestVacationModel[i]
                                                                              .VacationStateE ==
                                                                          "Pending"
                                                                      ? GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            employeeProvider.updateVacation(
                                                                                context,
                                                                                i,
                                                                                "2",
                                                                                "Notified");
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                120,
                                                                            padding: const EdgeInsets.only(
                                                                                left: 10.0,
                                                                                right: 10.0,
                                                                                top: 10.0,
                                                                                bottom: 10.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15.0),
                                                                              color: kMainColor,
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                'Notify'.tr(),
                                                                                style: kTextStyle.copyWith(color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Text(
                                                                          employeeProvider.requestVacationModel[i].VacationStateE == "Pending"
                                                                              ? "Notified"
                                                                              : employeeProvider.requestVacationModel[i].VacationStateE,
                                                                          style: TextStyle(
                                                                              color: kGreenColor,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                ],
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.5,
                                      child: Center(
                                        child: Text('No Requests Yet'.tr(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54),
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                        ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget ShowLoanNotifiedList(
      {required bool isApproved,
      required TextEditingController reasonController}) {
    return Consumer<LoanProvider>(builder: (context, loanProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: kBgColor,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  loanProvider.isLoading
                      ? Container(
                          // child: Expanded(
                          //   flex: 1,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[400],
                              highlightColor: Colors.grey[100],
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 1.0))),
                                margin: EdgeInsets.only(top: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 15, right: 10),
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                        ),
                                        // Expanded(
                                        //   child: Container(
                                        //     padding: EdgeInsets.only(left: 10),
                                        //     height: 8,
                                        //     color: Colors.grey,
                                        //   ),
                                        // ),
                                        Container(
                                          height: 10,
                                          margin: EdgeInsets.only(right: 10),
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 15),
                                      height: 200,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //   ),
                        )
                      : Visibility(
                          visible: true,
                          child: loanProvider.loanNotifyList.length != 0
                              ?
                              // Column(
                              //   children:[
                              //     Expanded(
                              //     flex: 1,
                              // child:
                              SingleChildScrollView(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height -
                                        160,
                                    child: ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      itemCount:
                                          loanProvider.loanNotifyList.length,
                                      itemBuilder: (context, i) {
                                        String EmpImgOrig =
                                            'https://www.w3schools.com/howto/img_avatar.png';
                                        String xx = loanProvider
                                            .loanNotifyList[i].RequestDate;
                                        String reqDate = xx.substring(0, 10);
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              DecisionHistory(
                                                      vacationId: loanProvider
                                                          .loanNotifyList[i]
                                                          .LoanRequestID,
                                                      type: 'loan')
                                                  .launch(context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0,
                                                  right: 5,
                                                  top: 10,
                                                  bottom: 20),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  border: Border.all(
                                                    color: kTitleColor,
                                                    width: 0.5,
                                                  )),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  ListTile(
                                                    onTap: () {},
                                                    leading: SizedBox(
                                                      width: 50,
                                                      child: CachedNetworkImage(
                                                        imageUrl: EmpImgOrig,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    title: Text(
                                                      Provider.of<AccountProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .authRepo
                                                                  .getLang() ==
                                                              'ar'
                                                          ? loanProvider
                                                              .loanNotifyList[i]
                                                              .EmpNameA
                                                          : loanProvider
                                                              .loanNotifyList[i]
                                                              .EmpNameE,
                                                      style: kTextStyle,
                                                    ),
                                                    subtitle: Text(
                                                      'Employee'.tr(),
                                                      style: kTextStyle.copyWith(
                                                          color:
                                                              kGreyTextColor),
                                                    ),
                                                    trailing: Container(
                                                      height: 50.0,
                                                      width: 90.0,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        color: kMainColor
                                                            .withOpacity(0.08),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          Provider.of<AccountProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .authRepo
                                                                      .getLang() ==
                                                                  'ar'
                                                              ? loanProvider
                                                                  .loanNotifyList[
                                                                      i]
                                                                  .StatusA
                                                              : loanProvider
                                                                  .loanNotifyList[
                                                                      i]
                                                                  .StatusE,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: VacColor,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20.0,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Amount'.tr(),
                                                              style: kTextStyle.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            Text(
                                                              'LoanDate'.tr(),
                                                              style: kTextStyle.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              width: 30,
                                                            ),
                                                            Text(
                                                              'Loan Reason'
                                                                  .tr(),
                                                              style: kTextStyle.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Divider(
                                                        thickness: 1.0,
                                                        color: kGreyTextColor,
                                                      ),
                                                      // const SizedBox(
                                                      //   width: 20.0,
                                                      // ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            loanProvider
                                                                .loanNotifyList[
                                                                    i]
                                                                .LoanAmount,
                                                            style: kTextStyle
                                                                .copyWith(
                                                                    color:
                                                                        kGreyTextColor),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 25.0,
                                                                    right:
                                                                        25.0),
                                                            child: Text(
                                                              reqDate,
                                                              style: kTextStyle
                                                                  .copyWith(
                                                                      color:
                                                                          kGreyTextColor),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 40.0),
                                                            child: Text(
                                                              loanProvider
                                                                  .loanNotifyList[
                                                                      i]
                                                                  .LoanReason,
                                                              style: kTextStyle
                                                                  .copyWith(
                                                                      color:
                                                                          kGreyTextColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20.0,
                                                  ),
                                                  loanProvider.loanNotifyList[i]
                                                              .IsApprove ==
                                                          "1"
                                                      ? Visibility(
                                                          visible: !isApproved,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  AppWidget()
                                                                      .showLoanSheet(
                                                                          context,
                                                                          i,
                                                                          "2",
                                                                          reasonController);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 120,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          10.0,
                                                                      top: 10.0,
                                                                      bottom:
                                                                          10.0),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0),
                                                                      color:
                                                                          kMainColor),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Approve'
                                                                          .tr(),
                                                                      style: kTextStyle.copyWith(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10.0),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  AppWidget()
                                                                      .showLoanSheet(
                                                                          context,
                                                                          i,
                                                                          "3",
                                                                          reasonController);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 120,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          10.0,
                                                                      top: 10.0,
                                                                      bottom:
                                                                          10.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0),
                                                                    color: kAlertColor
                                                                        .withOpacity(
                                                                            0.1),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Reject'
                                                                          .tr(),
                                                                      style: kTextStyle.copyWith(
                                                                          color:
                                                                              kAlertColor),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            loanProvider
                                                                        .loanNotifyList[
                                                                            i]
                                                                        .StatusE ==
                                                                    "Pending"
                                                                ? GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      loanProvider.updateLoan(
                                                                          context,
                                                                          i,
                                                                          "2",
                                                                          "Notified");
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          120,
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              10.0,
                                                                          right:
                                                                              10.0,
                                                                          top:
                                                                              10.0,
                                                                          bottom:
                                                                              10.0),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15.0),
                                                                        color:
                                                                            kMainColor,
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'Notify'
                                                                              .tr(),
                                                                          style:
                                                                              kTextStyle.copyWith(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    loanProvider.loanNotifyList[i].StatusE ==
                                                                            "Pending"
                                                                        ? "Notified"
                                                                        : loanProvider
                                                                            .loanNotifyList[i]
                                                                            .StatusA,
                                                                    style: TextStyle(
                                                                        color:
                                                                            kGreenColor,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                          ],
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              //  )
                              //   ])
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: Center(
                                    child: Text('No Requests Yet'.tr(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                        ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget ShowLoanDelayNotifiedList(
      {required bool isApproved,
      required TextEditingController reasonController}) {
    return Consumer<LoanDelayProvider>(
        builder: (context, loanDelayProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: kBgColor,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  loanDelayProvider.isLoading
                      ? Expanded(
                          child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.grey[100],
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black, width: 1.0))),
                              margin: EdgeInsets.only(top: 15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 15, right: 10),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          height: 8,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                        margin: EdgeInsets.only(right: 10),
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 15),
                                    height: 200,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                      : Visibility(
                          visible: true,
                          child:
                              loanDelayProvider.loanDelayNotifiedList.length !=
                                      0
                                  ? Expanded(
                                      child: SingleChildScrollView(
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              150,
                                          child: ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            itemCount: loanDelayProvider
                                                .loanDelayNotifiedList.length,
                                            itemBuilder: (context, i) {
                                              String EmpImgOrig =
                                                  'https://www.w3schools.com/howto/img_avatar.png';
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    DecisionHistory(
                                                            vacationId: loanDelayProvider
                                                                .loanDelayNotifiedList[
                                                                    i]
                                                                .EmployeeLoanDelayRequestID,
                                                            type: 'loan_delay')
                                                        .launch(context);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5.0,
                                                            right: 5,
                                                            top: 10,
                                                            bottom: 20),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        border: Border.all(
                                                          color: kTitleColor,
                                                          width: 0.5,
                                                        )),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        ListTile(
                                                          onTap: () {},
                                                          leading: SizedBox(
                                                            width: 50,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  EmpImgOrig,
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                width: 50.0,
                                                                height: 50.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          title: Text(
                                                            Provider.of<AccountProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .authRepo
                                                                        .getLang() ==
                                                                    'ar'
                                                                ? loanDelayProvider
                                                                    .loanDelayNotifiedList[
                                                                        i]
                                                                    .EmpNameA
                                                                : loanDelayProvider
                                                                    .loanDelayNotifiedList[
                                                                        i]
                                                                    .EmpNameE,
                                                            style: kTextStyle,
                                                          ),
                                                          subtitle: Text(
                                                            'Employee'.tr(),
                                                            style: kTextStyle
                                                                .copyWith(
                                                                    color:
                                                                        kGreyTextColor),
                                                          ),
                                                          trailing: Container(
                                                            height: 50.0,
                                                            width: 90.0,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              color: kMainColor
                                                                  .withOpacity(
                                                                      0.08),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                Provider.of<AccountProvider>(context, listen: false)
                                                                            .authRepo
                                                                            .getLang() ==
                                                                        'ar'
                                                                    ? loanDelayProvider
                                                                        .loanDelayNotifiedList[
                                                                            i]
                                                                        .LoanDescA
                                                                    : loanDelayProvider
                                                                        .loanDelayNotifiedList[
                                                                            i]
                                                                        .LoanDescE,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color:
                                                                        VacColor,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20.0,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 60,
                                                                      right:
                                                                          60),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'AmountPerMonth'
                                                                        .tr(),
                                                                    style: kTextStyle.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    'MonthName'
                                                                        .tr(),
                                                                    style: kTextStyle.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(
                                                              thickness: 1.0,
                                                              color:
                                                                  kGreyTextColor,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 100,
                                                                      right:
                                                                          90),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    loanDelayProvider
                                                                        .loanDelayNotifiedList[
                                                                            i]
                                                                        .AmountPerMonth,
                                                                    style: kTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                  ),
                                                                  Text(
                                                                    loanDelayProvider
                                                                        .loanDelayNotifiedList[
                                                                            i]
                                                                        .MonthName,
                                                                    style: kTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 20.0,
                                                        ),
                                                        loanDelayProvider
                                                                    .loanDelayNotifiedList[
                                                                        i]
                                                                    .IsApprove ==
                                                                "1"
                                                            ? Visibility(
                                                                visible:
                                                                    !isApproved,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        AppWidget().showLoanDelaySheet(
                                                                            context,
                                                                            i,
                                                                            "2",
                                                                            reasonController);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            120,
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0,
                                                                            top:
                                                                                10.0,
                                                                            bottom:
                                                                                10.0),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15.0),
                                                                            color: kMainColor),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Approve'.tr(),
                                                                            style:
                                                                                kTextStyle.copyWith(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10.0),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        AppWidget().showLoanDelaySheet(
                                                                            context,
                                                                            i,
                                                                            "3",
                                                                            reasonController);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            120,
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0,
                                                                            top:
                                                                                10.0,
                                                                            bottom:
                                                                                10.0),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15.0),
                                                                          color:
                                                                              kAlertColor.withOpacity(0.1),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Reject'.tr(),
                                                                            style:
                                                                                kTextStyle.copyWith(color: kAlertColor),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  loanDelayProvider
                                                                              .loanDelayNotifiedList[i]
                                                                              .StatusE ==
                                                                          "Pending"
                                                                      ? GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            loanDelayProvider.updateLoanDelay(
                                                                                context,
                                                                                i,
                                                                                "2",
                                                                                "Notified");
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                120,
                                                                            padding: const EdgeInsets.only(
                                                                                left: 10.0,
                                                                                right: 10.0,
                                                                                top: 10.0,
                                                                                bottom: 10.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15.0),
                                                                              color: kMainColor,
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                'Notify'.tr(),
                                                                                style: kTextStyle.copyWith(color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Text(
                                                                          loanDelayProvider.loanDelayNotifiedList[i].StatusE == "Pending"
                                                                              ? "Notified"
                                                                              : loanDelayProvider.loanDelayNotifiedList[i].StatusA,
                                                                          style: TextStyle(
                                                                              color: kGreenColor,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                ],
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.5,
                                      child: Center(
                                        child: Text('No Requests Yet'.tr(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54),
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                        ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget ShowGeneralNotifiedList(
      {required bool isApproved,
      required TextEditingController reasonController}) {
    return Consumer<GeneralRequestProvider>(
        builder: (context, generalRequestProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: kBgColor,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  generalRequestProvider.isLoading
                      ? Expanded(
                          child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.grey[100],
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black, width: 1.0))),
                              margin: EdgeInsets.only(top: 15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 15, right: 10),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          height: 8,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                        margin: EdgeInsets.only(right: 10),
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 15),
                                    height: 200,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                      : Visibility(
                          visible: true,
                          child:
                              generalRequestProvider
                                          .generalNotifiedList.length !=
                                      0
                                  ? Expanded(
                                      child: SingleChildScrollView(
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              150,
                                          child: ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            itemCount: generalRequestProvider
                                                .generalNotifiedList.length,
                                            itemBuilder: (context, i) {
                                              String EmpImgOrig =
                                                  'https://www.w3schools.com/howto/img_avatar.png';
                                              String xx = generalRequestProvider
                                                  .generalNotifiedList[i]
                                                  .RequestDate;
                                              String reqDate =
                                                  xx.substring(0, 10);
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    DecisionHistory(
                                                            vacationId:
                                                                generalRequestProvider
                                                                    .generalNotifiedList[
                                                                        i]
                                                                    .RequestID
                                                                    .toString(),
                                                            type: 'general')
                                                        .launch(context);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5.0,
                                                            right: 5,
                                                            top: 10,
                                                            bottom: 20),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        border: Border.all(
                                                          color: kTitleColor,
                                                          width: 0.5,
                                                        )),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        ListTile(
                                                          onTap: () {},
                                                          leading: SizedBox(
                                                            width: 50,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  EmpImgOrig,
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                width: 50.0,
                                                                height: 50.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image:
                                                                      DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          title: Text(
                                                            Provider.of<AccountProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .authRepo
                                                                        .getLang() ==
                                                                    'ar'
                                                                ? generalRequestProvider
                                                                    .generalNotifiedList[
                                                                        i]
                                                                    .EmpNameA
                                                                : generalRequestProvider
                                                                    .generalNotifiedList[
                                                                        i]
                                                                    .EmpNameE,
                                                            style: kTextStyle,
                                                          ),
                                                          subtitle: Text(
                                                            'Employee'.tr(),
                                                            style: kTextStyle
                                                                .copyWith(
                                                                    color:
                                                                        kGreyTextColor),
                                                          ),
                                                          trailing: Container(
                                                            height: 50.0,
                                                            width: 90.0,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              color: kMainColor
                                                                  .withOpacity(
                                                                      0.08),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                Provider.of<AccountProvider>(context, listen: false)
                                                                            .authRepo
                                                                            .getLang() ==
                                                                        'ar'
                                                                    ? generalRequestProvider
                                                                        .generalNotifiedList[
                                                                            i]
                                                                        .StatusA
                                                                    : generalRequestProvider
                                                                        .generalNotifiedList[
                                                                            i]
                                                                        .StatusE,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color:
                                                                        VacColor,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20.0,
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 80,
                                                                      right:
                                                                          80),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'Title'
                                                                        .tr(),
                                                                    style: kTextStyle.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    'Details'
                                                                        .tr(),
                                                                    style: kTextStyle.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(
                                                              thickness: 1.0,
                                                              color:
                                                                  kGreyTextColor,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 80,
                                                                      right:
                                                                          80),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    generalRequestProvider
                                                                        .generalNotifiedList[
                                                                            i]
                                                                        .RequestTitle,
                                                                    style: kTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                  ),
                                                                  Text(
                                                                    generalRequestProvider
                                                                        .generalNotifiedList[
                                                                            i]
                                                                        .RequestDetails,
                                                                    style: kTextStyle
                                                                        .copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 20.0,
                                                        ),
                                                        generalRequestProvider
                                                                    .generalNotifiedList[
                                                                        i]
                                                                    .IsApprove ==
                                                                "1"
                                                            ? Visibility(
                                                                visible:
                                                                    !isApproved,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        AppWidget().showGeneralSheet(
                                                                            context,
                                                                            i,
                                                                            "2",
                                                                            reasonController);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            120,
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0,
                                                                            top:
                                                                                10.0,
                                                                            bottom:
                                                                                10.0),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15.0),
                                                                            color: kMainColor),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Approve'.tr(),
                                                                            style:
                                                                                kTextStyle.copyWith(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10.0),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        AppWidget().showGeneralSheet(
                                                                            context,
                                                                            i,
                                                                            "3",
                                                                            reasonController);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            120,
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0,
                                                                            top:
                                                                                10.0,
                                                                            bottom:
                                                                                10.0),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15.0),
                                                                          color:
                                                                              kAlertColor.withOpacity(0.1),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Reject'.tr(),
                                                                            style:
                                                                                kTextStyle.copyWith(color: kAlertColor),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  generalRequestProvider
                                                                              .generalNotifiedList[i]
                                                                              .StatusE ==
                                                                          "Pending"
                                                                      ? GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            generalRequestProvider.updateGeneral(
                                                                                context,
                                                                                i,
                                                                                "2",
                                                                                "Notified");
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                120,
                                                                            padding: const EdgeInsets.only(
                                                                                left: 10.0,
                                                                                right: 10.0,
                                                                                top: 10.0,
                                                                                bottom: 10.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15.0),
                                                                              color: kMainColor,
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                'Notify'.tr(),
                                                                                style: kTextStyle.copyWith(color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Text(
                                                                          generalRequestProvider.generalNotifiedList[i].StatusE == "Pending"
                                                                              ? "Notified"
                                                                              : generalRequestProvider.generalNotifiedList[i].StatusA,
                                                                          style: TextStyle(
                                                                              color: kGreenColor,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                ],
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.5,
                                      child: Center(
                                        child: Text('No Requests Yet'.tr(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54),
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                        ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget ShowCashNotifiedList(
      {required bool isApproved,
      required TextEditingController reasonController}) {
    return Consumer<CashProvider>(builder: (context, cashProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: kBgColor,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  cashProvider.isLoading
                      ? Expanded(
                          child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.grey[100],
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black, width: 1.0))),
                              margin: EdgeInsets.only(top: 15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 15, right: 10),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          height: 8,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                        margin: EdgeInsets.only(right: 10),
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 15),
                                    height: 200,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                      : Visibility(
                          visible: true,
                          child: cashProvider.cashNotifiedList.length != 0
                              ? Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              150,
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount: cashProvider
                                            .cashNotifiedList.length,
                                        itemBuilder: (context, i) {
                                          String EmpImgOrig =
                                              'https://www.w3schools.com/howto/img_avatar.png';
                                          String xx = cashProvider
                                              .cashNotifiedList[i].RequestDate;
                                          String reqDate = xx.substring(0,
                                              10); // Starts from 5 and goes to 10
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                DecisionHistory(
                                                        vacationId: cashProvider
                                                            .cashNotifiedList[i]
                                                            .EmpCashRequestID,
                                                        type: 'cash')
                                                    .launch(context);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0,
                                                    right: 5,
                                                    top: 10,
                                                    bottom: 20),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    border: Border.all(
                                                      color: kTitleColor,
                                                      width: 0.5,
                                                    )),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    ListTile(
                                                      onTap: () {},
                                                      leading: SizedBox(
                                                        width: 50,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: EmpImgOrig,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      title: Text(
                                                        Provider.of<AccountProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .authRepo
                                                                    .getLang() ==
                                                                'ar'
                                                            ? cashProvider
                                                                .cashNotifiedList[
                                                                    i]
                                                                .EmpNameA
                                                            : cashProvider
                                                                .cashNotifiedList[
                                                                    i]
                                                                .EmpNameE,
                                                        style: kTextStyle,
                                                      ),
                                                      subtitle: Text(
                                                        'Employee'.tr(),
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                                kGreyTextColor),
                                                      ),
                                                      trailing: Container(
                                                        height: 50.0,
                                                        width: 90.0,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: kMainColor
                                                              .withOpacity(
                                                                  0.08),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Cash Request'.tr(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: VacColor,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 50,
                                                                  right: 50),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Text(
                                                                'Amount'.tr(),
                                                                style: kTextStyle.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                'RequestDate'
                                                                    .tr(),
                                                                style: kTextStyle.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Divider(
                                                          thickness: 1.0,
                                                          color: kGreyTextColor,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 55,
                                                                  right: 50),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Text(
                                                                cashProvider
                                                                    .cashNotifiedList[
                                                                        i]
                                                                    .LoanAmount,
                                                                style: kTextStyle
                                                                    .copyWith(
                                                                        color:
                                                                            kGreyTextColor),
                                                              ),
                                                              Text(
                                                                reqDate,
                                                                style: kTextStyle
                                                                    .copyWith(
                                                                        color:
                                                                            kGreyTextColor),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    cashProvider
                                                                .cashNotifiedList[
                                                                    i]
                                                                .IsApprove ==
                                                            "1"
                                                        ? Visibility(
                                                            visible:
                                                                !isApproved,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    AppWidget().showCashSheet(
                                                                        context,
                                                                        i,
                                                                        "2",
                                                                        reasonController);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 120,
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0,
                                                                        top:
                                                                            10.0,
                                                                        bottom:
                                                                            10.0),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                15.0),
                                                                        color:
                                                                            kMainColor),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Approve'
                                                                            .tr(),
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width:
                                                                        10.0),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    AppWidget().showCashSheet(
                                                                        context,
                                                                        i,
                                                                        "3",
                                                                        reasonController);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 120,
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0,
                                                                        top:
                                                                            10.0,
                                                                        bottom:
                                                                            10.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0),
                                                                      color: kAlertColor
                                                                          .withOpacity(
                                                                              0.1),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Reject'
                                                                            .tr(),
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                kAlertColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              cashProvider
                                                                          .cashNotifiedList[
                                                                              i]
                                                                          .StatusE ==
                                                                      "Pending"
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        cashProvider.updateCash(
                                                                            context,
                                                                            i,
                                                                            "2",
                                                                            "Notified");
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            120,
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0,
                                                                            top:
                                                                                10.0,
                                                                            bottom:
                                                                                10.0),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15.0),
                                                                          color:
                                                                              kMainColor,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Notify'.tr(),
                                                                            style:
                                                                                kTextStyle.copyWith(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      cashProvider.cashNotifiedList[i].StatusE ==
                                                                              "Pending"
                                                                          ? "Notified"
                                                                          : cashProvider
                                                                              .cashNotifiedList[i]
                                                                              .StatusA,
                                                                      style: TextStyle(
                                                                          color:
                                                                              kGreenColor,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                            ],
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: Center(
                                    child: Text('No Requests Yet'.tr(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                        ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget ShowPenaltyNotifiedList(
      {required bool isApproved,
      required TextEditingController reasonController}) {
    return Consumer<PenaltyProvider>(
        builder: (context, penaltyProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: kBgColor,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  penaltyProvider.isLoading
                      ? Expanded(
                          child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.grey[100],
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black, width: 1.0))),
                              margin: EdgeInsets.only(top: 15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 15, right: 10),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          height: 8,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                        margin: EdgeInsets.only(right: 10),
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 15),
                                    height: 200,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                      : Visibility(
                          visible: true,
                          child: penaltyProvider.PenaltyNotifiedData.length != 0
                              ? Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              150,
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount: penaltyProvider
                                            .PenaltyNotifiedData.length,
                                        itemBuilder: (context, i) {
                                          String EmpImgOrig =
                                              'https://www.w3schools.com/howto/img_avatar.png';
                                          String xx = penaltyProvider
                                              .PenaltyNotifiedData[i]
                                              .RequestDate;
                                          String reqDate = xx.substring(0,
                                              10); // Starts from 5 and goes to 10
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                DecisionHistory(
                                                        vacationId: penaltyProvider
                                                            .PenaltyNotifiedData[
                                                                i]
                                                            .PenaltyRequestID
                                                            .toString(),
                                                        type: 'penalty')
                                                    .launch(context);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0,
                                                    right: 5,
                                                    top: 10,
                                                    bottom: 20),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    border: Border.all(
                                                      color: kTitleColor,
                                                      width: 0.5,
                                                    )),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    ListTile(
                                                      onTap: () {},
                                                      leading: SizedBox(
                                                        width: 50,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: EmpImgOrig,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      title: Text(
                                                        Provider.of<AccountProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .authRepo
                                                                    .getLang() ==
                                                                'ar'
                                                            ? penaltyProvider
                                                                .PenaltyNotifiedData[
                                                                    i]
                                                                .EmpNameA
                                                            : penaltyProvider
                                                                .PenaltyNotifiedData[
                                                                    i]
                                                                .EmpNameE,
                                                        style: kTextStyle,
                                                      ),
                                                      subtitle: Text(
                                                        'Employee'.tr(),
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                                kGreyTextColor),
                                                      ),
                                                      trailing: Container(
                                                        height: 50.0,
                                                        width: 90.0,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: kMainColor
                                                              .withOpacity(
                                                                  0.08),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            reqDate,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: VacColor,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 140,
                                                                  right: 140),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  'Penalty'
                                                                      .tr(),
                                                                  style: kTextStyle.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Divider(
                                                          thickness: 1.0,
                                                          color: kGreyTextColor,
                                                        ),
                                                        const SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 30,
                                                                      right:
                                                                          30),
                                                              child: SizedBox(
                                                                width: 300,
                                                                child: Text(
                                                                  Provider.of<AccountProvider>(context, listen: false)
                                                                              .authRepo
                                                                              .getLang() ==
                                                                          'ar'
                                                                      ? penaltyProvider
                                                                          .PenaltyNotifiedData[
                                                                              i]
                                                                          .PenalityDescA
                                                                      : penaltyProvider
                                                                          .PenaltyNotifiedData[
                                                                              i]
                                                                          .PenalityDescE,
                                                                  maxLines: 3,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    penaltyProvider
                                                                .PenaltyNotifiedData[
                                                                    i]
                                                                .IsApprove ==
                                                            "1"
                                                        ? Visibility(
                                                            visible:
                                                                !isApproved,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    AppWidget().showPenaltySheet(
                                                                        context,
                                                                        i,
                                                                        "2",
                                                                        reasonController);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 120,
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0,
                                                                        top:
                                                                            10.0,
                                                                        bottom:
                                                                            10.0),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                15.0),
                                                                        color:
                                                                            kMainColor),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Approve'
                                                                            .tr(),
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width:
                                                                        10.0),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    AppWidget().showPenaltySheet(
                                                                        context,
                                                                        i,
                                                                        "3",
                                                                        reasonController);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 120,
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0,
                                                                        top:
                                                                            10.0,
                                                                        bottom:
                                                                            10.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0),
                                                                      color: kAlertColor
                                                                          .withOpacity(
                                                                              0.1),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Reject'
                                                                            .tr(),
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                kAlertColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              penaltyProvider
                                                                          .PenaltyNotifiedData[
                                                                              i]
                                                                          .StatusE ==
                                                                      "Pending"
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        penaltyProvider.updatePenalty(
                                                                            context,
                                                                            i,
                                                                            "2",
                                                                            "Notified");
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            120,
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0,
                                                                            top:
                                                                                10.0,
                                                                            bottom:
                                                                                10.0),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15.0),
                                                                          color:
                                                                              kMainColor,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Notify'.tr(),
                                                                            style:
                                                                                kTextStyle.copyWith(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      penaltyProvider.PenaltyNotifiedData[i].StatusE ==
                                                                              "Pending"
                                                                          ? "Notified"
                                                                          : penaltyProvider
                                                                              .PenaltyNotifiedData[i]
                                                                              .StatusA,
                                                                      style: TextStyle(
                                                                          color:
                                                                              kGreenColor,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                            ],
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: Center(
                                    child: Text('No Requests Yet'.tr(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                        ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget ShowEmpPenaltyNotifiedList(
      {required bool isApproved,
      required TextEditingController reasonController}) {
    return Consumer<PenaltyProvider>(
        builder: (context, penaltyProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: kBgColor,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  penaltyProvider.isLoading
                      ? Expanded(
                          child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.grey[100],
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black, width: 1.0))),
                              margin: EdgeInsets.only(top: 15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 15, right: 10),
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          height: 8,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        height: 10,
                                        margin: EdgeInsets.only(right: 10),
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 15),
                                    height: 200,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                      : Visibility(
                          visible: true,
                          child: penaltyProvider
                                      .EmpPenaltyNotifiedData.length !=
                                  0
                              ? Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              150,
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount: penaltyProvider
                                            .EmpPenaltyNotifiedData.length,
                                        itemBuilder: (context, i) {
                                          String EmpImgOrig =
                                              'https://www.w3schools.com/howto/img_avatar.png';
                                          String xx = penaltyProvider
                                              .EmpPenaltyNotifiedData[i]
                                              .RequestDate;
                                          String reqDate = xx.substring(0,
                                              10); // Starts from 5 and goes to 10
                                          dynamic Arabic_name = Provider.of<
                                                      AccountProvider>(context,
                                                  listen: false)
                                              .authRepo
                                              .sharedPreferences
                                              .getString(
                                                  AppConstants.EMP_ARABIC_NAME);
                                          dynamic English_name =
                                              Provider.of<AccountProvider>(
                                                      context,
                                                      listen: false)
                                                  .authRepo
                                                  .sharedPreferences
                                                  .getString(AppConstants
                                                      .EMP_ENGLISH_NAME);
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0,
                                                    right: 5,
                                                    top: 10,
                                                    bottom: 20),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    border: Border.all(
                                                      color: kTitleColor,
                                                      width: 0.5,
                                                    )),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    ListTile(
                                                      onTap: () {},
                                                      leading: SizedBox(
                                                        width: 50,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: EmpImgOrig,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      title: Text(
                                                        Provider.of<AccountProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .authRepo
                                                                    .getLang() ==
                                                                'ar'
                                                            ? Arabic_name
                                                            : English_name,
                                                        style: kTextStyle,
                                                      ),
                                                      subtitle: Text(
                                                        'Employee'.tr(),
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                                kGreyTextColor),
                                                      ),
                                                      trailing: Container(
                                                        height: 50.0,
                                                        width: 90.0,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: kMainColor
                                                              .withOpacity(
                                                                  0.08),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            reqDate,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: VacColor,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 140,
                                                                  right: 140),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  'Penalty'
                                                                      .tr(),
                                                                  style: kTextStyle.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Divider(
                                                          thickness: 1.0,
                                                          color: kGreyTextColor,
                                                        ),
                                                        const SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 30,
                                                                      right:
                                                                          30),
                                                              child: SizedBox(
                                                                width: 300,
                                                                child: Text(
                                                                  Provider.of<AccountProvider>(context, listen: false)
                                                                              .authRepo
                                                                              .getLang() ==
                                                                          'ar'
                                                                      ? penaltyProvider
                                                                          .EmpPenaltyNotifiedData[
                                                                              i]
                                                                          .PenalityDescA
                                                                      : penaltyProvider
                                                                          .EmpPenaltyNotifiedData[
                                                                              i]
                                                                          .PenalityDescE,
                                                                  maxLines: 3,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 20.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: Center(
                                    child: Text('No Requests Yet'.tr(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                        ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget ShowEmpManagementList({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    decoration: AppWidget().boxDecorations(
                        bgColor: Colors.white, radius: 20, showShadow: true),
                    child: Stack(
                      children: [
                        Container(
                          width: context.width(),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            onTap: () {
                              const AttendanceEmployeeList().launch(context);
                            },
                            leading: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: const Image(
                                  width: 40,
                                  height: 40,
                                  image: AssetImage(
                                      'assets/images/employeemanagement.png')),
                            ),
                            title: Text(
                              'Employees'.tr(),
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 35,
                          margin: EdgeInsets.only(top: 25),
                          color: Color(0xFF9090C4),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    decoration: AppWidget().boxDecorations(
                        bgColor: Colors.white, radius: 20, showShadow: true),
                    child: Stack(
                      children: [
                        Container(
                          width: context.width(),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            onTap: () {
                              const LeaveManagement().launch(context);
                            },
                            leading: const Image(
                                width: 40,
                                height: 40,
                                image: AssetImage('assets/images/vac.png')),
                            title: Row(children: [
                              Text(
                                'Vacation Management'.tr(),
                                maxLines: 2,
                                style: kTextStyle.copyWith(
                                    color: kTitleColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Consumer(builder:
                                  (context, EmployeeProvider provider, child) {
                                return Badge(
                                  showBadge: provider.showBadge,
                                  position: BadgePosition.bottomEnd(
                                      bottom: 8, end: 8),
                                  badgeContent: Text(
                                    provider.requestVacationModel.length
                                        .toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.only(right: 10.0),
                                    icon: Icon(
                                      FontAwesomeIcons.bell,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      //  provider.clear();
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => SVNotificationFragment()));
                                    },
                                  ),
                                );
                              }),
                            ]),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 35,
                          margin: EdgeInsets.only(top: 25),
                          color: kAlertColor,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    decoration: AppWidget().boxDecorations(
                        bgColor: Colors.white, radius: 20, showShadow: true),
                    child: Stack(
                      children: [
                        Container(
                          width: context.width(),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            onTap: () {
                              const MissingAttendanceManagement()
                                  .launch(context);
                            },
                            leading: const Image(
                                image: AssetImage(
                                    'assets/images/timeattendance.png')),
                            title: Text(
                              'Attendance Management'.tr(),
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 35,
                          margin: EdgeInsets.only(top: 25),
                          color: Color(0xFFFD73B0),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    decoration: AppWidget().boxDecorations(
                        bgColor: Colors.white, radius: 20, showShadow: true),
                    child: Stack(
                      children: [
                        Container(
                          width: context.width(),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            onTap: () {
                              const LoanManagement().launch(context);
                            },
                            leading: const Image(
                                width: 40,
                                height: 40,
                                image:
                                    AssetImage('assets/images/loanicon.png')),
                            title: Row(children: [
                              Text(
                                'Loan Management'.tr(),
                                maxLines: 2,
                                style: kTextStyle.copyWith(
                                    color: kTitleColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Consumer(builder:
                                  (context, LoanProvider provider, child) {
                                return Badge(
                                  showBadge: provider.showBadge,
                                  position: BadgePosition.bottomEnd(
                                      bottom: 8, end: 8),
                                  badgeContent: Text(
                                    provider.loanNotifyList.length.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.only(right: 10.0),
                                    icon: Icon(
                                      FontAwesomeIcons.bell,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      //provider.clear();
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => SVNotificationFragment()));
                                    },
                                  ),
                                );
                              }),
                            ]),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 35,
                          margin: EdgeInsets.only(top: 25),
                          color: Color(0xFF297E07),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    decoration: AppWidget().boxDecorations(
                        bgColor: Colors.white, radius: 20, showShadow: true),
                    child: Stack(
                      children: [
                        Container(
                          width: context.width(),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            onTap: () {
                              const LoanDelayManagement().launch(context);
                            },
                            leading: const Image(
                                width: 40,
                                height: 40,
                                image: AssetImage(
                                    'assets/images/loandelayicon.png')),
                            title: Row(children: [
                              Text(
                                'Loan Delay Management'.tr(),
                                maxLines: 2,
                                style: kTextStyle.copyWith(
                                    color: kTitleColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Consumer(builder:
                                  (context, LoanDelayProvider provider, child) {
                                return Badge(
                                  showBadge: provider.showBadge,
                                  position: BadgePosition.bottomEnd(
                                      bottom: 8, end: 8),
                                  badgeContent: Text(
                                    provider.loanDelayNotifiedList.length
                                        .toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.only(right: 10.0),
                                    icon: Icon(
                                      FontAwesomeIcons.bell,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      //provider.clear();
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => SVNotificationFragment()));
                                    },
                                  ),
                                );
                              }),
                            ]),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 35,
                          margin: EdgeInsets.only(top: 25),
                          color: Color(0xFFe8870a),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    decoration: AppWidget().boxDecorations(
                        bgColor: Colors.white, radius: 20, showShadow: true),
                    child: Stack(
                      children: [
                        Container(
                          width: context.width(),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            onTap: () {
                              const CashRequestManagement().launch(context);
                            },
                            leading: const Image(
                                width: 40,
                                height: 40,
                                image: AssetImage(
                                    'assets/images/cashreqicon.png')),
                            title: Row(children: [
                              Text(
                                'Cash Management'.tr(),
                                maxLines: 2,
                                style: kTextStyle.copyWith(
                                    color: kTitleColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Consumer(builder:
                                  (context, CashProvider provider, child) {
                                return Badge(
                                  showBadge: provider.showBadge,
                                  position: BadgePosition.bottomEnd(
                                      bottom: 8, end: 8),
                                  badgeContent: Text(
                                    provider.cashNotifiedList.length.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.only(right: 10.0),
                                    icon: Icon(
                                      FontAwesomeIcons.bell,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      // provider.clear();
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => SVNotificationFragment()));
                                    },
                                  ),
                                );
                              }),
                            ]),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 35,
                          margin: EdgeInsets.only(top: 25),
                          color: Color(0xFF4f3c04),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    decoration: AppWidget().boxDecorations(
                        bgColor: Colors.white, radius: 20, showShadow: true),
                    child: Stack(
                      children: [
                        Container(
                          width: context.width(),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            onTap: () {
                              const GeneralRequestManagement().launch(context);
                            },
                            leading: const Image(
                                width: 40,
                                height: 40,
                                image: AssetImage(
                                    'assets/images/general_icon.png')),
                            title: Row(children: [
                              Text(
                                'General Management'.tr(),
                                maxLines: 2,
                                style: kTextStyle.copyWith(
                                    color: kTitleColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Consumer(builder: (context,
                                  GeneralRequestProvider provider, child) {
                                return Badge(
                                  showBadge: provider.showBadge,
                                  position: BadgePosition.bottomEnd(
                                      bottom: 8, end: 8),
                                  badgeContent: Text(
                                    provider.generalNotifiedList.length
                                        .toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.only(right: 10.0),
                                    icon: Icon(
                                      FontAwesomeIcons.bell,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      //  provider.clear();
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => SVNotificationFragment()));
                                    },
                                  ),
                                );
                              }),
                            ]),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 35,
                          margin: EdgeInsets.only(top: 25),
                          color: Color(0xFFf31242),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    decoration: AppWidget().boxDecorations(
                        bgColor: Colors.white, radius: 20, showShadow: true),
                    child: Stack(
                      children: [
                        Container(
                          width: context.width(),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            onTap: () {
                              const PenaltyManagement().launch(context);
                            },
                            leading: const Image(
                                width: 40,
                                height: 40,
                                image: AssetImage(
                                    'assets/images/penaltyicon.png')),
                            title: Row(children: [
                              Text(
                                'Penalty Management'.tr(),
                                maxLines: 2,
                                style: kTextStyle.copyWith(
                                    color: kTitleColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Consumer(builder:
                                  (context, PenaltyProvider provider, child) {
                                return Badge(
                                  showBadge: provider.showBadge,
                                  position: BadgePosition.bottomEnd(
                                      bottom: 8, end: 8),
                                  badgeContent: Text(
                                    provider.PenaltyNotifiedData.length
                                        .toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.only(right: 10.0),
                                    icon: Icon(
                                      FontAwesomeIcons.bell,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      //  provider.clear();
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => SVNotificationFragment()));
                                    },
                                  ),
                                );
                              }),
                            ]),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 35,
                          margin: EdgeInsets.only(top: 25),
                          color: Color(0xFFFA1A1FF),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    decoration: AppWidget().boxDecorations(
                        bgColor: Colors.white, radius: 20, showShadow: true),
                    child: Stack(
                      children: [
                        Container(
                          width: context.width(),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            onTap: () {
                              const ClearanceManagement().launch(context);
                            },
                            leading: const Image(
                                width: 40,
                                height: 40,
                                image: AssetImage('assets/images/out.png')),
                            title: Row(children: [
                              Text(
                                'Clearance Management'.tr(),
                                maxLines: 2,
                                style: kTextStyle.copyWith(
                                    color: kTitleColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Consumer(builder:
                                  (context, ClearanceProvider provider, child) {
                                return Badge(
                                  showBadge: provider.showBadge,
                                  position: BadgePosition.bottomEnd(
                                      bottom: 8, end: 8),
                                  badgeContent: Text(
                                    provider.clearanceEmpData.length.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.only(right: 10.0),
                                    icon: Icon(
                                      FontAwesomeIcons.bell,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      // provider.clear();
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => SVNotificationFragment()));
                                    },
                                  ),
                                );
                              }),
                            ]),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 35,
                          margin: EdgeInsets.only(top: 25),
                          color: Color(0xFF4FA9C9),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget ShowEmpDecisionHistory(
      {required BuildContext context, required bool ShowHistoryList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        Expanded(
          child: Container(
            width: context.width(),
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              color: kBgColor,
            ),
            child: Consumer<VacationProvider>(
                builder: (context, vacationProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  vacationProvider.VacHistoryIsLoading
                      ? Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[400],
                              highlightColor: Colors.grey[100],
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 1.0))),
                                margin: EdgeInsets.only(top: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 15, right: 10),
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(left: 10),
                                            height: 8,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Container(
                                          height: 10,
                                          margin: EdgeInsets.only(right: 10),
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 15),
                                      height: 200,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Visibility(
                          visible: true,
                          child: vacationProvider.ShowHistoryList
                              ? Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: vacationProvider
                                                      .vacationHistoryList
                                                      .length,
                                                  itemBuilder: (context, i) {
                                                    return SingleChildScrollView(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      child: DecisionHistoryList(
                                                          vacationProvider
                                                              .vacationHistoryList[i],
                                                          i),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: Center(
                                    child: Text(
                                      'No History Yet'.tr(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                        ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget ShowEmpDecisionAttendanceHistory(
      {required BuildContext context, required bool ShowHistoryList}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        Expanded(
          child: Container(
            width: context.width(),
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              color: kBgColor,
            ),
            child: Consumer<AttendanceProvider>(
                builder: (context, attendanceProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  attendanceProvider.AttendanceHistoryIsLoading
                      ? Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[400],
                              highlightColor: Colors.grey[100],
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 1.0))),
                                margin: EdgeInsets.only(top: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 15, right: 10),
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(left: 10),
                                            height: 8,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Container(
                                          height: 10,
                                          margin: EdgeInsets.only(right: 10),
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 15),
                                      height: 200,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Visibility(
                          visible: true,
                          child: ShowHistoryList
                              ? Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: attendanceProvider
                                                      .attendanceHistoryList
                                                      .length,
                                                  itemBuilder: (context, i) {
                                                    return SingleChildScrollView(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      child: DecisionAttendanceHistoryList(
                                                          attendanceProvider
                                                              .attendanceHistoryList[i],
                                                          i),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: Center(
                                    child: Text(
                                      'No History Yet'.tr(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                        ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget ShowMarkAttendanceList(
      {required BuildContext context,
      required bool isPresent,
      required bool isAbsent,
      required bool isHalfDay,
      required bool isHoliday,
      required bool inTimeSelected,
      required bool outTimeSelected,
      required TimeOfDay selectedInTime,
      required TimeOfDay selectedOutTime}) {
    return SingleChildScrollView(
      child: Consumer<AttendanceProvider>(
          builder: (context, attendanceProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Container(
              width: context.width(),
              height: context.height(),
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: kBgColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: context.width(),
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Attendance'.tr(),
                          style: kTextStyle,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => {isPresent = !isPresent},
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 30.0,
                                    right: 30.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: isPresent
                                      ? kMainColor
                                      : kMainColor.withOpacity(0.1),
                                ),
                                child: Text(
                                  'Present'.tr(),
                                  style: kTextStyle.copyWith(
                                      color:
                                          isPresent ? Colors.white : kMainColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                                child: Opacity(
                              opacity: 0.5,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 30.0,
                                    right: 30.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: isAbsent
                                      ? kAlertColor
                                      : kAlertColor.withOpacity(0.1),
                                ),
                                child: Text(
                                  'Absent'.tr(),
                                  style: kTextStyle.copyWith(
                                    color:
                                        isAbsent ? Colors.white : kAlertColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // setState(() {
                                //   isHalfDay = !isHalfDay;
                                // });
                              },
                              child: Opacity(
                                opacity: 0.5,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 30.0,
                                      right: 30.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: isHalfDay
                                        ? kHalfDay
                                        : kHalfDay.withOpacity(0.1),
                                  ),
                                  child: Text(
                                    'Half Day'.tr(),
                                    style: kTextStyle.copyWith(
                                        color:
                                            isHalfDay ? Colors.white : kHalfDay,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                // setState(() {
                                //   isHoliday = !isHoliday;
                                // });
                              },
                              child: Opacity(
                                opacity: 0.5,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 30.0,
                                      right: 30.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: isHoliday
                                        ? kGreenColor
                                        : kGreenColor.withOpacity(0.1),
                                  ),
                                  child: Text(
                                    'Holiday'.tr(),
                                    style: kTextStyle.copyWith(
                                      color: isHoliday
                                          ? Colors.white
                                          : kGreenColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: context.width(),
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Attendance'.tr(),
                          style: kTextStyle,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Visibility(
                              visible: inTimeSelected,
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(color: kGreyTextColor),
                                    ),
                                    child: Row(
                                      children: [
                                        TextButton(
                                            onPressed: () async {
                                              attendanceProvider
                                                  .selectInTimeMethod(
                                                      context: context,
                                                      selectedInTime:
                                                          selectedInTime,
                                                      inTimeSelected:
                                                          inTimeSelected);
                                            },
                                            child: Text(
                                                "${selectedInTime.hour}:${selectedInTime.minute} ${selectedInTime.period.toString().substring(10, 12)}")),
                                        const Spacer(),
                                        const Icon(
                                          Icons.access_time,
                                          color: kGreyTextColor,
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !inTimeSelected,
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: AppTextField(
                                    textFieldType: TextFieldType.NAME,
                                    readOnly: true,
                                    onTap: () async {
                                      attendanceProvider.selectInTimeMethod(
                                          context: context,
                                          selectedInTime: selectedInTime,
                                          inTimeSelected: inTimeSelected);
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        suffixIcon: Icon(
                                          Icons.access_time,
                                          color: kGreyTextColor,
                                        ),
                                        labelText: 'In Time'.tr(),
                                        hintText: 'In Time'.tr()),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: outTimeSelected,
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(color: kGreyTextColor),
                                    ),
                                    child: Row(
                                      children: [
                                        TextButton(
                                            onPressed: () async {
                                              attendanceProvider
                                                  .selectOutTimeMethod(
                                                      context: context,
                                                      selectedOutTime:
                                                          selectedOutTime,
                                                      outTimeSelected:
                                                          outTimeSelected);
                                            },
                                            child: Text(
                                                "${selectedOutTime.hour}:${selectedOutTime.minute} ${selectedOutTime.period.toString().substring(10, 12)}")),
                                        const Spacer(),
                                        const Icon(
                                          Icons.access_time,
                                          color: kGreyTextColor,
                                        ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !outTimeSelected,
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: AppTextField(
                                    textFieldType: TextFieldType.NAME,
                                    readOnly: true,
                                    onTap: () async {
                                      attendanceProvider.selectOutTimeMethod(
                                          context: context,
                                          selectedOutTime: selectedOutTime,
                                          outTimeSelected: outTimeSelected);
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        suffixIcon: Icon(
                                          Icons.access_time,
                                          color: kGreyTextColor,
                                        ),
                                        labelText: 'Out Time'.tr(),
                                        hintText: 'Out Time'.tr()),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ButtonGlobal(
                    buttontext: 'Submit Attendance'.tr(),
                    buttonDecoration:
                        kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: () {
                      if (inTimeSelected && outTimeSelected) {
                        DateTime? checkInSelectedTime = DateTime(
                            selectedInTime.hour, selectedInTime.minute);
                        DateTime? checkOutSelectedTime = DateTime(
                            selectedOutTime.hour, selectedOutTime.minute);
                        Duration difference = checkInSelectedTime
                            .difference(checkOutSelectedTime);
                        if (difference.inMinutes > 1) {
                          Provider.of<EmployeeProvider>(context, listen: false)
                              .addAttendance(
                            context,
                            isHoliday,
                            isPresent,
                            selectedInTime,
                            selectedOutTime,
                          );
                        } else {
                          showCustomSnackBar(
                              'selected check-in must be less than check-out time'
                                  .tr(),
                              context,
                              isError: true);
                        }
                      } else {
                        showCustomSnackBar(
                            'select check-in and check-out time'.tr(), context,
                            isError: true);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget showClearanceEmpCard(BuildContext context, isDecision, reasonController, bool ShowList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              color: kBgColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Visibility(
                  visible: true,
                  child: ShowList && Provider.of<ClearanceProvider>(context, listen: false).clearanceEmpData.length != 0
                      ? Expanded(
                          child: Container(
                            height: context.height(),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Consumer<ClearanceProvider>(
                                builder: (context, clearanceProvider, child) {
                              return ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount:
                                      clearanceProvider.clearanceEmpData.length,
                                  itemBuilder: (context, index) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: AppWidget()
                                                .boxDecorations(
                                                    bgColor: Colors.white,
                                                    radius: 20,
                                                    showShadow: true),
                                            child: Column(
                                              children:[
                                            ListTile(
                                              onTap: () {
                                                ClearanceSubManagement(
                                                        EmpCode: clearanceProvider
                                                            .clearanceEmpData[
                                                                index]
                                                            .EmpCode,
                                                        model: clearanceProvider
                                                            .clearanceSubData,
                                                        isDecision: isDecision,
                                                        index: index)
                                                    .launch(context);
                                              },
                                              leading: CachedNetworkImage(
                                                imageUrl:
                                                    'https://www.w3schools.com/howto/img_avatar.png',
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                              title: Text(
                                                  Provider.of<AccountProvider>(
                                                                  context)
                                                              .authRepo
                                                              .getLang() ==
                                                          'ar'
                                                      ? clearanceProvider
                                                          .clearanceEmpData[
                                                              index]
                                                          .EmpNameA
                                                      : clearanceProvider
                                                          .clearanceEmpData[
                                                              index]
                                                          .EmpNameE,
                                                  style: kTextStyle),
                                              subtitle: Text(
                                                  Provider.of<AccountProvider>(
                                                                  context)
                                                              .authRepo
                                                              .getLang() ==
                                                          'ar'
                                                      ? clearanceProvider
                                                          .clearanceEmpData[
                                                              index]
                                                          .PositionDescA
                                                      : clearanceProvider
                                                          .clearanceEmpData[
                                                              index]
                                                          .PositionDescE,
                                                  style: kTextStyle.copyWith(
                                                      color: kGreyTextColor,
                                                      fontSize: 12)),
                                              trailing: const Icon(
                                                  Icons.arrow_forward_ios),
                                                 ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            }),
                          ),
                        )
                      : Provider.of<ClearanceProvider>(context, listen: false)
                                  .isLoading == false
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: Center(
                                child: Text('No Requests Yet'.tr(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54),
                                    textAlign: TextAlign.center),
                              ),
                            )
                          : ShowList == false &&
                                  Provider.of<ClearanceProvider>(context,
                                              listen: false)
                                          .isLoading ==
                                      true
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: Center(
                                    child: Text(
                                      'Loading ...'.tr(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : Offstage(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget ShowMissingAttendance(
      {required bool ShowList,
      required String hint,
      required bool isApproved,
      required selectedOutTime,
      required outTimeSelected,
      selectedTime,
      required selectedDate,
      required TimeToController,
      required dateToController,
      required reasonController}) {
    return Consumer<AttendanceProvider>(
        builder: (context, attendanceProvider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: kBgColor,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  attendanceProvider.isLoading
                      ? Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[400],
                              highlightColor: Colors.grey[100],
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 1.0))),
                                margin: EdgeInsets.only(top: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 15, right: 10),
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(left: 10),
                                            height: 8,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Container(
                                          height: 10,
                                          margin: EdgeInsets.only(right: 10),
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 15),
                                      height: 200,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Visibility(
                          visible: true,
                          child: ShowList
                              ? Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              150,
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount: attendanceProvider
                                            .MissedAttendanceList.length,
                                        itemBuilder: (context, i) {
                                          DateTime checkTime = DateTime.parse(
                                              attendanceProvider
                                                  .MissedAttendanceList[i]
                                                  .AttendanceCheckTime);
                                          DateTime checkOutDate =
                                              DateTime.parse(attendanceProvider
                                                  .MissedAttendanceList[i]
                                                  .AttendanceCheckDate);
                                          String EmployeeCheckOutTime =
                                              DateFormat('HH:mm:ss a')
                                                  .format(checkTime);
                                          String EmployeeCheckTimeDate =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(checkTime);
                                          String EmployeeCheckOutDate =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(checkOutDate);

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                /** history cycle **/
                                                String MissedAttendanceId =
                                                    attendanceProvider
                                                        .MissedAttendanceList[i]
                                                        .attendanceRequestID;
                                                DecisionAttendanceHistory(
                                                        attendanceId:
                                                            MissedAttendanceId)
                                                    .launch(context);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0,
                                                    right: 5,
                                                    top: 10,
                                                    bottom: 20),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  border: Border.all(
                                                      color: kTitleColor,
                                                      width: 0.5),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    ListTile(
                                                      onTap: () {},
                                                      leading:
                                                          CachedNetworkImage(
                                                        imageUrl:
                                                            'https://www.w3schools.com/howto/img_avatar.png',
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            const CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                      title: Text(
                                                          attendanceProvider
                                                              .MissedAttendanceList[
                                                                  i]
                                                              .attendanceDecisionMakerNameE,
                                                          style: kTextStyle),
                                                      subtitle: Text(
                                                          attendanceProvider
                                                              .MissedAttendanceList[
                                                                  i]
                                                              .EmployeePosition,
                                                          style: kTextStyle
                                                              .copyWith(
                                                                  color:
                                                                      kGreyTextColor)),
                                                      trailing: Container(
                                                        height: 50.0,
                                                        width: 120.0,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            color: kMainColor
                                                                .withOpacity(
                                                                    0.08)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                  EmployeeCheckOutTime,
                                                                  style: TextStyle(
                                                                      color:
                                                                          VacColor,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  'check In'
                                                                      .tr(),
                                                                  style: kTextStyle.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  'Check out'
                                                                      .tr(),
                                                                  style: kTextStyle.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  'reason'.tr(),
                                                                  style: kTextStyle
                                                                      .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  maxLines: 2,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Divider(
                                                          thickness: 1.0,
                                                          color: kGreyTextColor,
                                                        ),
                                                        const SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 12),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  EmployeeCheckOutDate,
                                                                  style: kTextStyle
                                                                      .copyWith(
                                                                          color:
                                                                              kGreyTextColor),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  EmployeeCheckTimeDate,
                                                                  style: kTextStyle
                                                                      .copyWith(
                                                                          color:
                                                                              kGreyTextColor),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  attendanceProvider
                                                                      .MissedAttendanceList[
                                                                          i]
                                                                      .attendanceReason,
                                                                  style: kTextStyle
                                                                      .copyWith(
                                                                          color:
                                                                              kGreyTextColor),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    attendanceProvider
                                                                .MissedAttendanceList[
                                                                    i]
                                                                .IsApprove ==
                                                            "1"
                                                        ? Visibility(
                                                            visible:
                                                                !isApproved,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    hint = "";
                                                                    showSheetForMissingAttendance(
                                                                        context,
                                                                        i,
                                                                        "2",
                                                                        attendanceProvider
                                                                            .MissedAttendanceList[
                                                                                i]
                                                                            .RequestStatusID,
                                                                        attendanceProvider
                                                                            .MissedAttendanceList[
                                                                                i]
                                                                            .IsDecision,
                                                                        attendanceProvider
                                                                            .MissedAttendanceList[
                                                                                i]
                                                                            .AttendanceCheckDate,
                                                                        attendanceProvider
                                                                            .MissedAttendanceList[
                                                                                i]
                                                                            .AttendanceCheckTime,
                                                                        attendanceProvider
                                                                            .MissedAttendanceList[i]
                                                                            .FK_InOutSignID,
                                                                        selectedOutTime,
                                                                        outTimeSelected,
                                                                        selectedTime,
                                                                        selectedDate,
                                                                        TimeToController,
                                                                        dateToController,
                                                                        reasonController);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 120,
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0,
                                                                        top:
                                                                            10.0,
                                                                        bottom:
                                                                            10.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0),
                                                                      color:
                                                                          kMainColor,
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Approve'
                                                                            .tr(),
                                                                        style: kTextStyle
                                                                            .copyWith(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10.0,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    showSheetForMissingAttendance(
                                                                        context,
                                                                        i,
                                                                        "3",
                                                                        attendanceProvider
                                                                            .MissedAttendanceList[
                                                                                i]
                                                                            .RequestStatusID,
                                                                        attendanceProvider
                                                                            .MissedAttendanceList[
                                                                                i]
                                                                            .IsDecision,
                                                                        attendanceProvider
                                                                            .MissedAttendanceList[
                                                                                i]
                                                                            .AttendanceCheckDate,
                                                                        attendanceProvider
                                                                            .MissedAttendanceList[
                                                                                i]
                                                                            .AttendanceCheckTime,
                                                                        attendanceProvider
                                                                            .MissedAttendanceList[i]
                                                                            .FK_InOutSignID,
                                                                        selectedOutTime,
                                                                        outTimeSelected,
                                                                        selectedTime,
                                                                        selectedDate,
                                                                        TimeToController,
                                                                        dateToController,
                                                                        reasonController);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 120,
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10.0,
                                                                        top:
                                                                            10.0,
                                                                        bottom:
                                                                            10.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0),
                                                                      color: kAlertColor
                                                                          .withOpacity(
                                                                              0.1),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Reject'
                                                                            .tr(),
                                                                        style: kTextStyle
                                                                            .copyWith(
                                                                          color:
                                                                              kAlertColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              attendanceProvider
                                                                          .MissedAttendanceList[
                                                                              i]
                                                                          .ReqStatusE ==
                                                                      "Pending"
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        await Provider.of<AttendanceProvider>(context, listen: false).updateAttendance(
                                                                            context,
                                                                            i,
                                                                            attendanceProvider.MissedAttendanceList[i].ReqStatusE,
                                                                            attendanceProvider.MissedAttendanceList[i].RequestStatusID,
                                                                            attendanceProvider.MissedAttendanceList[i].attendanceReason,
                                                                            attendanceProvider.MissedAttendanceList[i].AttendanceCheckDate,
                                                                            attendanceProvider.MissedAttendanceList[i].AttendanceCheckTime,
                                                                            attendanceProvider.MissedAttendanceList[i].FK_InOutSignID);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            120,
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10.0,
                                                                            right:
                                                                                10.0,
                                                                            top:
                                                                                10.0,
                                                                            bottom:
                                                                                10.0),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15.0),
                                                                          color:
                                                                              kMainColor,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Notify'.tr(),
                                                                            style:
                                                                                kTextStyle.copyWith(
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      attendanceProvider
                                                                          .MissedAttendanceList[
                                                                              i]
                                                                          .ReqStatusE,
                                                                      style: TextStyle(
                                                                          color:
                                                                              kGreenColor,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                            ],
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : !ShowList
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.5,
                                      child: Center(
                                        child: Text('No Requests Yet'.tr(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54),
                                            textAlign: TextAlign.center),
                                      ),
                                    )
                                  : Offstage(),
                        ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget ShowLocationPermissionAlert(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(2),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Image.asset('assets/images/question.png'),
                        ),
                      ],
                    ),
                    Image.asset('assets/images/locationicon.png'),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Use your location',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          'To see maps for automatically tracked activities,',
                          style: TextStyle(fontSize: 13.0, color: Colors.black),
                        ),
                        Text(
                          'allow huma_life App to use your location all of the time.',
                          style: TextStyle(fontSize: 13.0, color: Colors.black),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Text(
                          'huma_life App collects location data',
                          style: TextStyle(fontSize: 13.0, color: Colors.black),
                        ),
                        Text(
                          'to make sure you make attendance at the company,',
                          style: TextStyle(fontSize: 13.0, color: Colors.black),
                        ),
                        Text(
                          'According to the terms of the agreement,',
                          style: TextStyle(fontSize: 13.0, color: Colors.black),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          'App will take location even when the app is closed',
                          style: TextStyle(fontSize: 13.0, color: Colors.black),
                        ),
                        Text(
                          'or not, As you approve',
                          style: TextStyle(fontSize: 13.0, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Image.asset(
                      'assets/images/maps.png',
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0.0,
                          ),
                          child: Text("DENY",
                              style: TextStyle(color: Colors.lightBlueAccent)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            // initPlatformState(context);
                          },
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0.0,
                          ),
                          child: Text("ACCEPT",
                              style: TextStyle(color: Colors.lightBlueAccent)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            initPlatformState(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget showDialogQrCardState(String title, String message) {
    return Consumer<AttendanceProvider>(
        builder: (context, attendanceProvider, child) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 160,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Wrap(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  color:
                      title == "success" ? Colors.green[400] : Colors.red[400],
                  child: Column(
                    children: <Widget>[
                      Container(height: 10),
                      Icon(Icons.verified_user, color: Colors.white, size: 80),
                      Container(height: 10),
                      title == "success"
                          ? Text("Attendance Success!",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: Colors.white))
                          : Text("Attendance Error!",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: Colors.white)),
                      Container(height: 10),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      title == "success"
                          ? Text(message,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.blueGrey))
                          : Text(message,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: Colors.blueGrey)),
                      Container(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: title == "success"
                              ? Colors.green[500]
                              : Colors.red[500],
                          elevation: 0,
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0)),
                        ),
                        child:
                            Text("Done", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget LanguageItemList(d, index, BuildContext context, authRepo) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.language),
          title: Text(d),
          onTap: () async {
            if (d == 'English') {
              context.setLocale(Locale('en'));
            } else if (d == 'Arabic') {
              context.setLocale(Locale('ar'));
            } else if (d == 'Urdu') {
              context.setLocale(Locale('ur'));
            }
            if (authRepo.isAdmin()) {
              HomeScreenAdmin().launch(context);
            } else {
              HomeScreenEmployee().launch(context);
            }
          },
        ),
        Divider(
          height: 3,
          color: Colors.grey[400],
        )
      ],
    );
  }

  initPlatformState(BuildContext context) async {
    final detectLocation =
        await Provider.of<AccountProvider>(context, listen: false)
            .requestPermission(Permission.location);
    if (!detectLocation) {
      Navigator.pop(context);
    } else {
      await Provider.of<AccountProvider>(context, listen: false)
          .setCurrentLocation(context);
    }
  }

  Future<void> initAttendanceEmployee(
      BuildContext context, showProgress) async {
    var status = await Permission.locationWhenInUse.status;
    if (status != PermissionStatus.granted) {
      Future.delayed(Duration(milliseconds: 1)).then((value) async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AppWidget().ShowLocationPermissionAlert(context));
        Provider.of<EmployeeProvider>(context, listen: false)
            .getEmployeeList(context, '');
        Provider.of<EmployeeProvider>(context, listen: false).clearData();
        showProgress = true;
      });
    } else {
      Future.delayed(Duration(milliseconds: 1)).then((value) async {
        Provider.of<EmployeeProvider>(context, listen: false)
            .getEmployeeList(context, '')
            .then((value) async {
          bool EmployeeListShow =
              await Provider.of<EmployeeProvider>(context, listen: false)
                  .getEmployeeList(context, '');
          if (EmployeeListShow != true) {
            Provider.of<EmployeeProvider>(context, listen: false).showList =
                false;
          } else {
            Provider.of<EmployeeProvider>(context, listen: false).showList =
                true;
          }
        });
        Provider.of<EmployeeProvider>(context, listen: false).clearData();
        showProgress = true;
      });
    }
  }
}
