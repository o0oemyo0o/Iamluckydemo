import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/GetControllers/product_controller.dart';
import 'package:iamluckydemo/GetControllers/support_store_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/category_model.dart';
import 'package:iamluckydemo/Models/product_model.dart';
import 'package:iamluckydemo/Models/support_store_model.dart';
import 'package:iamluckydemo/Widgets/common_button.dart';

class AddProductHomePage extends StatefulWidget {
  final ProductModel? productModel;

  const AddProductHomePage({Key? key, this.productModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddProductHomePageState();
}

class _AddProductHomePageState extends State<AddProductHomePage> {
  final _productController = Get.put(ProductController());
  final _adminController = Get.put(AdminController());
  final _storeController = Get.put(SupportStoreController());
  // final _storeController = Get.put(StoreController());

  TextEditingController nameController = TextEditingController();
  TextEditingController pointsController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  void addStoreFun() {
    if (nameController.text.trim().isEmpty ||
        pointsController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty) {
      Get.snackbar('error'.tr, 'Please_fill_in_all_fields'.tr,
          backgroundColor: Colors.red);
    } else if (widget.productModel == null) {
      /// Add_store
      _productController.addNewProduct(
          catName: _adminController.selectedCategory.name!,
          catID: _adminController.selectedCategory.id!,
          storeID: _storeController.storeDropdownValue!.value.id!,
          storeName: _storeController.storeDropdownValue!.value.storeName!,
          name: nameController.text,
          message: messageController.text,
          points: int.parse(pointsController.text));
      return;
    }

    /// Update Product
    _productController.editProduct(
      catName: _adminController.selectedCategory.name!,
      catID: _adminController.selectedCategory.id!,
      storeID: _storeController.storeDropdownValue!.value.id!,
      storeName: _storeController.storeDropdownValue!.value.storeName!,
      productID: widget.productModel!.id!,
      name: nameController.text,
      message: messageController.text,
      points: int.parse(pointsController.text),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.productModel != null) {
      nameController.text = widget.productModel!.name!;
      pointsController.text = widget.productModel!.points!.toString();
      _adminController.selectedCategory = _adminController.categories
          .where((element) => element.id == widget.productModel!.catID!)
          .first;
      _storeController.storeDropdownValue = _adminController.supportStores
          .where((element) => element.id == widget.productModel!.storeID!)
          .first
          .obs;
    } else {
      _adminController.selectedCategory = _adminController.categories[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        centerTitle: true,
        title: Text(
            widget.productModel == null ? 'Add_product'.tr : 'Edit_product'.tr),
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
              /// Name
              Text('Product_name'.tr,
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
                      hintText: 'Product_name'.tr, border: InputBorder.none),
                ),
              ),
              getSpaceHeight(25),

              /// Category
              Text('Category_name'.tr,
                  style: const TextStyle(
                      color: AppConstants.tealColor,
                      fontSize: AppConstants.largeFontSize)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultButtonRadius)),
                child: DropdownButton<CategoryModel>(
                  underline: const SizedBox(),
                  items: _adminController.categories.map((CategoryModel value) {
                    return DropdownMenuItem<CategoryModel>(
                      value: value,
                      child: Text(value.name!),
                    );
                  }).toList(),
                  onChanged: (model) {
                    setState(() {
                      _adminController.selectedCategory = model!;
                    });
                  },
                  isExpanded: true,
                  hint: Text(_adminController.selectedCategory.name!),
                ),
              ),
              getSpaceHeight(25),

              /// Stores
              Text('Stores'.tr,
                  style: const TextStyle(
                      color: AppConstants.tealColor,
                      fontSize: AppConstants.largeFontSize)),
              StreamBuilder(
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    _storeController.storeDropdownValue ??=
                        _adminController.supportStores[0].obs;

                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(
                              AppConstants.defaultButtonRadius)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<SupportStoreModel>(
                          hint: Text(_storeController.storeDropdownValue == null
                              ? 'Select_store'.tr
                              : _storeController
                              .storeDropdownValue!.value.storeName!),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          isExpanded: true,
                          underline:
                          Container(height: 2, color: Colors.transparent),
                          onChanged: (SupportStoreModel? newValue) {
                            setState(() {
                              _storeController.storeDropdownValue =
                                  newValue!.obs;
                            });
                          },
                          items: _adminController.supportStores
                              .map<DropdownMenuItem<SupportStoreModel>>(
                                  (SupportStoreModel value) {
                                return DropdownMenuItem<SupportStoreModel>(
                                  value: value,
                                  child: Text(value.storeName!),
                                );
                              }).toList(),
                        ),
                      ),
                    );
                  },
                  stream: _adminController.loadSupportStores()),
              getSpaceHeight(25),

              /// Points
              Text('Points'.tr,
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
                  controller: pointsController,
                  decoration: InputDecoration(
                      hintText: 'Points'.tr, border: InputBorder.none),
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

              /// Add | Edit Button
              CommonButton(
                text: widget.productModel == null
                    ? 'Add_store'.tr
                    : 'Edit_store'.tr,
                onPressed: () {
                  addStoreFun();
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
