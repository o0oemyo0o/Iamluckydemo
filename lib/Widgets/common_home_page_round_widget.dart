import 'package:flutter/material.dart';

import '../Constants/app_constants.dart';
import '../Helpers/Responsive_UI/shared.dart';


class CommonHomePageRoundWidget extends StatelessWidget {
  final Function() onTap;
  final Color bgColor;
  final String title;
  final IconData icon;

  const CommonHomePageRoundWidget({
    Key? key,
    required this.onTap,
    required this.bgColor,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: getWidgetHeight(100),
        width: getWidgetHeight(100),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: bgColor,
            borderRadius: BorderRadius.circular(AppConstants.roundedRadius)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, size: 30,),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.black, fontSize: AppConstants.smallFontSize),
            ),
          ],
        ),
      ),
    );
  }
}
