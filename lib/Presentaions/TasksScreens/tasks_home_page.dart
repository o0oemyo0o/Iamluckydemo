import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Constants/app_constants.dart';
import '../../GetControllers/tasks_controller.dart';
import '../../Helpers/shared_texts.dart';
import 'add_new_task_page.dart';

class TasksHomePage extends StatefulWidget {
  final bool withAppBar;
  const TasksHomePage({Key? key, this.withAppBar = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TasksHomePageState();
}

class _TasksHomePageState extends State<TasksHomePage> {
  final _tasksServices = Get.put(TasksController());
  int timeStamp = 0;

  @override
  void initState() {
    super.initState();

    Timestamp stamp =
        Timestamp.fromDate(DateTime.now().add(const Duration(minutes: -1)));
    timeStamp = stamp.millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.withAppBar
          ? AppBar(
              backgroundColor: AppConstants.mainColor,
              title: Text('New_task'.tr),
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios),
              ),
            )
          : const PreferredSize(child: SizedBox(), preferredSize: Size(0, 0)),
      body: FutureBuilder(
        future: _tasksServices.fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return FutureBuilder(
            future: _tasksServices.fetchUserCompletedTasks(),
            builder: (context, completeSnapshot) {
              if (completeSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return SizedBox(
                height: widget.withAppBar
                    ? SharedText.screenHeight
                    : SharedText.screenHeight * 0.75,
                width: SharedText.screenWidth,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    height: SharedText.screenHeight - (kToolbarHeight * 2),
                    width: SharedText.screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Choose_task_type'.tr,
                            style: const TextStyle(
                                color: AppConstants.mainColor,
                                fontSize: AppConstants.largeFontSize)),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.question_mark,
                                size: 15, color: Colors.red),
                            const SizedBox(width: 10),
                            Text(
                              'To_see_the_details_of_the_task_long_click_on_it'
                                  .tr,
                              style: const TextStyle(
                                  color: AppConstants.mainColor,
                                  fontSize: AppConstants.smallFontSize),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 16 / 12,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 15),
                            itemCount: _tasksServices.taskList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              bool isDivisibleBy3 = index % 3 == 0;

                              return TaskWidget(
                                  onTap: () {
                                    if (_tasksServices
                                            .taskList[index].completedCount <
                                        _tasksServices.taskList[index].count!) {
                                      if (SharedText.isLogged) {
                                        Get.to(AddNewTaskHomePage(
                                            taskModel:
                                                _tasksServices.taskList[index],
                                            docID: _tasksServices
                                                .taskList[index].id!));
                                      } else {
                                        Get.snackbar(
                                            'error'.tr, 'Please_login_first'.tr,
                                            backgroundColor: Colors.red);
                                      }
                                    } else {
                                      Get.showSnackbar(GetSnackBar(
                                          title: 'Warning'.tr,
                                          message:
                                              'You_have_completed_all_tasks_of_this_part'
                                                  .tr,
                                          duration: const Duration(
                                              milliseconds: 5000),
                                          backgroundColor:
                                              AppConstants.drawerBottomColor));
                                    }
                                  },
                                  countToEarn: _tasksServices
                                      .taskList[index].countToEarn,
                                  taskID: _tasksServices.taskList[index].id!,
                                  title: _tasksServices.taskList[index].nameAr!,
                                  message:
                                      _tasksServices.taskList[index].message!,
                                  subtitle:
                                      '${'completed'.tr}: ${_tasksServices.taskList[index].completedCount}',
                                  bgColor: isDivisibleBy3
                                      ? AppConstants.easyTaskColor
                                      : AppConstants.finishedNewHabitTaskColor,
                                  finishedTasks: _tasksServices
                                      .taskList[index].completedCount,
                                  totalTasks:
                                      _tasksServices.taskList[index].count!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class TaskWidget extends StatelessWidget {
  final String taskID;
  final int totalTasks;
  final int finishedTasks;
  final int countToEarn;
  final String title;
  final String message;
  final String? subtitle;
  final Color bgColor;
  final Function() onTap;
  final bool withTopRadius;

  const TaskWidget({
    Key? key,
    required this.taskID,
    required this.totalTasks,
    required this.finishedTasks,
    required this.countToEarn,
    required this.title,
    required this.message,
    this.subtitle,
    required this.onTap,
    required this.bgColor,
    this.withTopRadius = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    void _onTap(GlobalKey key) {
      final dynamic tooltip = key.currentState;
      tooltip?.ensureTooltipVisible();
    }

    return Tooltip(
      message: message,
      key: key,
      child: GestureDetector(
        onLongPress: () {
          _onTap(key);
        },
        onTap: onTap,
        child: SizedBox(
          width: 142,
          height: 170,
          child: Column(
            children: [
              // if (subtitle != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${'Still_have'.tr} ',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: AppConstants.xSmallFontSize),
                  ),
                  Text(
                    '$countToEarn',
                    style: const TextStyle(
                        color: AppConstants.tealColor,
                        fontSize: AppConstants.smallFontSize),
                  ),
                  Text(
                    ' ${'to_earn'.tr}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: AppConstants.xSmallFontSize),
                  ),
                ],
              ),

              subtitle == null
                  ? const SizedBox(height: 1)
                  : Container(
                      height: 3.5,
                      width: 142,
                      color: bgColor,
                      child: Row(
                        children: [
                          SizedBox(
                            width: (finishedTasks == 0
                                    ? 1
                                    : finishedTasks / totalTasks) *
                                142,
                            child: ListView.builder(
                              itemBuilder: (context, index) => Container(
                                  height: 3.5,
                                  width: 142 / totalTasks,
                                  color: Colors.green),
                              shrinkWrap: true,
                              itemCount: finishedTasks,
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 5),
              Expanded(
                child: SizedBox(
                  width: 150,
                  child: Card(
                    margin: EdgeInsets.zero,
                    color: bgColor,
                    // elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: const Radius.circular(
                                AppConstants.roundedRadius),
                            bottomRight: const Radius.circular(
                                AppConstants.roundedRadius),
                            topLeft: Radius.circular(withTopRadius
                                ? AppConstants.defaultButtonRadius
                                : 0),
                            topRight: Radius.circular(withTopRadius
                                ? AppConstants.defaultButtonRadius
                                : 0))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: AppConstants.largeFontSize,
                              color: AppConstants.taskTitleColor),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: AppConstants.smallFontSize,
                                color: AppConstants.taskTitleColor),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
