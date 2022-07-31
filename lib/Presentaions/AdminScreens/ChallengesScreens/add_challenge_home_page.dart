import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/Constants/enums.dart';
import 'package:iamluckydemo/GetControllers/challenges_controller.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/challenge_model.dart';
import 'package:iamluckydemo/Widgets/common_button.dart';

import '../../../GetControllers/image_controller.dart';
import '../../TasksScreens/image_picker_widget.dart';

class AddChallengeHomePage extends StatefulWidget {
  final ChallengeModel? challengeModel;

  const AddChallengeHomePage({Key? key, this.challengeModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddChallengeHomePageState();
}

class _AddChallengeHomePageState extends State<AddChallengeHomePage> {
  final _challengeController = Get.put(ChallengesController());
  final _imageController = Get.put(ImageController());

  void addChallenge() {
    if (_challengeController.challengeImage.isEmpty) {
      Get.snackbar('error'.tr, 'Add_the_picture_first'.tr,
          backgroundColor: Colors.red);
      return;
    }

    if (widget.challengeModel == null) {
      _challengeController.addNewChallenge();
    } else {
      _challengeController.editChallenge(
          docID: widget.challengeModel!.id!,
          isUserApproved: widget.challengeModel!.isUserApproved!,
          isAdminApproved: widget.challengeModel!.isAdminApproved!,
          isActive: widget.challengeModel!.isActive!,
          image: _challengeController.challengeImage.isEmpty
              ? widget.challengeModel!.image!
              : _challengeController.challengeImage);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.challengeModel != null) {
      _challengeController.titleController.text = widget.challengeModel!.title!;
      _challengeController.pointsController.text =
          widget.challengeModel!.points!.toString();
      _challengeController.descriptionController.text =
      widget.challengeModel!.description!;
      _challengeController.challengeImage = widget.challengeModel!.image!;
    } else {
      _challengeController.titleController = TextEditingController();
      _challengeController.pointsController = TextEditingController();
      _challengeController.descriptionController = TextEditingController();
      _challengeController.challengeImage = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        centerTitle: true,
        title: Text(widget.challengeModel == null
            ? 'Add_new_challenge'.tr
            : 'Challenge_adjustment'.tr),
      ),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              StreamBuilder(
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('${'error'.tr}: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());

                    default:
                      return Column(
                        children: [
                          /// Title
                          TextFormField(
                            controller: _challengeController.titleController,
                            decoration: InputDecoration(labelText: 'Title'.tr),
                          ),
                          const SizedBox(height: 20),

                          /// Description
                          TextField(
                            controller:
                            _challengeController.descriptionController,
                            minLines: 1,
                            maxLines: 10,
                            decoration: InputDecoration(
                              labelText: 'Description'.tr,
                            ),
                          ),
                          const SizedBox(height: 20),

                          /// Points
                          TextFormField(
                            controller: _challengeController.pointsController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(labelText: 'Points'.tr),
                          ),
                          const SizedBox(height: 20),

                          /// Images
                          GetBuilder<ImageController>(
                            builder: (ImageController logic) {
                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  imageWidget(
                                      context: context,
                                      onTap: () async {
                                        await _imageController
                                            .getImage(context,
                                            ImageTypes.challengeImage)
                                            .then((value) {
                                          _challengeController.challengeImage =
                                              value;
                                        });
                                      },
                                      xFile: _imageController.challengeImage,
                                      imageUrl: widget.challengeModel == null
                                          ? null
                                          : widget.challengeModel!.image!),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          /// Confirm Button
                          GetBuilder(builder: (ChallengesController auth) {
                            if (auth.rxIsLoading.value) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return CommonButton(
                                text: widget.challengeModel == null
                                    ? 'Add'.tr
                                    : 'Edit'.tr,
                                onPressed: () {
                                  addChallenge();
                                },
                                backgroundColor: AppConstants.mainColor,
                                radius: AppConstants.roundedRadius,
                                elevation: 5.0,
                                fontSize: AppConstants.mediumFontSize,
                                textColor: Colors.white,
                                width: 197.33);
                          }),
                        ],
                      );
                  }
                },
                stream: _challengeController.loadChallenges(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
