import 'package:flutter/material.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';

class HomeModel {
  IconData? icon;
  String? nameAr;
  String? nameEn;
  Color? bgColor;

  HomeModel({this.icon, this.nameAr, this.nameEn, this.bgColor});

  // TODO: add images to assets/images and change image path
  static List<HomeModel> list = [
    HomeModel(
        nameAr: 'مهمة جديدة',
        nameEn: 'New Task',
        icon: Icons.add_task,
        bgColor: AppConstants.finishedEasyTaskColor),
    HomeModel(
        nameAr: 'استبدال النقاط',
        nameEn: 'Redeem Points',
        icon: Icons.switch_access_shortcut,
        bgColor: AppConstants.finishedNewHabitTaskColor),
    HomeModel(
        nameAr: 'اضافه 5 نقاط',
        nameEn: 'Add 5 Points',
        icon: Icons.monetization_on_outlined,
        bgColor: AppConstants.finishedNewHabitTaskColor),
    HomeModel(
        nameAr: 'انجازاتي',
        nameEn: 'My ِAchievements',
        icon: Icons.military_tech,
        bgColor: AppConstants.finishedEasyTaskColor),
  ];
}
