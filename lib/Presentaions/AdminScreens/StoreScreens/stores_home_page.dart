import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/support_store_model.dart';
import 'package:iamluckydemo/Presentaions/SupportStoreScreens/support_store_home_page.dart';
import 'package:iamluckydemo/Widgets/common_cached_image_widget.dart';

class StoresHomePage extends StatefulWidget {
  const StoresHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StoresHomePageState();
}

class _StoresHomePageState extends State<StoresHomePage> {
  final _adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        title: Text('Stores'.tr),
      ),
      body: Container(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
          stream: _adminController.loadSupportStores(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.separated(
                itemBuilder: (context, index) {
                  SupportStoreModel model =
                  _adminController.supportStores[index];

                  return ListTile(
                    onTap: () => Get.to(
                            () => SupportStoreHomePage(supportStoreModel: model)),
                    title: Text(model.storeName!),
                    leading: commonCachedImageWidget(
                        context: context,
                        imageUrl: model.image!,
                        height: 50,
                        width: 50,
                        fit: BoxFit.fill),
                  );
                },
                separatorBuilder: (context, index) => Container(
                    height: 1.5,
                    width: SharedText.screenWidth,
                    color: AppConstants.lightGreyColor),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _adminController.supportStores.length);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppConstants.mainColor,
        onPressed: () => Get.to(() => const SupportStoreHomePage()),
        label: Row(
          children: [
            const Icon(Icons.add, color: Colors.white),
            Text('Add'.tr),
          ],
        ),
      ),
    );
  }
}
