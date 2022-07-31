import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/keys.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';

class CategoryController extends GetxController {
  Future<bool> addNewCategory(
      {required String image, required String name}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.categoriesCollection)
          .add({'image': image, 'name': name});

      Get.put(AdminController()).categories.clear();
      Get.put(AdminController()).loadCategories();

      Get.back();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }

  Future<bool> editCategory(
      {required String catID,
        required String image,
        required String name}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.categoriesCollection)
          .doc(catID)
          .set({'image': image, 'name': name});

      Get.put(AdminController()).categories.clear();
      Get.put(AdminController()).loadCategories();

      Get.back();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }
}
