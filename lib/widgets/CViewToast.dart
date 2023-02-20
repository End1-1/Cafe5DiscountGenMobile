import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void CViewToast(String txt) {
  Fluttertoast.showToast(
      msg: txt,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}