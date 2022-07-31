import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/AdminAchievementScreens/admin_add_achievement_page.dart';

class AdminAchievementsHomePage extends StatefulWidget {
  const AdminAchievementsHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminAchievementsHomePageState();
}

class _AdminAchievementsHomePageState extends State<AdminAchievementsHomePage> {
  final _adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        centerTitle: true,
        title: Text('Achievements'.tr),
      ),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: StreamBuilder(
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('${'error'.tr}: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                return ListView.separated(
                  separatorBuilder: (context, index) => Container(
                    height: 1.5,
                    width: SharedText.screenWidth * 0.75,
                    margin: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 20, right: 10),
                    color: Colors.grey[200],
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Get.to(() => AdminAddAchievementPage(
                          taskModel: _adminController.tasks[index])),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _adminController.tasks[index].nameEn!,
                                  style: const TextStyle(
                                      color: AppConstants.tealColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Count to reward'.tr +
                                      ': ' +
                                      _adminController
                                          .tasks[index].countToReward!
                                          .toString(),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  _adminController.tasks[index].count!
                                      .toString(),
                                  style: const TextStyle(
                                      color: AppConstants.tealColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Icon(Icons.keyboard_arrow_right),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: _adminController.tasks.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                );
            }
          },
          stream: _adminController.loadAchievements(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AdminAddAchievementPage()),
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: AppConstants.mainColor,
      ),
    );
  }
}
