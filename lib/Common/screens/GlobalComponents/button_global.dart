import 'package:flutter/material.dart';
import 'package:huma_life/Common/Util/constant.dart';

class ButtonGlobal extends StatelessWidget {
  final String buttontext;
  final Decoration buttonDecoration;
  var onPressed;

  ButtonGlobal(
      {required this.buttontext,
      required this.buttonDecoration,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: buttonDecoration,
        child: Center(
          child: Text(
            buttontext,
            style: kTextStyle.copyWith(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class ButtonGlobalWithoutIcon extends StatelessWidget {
  final String buttontext;
  final Decoration buttonDecoration;
  var onPressed;
  final Color buttonTextColor;

  ButtonGlobalWithoutIcon(
      {required this.buttontext,
      required this.buttonDecoration,
      required this.onPressed,
      required this.buttonTextColor});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        decoration: buttonDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttontext,
              style: kTextStyle.copyWith(color: buttonTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
