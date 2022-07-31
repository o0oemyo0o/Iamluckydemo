import 'package:flutter/material.dart';

import '../Constants/app_constants.dart';
import '../Helpers/Responsive_UI/shared.dart';
import '../Helpers/shared_texts.dart';


class CommonUserCredentialWidget extends StatelessWidget {
  final bool withLine;
  const CommonUserCredentialWidget({Key? key, this.withLine = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getSpaceHeight(20),

        /// Profile Image
        // ClipPath(
        //   clipper: HexagonClipper(),
        //   child:
        Container(
          width: getWidgetHeight(150),
          height: getWidgetHeight(150),
          decoration: const BoxDecoration(
            color: AppConstants.mainColor,
            shape: BoxShape.circle,
          ),
          padding:
              const EdgeInsets.only(top: 30, bottom: 30, left: 15, right: 15),
          child: Image.asset(
            'assets/images/user-placeholder.png',
            color: Colors.white,
            fit: BoxFit.contain,
          ),
        ),
        // ),

        /// User Name
        IntrinsicWidth(
          stepHeight: 1,
          child: Column(
            children: [

              Text(
                SharedText.isLogged ? SharedText.userModel.name! : 'New Lucky',
                style: const TextStyle(
                    fontSize: AppConstants.largeFontSize,
                    color: AppConstants.newInterestColor),
              ),
              const SizedBox(height: 10),
              if (withLine) Container(color: AppConstants.tealColor, height: 1),
            ],
          ),
        ),
      ],
    );
  }
}


