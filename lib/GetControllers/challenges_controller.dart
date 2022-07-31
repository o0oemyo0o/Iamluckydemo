import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/keys.dart';
import 'package:iamluckydemo/Models/challenge_model.dart';

class ChallengesController extends GetxController {
  List<ChallengeModel> challenges = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController pointsController = TextEditingController();

  String challengeImage = '';

  RxBool rxIsLoading = false.obs;

  Stream<QuerySnapshot> loadChallenges() {
    var result = FirebaseFirestore.instance
        .collection(Keys.challengesCollection)
        .snapshots();

    result.forEach((element) {
      challenges.clear();
      for (var i in element.docs) {
        debugPrint('element.docs: challenges ${element.docs.length}');

        ChallengeModel model = ChallengeModel()
          ..id = i.id
          ..isUserApproved = i['isUserApproved']
          ..isAdminApproved = i['isAdminApproved']
          ..isActive = i['isActive']
          ..description = i['description']
          ..points = i['points']
          ..title = i['title']
          ..image = i['image'];

        challenges.add(model);
      }
    });

    return result;
  }

  Future<bool> addNewChallenge() async {
    try {
      rxIsLoading = true.obs;
      update();

      await FirebaseFirestore.instance
          .collection(Keys.challengesCollection)
          .add({
        "isUserApproved": false,
        "isAdminApproved": false,
        "isActive": true,
        "description": descriptionController.text,
        "points": int.parse(pointsController.text),
        "title": titleController.text,
        "image": challengeImage,
      });

      rxIsLoading = false.obs;
      update();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('add challenge exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      rxIsLoading = false.obs;
      update();

      return true;
    }
  }

  Future<bool> editChallenge({
    required bool isUserApproved,
    required bool isAdminApproved,
    required bool isActive,
    required String image,
    required String docID,
  }) async {
    try {
      rxIsLoading = true.obs;
      update();

      await FirebaseFirestore.instance
          .collection(Keys.challengesCollection)
          .doc(docID)
          .update({
        "isUserApproved": isUserApproved,
        "isAdminApproved": isAdminApproved,
        "isActive": isActive,
        "description": descriptionController.text,
        "points": int.parse(pointsController.text),
        "title": titleController.text,
        "image": image,
      });

      rxIsLoading = false.obs;
      update();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('add challenge exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      rxIsLoading = false.obs;
      update();

      return true;
    }
  }

  Future<bool> updateApprovals(
      {required String docID, required String key, required bool value}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.challengesCollection)
          .doc(docID)
          .update({key: value});

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }
}
