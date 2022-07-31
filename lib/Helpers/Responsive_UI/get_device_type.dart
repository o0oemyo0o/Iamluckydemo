import 'package:flutter/material.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/device_enums.dart';

DeviceType getDeviceType(MediaQueryData mediaQueryData) {
  Orientation orientation = mediaQueryData.orientation;
  double width = 0;
  if (orientation == Orientation.landscape) {
    width = mediaQueryData.size.height;
  } else {
    width = mediaQueryData.size.width;
  }
  if (width >= 950) {
    return DeviceType.desktop;
  }
  if (width >= 600) {
    return DeviceType.tablet;
  }
  return DeviceType.mobile;
}
