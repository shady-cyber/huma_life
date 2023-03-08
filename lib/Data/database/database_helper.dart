import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:huma_life/Data/database/model/attendance_model.dart';
import 'package:huma_life/Data/database/model/notification_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static const _databaseName = "huma_life.db";
  static const _dbVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance =
      new DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = path.join(dataDirectory.path, _databaseName);
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreateTable,
      onUpgrade: _onUpgradeTable,
    );
  }

  _onCreateTable(Database db, int version) async {
    try {
      String sql = '''
      CREATE TABLE ${AttendanceModel.tableName} 
      (${AttendanceModel.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${AttendanceModel.colEmpCode} STRING,
      ${AttendanceModel.colEmpCheckInDate} TIMESTAMP ,
      ${AttendanceModel.colEmpCheckOutDate} TIMESTAMP,
      current_date DATE DEFAULT (DATE('now','localtime'))
    )''';
      await db.execute(sql);

      //create table form FCM notification
      String sql2 = '''
      CREATE TABLE ${NotificationModel.tableName} 
      (${NotificationModel.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${NotificationModel.colTitle} STRING,
      ${NotificationModel.colBody} STRING,
      ${NotificationModel.colDate} TIMESTAMP,
      ${NotificationModel.colTime} TIMESTAMP,
      ${NotificationModel.colType} STRING,
      ${NotificationModel.colFrom} STRING,
      ${NotificationModel.colUserNameA} STRING,
      ${NotificationModel.colUserNameE} STRING,
      ${NotificationModel.colIsNotify} STRING,
      ${NotificationModel.colIsApprove} STRING,
      ${NotificationModel.colIsDecisions} STRING,
      ${NotificationModel.colRowId} STRING,
      ${NotificationModel.colIsRead} STRING,
      ${NotificationModel.colIsDelete} STRING,
      ${NotificationModel.colNeedAction} STRING DEFAULT '0',
    
      current_date DATE DEFAULT (DATE('now','localtime'))
    )''';
      await db.execute(sql2);
    } catch (e) {
      print(e);
    }
  }

  _onUpgradeTable(Database db, oldVersion, newVersion) async {
    if (oldVersion > newVersion) {
      //create table form FCM notification

    }
  }
}
