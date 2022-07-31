// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iamlucky/Constants/keys.dart';
// import 'package:iamlucky/Models/city_model.dart';
// import 'package:iamlucky/Models/store_model.dart';
//
// class StoreController extends GetxController {
//   RxInt totalStores = 0.obs;
//   String storeUrl = '';
//   List<StoreModel> stores = [];
//   List<StoreModel> storesPerCity = [];
//   Rx<CityModel>? dropdownValue;
//   Rx<StoreModel>? storeDropdownValue;
//
//   Stream<QuerySnapshot> loadStores() {
//     var result = FirebaseFirestore.instance
//         .collection(Keys.storesCollection)
//         .snapshots();
//
//     result.forEach((element) {
//       stores.clear();
//       totalStores = 0.obs;
//       totalStores = RxInt(element.docs.length);
//       for (var i in element.docs) {
//         debugPrint('element.docs: ${element.docs.length}');
//
//         StoreModel model = StoreModel()
//           ..id = i.id
//           ..lng = i['lng']
//           ..lat = i['lat']
//           ..name = i['name']
//           ..cityName = i['city_name']
//           ..cityID = i['city_id']
//           ..image = i['image'];
//
//         stores.add(model);
//       }
//     });
//
//     return result;
//   }
//
//   Stream<QuerySnapshot> loadStoresPerCity(String cityID) {
//     var result = FirebaseFirestore.instance
//         .collection(Keys.storesCollection)
//         .snapshots();
//
//     result.forEach((element) {
//       storesPerCity.clear();
//       for (var i in element.docs
//           .where((element) => element.data()['city_id'] == cityID)) {
//         debugPrint('element.docs: ${element.docs.length}');
//
//         StoreModel model = StoreModel()
//           ..id = i.id
//           ..lng = i['lng']
//           ..lat = i['lat']
//           ..name = i['name']
//           ..cityName = i['city_name']
//           ..cityID = i['city_id']
//           ..image = i['image'];
//
//         storesPerCity.add(model);
//       }
//     });
//
//     return result;
//   }
//
//   Future<bool> addNewStore(
//       {required String name,
//       required String image,
//       required String cityName,
//       required String cityID,
//       required num lat,
//       required num lng}) async {
//     try {
//       await FirebaseFirestore.instance.collection(Keys.storesCollection).add({
//         'name': name,
//         'image': image,
//         'city_name': cityName,
//         'city_id': cityID,
//         'lat': lat,
//         'lng': lng,
//         'rating': 0,
//       });
//
//       stores.clear();
//       loadStores();
//
//       Get.back();
//
//       return false;
//     } on FirebaseAuthException catch (e) {
//       debugPrint('add store exception: ${e.code}');
//
//       return true;
//     } catch (e) {
//       debugPrint(e.toString());
//       return true;
//     }
//   }
//
//   Future<bool> editStore(
//       {required String storeID,
//       required String name,
//       required String image,
//       required String cityName,
//       required String cityID,
//       required num lat,
//       required num lng}) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection(Keys.storesCollection)
//           .doc(storeID)
//           .set(
//         {
//           'name': name,
//           'image': image,
//           'city_name': cityName,
//           'city_id': cityID,
//           'lat': lat,
//           'lng': lng,
//         },
//         // SetOptions(merge: true),
//       );
//
//       stores.clear();
//       loadStores();
//
//       Get.back();
//
//       return false;
//     } on FirebaseAuthException catch (e) {
//       debugPrint('add task exception: ${e.code}');
//
//       return true;
//     } catch (e) {
//       debugPrint(e.toString());
//       return true;
//     }
//   }
// }
