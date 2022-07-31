import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Constants/app_constants.dart';
import '../GetControllers/language_controller.dart';
import '../Helpers/Responsive_UI/shared.dart';
import '../Helpers/shared_texts.dart';
import '../Presentaions/AdminScreens/MediaScreens/media_home_page.dart';
import '../Presentaions/AuthenticationScreens/login_screen.dart';
import '../Presentaions/CoinsReplacement/coins_replacement_home_page.dart';
import '../Presentaions/ProfileScreens/profile_home_page.dart';
import '../Presentaions/PublishAdsScreens/publish_ads_home_page.dart';
import '../Presentaions/SupportStoreScreens/support_store_home_page.dart';
import '../Presentaions/TasksScreens/tasks_home_page.dart';
import '../Services/firebase_auth.dart';
import 'common_list_tile_widget.dart';
import 'common_user_credential_widget.dart';


class CommonDrawerWidget extends StatelessWidget {
  const CommonDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            AppConstants.eButtonColorLightPink,
            AppConstants.eButtonColorLavender,
          ],
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getSpaceHeight(20),

              /// User Profile
              if (SharedText.isLogged) ...[
                InkWell(
                    onTap: () {
                      Get.to(() => const ProfileHomePage(withAppBar: true));
                    },
                    child: const CommonUserCredentialWidget()),
              ] else ...[
                /// profile
                const CommonUserCredentialWidget(withLine: false),
              ],
              getSpaceHeight(10),

              /// Lang
              customListTile(
                  title: 'Lang'.tr,
                  iconData: Icons.translate_outlined,
                  onTap: () {
                    Get.put(LanguageController()).changeLanguage();
                  }),
              Container(
                  height: 0.25, width: getWidgetWidth(250), color: Colors.grey),
              getSpaceHeight(10),

              /// Profile
              if (SharedText.isLogged) ...[
                customListTile(
                    iconData: Icons.person,
                    title: 'Profile'.tr,
                    onTap: () {})
              ],
              getSpaceHeight(10),
              Container(
                  height: 0.25, width: getWidgetWidth(250), color: Colors.grey),

              /// New Task
              customListTile(
                  title: 'Add_new_task'.tr,
                  iconData: Icons.add_task,
                  onTap: () {
                    if (SharedText.isLogged) {
                      Get.back();
                      Get.to(() => const TasksHomePage(withAppBar: true));
                    } else {
                      Get.snackbar('error'.tr, 'Please_login_first'.tr,
                          backgroundColor: Colors.red);
                    }
                  }),

              getSpaceHeight(10),
              Container(
                  height: 0.25, width: getWidgetWidth(250), color: Colors.grey),

              /// My achievements
              customListTile(
                  title: 'My_Achievements'.tr,
                  iconData: Icons.military_tech,
                  onTap: () {
                    if (SharedText.isLogged) {
                      Get.back();
                      Get.to(() => const TasksHomePage(withAppBar: true));
                    } else {
                      Get.snackbar('error'.tr, 'Please_login_first'.tr,
                          backgroundColor: Colors.red);
                    }
                  }),

              getSpaceHeight(10),
              Container(
                  height: 0.25, width: getWidgetWidth(250), color: Colors.grey),

              /// Convert Points
              customListTile(
                  title: 'Redeem_Points'.tr,
                  iconData: Icons.switch_access_shortcut,
                  onTap: () {
                    if (SharedText.isLogged) {
                      Get.back();
                      Get.to(() => const CoinsReplacementHomePage());
                    } else {
                      Get.snackbar('error'.tr, 'Please_login_first'.tr,
                          backgroundColor: Colors.red);
                    }
                  }),

              getSpaceHeight(10),
              Container(
                  height: 0.25, width: getWidgetWidth(250), color: Colors.grey),

              /// Earn Bonus
              customListTile(
                  title: 'Add_5_Points'.tr,
                  iconData: Icons.monetization_on_outlined,
                  onTap: () {
                    if (SharedText.isLogged) {
                      Get.back();
                      Get.to(() => const MediaHomePage(showFAB: false));
                    } else {
                      Get.snackbar('error'.tr, 'Please_login_first'.tr,
                          backgroundColor: Colors.red);
                    }
                  }),

              getSpaceHeight(10),
              Container(
                  height: 0.25, width: getWidgetWidth(250), color: Colors.grey),

              /// Store Rating
              customListTile(
                  title: 'Store_Rating'.tr,
                  iconData: Icons.thumbs_up_down_outlined,
                  onTap: () {
                    if (SharedText.isLogged) {
                      Get.back();
                      Get.to(() => const MediaHomePage(showFAB: false));
                    } else {
                      Get.snackbar('error'.tr, 'Please_login_first'.tr,
                          backgroundColor: Colors.red);
                    }

                  }),

              getSpaceHeight(10),
              Container(
                  height: 0.25, width: getWidgetWidth(250), color: Colors.grey),

              /// Contact Us
              customListTile(
                  title: 'Help_Center'.tr,
                  iconData: Icons.help_outline,
                  onTap: () {}),

              getSpaceHeight(10),
              Container(
                  height: 0.25, width: getWidgetWidth(250), color: Colors.grey),

              /// Login && Sign Out
              if (SharedText.isLogged) ...[
                customListTile(
                    title: 'Sign_out'.tr,
                    iconData: Icons.logout,
                    onTap: () {
                      Get.put(FirebaseAuthClass()).signOut();
                    })
              ] else ...[
                customListTile(
                    title: 'Login'.tr,
                    iconData: Icons.login,
                    onTap: () {
                      Get.back();
                      Get.to(() => const LoginScreen());
                    })
              ],

              getSpaceHeight(10),
              Container(
                  height: 0.25, width: getWidgetWidth(250), color: Colors.grey),

              /// Store Register
              GestureDetector(
                onTap: () {
                  Get.to(() => const SupportStoreHomePage());
                },
                child: Container(
                  height: 60,
                  width: 336,
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  decoration: BoxDecoration(
                      color: AppConstants.newInterestColor ,
                      borderRadius:
                          BorderRadius.circular(AppConstants.roundedRadius)),
                  child: const FittedBox(
                    child: Text(
                      'Register as a support store',
                      style: TextStyle(
                          fontSize: AppConstants.titleFontSize,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),

              getSpaceHeight(20),
              Container(
                  height: 0.25, width: getWidgetWidth(250), color: Colors.grey),

              /// Publish Ads
              GestureDetector(
                onTap: () {
                  Get.to(() => const PublishAdsHomePage(userRole: 'user'));
                },
                child: Container(
                  height: 60,
                  width: 336,
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  decoration: BoxDecoration(
                      color: AppConstants.drawerBottomColor,
                      //border: Border.all(color: AppConstants.newInterestColor),
                      borderRadius:
                          BorderRadius.circular(AppConstants.roundedRadius)),
                  child: const FittedBox(
                    child: Text(
                      'Publish a commercial Ads',
                      style: TextStyle(
                          fontSize: AppConstants.titleFontSize,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 37),
            ],
          ),
        ),
      ),
    );
  }
}
