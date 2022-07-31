import 'package:flutter/material.dart';

import '../shared_texts.dart';

/// Hide Keyboard
void hideKeyboard(BuildContext context) =>
    FocusScope.of(context).requestFocus(FocusNode());

/// Get Widget Height
double getWidgetHeight(double height) {
  double currentHeight = SharedText.screenHeight * (height / 810);
  return currentHeight;
}

/// Get Widget Width
double getWidgetWidth(double width) {
  double currentWidth = SharedText.screenWidth * (width / 375);
  return currentWidth;
}

/// Get Space Height
SizedBox getSpaceHeight(double height) {
  double currentHeight = SharedText.screenHeight * (height / 810);
  return SizedBox(height: currentHeight);
}

/// Get Space Width
SizedBox getSpaceWidth(double width) {
  double currentWidth = SharedText.screenWidth * (width / 375);
  return SizedBox(width: currentWidth);
}
