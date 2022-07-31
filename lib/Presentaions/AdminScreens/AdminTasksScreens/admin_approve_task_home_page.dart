import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/GetControllers/tasks_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/complete_task_model.dart';
import 'package:iamluckydemo/Services/firebase_auth.dart';
import 'package:iamluckydemo/Widgets/common_button.dart';
import 'package:iamluckydemo/Widgets/common_cached_image_widget.dart';
import 'package:intl/intl.dart';

class AdminApproveTaskHomePage extends StatefulWidget {
  final CompleteTaskModel model;

  const AdminApproveTaskHomePage({Key? key, required this.model})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminApproveTaskHomePageState();
}

class _AdminApproveTaskHomePageState extends State<AdminApproveTaskHomePage> {
  final _adminController = Get.put(AdminController());
  final _taskController = Get.put(TasksController());
  final _firebaseAuthClass = Get.put(FirebaseAuthClass());

  final dtFormat = DateFormat('yyyy/MM/dd');
  final timeFormat = DateFormat('hh:mm:ss a');

  @override
  Widget build(BuildContext context) {
    debugPrint('widget.model.taskID!: ${widget.model.taskID!}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getSpaceHeight(20),

              /// User_name
              commonRow('User_name'.tr, widget.model.userName!,
                  textColor: AppConstants.tealColor,
                  fontSize: AppConstants.mediumFontSize),
              getSpaceHeight(20),
              Container(
                  height: 0.5,
                  width: SharedText.screenWidth,
                  color: Colors.grey[200]),
              getSpaceHeight(20),

              /// Task_name
              commonRow('Achievement_name'.tr,
                  _adminController.getTaskName(widget.model.taskID!),
                  textColor: AppConstants.tealColor,
                  fontSize: AppConstants.mediumFontSize),
              getSpaceHeight(20),
              Container(
                  height: 0.5,
                  width: SharedText.screenWidth,
                  color: Colors.grey[200]),
              getSpaceHeight(20),

              /// Date
              commonRow(
                  'Date'.tr,
                  dtFormat
                      .format(DateTime.fromMicrosecondsSinceEpoch(
                      int.parse(widget.model.dateTimeStamp!.toString())))
                      .toString()),
              getSpaceHeight(20),
              Container(
                  height: 0.5,
                  width: SharedText.screenWidth,
                  color: Colors.grey[200]),
              getSpaceHeight(20),

              /// Time_from
              commonRow('Time_from'.tr, widget.model.timeFrom!),
              getSpaceHeight(20),
              Container(
                  height: 0.5,
                  width: SharedText.screenWidth,
                  color: Colors.grey[200]),
              getSpaceHeight(20),

              /// Time_to
              commonRow('Time_to'.tr, widget.model.timeTo!),
              getSpaceHeight(20),
              Container(
                  height: 0.5,
                  width: SharedText.screenWidth,
                  color: Colors.grey[200]),
              getSpaceHeight(20),

              /// Achievement_name
              commonRow('Achievement_name'.tr, widget.model.taskName!),
              getSpaceHeight(20),
              Container(
                  height: 0.5,
                  width: SharedText.screenWidth,
                  color: Colors.grey[200]),
              getSpaceHeight(20),

              /// Feedback
              commonRow('Feedback'.tr, widget.model.feedback!),
              getSpaceHeight(20),
              Container(
                  height: 0.5,
                  width: SharedText.screenWidth,
                  color: Colors.grey[200]),
              getSpaceHeight(20),

              /// Images
              Text('Images'.tr,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              getSpaceHeight(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  showImage(widget.model.firstAchieveImage!),
                  showImage(widget.model.secondAchieveImage!),
                  showImage(widget.model.thirdAchieveImage!),
                ],
              ),
              getSpaceHeight(20),
              Container(
                  height: 0.5,
                  width: SharedText.screenWidth,
                  color: Colors.grey[200]),
              getSpaceHeight(20),

              /// Buttons
              Row(
                children: [
                  Expanded(
                      child: CommonButton(
                          text: 'Confirm'.tr,
                          onPressed: () {
                            defaultDialog();
                          },
                          backgroundColor: AppConstants.mainColor,
                          textColor: Colors.white,
                          fontSize: AppConstants.mediumFontSize)),
                  getSpaceWidth(10),
                  Expanded(
                      child: CommonButton(
                          text: 'Cancel'.tr,
                          onPressed: () => Get.back(),
                          backgroundColor: AppConstants.finishedEasyTaskColor,
                          textColor: Colors.white,
                          fontSize: AppConstants.mediumFontSize)),
                ],
              ),
              getSpaceHeight(20),
            ],
          ),
        ),
      ),
    );
  }

  defaultDialog() {
    _adminController.adminComment = TextEditingController();

    Get.defaultDialog(
      title: "Write_your_comment".tr,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33),
        child: TextFormField(
          controller: _adminController.adminComment,
          decoration: InputDecoration(labelText: 'comment'.tr),
        ),
      ),
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(color: AppConstants.tealColor),
      middleTextStyle: const TextStyle(color: Colors.white),
      textConfirm: "Confirm".tr,
      textCancel: "Cancel".tr,
      cancelTextColor: AppConstants.mainColor,
      confirmTextColor: Colors.white,
      buttonColor: AppConstants.mainColor,
      barrierDismissible: true,
      radius: AppConstants.defaultButtonRadius,
      onConfirm: () async {
        await _taskController
            .editCurrentTask(
            docID: widget.model.id!,
            adminComment: _adminController.adminComment.text,
            adminApproved: true)
            .then(
              (value) async {
            if (value) {
              await _adminController
                  .getCurrentTaskCountToReward(widget.model.taskID!)
                  .then(
                    (points) {
                  if (points == 0) {
                    _firebaseAuthClass.changeUserPoints(
                        _firebaseAuthClass.currentPoints.value +
                            _taskController.taskRewardPoints);
                  }
                },
              );
            }
          },
        );
      },
    );
  }

  Widget commonRow(
      String title,
      String subtitle, {
        Color textColor = AppConstants.mainColor,
        double fontSize = AppConstants.smallFontSize,
      }) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Text(title + ':',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16))),
        Expanded(
          flex: 1,
          child: Text(
            subtitle,
            style: TextStyle(color: textColor, fontSize: fontSize),
          ),
        ),
      ],
    );
  }

  Widget showImage(String image) {
    return InkWell(
      onTap: () {
        Get.defaultDialog(
          title: '',
          titlePadding: EdgeInsets.zero,
          content: commonCachedImageWidget(
            context: context,
            imageUrl: image,
            fit: BoxFit.fill,
            height: SharedText.screenHeight * 0.5,
            width: SharedText.screenWidth * 0.5,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.defaultButtonRadius),
        child: Container(
          color: Colors.grey[100],
          child: commonCachedImageWidget(
            context: context,
            imageUrl: image,
            fit: BoxFit.contain,
            height: 75,
            width: 75,
          ),
        ),
      ),
    );
  }
}
