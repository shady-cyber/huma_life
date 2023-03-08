import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Data/provider/loan_delay_provider.dart';

class LoanDelayManagement extends StatefulWidget {
  const LoanDelayManagement({Key? key}) : super(key: key);

  @override
  _LoanDelayManagementState createState() => _LoanDelayManagementState();
}

class _LoanDelayManagementState extends State<LoanDelayManagement> {
  bool isApproved = false;
  final reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<LoanDelayProvider>(context, listen: false).getLoansDelayNotifiedList();
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
          'Loan Delay List'.tr(),
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: AppWidget().ShowLoanDelayNotifiedList(isApproved: isApproved, reasonController: reasonController),
    );
  }
}
