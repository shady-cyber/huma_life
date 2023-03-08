import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Data/provider/clearance_provider.dart';

class ClearanceManagement extends StatefulWidget {
  const ClearanceManagement({Key? key}) : super(key: key);

  @override
  _ClearanceManagement createState() => _ClearanceManagement();
}

class _ClearanceManagement extends State<ClearanceManagement> {

  bool isDecision = false;
  final reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1)).then((value) async {
      Provider.of<ClearanceProvider>(context, listen: false).getClearanceNotificationList();
      bool ClearanceListShow = await Provider.of<ClearanceProvider>(context, listen: false).getClearanceEmpList();
      if (ClearanceListShow != true) {
        Provider.of<ClearanceProvider>(context, listen: false).showList = false;
        Provider.of<ClearanceProvider>(context, listen: false).isLoading = false;
      } else {
        Provider.of<ClearanceProvider>(context, listen: false).showList = true;
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
          'Clearance Management'.tr(),
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<ClearanceProvider>(
        builder: (context, clearanceProvider, child) {
         return AppWidget().showClearanceEmpCard(context, isDecision, reasonController, clearanceProvider.showList);
      }),
    );
  }
}
