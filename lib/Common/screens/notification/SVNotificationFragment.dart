import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:huma_life/Data/model/notification-model.dart';
import 'package:huma_life/Data/provider/notification_provider.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'components/SVBirthdayNotificationComponent.dart';
import 'components/SVLikeNotificationComponent.dart';
import 'components/SVNewPostNotificationComponent.dart';
import 'components/SVRequestNotificationComponent.dart';

class SVNotificationFragment extends StatefulWidget {
  const SVNotificationFragment({Key? key}) : super(key: key);

  @override
  State<SVNotificationFragment> createState() => _SVNotificationFragmentState();
}

class _SVNotificationFragmentState extends State<SVNotificationFragment> {
  Widget getNotificationComponent(
      {String? type, required SVNotificationModel element}) {
    if (type == SVNotificationType.like) {
      return SVLikeNotificationComponent(element: element);
    } else if (type == SVNotificationType.request) {
      return SVRequestNotificationComponent(element: element);
    } else if (type == SVNotificationType.newPost) {
      return SVNewPostNotificationComponent(element: element);
    } else {
      return SVBirthdayNotificationComponent(element: element);
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<NotificationProvider>(context, listen: false)
        .getNotificationsToday();
    afterBuildCreated(() {
      setStatusBarColor(kMainColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
        builder: (context, _notificationProvider, child) => Form(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: kMainColor,
                appBar: AppBar(
                  backgroundColor: kMainColor,
                  elevation: 0.0,
                  titleSpacing: 0.0,
                  iconTheme: const IconThemeData(color: Colors.white),
                  title: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Notifications'.tr(),
                          style: TextStyle(
                              fontSize: 25,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'sheriff',
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                  Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              bottom: 10, top: 20, right: 10, left: 10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0)),
                            color: Colors.white,
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) =>
                                RefreshIndicator(
                                  onRefresh: () {
                                    return _notificationProvider
                                        .getNotificationsToday();
                              },
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TODAY', style: boldTextStyle())
                                    .paddingAll(16),
                                Divider(height: 0, indent: 16, endIndent: 16),
                                Column(
                                  children: //get data from future function
                                  _notificationProvider.notificationListToday
                                      .map((element) => getNotificationComponent(
                                          type: element.notificationType,
                                          element: element))
                                      .toList(),

                                  ),
                                Text('THIS MONTH', style: boldTextStyle())
                                    .paddingAll(16),
                                Divider(height: 0, indent: 16, endIndent: 16),

                                Column(
                                  children: _notificationProvider.getNotificationsThisMonth().map((e) {
                                    return getNotificationComponent(
                                        type: e.notificationType, element: e);
                                  }).toList(),
                                ),
                                Text('Earlier', style: boldTextStyle())
                                    .paddingAll(16),
                                Divider(height: 0, indent: 16, endIndent: 16),
                                Column(
                                  children: _notificationProvider
                                      .getNotificationsEarlier()
                                      .map((e) {
                                    return getNotificationComponent(
                                        type: e.notificationType, element: e);
                                  }).toList(),
                                ),
                                16.height,
                              ],
                            ),
                          ),
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ));
  }
}
