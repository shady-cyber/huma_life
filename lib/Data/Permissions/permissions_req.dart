import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class permissions_req {

permissions_req(){}
    Future <void> requestPermissions() async{
      Map<Permission, PermissionStatus> statuses = await [
          Permission.camera,
          Permission.location,
      ].request();
      print(statuses[Permission.camera]);
      print(statuses[Permission.location]);
    }
}