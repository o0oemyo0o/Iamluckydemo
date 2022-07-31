import 'package:flutter/material.dart';

import '../Constants/app_constants.dart';


Widget customListTile(
    {required String title, required Function() onTap, IconData? iconData}) {
  return ListTile(
    onTap: onTap,
    contentPadding: EdgeInsets.zero,
    leading: iconData == null ? const SizedBox() : Icon(iconData, size: 29,color:AppConstants.newInterestColor ,),
    title: Text(
      title,
      style: const TextStyle(
          color: AppConstants.newInterestColor,
          fontSize: AppConstants.largeFontSize,
          fontWeight: FontWeight.w400),
    ),
  );
}
