import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/keys.dart';
import 'package:iamluckydemo/Models/product_model.dart';

class ProductController extends GetxController {
  RxInt totalProducts = 0.obs;
  List<ProductModel> products = [];
  List<ProductModel> storeProducts = [];

  TextEditingController pointsController = TextEditingController();

  Stream<QuerySnapshot> loadProducts() {
    var result = FirebaseFirestore.instance
        .collection(Keys.productsCollection)
        .snapshots();

    result.forEach((element) {
      products.clear();
      totalProducts = 0.obs;
      totalProducts = RxInt(element.docs.length);
      for (var i in element.docs) {
        debugPrint('element.docs: ${element.docs.length}');

        ProductModel productModel = ProductModel()
          ..id = i.id
          ..points = i['points']
          ..message = i['message']
          ..catID = i['cat_id']
          ..name = i['name']
          ..storeID = i['store_id']
          ..storeName = i['store_name']
          ..catName = i['cat_name'];

        products.add(productModel);
      }
    });

    return result;
  }

  Future<bool> addNewProduct(
      {required String catID,
        required String catName,
        required String storeID,
        required String storeName,
        required String name,
        required String message,
        required int points}) async {
    try {
      await FirebaseFirestore.instance.collection(Keys.productsCollection).add({
        'cat_id': catID,
        'cat_name': catName,
        'store_id': storeID,
        'store_name': storeName,
        'name': name,
        'message': message,
        'points': points,
        'num_of_evaluations': 0,
      });

      products.clear();
      loadProducts();

      Get.back();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }

  Future<bool> editProduct(
      {required String catID,
        required String productID,
        required String catName,
        required String storeID,
        required String storeName,
        required String name,
        required String message,
        required int points}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.productsCollection)
          .doc(productID)
          .set(
        {
          'cat_name': catName,
          'cat_id': catID,
          'store_id': storeID,
          'store_name': storeName,
          'name': name,
          'message': message,
          'points': points,
          'num_of_evaluations': 0
        },
        // SetOptions(merge: true),
      );

      products.clear();
      loadProducts();

      Get.back();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }

  Stream<QuerySnapshot> loadStoreProducts(
      {required String attributeName, String? docID}) {
    var result = FirebaseFirestore.instance
        .collection(Keys.productsCollection)
        .snapshots();

    result.forEach((element) {
      storeProducts.clear();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> list =
      element.docs.where((element) {
        if (attributeName == 'store') {
          return element.data()['store_id'] == docID;
        } else {
          return element.data()['catID'] == docID;
        }
      }).toList();

      for (var i in list) {
        ProductModel productModel = ProductModel()
          ..id = i.id
          ..catID = i['cat_id']
          ..name = i['name']
          ..storeID = i['store_id']
          ..storeName = i['store_name']
          ..catName = i['cat_name'];

        storeProducts.add(productModel);
      }
    });

    return result;
  }
}
