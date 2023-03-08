import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Data/provider/profile_provider.dart';
import 'package:huma_life/Common/Util/decrypt.dart';

class EmployeeCard extends StatefulWidget {
  const EmployeeCard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EmployeeCardState();
}

class EmployeeCardState extends State<EmployeeCard> {

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
      body: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
          String data = profileProvider.getEmpCode();
          String _dataString = decrypt.EncryptSHAQr(data);
        return AppWidget().ShowEmpCard(context: context, Qr_code: _dataString);
        }),
    );
  }
}