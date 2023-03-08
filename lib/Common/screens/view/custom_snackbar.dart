import 'package:flutter/material.dart';

void showCustomSnackBar(String? message, BuildContext context,
    {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: isError ? Colors.red : Colors.green,
    duration: Duration(seconds: 1),
    content: Text(message!),
  ));
}
