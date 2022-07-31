import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/publish_ad_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/functions.dart';

class AdminSupportAdsHomePage extends StatefulWidget {
  const AdminSupportAdsHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminSupportAdsHomePageState();
}

class _AdminSupportAdsHomePageState extends State<AdminSupportAdsHomePage> {
  final _publishAdsController = Get.put(PublishAdsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        centerTitle: true,
        title: Text('Support_Ads'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: StreamBuilder(
          stream: _publishAdsController.loadSupportAds(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('${'error'.tr}: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    _publishAdsController.supportAds
                        .sort((a, b) => b.isActive! ? -1 : 1);

                    var model = _publishAdsController.supportAds[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              AppConstants.defaultButtonRadius),
                          color: AppConstants.lightGreyColor),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Owner Name
                          Text(model.ownerName!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppConstants.mainColor,
                                  fontSize: AppConstants.mediumFontSize)),
                          getSpaceHeight(10),

                          /// Store_name
                          Text(model.storeName!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppConstants.mainColor,
                                  fontSize: AppConstants.smallFontSize)),
                          getSpaceHeight(10),

                          /// Phone Number
                          InkWell(
                            onTap: () {
                              makePhoneCall(model.phoneNumber!);
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.call,
                                    size: 20,
                                    color: AppConstants.taskTitleColor),
                                getSpaceWidth(5),
                                Text(model.phoneNumber!.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: AppConstants.tealColor,
                                        fontSize: AppConstants.smallFontSize)),
                              ],
                            ),
                          ),
                          getSpaceHeight(10),

                          /// Email
                          Row(
                            children: [
                              const Icon(Icons.email,
                                  size: 20, color: AppConstants.taskTitleColor),
                              getSpaceWidth(5),
                              Text(model.email!.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: AppConstants.tealColor,
                                      fontSize: AppConstants.smallFontSize)),
                            ],
                          ),
                          getSpaceHeight(10),

                          /// Url
                          InkWell(
                            onTap: () {
                              launchInBrowser(Uri.parse(model.adLink!));
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.language,
                                    size: 20,
                                    color: AppConstants.taskTitleColor),
                                getSpaceWidth(5),
                                Text(model.adLink!.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: AppConstants.tealColor,
                                        fontSize: AppConstants.smallFontSize)),
                              ],
                            ),
                          ),
                          getSpaceHeight(10),

                          /// IsActive
                          Row(
                            children: [
                              Icon(
                                  model.isActive!
                                      ? Icons.done_outline
                                      : Icons.cancel,
                                  size: 20,
                                  color: model.isActive!
                                      ? AppConstants.tealColor
                                      : AppConstants.finishedEasyTaskColor),
                              getSpaceWidth(5),
                              Text(model.isActive!.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: model.isActive!
                                          ? AppConstants.tealColor
                                          : AppConstants.finishedEasyTaskColor,
                                      fontSize: AppConstants.smallFontSize)),
                            ],
                          ),

                          getSpaceHeight(10),

                          /// Confirm Button
                          Center(
                            child: TextButton(
                              onPressed: () {
                                _publishAdsController.editAdStatus(
                                    docID: _publishAdsController
                                        .supportAds[index].id!);
                              },
                              child: Text(
                                  _publishAdsController
                                      .supportAds[index].isActive!
                                      ? 'Cancel'.tr
                                      : 'Confirm'.tr,
                                  style: TextStyle(
                                      color: _publishAdsController
                                          .supportAds[index].isActive!
                                          ? AppConstants.finishedEasyTaskColor
                                          : AppConstants.mainColor)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 1),
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _publishAdsController.supportAds.length);
            }
          },
        ),
      ),
    );
  }
}
