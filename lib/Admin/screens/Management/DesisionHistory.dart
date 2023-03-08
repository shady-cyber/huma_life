import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Data/provider/vacation_provider.dart';
import 'package:huma_life/Common/Util/constant.dart';

class DecisionHistory extends StatefulWidget {
  final String vacationId;
  final String type;
  const DecisionHistory({Key? key, required this.vacationId, required this.type}) : super(key: key);

  @override
  _DecisionHistory createState() => _DecisionHistory(this.vacationId, this.type);
}

class _DecisionHistory extends State<DecisionHistory> {
  final String vacationId;
  final String type;
  bool ShowHistoryList = false;

  _DecisionHistory(this.vacationId, this.type);

  @override
  void initState() {
    super.initState();
    Provider.of<VacationProvider>(context, listen: false).showVacList(vacationId, type);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Provider.of<VacationProvider>(context, listen: false).VacHistoryIsLoading = true;
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
            'Decision History'.tr(),
            style: kTextStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: AppWidget().ShowEmpDecisionHistory(context: context, ShowHistoryList: ShowHistoryList),
      ),
    );
  }
}
