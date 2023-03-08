import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Common/Util/constant.dart';
import '../../../Data/provider/attendance_provider.dart';

class DecisionAttendanceHistory extends StatefulWidget {
  final String attendanceId;
  const DecisionAttendanceHistory({Key? key, required this.attendanceId}) : super(key: key);

  @override
  _DecisionAttendanceHistory createState() =>
      _DecisionAttendanceHistory(this.attendanceId);
}

class _DecisionAttendanceHistory extends State<DecisionAttendanceHistory> {
  final String attendanceId;
  bool ShowHistoryList = false;
  _DecisionAttendanceHistory(this.attendanceId);

  @override
  void initState() {
    super.initState();
    Provider.of<AttendanceProvider>(context, listen: false).showAttList(attendanceId: attendanceId, ShowHistoryList: ShowHistoryList);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Provider.of<AttendanceProvider>(context, listen: false)
            .AttendanceHistoryIsLoading = true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          elevation: 0.0,
          automaticallyImplyLeading: true,
          titleSpacing: 0.0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Attendance Decision History'.tr(),
            style: kTextStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: AppWidget().ShowEmpDecisionAttendanceHistory(context: context, ShowHistoryList: ShowHistoryList),
      ),
    );
  }
}
