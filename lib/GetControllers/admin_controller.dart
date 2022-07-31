import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/keys.dart';
import 'package:iamluckydemo/Models/achievement_model.dart';
import 'package:iamluckydemo/Models/category_model.dart';
import 'package:iamluckydemo/Models/city_model.dart';
import 'package:iamluckydemo/Models/complete_task_model.dart';
import 'package:iamluckydemo/Models/support_store_model.dart';
import 'package:iamluckydemo/Models/task_model.dart';
import 'package:iamluckydemo/Models/user_model.dart';

import '../Helpers/shared_texts.dart';
import '../Services/firebase_auth.dart';


class AdminController extends GetxController {
  RxBool isUsersLoading = false.obs;
  RxBool isProductsLoading = false.obs;
  RxBool isCategoriesLoading = false.obs;
  RxBool isCompletedTasksLoading = false.obs;
  RxInt totalUsers = 0.obs;
  RxInt totalTasks = 0.obs;
  RxInt totalCategories = 0.obs;
  RxInt taskCountToReward = 0.obs;
  RxInt totalCompletedTasks = 0.obs;
  RxInt totalAchievements = 0.obs;
  RxInt totalCities = 0.obs;
  RxInt totalStores = 0.obs;
  RxBool userStatus = false.obs;

  int taskRewardPoints = 0;

  List<TaskModel> tasks = [];
  List<CategoryModel> categories = [];
  List<CompleteTaskModel> completedTasks = [];
  List<AchievementModel> achievements = [];
  List<CityModel> cities = [];
  // List<StoreModel> stores = [];
  List<UserModel> users = [];
  List<SupportStoreModel> supportStores = [];
  List<SupportStoreModel> storesPerCity = [];

  CategoryModel selectedCategory = CategoryModel();
  TextEditingController adminComment = TextEditingController();

  setAdminComment(String comment) {
    adminComment.text = comment;
    update();
  }

  setUserStatus(bool value, String docID) {
    FirebaseFirestore.instance
        .collection(Keys.usersCollection)
        .doc(docID)
        .update({'isActive': value});

    userStatus = value.obs;
    update();
  }

  Stream<QuerySnapshot> loadUsers() {
    var result =
    FirebaseFirestore.instance.collection(Keys.usersCollection).snapshots();

    result.forEach((element) {
      users.clear();
      for (var i in element.docs.where((element) => element['role'] == 1)) {
        debugPrint('role: ${i['role']}');

        UserModel model = UserModel()
          ..userID = i.id
          ..name = i['name']
          ..isActive = i['isActive']
          ..point = i['points']
          ..role = i['role']
          ..level = i['level']
          ..email = i['email']
          ..city = i['city'];

        users.add(model);
      }

      totalUsers = 0.obs;
      totalUsers = RxInt(users.length);
    });

    return result;
  }

  Stream<QuerySnapshot> loadCategories() {
    var result = FirebaseFirestore.instance
        .collection(Keys.categoriesCollection)
        .snapshots();

    result.forEach((element) {
      categories.clear();
      totalCategories = 0.obs;
      totalCategories = RxInt(element.docs.length);
      for (var i in element.docs) {
        CategoryModel categoryModel = CategoryModel()
          ..id = i.id
          ..name = i['name']
          ..image = i['image'];

        categories.add(categoryModel);
      }
    });

    return result;
  }

  Stream<QuerySnapshot> loadCompletedTasks() {
    var result = FirebaseFirestore.instance
        .collection(Keys.completedTasksCollection)
        .snapshots();

    result.forEach((element) {
      completedTasks.clear();
      totalCompletedTasks = 0.obs;
      totalCompletedTasks = RxInt(element.docs.length);

      for (var i in element.docs) {
        // getCurrentTaskCountToReward(i['task_id']).then((value) {
        CompleteTaskModel model = CompleteTaskModel()
          ..id = i.id
        // ..countToReward = taskCountToReward.value
          ..countToReward = i['count_to_reward']
          ..taskID = i['task_id']
          ..userID = i['user_id']
          ..userName = i['user_name']
          ..completed = i['completed']
          ..dateTimeStamp = i['dateTime']
          ..feedback = i['feedback']
          ..firstAchieveImage = i['firstAchieveImage']
          ..secondAchieveImage = i['secondAchieveImage']
          ..thirdAchieveImage = i['thirdAchieveImage']
          ..taskName = i['taskName']
          ..timeFrom = i['timeFrom']
          ..timeTo = i['timeTo']
          ..adminComment = i['admin_comment']
          ..adminApproved = i['admin_approved'];

        completedTasks.add(model);
        // });
      }
    });
    update();

    return result;
  }

  Stream<QuerySnapshot> loadAchievements() {
    var result =
    FirebaseFirestore.instance.collection(Keys.tasksCollection).snapshots();

    result.forEach((element) {
      tasks.clear();
      totalTasks = RxInt(element.docs.length);
      for (var i in element.docs) {
        debugPrint('element.docs: ${element.docs.length}');

        TaskModel taskModel = TaskModel()
          ..id = i.id
          ..nameAr = i['nameAr']
          ..nameEn = i['nameEn']
          ..count = i['count']
          ..countToReward = i['count_to_reward']
          ..rewardPoints = i['reward_points']
          ..message = i['message'];

        tasks.add(taskModel);
      }
    });

    return result;
  }

