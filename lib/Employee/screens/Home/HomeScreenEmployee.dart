import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/Util/AppWidget.dart';
import 'package:huma_life/Common/screens/notification/SVNotificationFragment.dart';
import 'package:huma_life/Data/provider/notification_provider.dart';
import 'package:huma_life/Data/provider/account_provider.dart';
import 'package:huma_life/Common/Util/constant.dart';

import '../../../Data/provider/penalty_provider.dart';

class HomeScreenEmployee extends StatefulWidget {
  const HomeScreenEmployee({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenEmployee> {
  bool isChecked = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1)).then((value) async {
      await Provider.of<NotificationProvider>(context, listen: false)
          .initFirebasePushNotification(context);
      await Provider.of<NotificationProvider>(context, listen: false)
          .NotificationCount();
      try {
        await Provider.of<AccountProvider>(context, listen: false)
            .reloadUsername()
            .then((value) {
          Provider
              .of<AccountProvider>(context, listen: false)
              .EnglishName =
              Provider.of<AccountProvider>(context, listen: false)
                  .getEmpUsername();
          Provider
              .of<AccountProvider>(context, listen: false)
              .ArabicName = Provider.of<AccountProvider>(context, listen: false)
              .getEmpUsernameA();
          Provider.of<AccountProvider>(context, listen: false).notifyAll();
        });
        Provider.of<PenaltyProvider>(context, listen: false)
            .getEmpPenaltyNotifiedList();
      }catch(e){}
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AppWidget().showDialogExit(context: context);
            });

        return value == true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          elevation: 0.0,
          titleSpacing: 5.0,
          toolbarHeight: 80,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Consumer<AccountProvider>(
              builder: (context, authProvider, child) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.authRepo.getLang() == 'ar' ?
                          authProvider.ArabicName
                              : authProvider.EnglishName,
                        maxLines: 2,
                        style: kTextStyle.copyWith(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'You are welcome'.tr(),
                        maxLines: 2,
                        style: kTextStyle.copyWith(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
              }),
          actions: [
            Consumer(builder: (context, NotificationProvider provider, child) {
              return Badge(
                showBadge: provider.showBadge,
                position: BadgePosition.topEnd(top: 15, end: 9),
                badgeContent: Text(
                  provider.notificationCount.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: IconButton(
                  padding: EdgeInsets.only(right: 10.0),
                  icon: Icon(
                    FontAwesomeIcons.bell,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    provider.clear();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SVNotificationFragment()));
                  },
                ),
              );
            }),
          ],
        ),
        drawer: AppWidget().appDrawerEmployee(context: context),
        body: AppWidget().appDrawerWidgets(context: context, type: "Employee"),
      ),
    );
  }
}
