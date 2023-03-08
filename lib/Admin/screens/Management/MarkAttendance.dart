import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/screens/GlobalComponents/button_global.dart';
import 'package:huma_life/Common/screens/view/custom_snackbar.dart';
import 'package:huma_life/Data/provider/employee_provider.dart';
import 'package:huma_life/Common/Util/constant.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({Key? key}) : super(key: key);

  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  bool isPresent = false;
  bool isAbsent = false;
  bool isHalfDay = false;
  bool isHoliday = false;
  bool inTimeSelected = false;
  bool outTimeSelected = false;
  TimeOfDay selectedInTime = TimeOfDay.now();
  TimeOfDay selectedOutTime = TimeOfDay.now();

  _selectInTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedInTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedInTime) {
      setState(() {
        selectedInTime = timeOfDay;
        inTimeSelected = true;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  _selectOutTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedOutTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedOutTime) {
      setState(() {
        selectedOutTime = timeOfDay;
        outTimeSelected = true;
      });
    }
  }

  @override
  void dispose() {
    _selectInTime(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Mark Attendance'.tr(),
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                              onTap: () {
                                setState(() {
                                  isPresent = !isPresent;
                                });
                              },
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
                                onTap: () {
                                  // setState(() {
                                  //   isAbsent = !isAbsent;
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
                                      color: isAbsent
                                          ? kAlertColor
                                          : kAlertColor.withOpacity(0.1),
                                    ),
                                    child: Text(
                                      'Absent'.tr(),
                                      style: kTextStyle.copyWith(
                                        color: isAbsent
                                            ? Colors.white
                                            : kAlertColor,
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
                                              _selectInTime(context);
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
                                      _selectInTime(context);
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
                                              _selectOutTime(context);
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
                                      _selectOutTime(context);
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
                        // Duration difference = checkInSelectedTime
                        //     .difference(checkOutSelectedTime);
                        if (checkInSelectedTime.isBefore(checkOutSelectedTime)) {
                          Provider.of<EmployeeProvider>(context, listen: false)
                              .addAttendance(
                            context,
                            isHoliday,
                            isPresent,
                            selectedInTime,
                            selectedOutTime,
                          );
                        } else if(checkOutSelectedTime.isBefore(checkInSelectedTime)){
                          showCustomSnackBar(
                              'selected check-in must be less than check-out time'.tr(),
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
        ),
      ),
    );
  }
}