  Future<bool> addNewTask(
      {required int count,
        required int countToReward,
        required int rewardPoints,
        required String nameAr,
        required String nameEn,
        required String message}) async {
    try {
      await FirebaseFirestore.instance.collection(Keys.tasksCollection).add({
        'count': count,
        'count_to_reward': countToReward,
        'reward_points': rewardPoints,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'message': message,
      });

      loadAchievements();
      Get.back();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }

  editTask(
      {required String taskID,
        required int count,
        required int countToReward,
        required int rewardPoints,
        required String nameAr,
        required String nameEn,
        required String message}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.tasksCollection)
          .doc(taskID)
          .update({
        'count': count,
        'count_to_reward': countToReward,
        'reward_points': rewardPoints,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'message': message
      });

      loadAchievements();
      Get.back();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }

  Future<bool> addAchievementVideo({required String url}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.achievementsCollection)
          .add({
        'downloadUrl': url,
        'uploaded_by': 'A bad guy',
        'description': 'Some description...'
      });

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('add achievement exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }

  Future<bool> checkWatchingVideosDateTime() async {
    var result = await FirebaseFirestore.instance
        .collection(Keys.usersCollection)
        .doc(SharedText.userModel.email!)
        .get();

    var lastVideoWatchedTimeStamp = result.data()!['lastVideoWatchedTimeStamp'];

    DateTime lastVideoWatchedTimeStampDateTime =
    DateTime.fromMillisecondsSinceEpoch(lastVideoWatchedTimeStamp);
    DateTime dateTimeNow = DateTime.now();

    // if (dateTimeNow.isAfter(lastVideoWatchedTimeStampDateTime)) {
    //   await FirebaseFirestore.instance
    //       .collection(Keys.usersCollection)
    //       .doc(SharedText.userModel.email!)
    //       .update({'watchedVideosCount': 0});
    //   return true;
    // }

    debugPrint(
        'lastVideoWatchedTimeStampDateTime: ${lastVideoWatchedTimeStampDateTime.add(const Duration(hours: -24)).millisecondsSinceEpoch}');

    debugPrint(
        'lastVideoWatchedTimeStampDateTime: ${lastVideoWatchedTimeStampDateTime.millisecondsSinceEpoch}');
    debugPrint(
        'lastVideoWatchedTimeStampDateTime: ${dateTimeNow.millisecondsSinceEpoch}');

    if (lastVideoWatchedTimeStampDateTime.compareTo(dateTimeNow) > 0) {
      await FirebaseFirestore.instance
          .collection(Keys.usersCollection)
          .doc(SharedText.userModel.email!)
          .update({'watchedVideosCount': 0});
      return true;
    }

    return false;
  }

  Stream<QuerySnapshot> loadAchievementVideos() {
    var result = FirebaseFirestore.instance
        .collection(Keys.achievementsCollection)
        .snapshots();

    result.forEach((element) {
      achievements.clear();
      totalAchievements = 0.obs;
      totalAchievements = RxInt(element.docs.length);

      var list = element.docs
          .where((element) => element.data()['downloadUrl'].contains('.mp4'))
          .toList();

      for (var i in list) {
        AchievementModel model = AchievementModel()
          ..id = i.id
          ..downloadUrl = i['downloadUrl']
          ..uploadedBy = i['uploaded_by']
          ..description = i['description'];

        achievements.add(model);
      }
    });

    return result;
  }

  deleteAchievementVideo({required String docID, required String url}) async {
    /// Delete from storage
    await FirebaseStorage.instance.refFromURL(url).delete();

    /// Delete from collection
    await FirebaseFirestore.instance
        .collection(Keys.achievementsCollection)
        .doc(docID)
        .delete();
  }

  Future<List<Map<String, dynamic>>> loadVideos() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await FirebaseStorage.instance.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
        fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });

    return files;
  }

  Stream<QuerySnapshot> loadCities() {
    var result = FirebaseFirestore.instance
        .collection(Keys.citiesCollection)
        .snapshots();

    result.forEach((element) {
      cities.clear();
      totalCities = 0.obs;
      totalCities = RxInt(element.docs.length);
      for (var i in element.docs) {
        CityModel model = CityModel()
          ..id = i.id
          ..name = i['name'];

        cities.add(model);
      }
    });

    return result;
  }

  String getTaskName(String taskID) {
    debugPrint('widget.model.taskID!: ${tasks.length}');

    String name = tasks.firstWhere((element) => element.id! == taskID).nameAr!;

    return name;
  }

  Future<bool> editUserStatus(
      {required String userID, required bool isActive}) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.usersCollection)
          .doc(userID)
          .update({'isActive': isActive});

      users.clear();
      loadUsers();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }

  Future<bool> updateUserWatchedVideosCount() async {
    try {
      var result = await FirebaseFirestore.instance
          .collection(Keys.usersCollection)
          .doc(SharedText.userModel.email!)
          .get();

      int num = result.data()!['watchedVideosCount'];

      await FirebaseFirestore.instance
          .collection(Keys.usersCollection)
          .doc(SharedText.userModel.email!)
          .update({
        'watchedVideosCount': num + 1,
        'lastVideoWatchedTimeStamp': DateTime.now().millisecondsSinceEpoch,
      });

      /// Get Current UserData After Updating
      await Get.put(FirebaseAuthClass()).getCurrentUserData();
      update();

      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.toString());

      return true;
    }
  }

  Stream<QuerySnapshot> loadSupportStores() {
    var result = FirebaseFirestore.instance
        .collection(Keys.supportStoreCollection)
        .snapshots();

    result.forEach((element) {
      supportStores.clear();
      totalStores = 0.obs;
      totalStores = RxInt(element.docs.length);
      for (var i in element.docs) {
        debugPrint('element.docs: ${element.docs.length}');

        SupportStoreModel model = SupportStoreModel()
          ..id = i.id
          ..isActive = i['isActive']
          ..email = i['email']
          ..image = i['image']
          ..lat = i['lat']
          ..lng = i['lng']
          ..location = i['location']
          ..storeName = i['storeName']
          ..snapchat = i['snapchat']
          ..instagram = i['instagram']
          ..buying = i['buying']
          ..cityID = i['cityID']
          ..cityName = i['cityName']
          ..catID = i['catID']
          ..catName = i['catName']
          ..discount = i['discount']
          ..mapLink = i['mapLink']
          ..ownerName = i['ownerName']
          ..phoneNumber = i['phoneNumber']
          ..socialMedia = i['socialMedia']
          ..subscription = i['subscription']
          ..tiktok = i['tiktok']
          ..website = i['website'];

        supportStores.add(model);
      }
    });

    return result;
  }

  Stream<QuerySnapshot> loadStoresPerCity(String cityID) {
    var result = FirebaseFirestore.instance
        .collection(Keys.supportStoreCollection)
        .snapshots();

    result.forEach((element) {
      storesPerCity.clear();
      for (var i in element.docs
          .where((element) => element.data()['cityID'] == cityID)) {
        debugPrint('element.docs: city stores ${element.docs.length}');

        SupportStoreModel model = SupportStoreModel()
          ..id = i.id
          ..lng = i['lng']
          ..lat = i['lat']
          ..location = i['location']
          ..image = i['image']
          ..storeName = i['storeName']
          ..cityName = i['cityName']
          ..cityID = i['cityID']
          ..cityName = i['cityName']
          ..catID = i['catID']
          ..catName = i['catName']
          ..discount = i['discount']
          ..subscription = i['subscription']
          ..ownerName = i['ownerName']
          ..phoneNumber = i['phoneNumber']
          ..email = i['email']
          ..website = i['website']
          ..instagram = i['instagram']
          ..tiktok = i['tiktok']
          ..socialMedia = i['socialMedia']
          ..isActive = i['isActive'];

        storesPerCity.add(model);
      }
    });

    return result;
  }

  int getRemainingCountToReward(String taskID) {
    taskRewardPoints =
    tasks.firstWhere((element) => element.id! == taskID).rewardPoints!;
    update();

    debugPrint('taskRewardPoints: $taskRewardPoints');

    return taskRewardPoints;
  }

  Future<int> getCurrentTaskCountToReward(String taskID) async {
    try {
      taskCountToReward.value = 0;

      var result = await FirebaseFirestore.instance
          .collection(Keys.completedTasksCollection)
          .doc(taskID)
          .get();

      debugPrint('result: ${result.data()!.toString()}');

      taskCountToReward = result.data()!['count_to_reward'];
      update();

      return taskCountToReward.value;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('error'.tr, e.message!.toString());
      return taskCountToReward.value;
    }
  }

  Future<int> getCurrentTaskCountToRewardInTasksPage(String taskID) async {
    try {
      var result = await FirebaseFirestore.instance
          .collection(Keys.completedTasksCollection)
          .get();

      for (var i in result.docs
          .where((element) => element.data()['task_id'] == taskID)) {
        taskCountToReward.value = 0;
        taskCountToReward.value += int.parse(i.data()['count_to_reward']);
        update();
      }

      return taskCountToReward.value;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('error'.tr, e.message!.toString());
      return taskCountToReward.value;
    }
  }

  Stream<QuerySnapshot> loadSupportAds() {
    var result = FirebaseFirestore.instance
        .collection(Keys.supportAdsCollection)
        .snapshots();

    result.forEach((element) {
      categories.clear();
      totalCategories = 0.obs;
      totalCategories = RxInt(element.docs.length);
      for (var i in element.docs) {
        CategoryModel categoryModel = CategoryModel()
          ..id = i.id
          ..name = i['name']
          ..image = i['image'];

        categories.add(categoryModel);
      }
    });

    return result;
  }
}
