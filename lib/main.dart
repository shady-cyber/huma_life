import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:huma_life/Common/screens/notification/SVNotificationFragment.dart';
import 'package:huma_life/Data/database/db/notificationDB.dart';
import 'package:huma_life/Data/database/model/notification_model.dart';
import 'package:huma_life/Data/provider/account_provider.dart';
import 'package:huma_life/Data/provider/attendance_provider.dart';
import 'package:huma_life/Data/provider/cash_provider.dart';
import 'package:huma_life/Data/provider/clearance_provider.dart';
import 'package:huma_life/Data/provider/connection_string_provider.dart';
import 'package:huma_life/Data/provider/employee_provider.dart';
import 'package:huma_life/Data/provider/general_req_provider.dart';
import 'package:huma_life/Data/provider/loan_delay_provider.dart';
import 'package:huma_life/Data/provider/loan_provider.dart';
import 'package:huma_life/Data/provider/notification_provider.dart';
import 'package:huma_life/Data/provider/profile_provider.dart';
import 'package:huma_life/Data/provider/vacation_provider.dart';
import 'package:huma_life/Data/repository/attendance_repo.dart';
import 'Data/database/database_helper.dart';
import 'Data/provider/penalty_provider.dart';
import 'Data/provider/splash_provider.dart';
import 'app.dart';
import 'di_container.dart' as di;
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

late final AttendanceRepo attendanceRepo;
late final SharedPreferences sharedPreferences;

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();

  // print('Handling a background message ${message.messageId}');
  // print('Handling a background messages ${message.messageType}');

  NotificationDB notification = NotificationDB();
  await notification.insertAttendance(NotificationModel(
    title: message.notification!.title,
    body: message.notification!.body,
    date: DateTime.now().toString(),
    from: message.data['from_user'],
    type: message.data['msg_type'],
    action: message.data['msg_action'],
    isRead: "0",
  ));
  navigatorKey.currentState?.pushNamed('/second', arguments: SVNotificationFragment());
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

Future<void> showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('high_importance_channel', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, 'Location Alert',
      'You are going away from your company location', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("onMessageOpenedApp: $message");
    //print('Handling a background message ${message.messageId}');

    if (message.notification!.body != null) {
      //navigatorKey.currentState?.pushNamed('/second', arguments: SVNotificationFragment());

     // const SVNotificationFragment().launch(context);
    }
  });

  /** firebase initialization **/
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await di.init();
  DatabaseHelper.instance.database;

  runApp(
      MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AccountProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AttendanceProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<VacationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LoanProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<GeneralRequestProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<PenaltyProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LoanDelayProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ClearanceProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ConnectStringProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<EmployeeProvider>()),
    ],
    child: EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('ur')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      useOnlyLangCode: true,
      child: const MyApp(),
      ),
    ),
  );
}
