import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/AdminTasksScreens/admin_approve_task_home_page.dart';
import 'package:iamluckydemo/Widgets/common_cached_image_widget.dart';
import 'package:intl/intl.dart';

class AdminTasksHomePage extends StatefulWidget {
  const AdminTasksHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminTasksHomePageState();
}

class _AdminTasksHomePageState extends State<AdminTasksHomePage> {
  final _adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: AppConstants.mainColor),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _adminController.loadCompletedTasks(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('${'error'.tr}: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        var item = _adminController.completedTasks[index];
                        var date = DateTime.fromMillisecondsSinceEpoch(
                            int.parse(_adminController
                                .completedTasks[index].dateTimeStamp!
                                .toString()));
                        var formatter = DateFormat('yyyy-MM-dd hh:mm:ss a');

                        bool confirmed = item.completed! && item.adminApproved!;

                        return ListTile(
                          onTap: () {
                            Get.to(() => AdminApproveTaskHomePage(
                                model: _adminController.completedTasks[index]));
                          },
                          leading: commonCachedImageWidget(
                              context: context,
                              imageUrl: item.firstAchieveImage!,
                              fit: BoxFit.fill,
                              height: 50,
                              width: 50),
                          title: Text(item.taskName!),
                          subtitle: Text(formatter.format(date)),
                          trailing: Text(confirmed.toString(),
                              style: TextStyle(
                                  fontWeight: item.completed!
                                      ? FontWeight.bold
                                      : FontWeight.w400,
                                  color: item.completed!
                                      ? Colors.green
                                      : Colors.grey)),
                        );
                      },
                      separatorBuilder: (context, index) => Container(
                        height: 1,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                      ),
                      itemCount: _adminController
                          .completedTasks
                      // .where((element) => element.completed!)
                          .length);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
