import 'dart:core';
import 'package:easy_localization/easy_localization.dart';
import 'package:huma_life/Data/database/database_helper.dart';
import 'package:huma_life/Data/database/model/attendance_model.dart';
import 'package:sqflite/sqflite.dart';

class AttendanceDB {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insertAttendance(AttendanceModel attendance) async {
    Database db = await _dbHelper.database;
    return await db.insert(AttendanceModel.tableName, attendance.toJson());
  }

  Future<List<AttendanceModel>> getAttendanceByCurrentDay(
      String empCode) async {
    Database db = await _dbHelper.database;
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    List<Map<String, dynamic>> maps = await db.query(AttendanceModel.tableName,
        where: '${AttendanceModel.colEmpCode} = ? AND CURRENT_DATE = ?',
        whereArgs: [empCode, formattedDate]);

    return List.generate(maps.length, (i) {
      return AttendanceModel(
        id: maps[i][AttendanceModel.colId],
        empCode: maps[i][AttendanceModel.colEmpCode].toString(),
        empCheckInDate: maps[i][AttendanceModel.colEmpCheckInDate],
        empCheckOutDate: maps[i][AttendanceModel.colEmpCheckOutDate],
      );
    });
  }

  Future<List<AttendanceModel>> getUnCheckedOutDate(String empCode) async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query(AttendanceModel.tableName,
        where: 'current_date != DATE(\'now\',\'localtime\') AND '
            '${AttendanceModel.colEmpCode} = ?',
        whereArgs: [empCode]);
    List<AttendanceModel> attendanceList = [];

    for (int i = 0; i < maps.length; i++) {
      if (maps[i][AttendanceModel.colEmpCheckOutDate] == null ||
          maps[i][AttendanceModel.colEmpCheckOutDate] == '') {
        attendanceList.add(AttendanceModel(
          id: maps[i][AttendanceModel.colId],
          empCode: maps[i][AttendanceModel.colEmpCode].toString(),
          empCheckInDate: maps[i][AttendanceModel.colEmpCheckInDate],
          empCheckOutDate: maps[i][AttendanceModel.colEmpCheckOutDate],
          currentDate: maps[i][AttendanceModel.colCurrentDate],
        ));
      }
    }
    return attendanceList;
  }

  Future<int> updateAttendance(AttendanceModel attendance) async {
    Database db = await _dbHelper.database;
    //update only check out date

    return await db.update(AttendanceModel.tableName, attendance.toJson(),
        where: '${AttendanceModel.colEmpCode} = ?',
        whereArgs: [attendance.empCode]);
  }

  Future<int> deleteAttendance(int id) async {
    Database db = await _dbHelper.database;
    return await db.delete(AttendanceModel.tableName,
        where: '${AttendanceModel.colId} = ?', whereArgs: [id]);
  }
}
