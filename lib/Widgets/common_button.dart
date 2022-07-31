import 'package:flutter/material.dart';

import '../Constants/app_constants.dart';
import '../Helpers/shared_texts.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final double elevation;
  final double fontSize;
  final Color textColor;
  final BorderRadius? borderRadius;
  final double radius;
  final double? height;
  final double? width;

  const CommonButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.elevation = 0.0,
    this.fontSize = 25,
    this.textColor = AppConstants.tealColor,
    this.borderRadius,
    this.radius = AppConstants.defaultButtonRadius,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: elevation,
      color: backgroundColor!,
      height: height ?? 48.0,
      minWidth: width ?? SharedText.screenWidth,
      shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(radius),
          side: BorderSide(color: borderColor!)),

      // style: TextButton.styleFrom(
      //   padding: EdgeInsets.zero,
      //   backgroundColor: backgroundColor!,
      //   elevation: elevation,
      //   shape: RoundedRectangleBorder(
      //       borderRadius: borderRadius ?? BorderRadius.circular(radius),
      //       side: BorderSide(color: borderColor!)),
      //   fixedSize: Size(width ?? SharedText.screenWidth, height ?? 48.0),
      //   minimumSize: Size(width ?? SharedText.screenWidth, height ?? 48.0),
      //   maximumSize: Size(width ?? SharedText.screenWidth, height ?? 48.0),
      // ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
        ),
      ),
    );
  }
}
