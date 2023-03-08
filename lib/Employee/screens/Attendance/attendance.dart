import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Data/database/helper/common.dart';
import 'package:huma_life/Data/provider/attendance_provider.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import '../../../Common/Util/AppWidget.dart';

class attendance extends StatefulWidget {
  const attendance({Key? key}) : super(key: key);

  @override
  State<attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<attendance> {
  String loc = "";
  bool checker = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    var status = await Permission.locationWhenInUse.status;
    if (status != PermissionStatus.granted) {
      showDialog(context: context, barrierDismissible: false, builder: (_) => AppWidget().ShowLocationPermissionAlert(context));
    } else {
      Provider.of<AttendanceProvider>(context, listen: false).getLocations(context);
      Provider.of<AttendanceProvider>(context, listen: false).attendanceSwitcher();
      /** check for the configuration attendance **/
      await Provider.of<AttendanceProvider>(context, listen: false)
          .getConfiguration();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AttendanceProvider>(
        builder: (context, attendanceProvider, child) => Form(
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: kMainColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'My Attendance'.tr(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'sheriff',
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Be with us at a time'.tr(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'sheriff',
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          )),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              'Active your attendance mode'.tr(),
                              style: TextStyle(
                                  fontSize: 23,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'sheriff',
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                ),
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: attendanceProvider.main_button_color,
                                  ),
                                  child: Text(
                                    attendanceProvider.buttonText,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                onPressed: () async {
                                  attendanceProvider.initPlatformState(
                                      context: context);
                                  if (attendanceProvider.enabled) {
                                    if (attendanceProvider.buttonText ==
                                        'Check-In') {
                                      await attendanceProvider.checkIn(
                                          context: context);
                                    } else {
                                      await attendanceProvider.CheckedOutChoice(
                                          context);
                                    }
                                  } else {
                                    attendanceProvider.showMessage("you are already checked out".tr(), context);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Wish You Good Day'.tr(),
                              style: TextStyle(
                                  fontSize: 20,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'sheriff',
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              Common().getFormattedDate() + ' ' + Common().getFormattedTime(),
                              style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'sheriff',
                                  color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DigitalClock(
                              hourMinuteDigitTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 50,
                              ),
                              areaDecoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              secondDigitTextStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 50,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
