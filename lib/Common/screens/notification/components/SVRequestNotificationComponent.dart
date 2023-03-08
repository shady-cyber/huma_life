import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Data/model/notification-model.dart';
import 'package:huma_life/Common/Util/constant.dart';
import 'package:huma_life/Data/provider/notification_provider.dart';

class SVRequestNotificationComponent extends StatefulWidget {
  final SVNotificationModel element;

  SVRequestNotificationComponent({required this.element});

  @override
  State<SVRequestNotificationComponent> createState() => _State(this.element);
}

class _State extends State<SVRequestNotificationComponent> {
  final SVNotificationModel element;

  _State(this.element);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Consumer<NotificationProvider>(
          builder: (context, notificationProvider, child) {
        return GestureDetector(
          onTap: () {
            setState(() {
              notificationProvider.callNotificationRequests(element.name!,element.id!, context);
            });
          },
          child: Container(
            width: context.width(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: kBorderColorTextField,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.width,
                Column(
                  children: [
                    Row(
                      children: [
                        Text(element.name.validate(),
                            style: boldTextStyle(size: 14)),
                        2.width,
                      ],
                      mainAxisSize: MainAxisSize.min,
                    ),
                    6.height,
                    Text(element.secondName ?? "",
                        style: secondaryTextStyle(size: 12)),
                    6.height,
                    Text('${element.time}',
                        style: secondaryTextStyle(color: kRedColor, size: 12)),
                    16.height,
                    (element.IsApprove == "1")
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppButton(
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: radius(10)),
                                text: 'Confirm',
                                textStyle: secondaryTextStyle(
                                    color: Colors.white, size: 14),
                                onTap: () {},
                                elevation: 0,
                                color: kMainColor,
                                height: 32,
                              ),
                              50.width,
                              AppButton(
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: radius(10)),
                                text: 'Decline',
                                textStyle: secondaryTextStyle(
                                    color: Colors.white, size: 14),
                                onTap: () {},
                                elevation: 0,
                                color: Colors.red,
                                height: 32,
                              ),
                            ],
                          )
                        : Offstage(),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ],
            ).paddingAll(16),
          ),
        );
      }),
    );
  }
}
