import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/keys.dart';
import 'package:iamluckydemo/Models/city_model.dart';

class CityController extends GetxController {
  Rx<CityModel>? dropdownValue;

  Future<bool> addNewCity({required String name}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.citiesCollection)
          .add({'name': name});

      Get.back();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_city exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }

  Future<bool> editCity({required String cityID, required String name}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.citiesCollection)
          .doc(cityID)
          .set({'name': name});

      Get.back();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Edit_city exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }
}
