import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/task_model.dart';
import 'package:iamluckydemo/Widgets/common_button.dart';

class AdminAddAchievementPage extends StatefulWidget {
  final TaskModel? taskModel;

  const AdminAddAchievementPage({Key? key, this.taskModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminAddAchievementPageState();
}

class _AdminAddAchievementPageState extends State<AdminAddAchievementPage> {
  final _adminController = Get.put(AdminController());
  TextEditingController nameArController = TextEditingController();
  TextEditingController nameEnController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController countToRewardController = TextEditingController();
  TextEditingController rewardPointsController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  void addTaskFun() {
    if (nameArController.text.trim().isEmpty ||
        nameEnController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty ||
        countController.text.trim().isEmpty ||
        countToRewardController.text.trim().isEmpty ||
        rewardPointsController.text.trim().isEmpty) {
      Get.snackbar('error'.tr, 'Please_fill_in_all_fields'.tr,
          backgroundColor: Colors.red);
    } else if (widget.taskModel == null) {
      /// Add_category
      _adminController.addNewTask(
          count: int.parse(countController.text),
          countToReward: int.parse(countToRewardController.text),
          rewardPoints: int.parse(rewardPointsController.text),
          nameAr: nameArController.text,
          nameEn: nameEnController.text,
          message: messageController.text);
      return;
    }

    /// Update Category
    _adminController.editTask(
        taskID: widget.taskModel!.id!,
        count: int.parse(countController.text),
        countToReward: int.parse(countToRewardController.text),
        rewardPoints: int.parse(rewardPointsController.text),
        nameAr: nameArController.text,
        nameEn: nameEnController.text,
        message: messageController.text);
  }

  @override
  void initState() {
    super.initState();
    if (widget.taskModel != null) {
      countController.text = widget.taskModel!.count!.toString();
      countToRewardController.text =
          widget.taskModel!.countToReward!.toString();
      rewardPointsController.text = widget.taskModel!.rewardPoints!.toString();
      nameArController.text = widget.taskModel!.nameAr!.toString();
      nameEnController.text = widget.taskModel!.nameEn!.toString();
      messageController.text = widget.taskModel!.message!.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: AppConstants.mainColor),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// NameAr
              Text('NameAr'.tr,
                  style: const TextStyle(
                      color: AppConstants.tealColor,
                      fontSize: AppConstants.largeFontSize)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultButtonRadius)),
                child: TextField(
                  controller: nameArController,
                  decoration: InputDecoration(
                      hintText: 'NameAr'.tr, border: InputBorder.none),
                ),
              ),
              getSpaceHeight(25),

              /// NameEn
              Text('NameEn'.tr,
                  style: const TextStyle(
                      color: AppConstants.tealColor,
                      fontSize: AppConstants.largeFontSize)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultButtonRadius)),
                child: TextField(
                  controller: nameEnController,
                  decoration: InputDecoration(
                      hintText: 'NameEn'.tr, border: InputBorder.none),
                ),
              ),
              getSpaceHeight(25),

              /// Message
              Text('Message'.tr,
                  style: const TextStyle(
                      color: AppConstants.tealColor,
                      fontSize: AppConstants.largeFontSize)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultButtonRadius)),
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                      hintText: 'Message'.tr, border: InputBorder.none),
                ),
              ),
              getSpaceHeight(25),

              /// Count
              Text('Count'.tr,
                  style: const TextStyle(
                      color: AppConstants.tealColor,
                      fontSize: AppConstants.largeFontSize)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultButtonRadius)),
                child: TextField(
                  controller: countController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      hintText: 'Count'.tr, border: InputBorder.none),
                ),
              ),
              getSpaceHeight(25),

              /// Count To Reward
              Text('Add_5_Points'.tr,
                  style: const TextStyle(
                      color: AppConstants.tealColor,
                      fontSize: AppConstants.largeFontSize)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultButtonRadius)),
                child: TextField(
                  controller: countToRewardController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      hintText: 'Add_5_Points'.tr,
                      border: InputBorder.none),
                ),
              ),
              getSpaceHeight(25),

              /// Reward_points
              Text('Reward_points'.tr,
                  style: const TextStyle(
                      color: AppConstants.tealColor,
                      fontSize: AppConstants.largeFontSize)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultButtonRadius)),
                child: TextField(
                  controller: rewardPointsController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      hintText: 'Points_to_reward_every_completed_task'.tr,
                      border: InputBorder.none),
                ),
              ),
              getSpaceHeight(25),

              /// Add | Edit Button
              CommonButton(
                text: widget.taskModel == null ? 'Add'.tr : 'Edit'.tr,
                onPressed: () {
                  addTaskFun();
                },
                backgroundColor: AppConstants.mainColor,
                textColor: Colors.white,
                fontSize: AppConstants.mediumFontSize,
              ),
              getSpaceHeight(50),
            ],
          ),
        ),
      ),
    );
  }
}
