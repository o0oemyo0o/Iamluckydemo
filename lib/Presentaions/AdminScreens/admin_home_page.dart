import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/GetControllers/challenges_controller.dart';
import 'package:iamluckydemo/GetControllers/product_controller.dart';
import 'package:iamluckydemo/GetControllers/publish_ad_controller.dart';
import 'package:iamluckydemo/GetControllers/quotes_controller.dart';
import 'package:iamluckydemo/GetControllers/rating_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/AdminAchievementScreens/admin_achievements_home_page.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/AdminSupportAdsScreens/admin_support_ads_home_page.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/AdminTasksScreens/admin_tasks_home_page.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/CategoryScreens/categories_home_page.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/ChallengesScreens/challenges_home_page.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/CityScreens/city_list_home_page.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/MediaScreens/media_home_page.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/ProductScreens/products_home_page.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/QuotesScreens/quotes_home_page.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/RatingScreens/admin_ratings_home_page.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/SettingScreens/settings_home_page.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/StoreScreens/stores_home_page.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/UsersScreens/users_home_page.dart';
import 'package:iamluckydemo/Services/firebase_auth.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final adminController = Get.put(AdminController());
  final _productController = Get.put(ProductController());
  final _ratingController = Get.put(RatingController());
  final _publishAdsController = Get.put(PublishAdsController());
  final _challengesController = Get.put(ChallengesController());
  final _quoteController = Get.put(QuotesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  /// Welcome Title
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          '${'welcome,'.tr} ',
                          style: const TextStyle(
                            color: AppConstants.mainColor,
                            fontSize: AppConstants.largeFontSize,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            SharedText.userModel.name!,
                            style: const TextStyle(
                                color: AppConstants.pointsColor,
                                fontSize: AppConstants.mediumFontSize,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Sign_out
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.to(() => const SettingsHomePage());
                          },
                          icon: const Icon(Icons.settings)),
                      getSpaceWidth(15),
                      IconButton(
                          onPressed: () {
                            Get.put(FirebaseAuthClass()).signOut();
                          },
                          icon: const Icon(Icons.logout)),
                    ],
                  ),
                ],
              ),
              getSpaceHeight(20),

              /// (1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Users
                  Expanded(
                    child: StreamBuilder(
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('${'error'.tr}: ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          default:
                            return TotalCountCardWidget(
                              title: 'Users'.tr,
                              count: adminController.totalUsers.obs.value,
                              bgColor: AppConstants.mainColor,
                              withIcon: true,
                              onTap: () => Get.to(() => const UsersHomePage()),
                            );
                        }
                      },
                      stream: adminController.loadUsers(),
                    ),
                  ),

                  /// Videos
                  Expanded(
                    child: StreamBuilder(
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('${'error'.tr} ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          default:
                            return TotalCountCardWidget(
                              title: 'Videos'.tr,
                              count: adminController.achievements.length.obs,
                              bgColor: AppConstants.finishedEasyTaskColor,
                              onTap: () => Get.to(() => const MediaHomePage()),
                              withIcon: true,
                            );
                        }
                      },
                      stream: adminController.loadAchievementVideos(),
                    ),
                  ),
                ],
              ),
              getSpaceHeight(10),

              /// (2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Categories
                  Expanded(
                    child: StreamBuilder(
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('${'error'.tr} ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          default:
                            return TotalCountCardWidget(
                              title: 'Categories'.tr,
                              count: adminController.totalCategories.obs.value,
                              bgColor: AppConstants.finishedEasyTaskColor,
                              onTap: () =>
                                  Get.to(() => const CategoriesHomePage()),
                              withIcon: true,
                            );
                        }
                      },
                      stream: adminController.loadCategories(),
                    ),
                  ),

                  /// Cities
                  Expanded(
                    child: StreamBuilder(
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('${'error'.tr} ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          default:
                            return TotalCountCardWidget(
                              title: 'Cities'.tr,
                              withIcon: true,
                              count: adminController.totalCities.obs.value,
                              bgColor: AppConstants.mainColor,
                              onTap: () {
                                Get.to(() => const CityListHomePage());
                              },
                            );
                        }
                      },
                      stream: adminController.loadCities(),
                    ),
                  ),
                ],
              ),
              getSpaceHeight(10),

              /// (3)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Stores
                  Expanded(
                    child: StreamBuilder(
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('${'error'.tr} ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          default:
                            return TotalCountCardWidget(
                              title: 'Stores'.tr,
                              count: adminController.supportStores.length.obs,
                              bgColor: AppConstants.mainColor,
                              onTap: () => Get.to(() => const StoresHomePage()),
                              withIcon: true,
                            );
                        }
                      },
                      stream: adminController.loadSupportStores(),
                    ),
                  ),

                  /// Products
                  Expanded(
                    child: StreamBuilder(
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('${'error'.tr} ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          default:
                            return TotalCountCardWidget(
                              title: 'Products'.tr,
                              count: _productController.totalProducts.obs.value,
                              bgColor: AppConstants.finishedEasyTaskColor,
                              onTap: () {
                                if (adminController.supportStores.isEmpty) {
                                  Get.defaultDialog(
                                    title: 'error'.tr,
                                    content: Text('Please_add_stores_first'.tr),
                                  );
                                } else {
                                  Get.to(() => const ProductsHomePage());
                                }
                              },
                              withIcon: true,
                            );
                        }
                      },
                      stream: _productController.loadProducts(),
                    ),
                  ),
                ],
              ),
              getSpaceHeight(10),

              /// (4)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Achievements
                  Expanded(
                    child: StreamBuilder(
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('${'error'.tr} ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          default:
                            return TotalCountCardWidget(
                              title: 'Achievements'.tr,
                              withIcon: true,
                              count:
                              RxInt(adminController.completedTasks.length),
                              bgColor: AppConstants.finishedEasyTaskColor,
                              onTap: () {
                                Get.to(() => const AdminTasksHomePage());
                              },
                            );
                        }
                      },
                      stream: adminController.loadCompletedTasks(),
                    ),
                  ),

                  /// Support_Ads
                  Expanded(
                    child: StreamBuilder(
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('${'error'.tr} ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          default:
                            return TotalCountCardWidget(
                              title: 'Support_Ads'.tr,
                              withIcon: true,
                              count: RxInt(
                                  _publishAdsController.supportAds.length),
                              bgColor: AppConstants.mainColor,
                              onTap: () {
                                Get.to(() => const AdminSupportAdsHomePage());
                              },
                            );
                        }
                      },
                      stream: _publishAdsController.loadSupportAds(),
                    ),
                  ),
                ],
              ),
              getSpaceHeight(10),

              /// (5)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Tasks
                  Expanded(
                    child: StreamBuilder(
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('${'error'.tr} ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          default:
                            return TotalCountCardWidget(
                              title: 'Tasks'.tr,
                              count: adminController.tasks.length.obs,
                              bgColor: AppConstants.mainColor,
                              onTap: () => Get.to(
                                      () => const AdminAchievementsHomePage()),
                              withIcon: true,
                            );
                        }
                      },
                      stream: adminController.loadAchievements(),
                    ),
                  ),

                  /// Ratings
                  Expanded(
                    child: StreamBuilder(
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('${'error'.tr} ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          default:
                            return TotalCountCardWidget(
                              title: 'Ratings'.tr,
                              withIcon: true,
                              count: RxInt(_ratingController.ratings.length),
                              bgColor: AppConstants.finishedEasyTaskColor,
                              onTap: () {
                                Get.to(() => const AdminRatingsHomePage());
                              },
                            );
                        }
                      },
                      stream: _ratingController.loadRatings(),
                    ),
                  ),
                ],
              ),
              getSpaceHeight(10),

              /// (6)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Challenges
                  Expanded(
                    child: StreamBuilder(
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('${'error'.tr} ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          default:
                            return TotalCountCardWidget(
                              title: 'Challenges'.tr,
                              count:
                              _challengesController.challenges.length.obs,
                              bgColor: AppConstants.mainColor,
                              onTap: () =>
                                  Get.to(() => const ChallengesHomePage()),
                              withIcon: true,
                            );
                        }
                      },
                      stream: _challengesController.loadChallenges(),
                    ),
                  ),

                  /// Quotes
                  Expanded(
                    child: StreamBuilder(
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('${'error'.tr} ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());

                          default:
                            return TotalCountCardWidget(
                              title: 'Quotes'.tr,
                              withIcon: true,
                              count: RxInt(_quoteController.quotes.length),
                              bgColor: AppConstants.finishedEasyTaskColor,
                              onTap: () {
                                Get.to(() => const QuotesHomePage());
                              },
                            );
                        }
                      },
                      stream: _quoteController.loadQuotes(),
                    ),
                  ),
                ],
              ),
              getSpaceHeight(10),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalCountCardWidget extends StatelessWidget {
  final String title;
  final RxInt count;
  final Color bgColor;
  final Function() onTap;
  final bool withIcon;

  const TotalCountCardWidget({
    Key? key,
    required this.title,
    required this.count,
    required this.bgColor,
    required this.onTap,
    this.withIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: getWidgetHeight(130),
        child: Card(
          color: bgColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.roundedRadius)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppConstants.mediumFontSize),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (count != 0.obs)
                      Obx(
                            () => Text(
                          count.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: AppConstants.xLargeFontSize),
                        ),
                      ),
                    if (withIcon)
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
