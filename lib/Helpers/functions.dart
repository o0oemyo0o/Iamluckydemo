import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

double convertFileSizeToMB(XFile pickedFile) {
  File fileSize = File(pickedFile.path);
  final sizeInBytes = fileSize.readAsBytesSync().lengthInBytes;
  double sizeInMb = sizeInBytes / (1024 * 1024);
  debugPrint('sizeInMb: $sizeInMb');

  return sizeInMb;
}

void showGetDialog({
  required String title,
  required Widget content,
  required Function() onConfirmPressed,
}) {
  Get.defaultDialog(
      title: title,
      content: content,
      confirm: TextButton(
        onPressed: onConfirmPressed,
        child:
             Text('OK'.tr, style:const  TextStyle(color: AppConstants.mainColor)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child:  Text('Cancel'.tr, style: const TextStyle(color: Colors.red)),
      ),
      radius: AppConstants.defaultButtonRadius);
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

Future<void> launchInWebViewOrVC(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(
        headers: <String, String>{'my_header_key': 'my_header_value'}),
  )) {
    throw 'Could not launch $url';
  }
}
