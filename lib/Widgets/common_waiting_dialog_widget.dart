import 'package:flutter/material.dart';

import '../Constants/app_constants.dart';


showWaitingDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        contentPadding: const EdgeInsets.all(0.0),
        content: Center(
          child: Container(
            height: (80),
            width: (80),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(AppConstants.defaultButtonRadius)),
            child: const Center(
                child:
                    CircularProgressIndicator(color: AppConstants.mainColor)),
          ),
        ),
      );
    },
  );
}
