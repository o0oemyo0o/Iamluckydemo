import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/challenges_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/ChallengesScreens/add_challenge_home_page.dart';

class ChallengesHomePage extends StatefulWidget {
  const ChallengesHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChallengesHomePageState();
}

class _ChallengesHomePageState extends State<ChallengesHomePage> {
  final _challengeController = Get.put(ChallengesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: StreamBuilder(
          stream: _challengeController.loadChallenges(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('${'error'.tr}: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());

              default:
                return ListView.separated(
                    itemBuilder: (context, index) {
                      _challengeController.challenges.sort((a, b) {
                        return b.isActive! ? 1 : -1;
                      });

                      final model = _challengeController.challenges[index];

                      return InkWell(
                        onTap: () {
                          Get.to(() =>
                              AddChallengeHomePage(challengeModel: model));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          decoration: BoxDecoration(
                              color: AppConstants.lightGreyColor,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.defaultButtonRadius)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Title
                              Text(model.title!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: AppConstants.mainColor,
                                      fontSize: AppConstants.mediumFontSize)),
                              getSpaceHeight(10),

                              /// Description
                              Text(model.description!,
                                  style: const TextStyle(
                                      color: AppConstants.mainColor,
                                      fontSize: AppConstants.smallFontSize)),
                              getSpaceHeight(10),

                              /// Points
                              Row(
                                children: [
                                  Text('${'Points'.tr}: '),
                                  Text(model.points!.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: AppConstants.tealColor,
                                          fontSize:
                                          AppConstants.smallFontSize)),
                                ],
                              ),
                              getSpaceHeight(10),

                              /// IsAdminApproved
                              Row(
                                children: [
                                  Text('${'Admin_approval'.tr}: '),
                                  getSpaceWidth(5),
                                  Text(model.isAdminApproved!.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: model.isAdminApproved!
                                              ? AppConstants.tealColor
                                              : AppConstants
                                              .finishedEasyTaskColor,
                                          fontSize:
                                          AppConstants.smallFontSize)),
                                ],
                              ),
                              getSpaceHeight(10),

                              /// IsUserApproved
                              Row(
                                children: [
                                  Text('${'User_approval'.tr}: '),
                                  getSpaceWidth(5),
                                  Text(model.isUserApproved!.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: model.isUserApproved!
                                              ? AppConstants.tealColor
                                              : AppConstants
                                              .finishedEasyTaskColor,
                                          fontSize:
                                          AppConstants.smallFontSize)),
                                ],
                              ),
                              getSpaceHeight(10),

                              /// Confirm Button
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  /// Confirm || Cancel
                                  if (_challengeController
                                      .challenges[index].isUserApproved!) ...[
                                    TextButton(
                                      onPressed: () {
                                        _challengeController.updateApprovals(
                                            key: 'isAdminApproved',
                                            docID: _challengeController
                                                .challenges[index].id!,
                                            value: !_challengeController
                                                .challenges[index]
                                                .isAdminApproved!);
                                      },
                                      child: Text(
                                          _challengeController.challenges[index]
                                              .isAdminApproved! &&
                                              _challengeController
                                                  .challenges[index]
                                                  .isUserApproved!
                                              ? 'Cancel'.tr
                                              : 'Confirm'.tr,
                                          style: TextStyle(
                                              fontSize:
                                              AppConstants.mediumFontSize,
                                              color: _challengeController
                                                  .challenges[index]
                                                  .isActive!
                                                  ? AppConstants
                                                  .finishedEasyTaskColor
                                                  : AppConstants.mainColor)),
                                    ),
                                  ] else ...[
                                    Text(
                                      'User_must_approve_it_first'.tr,
                                      style: const TextStyle(
                                        color: AppConstants.tealColor,
                                        fontSize: AppConstants.xSmallFontSize,
                                      ),
                                    ),
                                  ],

                                  /// Active || DeActive
                                  TextButton(
                                    onPressed: () {
                                      _challengeController.updateApprovals(
                                        key: 'isActive',
                                        docID: _challengeController
                                            .challenges[index].id!,
                                        value: !_challengeController
                                            .challenges[index].isActive!,
                                      );
                                    },
                                    child: Text(
                                        _challengeController
                                            .challenges[index].isActive!
                                            ? 'DeActive'.tr
                                            : 'Active'.tr,
                                        style: TextStyle(
                                            fontSize:
                                            AppConstants.mediumFontSize,
                                            color: _challengeController
                                                .challenges[index].isActive!
                                                ? AppConstants
                                                .finishedEasyTaskColor
                                                : AppConstants.mainColor)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 2.5),
                      );
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _challengeController.challenges.length);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddChallengeHomePage());
        },
        backgroundColor: AppConstants.mainColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
