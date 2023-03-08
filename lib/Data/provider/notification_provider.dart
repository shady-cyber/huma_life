import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:huma_life/Admin/screens/Management/CashRequestManagement.dart';
import 'package:huma_life/Admin/screens/Management/ClearanceManagement.dart';
import 'package:huma_life/Admin/screens/Management/GeneralRequestManagement.dart';
import 'package:huma_life/Admin/screens/Management/LeaveManagement.dart';
import 'package:huma_life/Admin/screens/Management/LoanDelayManagement.dart';
import 'package:huma_life/Admin/screens/Management/LoanManagement.dart';
import 'package:huma_life/Admin/screens/Management/MissingAttendanceManagement.dart';
import 'package:huma_life/Admin/screens/Management/PenaltyNotification.dart';
import 'package:huma_life/Common/screens/notification/SVNotificationFragment.dart';
import 'package:huma_life/Data/database/db/notificationDB.dart';
import 'package:huma_life/Data/database/model/notification_model.dart';
import 'package:huma_life/Data/model/notification-model.dart';
import 'package:huma_life/Data/repository/notification_repo.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationRepo notificationRepo;

  NotificationProvider({required this.notificationRepo});

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool? _subscribed;
  bool? get subscribed => _subscribed;
  int _notificationLength = 0;
  int get notificationLength => _notificationLength;
  int _savedNlength = 0;
  int get savedNlength => _savedNlength;
  int _notificationFinalLength = 0;
  int get notificationFinalLength => _notificationFinalLength;
  int notificationCount = 0;
  bool showBadge = false;
  bool isActive = false;
  List<SVNotificationModel> notificationListToday = [];

  Future<String?> firebasetoken() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    String? _token = await _fcm.getToken();
    return _token;
  }

  Future _handleIosNotificationPermissaion() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future initFirebasePushNotification(context) async {
    String? _token = await _fcm.getToken();
    await notificationRepo.saveToken(_token!).then((value) async {
      if (Platform.isIOS) {
        _handleIosNotificationPermissaion();
      }
      handleFcmSubscribtion();

      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      print('inittal message : $initialMessage');
      if (initialMessage != null) {
        //nextScreen(context, NotificationsPage());
      }
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        showBadge = true;
        await saveNotificationData(message);
        //notificationCount = (int.parse(notificationCount) + 1).toString();

        // showCustomSnackBar(message.notification?.body,context,isError: false);
        /** show vacation dialog **/
        showinAppDialog(
            context, message.notification!.title, message.notification!.body);
        notifyListeners();
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        //navigatorKey.currentState?.pushNamed('/second', arguments: SVNotificationFragment());
        //nextScreen(context, NotificationsPage());
       // const SVNotificationFragment().launch(context);
      });

      notifyListeners();
    });
  }

  Future handleFcmSubscribtion() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    bool _getsubcription = sp.getBool('subscribe') ?? true;
    if (_getsubcription == true) {
      await sp.setBool('subscribe', true);
      _fcm.subscribeToTopic('huma_life');
      _subscribed = true;
      notifyListeners();
      print('subscribed');
    } else {
      await sp.setBool('subscribe', false);
      _fcm.unsubscribeFromTopic('huma_life');
      _subscribed = false;
      notifyListeners();
      print('unsubscribed');
    }

    notifyListeners();
  }

  Future<void> NotificationCount() async {
    notificationCount = (await notificationRepo.getNotificationCount())!;
    if (notificationCount > 0) {
      showBadge = true;
    } else {
      showBadge = false;
    }
    notifyListeners();
  }

  void callNotificationRequests(String? data, int notification_id, context){
    if(data == ("Clearance Request")){
      const ClearanceManagement().launch(context);
    }
    else if(data == ("Vacation Request")){
      const LeaveManagement().launch(context);
    }
    else if(data == ("Loan request")){
      const LoanManagement().launch(context);
    }
    else if(data == ("Loan Delay Request")){
      const LoanDelayManagement().launch(context);
    }
    else if(data == ("Cash In Advance Request")){
      const CashRequestManagement().launch(context);
    }
    else if(data == ("General Request")){
      const GeneralRequestManagement().launch(context);
    }
    else if(data == ("Penalty Request")){
      const PenaltyNotification().launch(context);
    }
    else if(data == ("Attendance Request")){
      const MissingAttendanceManagement().launch(context);
    }
    notificationRepo.setNotificationRead(notification_id);
    notifyListeners();
  }

  Future<void> getNotificationsToday() async {
    //get notification from model and add to list
    Future<List<NotificationModel>> notificationList =
        notificationRepo.getNotification();
    notificationListToday.clear();
    final f = new DateFormat('yyyy-MM-dd hh:mm');
    await notificationList.then((value) {
      value.forEach((element) {
        notificationListToday.add(SVNotificationModel(
          id: element.id!,
          name: element.title,
          secondName: element.user_nameA,
          IsApprove: element.IsApprove ?? "0",
          IsDecision: element.IsDecisions ?? "0",
          isNotified: element.IsNotify ?? "0",
          //convert element.date to hh:mm a
          time: f.format(DateTime.parse(element.date ?? "")),
          profileImage: 'https://www.w3schools.com/howto/img_avatar.png',
          notificationType: SVNotificationType.request,
          isOfficial: true,
        ));
      });
    });
    notifyListeners();
  }

  Future<void> saveNotificationData(RemoteMessage message) async {
    NotificationDB notification = NotificationDB();
    await notification.insertAttendance(NotificationModel(
      title: message.notification!.title,
      body: message.notification!.body,
      from: message.data['from_user'],
      IsApprove: message.data['IsApprove'],
      IsNotify: message.data['IsNotify'],
      IsDecisions: message.data['IsDecision'],
      user_nameA: message.data['user_nameA'],
      user_nameE: message.data['user_nameE'],
      rowId: message.data['id'],
      date: DateTime.now().toString(),
      type: message.data['msg_type'],
      action: message.data['msg_action'],
      isRead: "0",
    ));
    NotificationCount();
    notifyListeners();
  }

  List<SVNotificationModel> getNotificationsThisMonth() {
    List<SVNotificationModel> list = [];
    return list;
  }

  List<SVNotificationModel> getNotificationsEarlier() {
    List<SVNotificationModel> list = [];
    return list;
  }

  void clear() {
    showBadge = false;
    // notificationRepo.clear();
    notifyListeners();
  }

  showinAppDialog(context, title, body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        content: ListTile(
          title: Text(title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              )),
          subtitle: Text("$body",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              )),
        ),
        actions: [
          TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          TextButton(
              child: Text('Open'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SVNotificationFragment()));
                // nextScreen(context, NotificationsPage());
              }),
        ],
      ),
    );
  }
}
