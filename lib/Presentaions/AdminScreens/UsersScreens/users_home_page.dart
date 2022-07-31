import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';

class UsersHomePage extends StatefulWidget {
  const UsersHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UsersHomePageState();
}

class _UsersHomePageState extends State<UsersHomePage> {
  final _adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        title: Text('Users'.tr),
      ),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: StreamBuilder(
          stream: _adminController.loadUsers(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.separated(
              separatorBuilder: (context, index) => getSpaceHeight(10),
              itemBuilder: (context, index) {
                _adminController.users.sort((a, b) => b.isActive! ? -1 : 1);

                return Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                      color: AppConstants.lightGreyColor,
                      borderRadius: BorderRadius.circular(
                          AppConstants.defaultButtonRadius)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Name
                            Text(_adminController.users[index].name!,
                                style: const TextStyle(
                                    color: AppConstants.mainColor,
                                    fontSize: AppConstants.mediumFontSize,
                                    fontWeight: FontWeight.bold)),

                            /// Email
                            Text(_adminController.users[index].email!,
                                style: const TextStyle(
                                    color: AppConstants.pointsColor,
                                    fontSize: AppConstants.smallFontSize)),

                            /// City
                            Row(
                              children: [
                                Text('City_name'.tr + ':',
                                    style: const TextStyle(
                                        color: AppConstants.pointsColor,
                                        fontSize: AppConstants.smallFontSize)),
                                Expanded(
                                  child: Text(
                                      _adminController.users[index].city!,
                                      style: const TextStyle(
                                          color: AppConstants.mainColor,
                                          fontSize:
                                          AppConstants.mediumFontSize)),
                                ),
                              ],
                            ),

                            /// Points
                            Row(
                              children: [
                                Text('Points'.tr + ': ',
                                    style: const TextStyle(
                                        color: AppConstants.pointsColor,
                                        fontSize: AppConstants.smallFontSize)),
                                Expanded(
                                  child: Text(
                                      _adminController.users[index].point!
                                          .toString(),
                                      style: const TextStyle(
                                          color: AppConstants.tealColor,
                                          fontSize:
                                          AppConstants.mediumFontSize)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GetBuilder(
                        builder: (AdminController controller) {
                          return Switch(
                            value: controller.users[index].isActive!,
                            onChanged: (value) {
                              controller.setUserStatus(
                                  value, _adminController.users[index].userID!);
                            },
                            activeColor: AppConstants.mainColor,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              itemCount: _adminController.users.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
            );
          },
        ),
      ),
    );
  }
}
