import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/Constants/enums.dart';
import 'package:iamluckydemo/GetControllers/category_controller.dart';
import 'package:iamluckydemo/GetControllers/image_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/category_model.dart';
import 'package:iamluckydemo/Presentaions/TasksScreens/image_picker_widget.dart';
import 'package:iamluckydemo/Widgets/common_button.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryScreen extends StatefulWidget {
  final CategoryModel? categoryModel;

  const AddCategoryScreen({Key? key, this.categoryModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _imageController = Get.put(ImageController());
  final _categoryController = Get.put(CategoryController());

  TextEditingController nameController = TextEditingController();

  void addCategoryFun() {
    if (_imageController.categoryImage == null ||
        nameController.text.trim().isEmpty) {
      Get.snackbar('error'.tr, 'Please_fill_in_all_fields'.tr,
          backgroundColor: Colors.red);
    } else if (widget.categoryModel == null) {
      /// Add_category
      _categoryController.addNewCategory(
          image: _imageController.downloadImageUrl, name: nameController.text);
      return;
    }

    /// Update Category
    debugPrint('nameController.text: ${nameController.text}');
    _categoryController.editCategory(
        catID: widget.categoryModel!.id!,
        image: _imageController.categoryImage!.value.path,
        name: nameController.text);
  }

  @override
  void initState() {
    super.initState();

    if (widget.categoryModel != null) {
      _imageController.categoryImage =
          Rx<XFile>(XFile(widget.categoryModel!.image!));

      nameController.text = widget.categoryModel!.name!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        centerTitle: true,
        title: Text(widget.categoryModel == null
            ? 'Add_category'.tr
            : 'Edit_category'.tr),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${'Image'.tr}:',
                      style: const TextStyle(
                          color: AppConstants.tealColor,
                          fontSize: AppConstants.largeFontSize)),
                  GetBuilder<ImageController>(
                    builder: (ImageController logic) {
                      return imageWidget(
                          context: context,
                          onTap: () async {
                            await _imageController.getImage(
                                context, ImageTypes.categoryImage);
                          },
                          xFile: _imageController.categoryImage);
                    },
                  ),
                ],
              ),
              getSpaceHeight(25),

              /// Name
              Text('Category_name'.tr,
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
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: 'Category_name'.tr, border: InputBorder.none),
                ),
              ),
              getSpaceHeight(25),

              /// Add | Edit Button
              CommonButton(
                text: widget.categoryModel == null
                    ? 'Add_category'.tr
                    : 'Edit_category'.tr,
                onPressed: () {
                  addCategoryFun();
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
