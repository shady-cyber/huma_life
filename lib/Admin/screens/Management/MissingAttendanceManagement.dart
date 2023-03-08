import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Data/provider/attendance_provider.dart';
import 'package:huma_life/Common/Util/constant.dart';

class MissingAttendanceManagement extends StatefulWidget {
  const MissingAttendanceManagement({Key? key}) : super(key: key);

  @override
  _MissingAttendanceManagement createState() => _MissingAttendanceManagement();
}

class _MissingAttendanceManagement extends State<MissingAttendanceManagement> {
  bool isApproved = false;
  bool ShowList = false;
  final reasonController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime? selectedDate = DateTime.now();
  final dateToController = TextEditingController();
  final TimeToController = TextEditingController();
  bool TimeSelected = false;
  String hint = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1)).then((value) async {
      bool MissedAttendanceShow =
          await Provider.of<AttendanceProvider>(context, listen: false)
              .getMissedAttendanceList(ShowList);

      if (MissedAttendanceShow != true) {
        ShowList = false;
      } else {
        ShowList = true;
      }
    });
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
          'Missed Attendance List'.tr(),
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: AppWidget().ShowMissingAttendance(ShowList: ShowList, hint: hint, isApproved: isApproved, selectedOutTime: selectedTime,
          outTimeSelected: TimeSelected, selectedDate: selectedDate, TimeToController: TimeToController, dateToController: dateToController,
          reasonController: reasonController)
    );
  }
}
