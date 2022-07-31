import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Constants/app_constants.dart';
import '../../Constants/enums.dart';
import '../../GetControllers/image_controller.dart';
import '../../GetControllers/tasks_controller.dart';
import '../../Helpers/shared_texts.dart';
import '../../Models/complete_task_model.dart';
import '../../Models/task_model.dart';
import '../../Widgets/common_button.dart';
import 'image_picker_widget.dart';

class AddNewTaskHomePage extends StatefulWidget {
  final CompleteTaskModel? completeTaskModel;
  final TaskModel? taskModel;
  final String docID;

  const AddNewTaskHomePage(
      {Key? key, this.completeTaskModel, this.taskModel, required this.docID})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddNewTaskHomePageState();
}

class _AddNewTaskHomePageState extends State<AddNewTaskHomePage> {
  final _imageController = Get.put(ImageController());
  final _tasksServices = Get.put(TasksController());

  bool isEnabled = false;

  TextEditingController taskNameController = TextEditingController();
  TextEditingController timeFromController = TextEditingController();
  TextEditingController timeToController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

  _selectTime(BuildContext context, bool from) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        if (from) {
          timeFromController.text = selectedTime.format(context);
        } else {
          timeToController.text = selectedTime.format(context);
        }
      });
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dayController.text = selectedDate.day.toString();
        monthController.text = selectedDate.month.toString();
        yearController.text = selectedDate.year.toString();
      });
    }
  }

  void addNewTask({required bool completed}) {
    if (taskNameController.text.isEmpty ||
        timeFromController.text.isEmpty ||
        timeToController.text.isEmpty ||
        dayController.text.isEmpty ||
        monthController.text.isEmpty ||
        yearController.text.isEmpty ||
        feedbackController.text.isEmpty) {
      isEnabled = false;
      Get.snackbar('error'.tr, 'Please_fill_in_all_fields'.tr,
          backgroundColor: Colors.red);
    } else {
      if (_tasksServices.firstDownloadUrl.isEmpty &&
          _tasksServices.secondDownloadUrl.isEmpty &&
          _tasksServices.thirdDownloadUrl.isEmpty) {
        Get.snackbar(
            'error'.tr, 'Please_attach_at_least_one_photo_of_the_assignment'.tr,
            backgroundColor: Colors.red);
        return;
      }

      /// Create New_task
      if (widget.completeTaskModel == null) {
        isEnabled = true;
        Timestamp dtTimeStamp = Timestamp.fromDate(DateTime.now());

        _tasksServices.addNewTask(
          completed: completed,
          countToReward: widget.taskModel!.countToReward!,
          taskID: widget.docID,
          taskName: taskNameController.text,
          timeFrom: timeFromController.text,
          timeTo: timeToController.text,
          dateTime: dtTimeStamp.millisecondsSinceEpoch,
          feedback: feedbackController.text,
        );
      } else {
        /// Edit Current Task
        isEnabled = true;

        _tasksServices.editCurrentTask(
          docID: widget.docID,
          adminComment: widget.completeTaskModel!.adminComment!,
          adminApproved: widget.completeTaskModel!.adminApproved!,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tasksServices.firstDownloadUrl = '';
    _tasksServices.secondDownloadUrl = '';
    _tasksServices.thirdDownloadUrl = '';

    if (widget.completeTaskModel != null) {
      var date = DateTime.fromMillisecondsSinceEpoch(
          int.parse(widget.completeTaskModel!.dateTimeStamp!.toString()));

      taskNameController.text = widget.completeTaskModel!.taskName!;
      feedbackController.text = widget.completeTaskModel!.feedback!;
      timeFromController.text = widget.completeTaskModel!.timeFrom!;
      timeToController.text = widget.completeTaskModel!.timeTo!;
      dayController.text = date.day.toString();
      monthController.text = date.month.toString();
      yearController.text = date.year.toString();
      _tasksServices.firstDownloadUrl =
      widget.completeTaskModel!.firstAchieveImage!;
      _tasksServices.secondDownloadUrl =
      widget.completeTaskModel!.secondAchieveImage!;
      _tasksServices.thirdDownloadUrl =
      widget.completeTaskModel!.thirdAchieveImage!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppConstants.mainColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text('Add_Task'.tr)),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Name
              TextFormField(
                controller: taskNameController,
                decoration: InputDecoration(
                  hintText: 'Task_name'.tr,
                ),
              ),
              const SizedBox(height: 10),

              /// Time
              Row(
                children: [
                  Text(
                    '${'Time'.tr}:',
                    style: const TextStyle(
                        color: AppConstants.mainColor,
                        fontSize: AppConstants.xLargeFontSize),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _selectTime(context, true);
                      },
                      child: IntrinsicWidth(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: timeFromController,
                              enabled: false,
                              decoration: InputDecoration(
                                  hintText: 'From'.tr,
                                  suffixIcon: const Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: 20.0,
                                      color: AppConstants.tealColor)),
                            ),
                            Container(height: 1, color: AppConstants.mainColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _selectTime(context, false);
                      },
                      child: IntrinsicWidth(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: timeToController,
                              enabled: false,
                              decoration: InputDecoration(
                                  hintText: 'To'.tr,
                                  suffixIcon: const Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: 20.0,
                                      color: AppConstants.tealColor)),
                            ),
                            Container(height: 1, color: AppConstants.mainColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              /// Date
              Row(
                children: [
                  Text(
                    '${'Date'.tr}:',
                    style: const TextStyle(
                        color: AppConstants.mainColor,
                        fontSize: AppConstants.xLargeFontSize),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: IntrinsicWidth(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: dayController,
                              enabled: false,
                              decoration: InputDecoration(
                                  hintText: 'Day'.tr,
                                  suffixIcon: const Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: 20.0,
                                      color: AppConstants.tealColor)),
                            ),
                            Container(height: 1, color: AppConstants.mainColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: IntrinsicWidth(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: monthController,
                              enabled: false,
                              decoration: InputDecoration(
                                  hintText: 'month'.tr,
                                  suffixIcon: const Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: 20.0,
                                      color: AppConstants.tealColor)),
                            ),
                            Container(height: 1, color: AppConstants.mainColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: IntrinsicWidth(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: yearController,
                              enabled: false,
                              decoration: InputDecoration(
                                  hintText: 'year'.tr,
                                  suffixIcon: const Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: 20.0,
                                      color: AppConstants.tealColor)),
                            ),
                            Container(height: 1, color: AppConstants.mainColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              /// Feedback
              Text(
                'Feedback'.tr,
                style: const TextStyle(
                    color: AppConstants.mainColor,
                    fontSize: AppConstants.xLargeFontSize),
              ),
              const SizedBox(height: 10),
              Container(
                height: 97,
                width: SharedText.screenWidth,
                padding: const EdgeInsets.all(10),
                decoration: DottedDecoration(
                  shape: Shape.box,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(AppConstants.roundedRadius),
                    bottomLeft: Radius.circular(AppConstants.roundedRadius),
                    bottomRight: Radius.circular(AppConstants.roundedRadius),
                  ),
                ),
                child: TextFormField(
                  controller: feedbackController,
                  maxLines: 2,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 10),

              /// Achievements
              Text(
                '${'Pictures_of_your_achievement'.tr}:',
                style: const TextStyle(
                    color: AppConstants.mainColor,
                    fontSize: AppConstants.xLargeFontSize),
              ),
              const SizedBox(height: 10),

              /// Images
              GetBuilder<ImageController>(
                builder: (ImageController logic) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// First Image
                      imageWidget(
                          context: context,
                          onTap: () async {
                            await _imageController
                                .getImage(context, ImageTypes.firstTaskImage)
                                .then((value) {
                              _tasksServices.firstDownloadUrl = value;
                            });
                          },
                          xFile: _imageController.firstAchieveImage,
                          imageUrl: widget.completeTaskModel == null
                              ? null
                              : widget.completeTaskModel!.firstAchieveImage!),

                      /// Second Image
                      imageWidget(
                          context: context,
                          onTap: () async {
                            await _imageController
                                .getImage(context, ImageTypes.secondTaskImage)
                                .then((value) {
                              _tasksServices.secondDownloadUrl = value;
                            });
                          },
                          xFile: _imageController.secondAchieveImage,
                          imageUrl: widget.completeTaskModel == null
                              ? null
                              : widget.completeTaskModel!.secondAchieveImage!),

                      /// Third Image
                      imageWidget(
                          context: context,
                          onTap: () async {
                            await _imageController
                                .getImage(context, ImageTypes.thirdTaskImage)
                                .then((value) {
                              _tasksServices.thirdDownloadUrl = value;
                            });
                          },
                          xFile: _imageController.thirdAchieveImage,
                          imageUrl: widget.completeTaskModel == null
                              ? null
                              : widget.completeTaskModel!.thirdAchieveImage!),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),

              /// Save Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CommonButton(
                      text: 'Complete'.tr,
                      onPressed: () => addNewTask(completed: true),
                      textColor: Colors.white,
                      fontSize: AppConstants.mediumFontSize,
                      backgroundColor: AppConstants.tealColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CommonButton(
                      text: 'Save'.tr,
                      onPressed: () => addNewTask(completed: false),
                      textColor: Colors.white,
                      fontSize: AppConstants.mediumFontSize,
                      backgroundColor: AppConstants.mainColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
