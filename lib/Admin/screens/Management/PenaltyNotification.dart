import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Data/provider/penalty_provider.dart';

class PenaltyNotification extends StatefulWidget {
  const PenaltyNotification({Key? key}) : super(key: key);

  @override
  _PenaltyNotificationState createState() => _PenaltyNotificationState();
}

class _PenaltyNotificationState extends State<PenaltyNotification> {

  bool isApproved = false;
  final reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<PenaltyProvider>(context, listen: false).getEmpPenaltyNotifiedList();
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
          'Penalty Notification'.tr(),
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: AppWidget().ShowEmpPenaltyNotifiedList(isApproved: isApproved, reasonController: reasonController),
    );
  }
}
