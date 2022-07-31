import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/publish_ad_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/publish_ad_model.dart';
import 'package:iamluckydemo/Widgets/common_button.dart';

class PublishAdsHomePage extends StatefulWidget {
  final String userRole;
  final PublishAdModel? publishAdModel;

  const PublishAdsHomePage(
      {Key? key, required this.userRole, this.publishAdModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PublishAdsHomePageState();
}

class _PublishAdsHomePageState extends State<PublishAdsHomePage> {
  final _publishAdController = Get.put(PublishAdsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        title: Text('Publish_ad'.tr),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.home)),
        ],
      ),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          child: FutureBuilder(
            builder: (context, snapshot) {
              return Column(
                children: [
                  /// Store_name
                  TextField(
                    controller: _publishAdController.storeNameController,
                    decoration: InputDecoration(hintText: 'Store_name'.tr),
                  ),
                  getSpaceHeight(15),

                  /// Owner Name
                  TextField(
                    controller: _publishAdController.ownerNameController,
                    decoration: InputDecoration(hintText: 'Owner_name'.tr),
                  ),
                  getSpaceHeight(15),

                  /// Phone Number
                  TextField(
                    controller: _publishAdController.phoneNumberController,
                    decoration: InputDecoration(hintText: 'Phone'.tr),
                  ),
                  getSpaceHeight(15),

                  /// Email
                  TextField(
                    controller: _publishAdController.emailController,
                    decoration: InputDecoration(hintText: 'Email'.tr),
                  ),
                  getSpaceHeight(15),

                  /// Ad_link
                  TextField(
                    controller: _publishAdController.adLinkController,
                    decoration: InputDecoration(hintText: 'Ad_link'.tr),
                  ),
                  getSpaceHeight(15),

                  /// Confirm Button
                  GetBuilder(
                    builder: (PublishAdsController controller) {
                      if (controller.rxIsLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return CommonButton(
                        text: widget.userRole == 'admin'
                            ? 'Confirm'.tr
                            : 'Send'.tr,
                        onPressed: () {
                          if (widget.userRole == 'admin') {
                            _publishAdController.updateSupportAdActivation(
                                docID: widget.publishAdModel!.id!);
                            return;
                          }

                          if (widget.publishAdModel == null) {
                            _publishAdController.addSupportAds();
                          } else {
                            _publishAdController.editSupportAds(
                                docID: widget.publishAdModel!.id!);
                          }
                        },
                        width: SharedText.screenWidth * 0.5,
                        backgroundColor: AppConstants.mainColor,
                        textColor: Colors.white,
                        fontSize: AppConstants.mediumFontSize,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
