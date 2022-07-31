import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/keys.dart';
import 'package:iamluckydemo/Models/publish_ad_model.dart';
import 'package:iamluckydemo/Widgets/common_snackbar_widget.dart';

class PublishAdsController extends GetxController {
  TextEditingController storeNameController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adLinkController = TextEditingController();

  RxBool activeValue = false.obs;
  RxBool rxIsLoading = false.obs;
  RxInt totalAds = 0.obs;

  List<PublishAdModel> supportAds = [];

  void updateActiveValue(bool value) {
    activeValue = value.obs;
    update();
  }

  void updateIsLoading(bool value) {
    rxIsLoading = value.obs;
    update();
  }

  Stream<QuerySnapshot> loadSupportAds() {
    var result = FirebaseFirestore.instance
        .collection(Keys.supportAdsCollection)
        .snapshots();

    result.forEach((element) {
      supportAds.clear();
      totalAds = 0.obs;
      totalAds = RxInt(element.docs.length);

      // .where((element) => element['isActive'] == false)
      for (var i in element.docs) {
        debugPrint('element.docs: supportAds ${element.docs}');

        PublishAdModel model = PublishAdModel()
          ..id = i.id
          ..isActive = i['isActive']
          ..email = i['email']
          ..storeName = i['storeName']
          ..ownerName = i['ownerName']
          ..adLink = i['adLink']
          ..phoneNumber = i['phoneNumber'];

        supportAds.add(model);
      }
    });

    return result;
  }

  Future<bool> addSupportAds() async {
    try {
      if (storeNameController.text.isEmpty ||
          ownerNameController.text.isEmpty ||
          phoneNumberController.text.isEmpty ||
          emailController.text.isEmpty ||
          adLinkController.text.isEmpty) {
        showSnackBar(message: 'Please fill all fields', bgColor: Colors.red);
        return true;
      }

      updateIsLoading(true);
      await FirebaseFirestore.instance
          .collection(Keys.supportAdsCollection)
          .add({
        'storeName': storeNameController.text,
        'ownerName': ownerNameController.text,
        'phoneNumber': phoneNumberController.text,
        'email': emailController.text,
        'adLink': adLinkController.text,
        'isActive': false,
      });

      Get.snackbar('Success', 'Your request has been sent to the admin.',
          backgroundColor: Colors.green);

      Get.back();

      updateIsLoading(false);
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('add task exception: ${e.code}');

      updateIsLoading(false);
      return true;
    } catch (e) {
      debugPrint(e.toString());

      updateIsLoading(false);
      return true;
    }
  }

  Future<bool> updateSupportAdActivation({required String docID}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.supportAdsCollection)
          .doc(docID)
          .update({'isActive': activeValue.value});

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('add task exception: ${e.code}');

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return true;
    }
  }

  Future<bool> editSupportAds({required String docID}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.supportAdsCollection)
          .doc(docID)
          .set({
        'storeName': storeNameController.text,
        'ownerName': ownerNameController.text,
        'phoneNumber': phoneNumberController.text,
        'email': emailController.text,
        'adLink': adLinkController.text,
        'isActive': false,
      });

      showSnackBar(message: 'Your request has been sent to the admin.');

      Get.back();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('add task exception: ${e.code}');

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return true;
    }
  }

  Future<bool> editAdStatus({required String docID}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.supportAdsCollection)
          .doc(docID)
          .update({'isActive': true});

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('add task exception: ${e.code}');

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return true;
    }
  }
}
