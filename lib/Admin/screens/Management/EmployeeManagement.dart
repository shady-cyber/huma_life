import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Data/provider/attendance_provider.dart';
import 'package:huma_life/Data/provider/cash_provider.dart';
import 'package:huma_life/Data/provider/clearance_provider.dart';
import 'package:huma_life/Data/provider/general_req_provider.dart';
import 'package:huma_life/Data/provider/loan_provider.dart';
import 'package:huma_life/Data/provider/penalty_provider.dart';
import 'package:huma_life/Data/provider/employee_provider.dart';
import 'package:huma_life/Data/provider/loan_delay_provider.dart';

class EmployeeManagement extends StatefulWidget {
  const EmployeeManagement({Key? key}) : super(key: key);

  @override
  _EmployeeManagementState createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement> {

  @override
  void initState() {
    super.initState();
    Provider.of<EmployeeProvider>(context, listen: false).getVacationsList();
    Provider.of<AttendanceProvider>(context, listen: false).getMissedAttendanceList(true);
    Provider.of<LoanProvider>(context, listen: false).getLoanNotifiedList();
    Provider.of<LoanDelayProvider>(context, listen: false).getLoansDelayNotifiedList();
    Provider.of<CashProvider>(context, listen: false).getCashNotifiedList();
    Provider.of<GeneralRequestProvider>(context, listen: false).getGeneralNotifiedList();
    Provider.of<ClearanceProvider>(context, listen: false).getClearanceEmpList();
    Provider.of<PenaltyProvider>(context, listen: false).getPenaltyNotifiedList();
    Provider.of<ClearanceProvider>(context, listen: false).getClearanceNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Employee Management'.tr(),
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: AppWidget().ShowEmpManagementList(context: context),
    );
  }
}
