import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/CategoryScreens/add_category_screen.dart';
import 'package:iamluckydemo/Widgets/common_cached_image_widget.dart';

class CategoriesHomePage extends StatefulWidget {
  const CategoriesHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoriesHomePageState();
}

class _CategoriesHomePageState extends State<CategoriesHomePage> {
  final _adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        centerTitle: true,
        title: Text('Categories'.tr),
      ),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: StreamBuilder(
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return Text('${'error'.tr}: ${snapshot.error}');

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                return ListView.separated(
                  separatorBuilder: (context, index) => Container(
                    height: 1.5,
                    width: SharedText.screenWidth * 0.75,
                    margin: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 20, right: 10),
                    color: Colors.grey[200],
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () => Get.to(AddCategoryScreen(
                          categoryModel: _adminController.categories[index])),
                      leading: commonCachedImageWidget(
                          context: context,
                          imageUrl: _adminController.categories[index].image!,
                          fit: BoxFit.fill,
                          height: 50,
                          width: 50,
                          radius: 10),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      title: Text(
                        _adminController.categories[index].name!,
                        style: const TextStyle(
                            color: AppConstants.tealColor,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                  itemCount: _adminController.categories.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                );
            }
          },
          stream: _adminController.loadCategories(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppConstants.mainColor,
        onPressed: () => Get.to(const AddCategoryScreen()),
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
