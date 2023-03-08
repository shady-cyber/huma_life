import 'package:huma_life/Data/database/database_helper.dart';
import 'package:huma_life/Data/database/model/notification_model.dart';
import 'package:sqflite/sqflite.dart';

class NotificationDB {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insertAttendance(NotificationModel notification) async {
    Database db = await _dbHelper.database;
    return await db.insert(NotificationModel.tableName, notification.toJson());
  }

  Future<int?> getNotificationCount() async {
    Database db = await _dbHelper.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM ${NotificationModel.tableName} WHERE ${NotificationModel.colIsRead} = 0'));
  }

  Future<void> setAllNotificationRead() async {
    Database db = await _dbHelper.database;
    await db.rawQuery(
        'UPDATE ${NotificationModel.tableName} SET ${NotificationModel.colIsRead} = 1');
  }

  Future<void> setNotificationRead(int notificationID) async {
    Database db = await _dbHelper.database;
    await db.rawQuery(
        'UPDATE ${NotificationModel.tableName} SET ${NotificationModel.colIsRead} = 1 where ${NotificationModel.colId} = ${notificationID} ');
  }

  Future<List<NotificationModel>> getNotification() async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(
        NotificationModel.tableName,
        where: '${NotificationModel.colIsRead} = "0"');
    return List.generate(maps.length, (i) {
      return NotificationModel.fromJson(maps[i]);
    });
  }
}
