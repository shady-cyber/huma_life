import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:huma_life/Common/Util/appConstatns.dart';
import 'package:huma_life/Data/database/db/notificationDB.dart';
import 'package:huma_life/Data/database/model/notification_model.dart';
import 'package:huma_life/Data/datasource/dio/dio_client.dart';

class NotificationRepo {
  final SharedPreferences sharedPreferences;
  final DioClient dioClient;
  NotificationDB notification = NotificationDB();

  NotificationRepo({required this.dioClient, required this.sharedPreferences});

  Future<void> saveToken(String token) async {
    sharedPreferences.setString(AppConstants.FCM_TOKEN, token);
    dioClient.post(AppConstants.SEND_TOKEN, data: {'token': token});
  }

  Future<void> saveNotification(RemoteMessage message) async {
    sharedPreferences.setString("fcmmessage", message.toString());
  }

  Future<int?> getNotificationCount() async {
    return await notification.getNotificationCount();
  }

  Future<void> clear() async {
    await notification.setAllNotificationRead();
  }

  Future<List<NotificationModel>> getNotification() async {
    return await notification.getNotification();
  }

  Future<void> setNotificationRead(int notificationID) async {
    await notification.setNotificationRead(notificationID);
  }

}
