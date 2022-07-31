import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Presentaions/TasksScreens/add_new_task_page.dart';
import 'package:iamluckydemo/Widgets/common_cached_image_widget.dart';
import 'package:intl/intl.dart';

class AchievementsHomePage extends StatefulWidget {
  final bool withAppBar;

  const AchievementsHomePage({Key? key, this.withAppBar = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AchievementsHomePageState();
}

class _AchievementsHomePageState extends State<AchievementsHomePage> {
  final _adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.withAppBar
          ? AppBar(
              backgroundColor: AppConstants.mainColor,
              centerTitle: true,
              title: Text('My_Achievements'.tr),
            )
          : null,
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: SharedText.isLogged
            ? StreamBuilder(
                stream: _adminController.loadCompletedTasks(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('${'error'.tr}: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    default:
                      return ListView.separated(
                          itemBuilder: (context, index) {
                            var item = _adminController.completedTasks[index];
                            var date = DateTime.fromMillisecondsSinceEpoch(
                                int.parse(_adminController
                                    .completedTasks[index].dateTimeStamp!
                                    .toString()));
                            var formatter = DateFormat('yyyy-MM-dd hh:mm:ss a');

                            return GestureDetector(
                              onTap: () {
                                Get.to(() => AddNewTaskHomePage(
                                    completeTaskModel:
                                        _adminController.completedTasks[index],
                                    docID: _adminController
                                        .completedTasks[index].taskID!));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Row(
                                  children: [
                                    commonCachedImageWidget(
                                        context: context,
                                        imageUrl: item.firstAchieveImage!,
                                        fit: BoxFit.fill,
                                        height: 50,
                                        width: 50),
                                    getSpaceWidth(15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.taskName!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  AppConstants.smallFontSize,
                                            ),
                                          ),
                                          Text(
                                            formatter.format(date),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize:
                                                  AppConstants.smallFontSize,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      item.completed!.toString(),
                                      style: TextStyle(
                                          fontWeight: item.completed!
                                              ? FontWeight.bold
                                              : FontWeight.w400,
                                          color: item.completed!
                                              ? Colors.green
                                              : Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );

                            // return ListTile(
                            //   onTap: () {
                            //     debugPrint(
                            //         'taskID: ${_adminController.completedTasks[index].taskID!}');
                            //     Get.to(() => AddNewTaskHomePage(
                            //         completeTaskModel:
                            //             _adminController.completedTasks[index],
                            //         docID: _adminController
                            //             .completedTasks[index].taskID!));
                            //   },
                            //   leading: commonCachedImageWidget(
                            //       context: context,
                            //       imageUrl: item.firstAchieveImage!,
                            //       fit: BoxFit.fill,
                            //       height: 50,
                            //       width: 50),
                            //   title: Text(item.taskName!),
                            //   subtitle: Text(formatter.format(date)),
                            //   trailing: Text(item.completed!.toString(),
                            //       style: TextStyle(
                            //           fontWeight: item.completed!
                            //               ? FontWeight.bold
                            //               : FontWeight.w400,
                            //           color: item.completed!
                            //               ? Colors.green
                            //               : Colors.grey)),
                            // );
                          },
                          separatorBuilder: (context, index) => Container(
                                height: 1,
                                color: Colors.grey,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 5),
                              ),
                          itemCount: _adminController.completedTasks.length);
                  }
                },
              )
            : Center(
                child: Text('Please_login_first'.tr),
              ),
      ),
    );
  }
}
