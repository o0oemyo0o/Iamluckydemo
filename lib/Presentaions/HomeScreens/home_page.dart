import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/level_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/home_model.dart';
import 'package:iamluckydemo/Presentaions/Achievement_Screens/achievements_home_page.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/MediaScreens/media_home_page.dart';
import 'package:iamluckydemo/Presentaions/CoinsReplacement/coins_replacement_home_page.dart';
import 'package:iamluckydemo/Presentaions/TasksScreens/tasks_home_page.dart';
import 'package:iamluckydemo/Services/firebase_auth.dart';
import 'package:iamluckydemo/Widgets/common_home_page_round_widget.dart';
import 'package:iamluckydemo/Widgets/common_user_credential_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firebaseAuthClass = Get.put(FirebaseAuthClass());
  final levelController = Get.put(LevelController());



  @override
  Widget build(BuildContext context) {
    String points = SharedText.isLogged
        ? SharedText.userModel.level!.toString()
        : 0.toString();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: SharedText.screenHeight * 0.8,
        width: SharedText.screenWidth,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /// profile
              const CommonUserCredentialWidget(withLine: false),

              /// points
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  pointsRoundedWidget(
                      bgColor: AppConstants.mainColor,
                      borderColor: Colors.transparent,
                      text: '${'Level'.tr} ' + points,
                      textColor: Colors.white),
                  const SizedBox(width: 20),
                  if (SharedText.isLogged) ...[
                    StreamBuilder(
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          return Text('${'error'.tr}: ${snapshot.error}');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: getWidgetHeight(50),
                            width: getWidgetWidth(100),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.roundedRadius),
                                border: Border.all(color: Colors.black)),
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        }

                        return pointsRoundedWidget(
                            bgColor: Colors.white,
                            borderColor: Colors.black,
                            text:
                            '${_firebaseAuthClass.currentPoints.value} ${'Point'.tr}',
                            textColor: Colors.black);
                      },
                      stream: _firebaseAuthClass.getCurrentUserPoints(),
                    ),
                  ] else ...[
                    pointsRoundedWidget(
                        bgColor: Colors.white,
                        borderColor: Colors.black,
                        text:
                        '${_firebaseAuthClass.currentPoints.value.toInt()} ${'Point'.tr}',
                        textColor: Colors.black),
                  ],
                ],
              ),

              const SizedBox(height: 20),

              /// Tasks
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: HomeModel.list.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 16 / 12,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    return CommonHomePageRoundWidget(
                        onTap: () {
                          if (index == 0) {
                            if (SharedText.isLogged) {
                              Get.to(const TasksHomePage(withAppBar: true));
                            } else {
                              Get.snackbar('error'.tr, 'Please_login_first'.tr,
                                  backgroundColor: Colors.red);
                            }
                          }
                          if (index == 1) {
                            if (SharedText.isLogged) {
                              Get.to(const CoinsReplacementHomePage());
                            } else {
                              Get.snackbar('error'.tr, 'Please_login_first'.tr,
                                  backgroundColor: Colors.red);
                            }
                          }
                          if (index == 2) {
                            if (SharedText.isLogged) {
                              Get.to(const MediaHomePage(showFAB: false));
                            } else {
                              Get.snackbar('error'.tr, 'Please_login_first'.tr,
                                  backgroundColor: Colors.red);
                            }
                          }
                          if (index == 3) {
                            if (SharedText.isLogged) {
                              Get.to(const AchievementsHomePage());
                            } else {
                              Get.snackbar('error'.tr, 'Please_login_first'.tr,
                                  backgroundColor: Colors.red);
                            }
                          }
                        },
                        bgColor: HomeModel.list[index].bgColor!,
                        title: SharedText.currentLocale == 'ar'
                            ? HomeModel.list[index].nameAr!
                            : HomeModel.list[index].nameEn!,
                        icon: HomeModel.list[index].icon!,);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pointsRoundedWidget({
    required Color bgColor,
    required String text,
    required Color textColor,
    required Color borderColor,
  }) {
    return Container(
      height: getWidgetHeight(50),
      width: getWidgetWidth(100),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppConstants.roundedRadius),
          border: Border.all(color: borderColor)),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: AppConstants.smallFontSize,
          ),
        ),
      ),
    );
  }
}