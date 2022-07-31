import 'package:flutter/material.dart';

import '../Helpers/shared_texts.dart';


Widget commonTextButton({
  required BuildContext context,
  required Function()? onPressed,
  required String text,
  Color? bgColor = Colors.transparent,
  Color? textColor = Colors.white,
  double fontSize = 18.0,
  FontWeight fontWeight = FontWeight.w400,
  double? height,
  double? width,
}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    ),
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        bgColor!,
      ),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      fixedSize: MaterialStateProperty.all<Size>(Size(
          width ?? SharedText.screenWidth * 0.8, height ?? kToolbarHeight)),
    ),
  );
}
