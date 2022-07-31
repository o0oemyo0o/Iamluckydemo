import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/Constants/enums.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/GetControllers/image_controller.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/MediaScreens/media_preview_page.dart';
import 'package:iamluckydemo/Widgets/common_cached_image_widget.dart';

class MediaHomePage extends StatefulWidget {
  final bool showFAB;

  const MediaHomePage({Key? key, this.showFAB = true}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MediaHomePageState();
}

class _MediaHomePageState extends State<MediaHomePage> {
  final _adminController = Get.put(AdminController());
  final _imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        title: Text('add_5_points'.tr),
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
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      childAspectRatio: 16 / 9,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        InkWell(
                          onTap: () async {
                            await _adminController
                                .checkWatchingVideosDateTime()
                                .then((value) {
                              if (value) {
                                if (SharedText.userModel.watchedVideosCount! <
                                    SharedText.userModel
                                        .watchingVideosAvailableCount!) {
                                  Get.to(
                                        () => MediaPreviewPage(
                                        url: _adminController
                                            .achievements[index].downloadUrl!),
                                  );
                                } else {
                                  Get.snackbar(
                                      'error'.tr,
                                      'you_exceeded_maximum_video_watch_limit'
                                          .tr,
                                      backgroundColor: Colors.red);
                                }
                              } else {
                                Get.snackbar('error'.tr,
                                    'you_exceeded_maximum_video_watch_limit'.tr,
                                    backgroundColor: Colors.red);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppConstants.lightGreyColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: commonCachedImageWidget(
                                context: context,
                                imageUrl: _adminController
                                    .achievements[index].downloadUrl!,
                                fit: BoxFit.fill),
                          ),
                        ),

                        /// Check if current user is an admin
                        if (SharedText.userModel.role! == 0)
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                                onPressed: () {
                                  _adminController.deleteAchievementVideo(
                                      docID: _adminController
                                          .achievements[index].id!,
                                      url: _adminController
                                          .achievements[index].downloadUrl!);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ),
                      ],
                    );
                  },
                  itemCount: _adminController.achievements.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                );
            }
          },
          stream: _adminController.loadAchievementVideos(),
        ),
      ),
      floatingActionButton: widget.showFAB
          ? FloatingActionButton(
        onPressed: () async {
          await _imageController
              .getImage(context, ImageTypes.achievementVideo,
              isVideo: true)
              .then((value) {
            // _adminController.addAchievementVideo(url: value);
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: AppConstants.mainColor,
      )
          : null,
    );
  }
}
