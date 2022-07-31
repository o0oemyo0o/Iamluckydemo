import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/keys.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/category_model.dart';
import 'package:iamluckydemo/Models/city_model.dart';
import 'package:iamluckydemo/Models/support_store_model.dart';
import 'package:iamluckydemo/Widgets/common_snackbar_widget.dart';

class SupportStoreController extends GetxController {
  CityModel? cityDropdownValue;
  CategoryModel? categoryDropdownValue;

  String imageUrl = '';
  String socialMedia = '';
  String lat = '';
  String lng = '';

  RxBool buyValue = false.obs;
  RxBool discountValue = false.obs;
  RxBool subscriptionValue = false.obs;
  RxBool instagramValue = false.obs;
  RxBool snapchatValue = false.obs;
  RxBool tiktokValue = false.obs;
  RxBool activeValue = false.obs;
  RxBool rxIsLoading = false.obs;

  Rx<Placemark> selectedPlaceMark = Placemark().obs;

  Rx<CityModel>? dropdownValue;
  Rx<SupportStoreModel>? storeDropdownValue;

  TextEditingController storeNameController = TextEditingController();
  TextEditingController buyingController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController subscriptionController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController snapchatController = TextEditingController();
  TextEditingController tiktokController = TextEditingController();
  TextEditingController selectedLocationController = TextEditingController();

  void updateCityDropdownValue(CityModel model) {
    cityDropdownValue = model;
    update();
  }

  void updateCategoryDropdownValue(CategoryModel model) {
    categoryDropdownValue = model;
    update();
  }

  void updateBuyValue(bool value) {
    buyValue = value.obs;
    update();
  }

  void updateDiscountValue(bool value) {
    discountValue = value.obs;
    update();
  }

  void updateSubscriptionValue(bool value) {
    subscriptionValue = value.obs;
    update();
  }

  void updateInstagramValue() {
    instagramValue = true.obs;
    snapchatValue = false.obs;
    tiktokValue = false.obs;

    socialMedia = 'instagram';
    debugPrint('socialMedia: $socialMedia');
    update();
  }

  void updateSnapchatValue() {
    instagramValue = false.obs;
    snapchatValue = true.obs;
    tiktokValue = false.obs;

    socialMedia = 'snapchat';
    debugPrint('socialMedia: $socialMedia');
    update();
  }

  void updateTiktokValue() {
    instagramValue = false.obs;
    snapchatValue = false.obs;
    tiktokValue = true.obs;

    socialMedia = 'tiktok';
    debugPrint('socialMedia: $socialMedia');
    update();
  }

  void updateActiveValue() {
    activeValue.value = !activeValue.value;
    update();
  }

  void updateIsLoading(bool value) {
    rxIsLoading.value = value;
    update();
  }

  Future<bool> addSupportStore() async {
    try {
      if (storeNameController.text.isEmpty ||
          cityDropdownValue == null ||
          categoryDropdownValue == null ||
          buyingController.text.isEmpty ||
          discountController.text.isEmpty ||
          subscriptionController.text.isEmpty ||
          ownerNameController.text.isEmpty ||
          phoneNumberController.text.isEmpty ||
          emailController.text.isEmpty ||
          websiteController.text.isEmpty ||
          selectedLocationController.text.isEmpty) {
        showSnackBar(message: 'Please fill all fields', bgColor: Colors.red);
        return true;
      }

      if (instagramValue.value && instagramController.text.isEmpty) {
        showSnackBar(
            message: 'Please write instagram link', bgColor: Colors.red);
        return true;
      }
      if (snapchatValue.value && snapchatController.text.isEmpty) {
        showSnackBar(
            message: 'Please write snapchat link', bgColor: Colors.red);
        return true;
      }
      if (tiktokValue.value && tiktokController.text.isEmpty) {
        showSnackBar(message: 'Please write tiktok link', bgColor: Colors.red);
        return true;
      }

      updateIsLoading(true);
      await FirebaseFirestore.instance
          .collection(Keys.supportStoreCollection)
          .add({
        'storeName': storeNameController.text,
        'buying': buyingController.text,
        'lat': lat,
        'lng': lng,
        'location': selectedLocationController.text,
        'image': imageUrl,
        'cityID': cityDropdownValue!.id!,
        'cityName': cityDropdownValue!.name!,
        'catID': categoryDropdownValue!.id!,
        'catName': categoryDropdownValue!.name!,
        'discount': discountController.text,
        'subscription': subscriptionController.text,
        'ownerName': ownerNameController.text,
        'phoneNumber': phoneNumberController.text,
        'email': emailController.text,
        'website': websiteController.text,
        'mapLink': selectedLocationController.text,
        'instagram': instagramController.text,
        'snapchat': snapchatController.text,
        'tiktok': tiktokController.text,
        'socialMedia': socialMedia,
        'isActive': false,
      });

      if (SharedText.userModel.role == 1) {
        Get.snackbar('Success'.tr, 'your_request_has_been_sent_to_the_admin'.tr,
            backgroundColor: Colors.green);
      } else {
        Get.snackbar('Success'.tr, 'store_data_has_been_added'.tr,
            backgroundColor: Colors.green);
      }

      updateIsLoading(false);

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      updateIsLoading(false);
      return true;
    }
  }

  Future<bool> updateSupportStoreActivation({required String docID}) async {
    try {
      updateIsLoading(true);
      await FirebaseFirestore.instance
          .collection(Keys.supportStoreCollection)
          .doc(docID)
          .update({'isActive': activeValue.value});

      updateIsLoading(false);
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      updateIsLoading(false);
      return true;
    }
  }

  Future<bool> editSupportStore({required String docID}) async {
    try {
      updateIsLoading(true);
      await FirebaseFirestore.instance
          .collection(Keys.supportStoreCollection)
          .doc(docID)
          .update({
        'storeName': storeNameController.text,
        'buying': buyingController.text,
        'lat': lat,
        'lng': lng,
        'location': selectedLocationController.text,
        'image': imageUrl,
        'cityID': cityDropdownValue!.id!,
        'cityName': cityDropdownValue!.name!,
        'catID': categoryDropdownValue!.id!,
        'catName': categoryDropdownValue!.name!,
        'discount': discountController.text,
        'subscription': subscriptionController.text,
        'ownerName': ownerNameController.text,
        'phoneNumber': phoneNumberController.text,
        'email': emailController.text,
        'website': websiteController.text,
        'mapLink': selectedLocationController.text,
        'instagram': instagramController.text,
        'snapchat': snapchatController.text,
        'tiktok': tiktokController.text,
        'socialMedia': socialMedia,
        'isActive': activeValue.value,
      });
      Get.back();

      if (SharedText.userModel.role == 1) {
        Get.snackbar(
            'Success'.tr, 'your_request_has_been_sent_to_the_admin'.tr);
      } else {
        Get.snackbar('Success'.tr, 'store_data_has_been_updated'.tr);
      }

      updateIsLoading(false);
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      updateIsLoading(false);
      return true;
    }
  }
}
