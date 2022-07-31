import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/support_store_model.dart';

class AdminSupportStoresHomePage extends StatefulWidget {
  const AdminSupportStoresHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminSupportStoresHomePageState();
}

class _AdminSupportStoresHomePageState
    extends State<AdminSupportStoresHomePage> {
  final _adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        title: Text('Support_Stores'.tr),
      ),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: StreamBuilder(
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.separated(
              separatorBuilder: (context, index) => getSpaceHeight(5),
              itemBuilder: (context, index) {
                SupportStoreModel model = _adminController.supportStores[index];

                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppConstants.lightGreyColor,
                      borderRadius: BorderRadius.circular(
                          AppConstants.defaultButtonRadius)),
                  child: Column(
                    children: [
                      Text(
                        model.storeName!,
                        style: const TextStyle(
                            color: AppConstants.mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: AppConstants.mediumFontSize),
                      ),
                      getSpaceHeight(10),
                      Text(
                        model.cityName!,
                        style: const TextStyle(
                            color: AppConstants.tealColor,
                            fontSize: AppConstants.mediumFontSize),
                      ),
                      getSpaceHeight(5),
                      Text(
                        model.catName!,
                        style: const TextStyle(
                            color: AppConstants.lightGreyColor,
                            fontSize: AppConstants.mediumFontSize),
                      ),
                      getSpaceHeight(5),
                    ],
                  ),
                );
              },
              shrinkWrap: true,
              itemCount: _adminController.supportStores.length,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            );
          },
          stream: _adminController.loadSupportStores(),
        ),
      ),
    );
  }
}
