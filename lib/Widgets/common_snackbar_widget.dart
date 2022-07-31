import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constants/app_constants.dart';


void showSnackBar({
  required String message,
  String title = '',
  Color bgColor = AppConstants.mainColor,
  Duration duration = const Duration(milliseconds: 3000),
}) {
  Get.showSnackbar(GetSnackBar(
    backgroundColor: bgColor,
    message: message,
    title: title,
    duration: duration,
  ));
}
