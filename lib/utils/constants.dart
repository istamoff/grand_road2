import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyContants{
  static final infinityDouble = double.infinity;
  static final textFieldSpace = 8.0;
  static final textFieldBorderRadius = 16.0;
  static final textFieldTextSize = 20.0;
  static final double kDefaultPaddin = 16;
  static final double kDialogSpaceSize = 8;
  static  double TEXTWIDHT = 0;
  static final double TEXTHEIGHT = 45;
  static int INDEX = 0;

  static int COMEIN = 0;

  static String BASE_URL = "https://zk.unikids.uz:8443";
  static int MINGRADUS = 33;
  static int MAXGRADUS = 45;

  static String TEACHER_ALL = "teacher_all";
  static String NURSE_ALL = "nurse_all";
  static String APP_VERSION = "v.2.0.7";

  static showToast(String message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

 // static List<String> list = [];

}

final kToday = DateTime.now();
final kFirstDay = DateTime(2000, kToday.month, kToday.day);
final kLastDay = DateTime(2050,  kToday.month, kToday.day);


 showToast(String msg, Color color){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}


