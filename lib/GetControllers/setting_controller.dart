import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/Constants/keys.dart';

class SettingController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  RxString docID = ''.obs;
  RxBool rxIsLoading = false.obs;

  Stream<QuerySnapshot> loadSettings() {
    var result = FirebaseFirestore.instance
        .collection(Keys.settingsCollection)
        .snapshots();

    result.forEach((element) {
      docID = element.docs[0].id.obs;
      emailController.text = element.docs[0]['email'];
      phoneController.text = element.docs[0]['phone'];
    });

    return result;
  }

  Future<bool> editSettings() async {
    try {
      rxIsLoading = true.obs;
      update();

      await FirebaseFirestore.instance
          .collection(Keys.settingsCollection)
          .doc(docID.value)
          .update(
          {'email': emailController.text, 'phone': phoneController.text});

      rxIsLoading = false.obs;
      update();

      Get.snackbar('Done', 'message',
          backgroundColor: AppConstants.finishedEasyTaskColor);

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('edit settings exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      rxIsLoading = false.obs;
      update();

      return true;
    }
  }
}
