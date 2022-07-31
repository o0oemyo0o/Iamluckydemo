import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/keys.dart';
import 'package:iamluckydemo/Models/quote_model.dart';

class QuotesController extends GetxController {
  List<QuoteModel> quotes = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  RxBool rxIsLoading = false.obs;

  Stream<QuerySnapshot> loadQuotes() {
    var result = FirebaseFirestore.instance
        .collection(Keys.quotesCollection)
        .snapshots();

    result.forEach((element) {
      quotes.clear();
      for (var i in element.docs) {
        debugPrint('element.docs: challenges ${element.docs.length}');

        QuoteModel model = QuoteModel()
          ..id = i.id
          ..isActive = i['isActive']
          ..description = i['description']
          ..title = i['title'];

        quotes.add(model);
      }
    });

    return result;
  }

  Future<bool> addNewQuote() async {
    try {
      rxIsLoading = true.obs;
      update();

      await FirebaseFirestore.instance.collection(Keys.quotesCollection).add({
        "isActive": true,
        "description": descriptionController.text,
        "title": titleController.text,
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

  Future<bool> editQuote({
    required bool isActive,
    required String docID,
  }) async {
    try {
      rxIsLoading = true.obs;
      update();

      await FirebaseFirestore.instance
          .collection(Keys.quotesCollection)
          .doc(docID)
          .update({
        "isActive": isActive,
        "description": descriptionController.text,
        "title": titleController.text,
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

  Future<bool> updateIsActive(
      {required String docID, required bool value}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.quotesCollection)
          .doc(docID)
          .update({'isActive': value});

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }
}
