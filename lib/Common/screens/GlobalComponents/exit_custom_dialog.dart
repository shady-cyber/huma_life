import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:huma_life/Common/Util/constant.dart';

class CheckOutCustomDialog extends StatelessWidget {
  CheckOutCustomDialog();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

dialogContent(BuildContext context) {
  var width = MediaQuery.of(context).size.width;

  return Container(
    decoration: BoxDecoration(
      color: context.scaffoldBackgroundColor,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(40),
      boxShadow: defaultBoxShadow(),
      border: Border.all(
          width: 1,
          color: Colors.red //                   <--- border width here
          ),
    ),
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.all(16.0),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: [
          SvgPicture.asset("assets/images/exit.svg",
              width: width * 0.15, height: width * 0.2, fit: BoxFit.fill),
          SizedBox(height: 16.0),
          Text("Are You Sure Want To Exit",
              style: secondaryTextStyle(), textAlign: TextAlign.center),
          SizedBox(height: 16.0),
          // Text(day, style: primaryTextStyle(), textAlign: TextAlign.center),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    exit(0);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    primary: kMainColor, // Background color
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "YES",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    primary: kMainColor, // Background color
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                    child: Text(
                      "NO",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
