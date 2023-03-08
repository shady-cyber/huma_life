import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:huma_life/Common/screens/view/custom_snackbar.dart';
import 'package:huma_life/Data/repository/attendance_repo.dart';

class Common {
  final now = new DateTime.now();
  String longitude = "";
  String latitude = "";
  String loc = "";
  late final AttendanceRepo attendanceRepo;

  String getFormattedDate() {
    return DateFormat.yMMMMd('en_US').format(now);
  }

  String getFormattedTime() {
    return DateFormat.jm('en_US').format(now);
  }

  Future<String> scanQR(BuildContext context) async {
    if (await Permission.camera.request().isGranted) {
      String barcode = "";
      await FlutterBarcodeScanner.scanBarcode(
              "#000000", "Cancel", true, ScanMode.QR)
          .then((value){
            barcode = value;
      });
      if (barcode == "-1") {
        showCustomSnackBar('Please start scan attendance Qr code'.tr(), context,
            isError: true);
        return "";
      } else {
        return barcode;
      }
    }
    return "";
  }
}
