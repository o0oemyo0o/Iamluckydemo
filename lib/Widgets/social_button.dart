import 'package:flutter/material.dart';

import '../Constants/app_constants.dart';


class SocialButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final String image;
  final Color bgColor;
  final Color textColor;
  final double textFontSize;
  final double height;
  final double minWidth;
  final double radius;
  final double imageWidth;
  final double imageHeight;
  final double elevation;
  final TextAlign buttonTextAlign;

  const SocialButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.image,
    this.bgColor = AppConstants.mainColor,
    this.textColor = Colors.white,
    this.textFontSize = AppConstants.largeFontSize,
    this.height = 48.0,
    this.minWidth = 155.0,
    this.radius = 40.0,
    this.imageWidth = 35.0,
    this.imageHeight = 35.0,
    this.elevation = 0.0,
    this.buttonTextAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: bgColor,
      height: height,
      elevation: elevation,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: textColor),
          borderRadius: BorderRadius.circular(radius)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              image,
              height: 25,
              width: 25,
            ),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: textFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
