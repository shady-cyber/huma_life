import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:huma_life/Common/screens/GlobalComponents/button_global.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Common/screens/view/custom_snackbar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreeState createState() => _SettingScreeState();
}

class _SettingScreeState extends State<SettingScreen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  @override
  void dispose() {
    super.dispose();
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
          'Settings'.tr(),
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Material(
                    elevation: 2.0,
                    child: Container(
                      width: context.width(),
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Color(0xFFFFCA05),
                            width: 3.0,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        onTap: () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: SizedBox(
                                  height: 300.0,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      const Image(
                                        image: AssetImage(
                                            'assets/images/clear.png'),
                                      ),
                                      const SizedBox(
                                        height: 45.0,
                                      ),
                                      Text(
                                        'Clear All Data'.tr(),
                                        style: kTextStyle.copyWith(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        'Are you sure?'.tr(),
                                        style: kTextStyle.copyWith(
                                          color: kGreyTextColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        'You want to clear all data.'.tr(),
                                        style: kTextStyle.copyWith(
                                          color: kGreyTextColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      ButtonGlobal(
                                          buttontext: 'OK'.tr(),
                                          buttonDecoration: kButtonDecoration
                                              .copyWith(color: kMainColor),
                                          onPressed: () {
                                            showCustomSnackBar('Data cleared successfully'.tr(), context,isError: false);
                                            Navigator.pop(context);
                                          }),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        leading: const Image(
                            image: AssetImage('assets/images/cleardata.png')),
                        title: Text(
                          'Clear All Data'.tr(),
                          maxLines: 2,
                          style: kTextStyle.copyWith(
                              color: kTitleColor, fontSize: 14.0),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
