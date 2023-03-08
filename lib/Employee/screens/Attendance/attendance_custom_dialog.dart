import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';

class AttendanceCustomDialog extends StatelessWidget {
  final String day;
  AttendanceCustomDialog({required this.day});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, day),
    );
  }
}

dialogContent(BuildContext context, String day) {
  var width = MediaQuery.of(context).size.width;

  return Container(
    decoration: BoxDecoration(
      color: context.scaffoldBackgroundColor,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(10),
      boxShadow: defaultBoxShadow(),
    ),
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.all(16.0),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: [
          SvgPicture.asset("assets/images/employee-card.svg",
              width: width * 0.15, height: width * 0.2, fit: BoxFit.fill),
          SizedBox(height: 16.0),
          Text("please check out this day!".tr(),
              style: secondaryTextStyle(), textAlign: TextAlign.center),
          SizedBox(height: 16.0),
          Text(day, style: primaryTextStyle(), textAlign: TextAlign.center),
          SizedBox(height: 16.0),
          TextFormField(
            cursorColor: Color(0xFF010003),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(16, 8, 4, 8),
              hintText: "reasons".tr(),
              hintStyle: secondaryTextStyle(),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFF0000), width: 0.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFFF0000), width: 0.0),
              ),
            ),
            keyboardType: TextInputType.text,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            style: TextStyle(
              fontSize: 20.0,
              color: Color(0xFF000000), //Color(0xFF554BDF),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("CHECK OUT".tr()),
          ),
        ],
      ),
    ),
  );
}
