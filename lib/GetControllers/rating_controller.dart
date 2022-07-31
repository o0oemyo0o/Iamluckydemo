import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/keys.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/rating_model.dart';
import 'package:iamluckydemo/Widgets/common_snackbar_widget.dart';

class RatingController extends GetxController {
  RxBool isVisited = false.obs;
  RxBool isRewardReceived = false.obs;
  RxNum rating = RxNum(1);
  RxInt totalRatings = 0.obs;

  List<RatingModel> ratings = [];

  TextEditingController commentController = TextEditingController();

  void changeVisit() {
    isVisited.value = !isVisited.value;
    update();
  }

  void changeRewardReceived() {
    isRewardReceived.value = !isRewardReceived.value;
    update();
  }

  void changeRating(num value) {
    rating = RxNum(value);
    debugPrint(rating.toString());
    update();
  }

  Stream<QuerySnapshot> loadRatings() {
    var result = FirebaseFirestore.instance
        .collection(Keys.ratingCollection)
        .snapshots();

    result.forEach((element) {
      ratings.clear();
      for (var i in element.docs
          .where((element) => element['isAdminAccepted'] == false)) {
        debugPrint('element.docs: ${element.docs.length}');

        RatingModel model = RatingModel()
          ..id = i.id
          ..rating = i['rating']
          ..isRewardReceived = i['isRewardReceived']
          ..isAdminAccepted = i['isAdminAccepted']
          ..isVisited = i['isVisited']
          ..comment = i['comment']
          ..productID = i['productID']
          ..productName = i['productName']
          ..userID = i['userID']
          ..userName = i['userName'];

        ratings.add(model);
      }

      totalRatings = 0.obs;
      totalRatings = RxInt(element.docs.length);
    });

    return result;
  }

  Future<bool> addNewRating({
    required bool isVisited,
    required bool isRewardReceived,
    required String comment,
    required String productID,
    required String productName,
    required num rating,
  }) async {
    try {
      await FirebaseFirestore.instance.collection(Keys.ratingCollection).add({
        'isVisited': isVisited,
        'isRewardReceived': isRewardReceived,
        'isAdminAccepted': false,
        'comment': comment,
        'rating': rating,
        'productID': productID,
        'productName': productName,
        'userName': SharedText.userModel.name!,
        'userID': SharedText.userModel.userID!,
      });

      showSnackBar(
          message: 'Thank you for your rating.',
          title: 'Success',
          bgColor: Colors.green);

      Get.back();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('add rating exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }

  Future<bool> editRatingStatus({required String rateID}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.ratingCollection)
          .doc(rateID)
          .update({'isAdminAccepted': true});

      ratings.clear();
      loadRatings();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }
}
