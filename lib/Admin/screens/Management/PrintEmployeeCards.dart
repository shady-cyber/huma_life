import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Data/provider/employee_provider.dart';

class PrintEmployeeCards extends StatefulWidget {
  const PrintEmployeeCards({Key? key}) : super(key: key);

  @override
  _PrintEmployeeCardsState createState() => _PrintEmployeeCardsState();
}

class _PrintEmployeeCardsState extends State<PrintEmployeeCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Employee Card'.tr(),
          style: kTextStyle.copyWith(color: Colors.white),
        ),
      ),
      body: Consumer<EmployeeProvider>(
          builder: (context, profileProvider, child) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: profileProvider.employeeModel.length,
              itemBuilder: (context, i) {
                String data = profileProvider.employeeModel[i].employeeId.toString();
                String _dataString = profileProvider.EncryptSHAQr(data);
                return AppWidget().ShowEmpCard(context: context, Qr_code: _dataString);
              },
            );
          }),
    );
  }
}
