import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tv_app/theme/colors.dart';

mixin ToastUtils {
  void successToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: AppColor.white,
      backgroundColor: Colors.blue,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void errorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: AppColor.white,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
