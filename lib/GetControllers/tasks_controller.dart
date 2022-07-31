import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/keys.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/complete_task_model.dart';
import 'package:iamluckydemo/Models/task_model.dart';
import 'package:iamluckydemo/Widgets/common_snackbar_widget.dart';

class TasksController extends GetxController {
  final adminController = Get.put(AdminController());

  RxBool isLoading = false.obs;
  String errorMessage = '';
  List<TaskModel> taskList = [];
  List<CompleteTaskModel> completedTasks = [];

  RxInt taskCountToReward = 0.obs;
  int taskRewardPoints = 0;

  String firstDownloadUrl = '';
  String secondDownloadUrl = '';
  String thirdDownloadUrl = '';

  Future<List> fetchTasks() async {
    try {
      taskList = [];
      completedTasks = [];
      var data = await FirebaseFirestore.instance
          .collection(Keys.tasksCollection)
          .get();

      for (var i in data.docs) {
        TaskModel taskModel = TaskModel()
          ..id = i.id
          ..nameAr = i['nameAr']
          ..nameEn = i['nameEn']
          ..count = i['count']
          ..countToReward = i['count_to_reward']
          ..rewardPoints = i['reward_points']
          ..message = i['message'];

        taskList.add(taskModel);
      }

      return taskList;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message!;
      Get.snackbar('Success'.tr, e.message!.toString().tr);
      return taskList;
    }
  }

  Future<List> fetchUserCompletedTasks() async {
    try {
      completedTasks = [];
      int count = 0;
      int points = 0;

      var data = await FirebaseFirestore.instance
          .collection(Keys.completedTasksCollection)
          .get();

      for (var x in taskList) {
        count = 0;
        points = 0;

        for (var i in data.docs.where((element) =>
        element.data()['user_id'] == SharedText.userModel.email! &&
            element.data()['completed'] == true &&
            element.data()['task_id'] == x.id!)) {
          count += 1;
          points = (i.data()['count_to_reward']);

          x.completedCount = count;
          x.countToEarn = points;
        }
      }

      return completedTasks;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message!;
      Get.snackbar('Success'.tr, e.message!.tr);
      return completedTasks;
    }
  }

  Future<bool> addNewTask({
    required bool completed,
    required String taskID,
    required String taskName,
    required String timeFrom,
    required String timeTo,
    required int dateTime,
    required int countToReward,
    required String feedback,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(Keys.completedTasksCollection)
          .add({
        'completed': completed,
        'count_to_reward': countToReward,
        'task_id': taskID,
        'user_id': SharedText.userModel.email!,
        'user_name': SharedText.userModel.name!,
        'taskName': taskName,
        'timeFrom': timeFrom,
        'timeTo': timeTo,
        'dateTime': dateTime,
        'feedback': feedback,
        'firstAchieveImage': firstDownloadUrl,
        'secondAchieveImage': secondDownloadUrl,
        'thirdAchieveImage': thirdDownloadUrl,
        'admin_comment': '',
        'admin_approved': false,
      }).whenComplete(() async {
        fetchUserCompletedTasks();
      });

      Get.back();
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('Success'.tr, e.message!.tr);

      return true;
    }
  }

  Future<int> getCurrentTaskCountToReward(String taskID) async {
    debugPrint('taskID: $taskID');
    var data = await FirebaseFirestore.instance
        .collection(Keys.completedTasksCollection)
        .doc(taskID)
        .get();

    int completedTaskCount = data['count_to_reward'];
    debugPrint('completedTaskCount: ${data['count_to_reward']}');

    taskCountToReward = RxInt(completedTaskCount - 1);
    update();

    return taskCountToReward.value;
  }

  Future<bool> editCurrentTask({
    required String docID,
    required String adminComment,
    required bool adminApproved,
  }) async {
    try {
      await getCurrentTaskCountToReward(docID).then((value) async {
        await FirebaseFirestore.instance
            .collection(Keys.completedTasksCollection)
            .doc(docID)
            .update({
          // 'completed': completed,
          // 'task_id': taskID,
          // 'user_id': SharedText.userEmail,
          // 'user_name': SharedText.userModel.name!,
          // 'taskName': taskName,
          // 'timeFrom': timeFrom,
          // 'timeTo': timeTo,
          // 'dateTime': dateTime,
          // 'feedback': feedback,
          // 'firstAchieveImage': firstDownloadUrl,
          // 'secondAchieveImage': secondDownloadUrl,
          // 'thirdAchieveImage': thirdDownloadUrl,
          'count_to_reward': value,
          'admin_comment': adminComment,
          'admin_approved': adminApproved
        });
      });

      Get.back();
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');

      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  int getTaskRewardPoints(String taskID) {
    taskRewardPoints = adminController.tasks
        .firstWhere((element) => element.id! == taskID)
        .rewardPoints!;
    update();

    debugPrint('taskRewardPoints: $taskRewardPoints');

    return taskRewardPoints;
  }
}
