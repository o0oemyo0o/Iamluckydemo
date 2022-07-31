import 'package:flutter/material.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/device_enums.dart';

class DeviceInfo {
  final Orientation orientation;
  final DeviceType deviceType;
  final double screenHeight;
  final double screenWidth;
  final double widgetHeight;
  final double widgetWidth;

  DeviceInfo(
      {required this.orientation,
      required this.deviceType,
      required this.screenHeight,
      required this.screenWidth,
      required this.widgetHeight,
      required this.widgetWidth});
}
