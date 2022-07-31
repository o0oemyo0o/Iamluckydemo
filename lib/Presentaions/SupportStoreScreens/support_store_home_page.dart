import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/Constants/enums.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/GetControllers/image_controller.dart';
import 'package:iamluckydemo/GetControllers/support_store_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/category_model.dart';
import 'package:iamluckydemo/Models/city_model.dart';
import 'package:iamluckydemo/Models/support_store_model.dart';
import 'package:iamluckydemo/Presentaions/Google_Map_Screens/google_map_home_page.dart';
import 'package:iamluckydemo/Presentaions/TasksScreens/image_picker_widget.dart';
import 'package:iamluckydemo/Widgets/common_button.dart';
import 'package:image_picker/image_picker.dart';

class SupportStoreHomePage extends StatefulWidget {
  final SupportStoreModel? supportStoreModel;

  const SupportStoreHomePage({Key? key, this.supportStoreModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SupportStoreHomePageState();
}

class _SupportStoreHomePageState extends State<SupportStoreHomePage> {
  final _adminController = Get.put(AdminController());
  final _supportStoreController = Get.put(SupportStoreController());
  final _imageController = Get.put(ImageController());

  @override
  void initState() {
    super.initState();

    if (widget.supportStoreModel != null) {
      _imageController.storeImage =
          Rx<XFile>(XFile(widget.supportStoreModel!.image!));

      _supportStoreController.imageUrl = widget.supportStoreModel!.image!;
      _supportStoreController.storeNameController.text =
      widget.supportStoreModel!.storeName!;
      _supportStoreController.cityDropdownValue = _adminController.cities
          .where((element) => element.id! == widget.supportStoreModel!.cityID!)
          .first;
      _supportStoreController.categoryDropdownValue = _adminController
          .categories
          .where((element) => element.id! == widget.supportStoreModel!.catID!)
          .first;
      _supportStoreController.buyingController.text =
      widget.supportStoreModel!.buying!;
      _supportStoreController.discountController.text =
      widget.supportStoreModel!.discount!;
      _supportStoreController.subscriptionController.text =
      widget.supportStoreModel!.subscription!;
      _supportStoreController.ownerNameController.text =
      widget.supportStoreModel!.ownerName!;
      _supportStoreController.phoneNumberController.text =
      widget.supportStoreModel!.phoneNumber!;
      _supportStoreController.emailController.text =
      widget.supportStoreModel!.email!;
      _supportStoreController.websiteController.text =
      widget.supportStoreModel!.website!;
      _supportStoreController.selectedLocationController.text =
      widget.supportStoreModel!.location!;
      _supportStoreController.instagramController.text =
          widget.supportStoreModel!.instagram ?? '';
      _supportStoreController.snapchatController.text =
          widget.supportStoreModel!.snapchat ?? '';
      _supportStoreController.tiktokController.text =
          widget.supportStoreModel!.tiktok ?? '';
      _supportStoreController.activeValue.value =
      widget.supportStoreModel!.isActive!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        centerTitle: true,
        title: Text('Support_Stores'.tr),
        actions: [
          IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.home)),
        ],
      ),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
            initialData: SupportStoreController,
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  getSpaceHeight(20),

                  /// Images
                  GetBuilder<ImageController>(
                    builder: (ImageController logic) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          imageWidget(
                              context: context,
                              onTap: () async {
                                await _imageController
                                    .getImage(context, ImageTypes.storeImage)
                                    .then((value) {
                                  _supportStoreController.imageUrl = value;
                                });
                              },
                              xFile: _imageController.storeImage,
                              imageUrl: widget.supportStoreModel == null
                                  ? null
                                  : widget.supportStoreModel!.image!),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  /// Store_name
                  TextField(
                    controller: _supportStoreController.storeNameController,
                    // enabled: isEnabled,
                    decoration: InputDecoration(hintText: 'Store_name'.tr),
                  ),
                  getSpaceHeight(15),

                  /// City
                  StreamBuilder(
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        _adminController.cities
                            .sort((a, b) => b.name!.compareTo(a.name!));

                        return Row(
                          children: [
                            Text('${'City_name'.tr}: ',
                                style: const TextStyle(
                                    color: AppConstants.mainColor,
                                    fontSize: AppConstants.mediumFontSize)),
                            SizedBox(
                              width: getWidgetWidth(125),
                              child: DropdownButton<CityModel>(
                                hint: Center(
                                  child: Text(_supportStoreController
                                      .cityDropdownValue ==
                                      null
                                      ? 'Select_your_city'.tr
                                      : _supportStoreController
                                      .cityDropdownValue!.name!),
                                ),
                                elevation: 16,
                                isExpanded: true,
                                style:
                                const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                    height: 2, color: AppConstants.mainColor),
                                onChanged: (CityModel? newValue) {
                                  _supportStoreController
                                      .updateCityDropdownValue(newValue!);
                                  setState(() {});
                                },
                                items: _adminController.cities
                                    .map<DropdownMenuItem<CityModel>>(
                                        (CityModel value) {
                                      return DropdownMenuItem<CityModel>(
                                        value: value,
                                        child: Text(value.name!),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                      stream: _adminController.loadCities()),
                  Text(
                      'if_your_store_is_online_or_located_in_all_regions_of_the_kingdom_choose_All'
                          .tr,
                      style: const TextStyle(color: Colors.red)),
                  getSpaceHeight(15),

                  /// Category
                  StreamBuilder(
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        return Row(
                          children: [
                            Text('${'Categories'.tr}: ',
                                style: const TextStyle(
                                    color: AppConstants.mainColor,
                                    fontSize: AppConstants.mediumFontSize)),
                            SizedBox(
                              width: getWidgetWidth(125),
                              child: DropdownButton<CategoryModel>(
                                hint: Center(
                                  child: Text(_supportStoreController
                                      .categoryDropdownValue ==
                                      null
                                      ? 'Select_category'.tr
                                      : _supportStoreController
                                      .categoryDropdownValue!.name!),
                                ),
                                elevation: 16,
                                isExpanded: true,
                                style:
                                const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                    height: 2, color: AppConstants.mainColor),
                                onChanged: (CategoryModel? newValue) {
                                  _supportStoreController
                                      .updateCategoryDropdownValue(newValue!);
                                  setState(() {});
                                },
                                items: _adminController.categories
                                    .map<DropdownMenuItem<CategoryModel>>(
                                        (CategoryModel value) {
                                      return DropdownMenuItem<CategoryModel>(
                                        value: value,
                                        child: Text(value.name!),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                      stream: _adminController.loadCategories()),
                  getSpaceHeight(15),

                  /// Offer_coupon_for:
                  Text('${'Offer_coupon_for'.tr}:',
                      style: const TextStyle(
                          color: AppConstants.mainColor,
                          fontSize: AppConstants.mediumFontSize)),
                  getSpaceHeight(15),

                  /// Buying 100 SAR
                  Obx(
                        () => InkWell(
                      // onTap: () {
                      //   _supportStoreController.updateBuyValue(
                      //       _supportStoreController.buyValue.value =
                      //           !_supportStoreController.buyValue.value);
                      // },
                      child: Row(
                        children: [
                          Icon(
                              _supportStoreController.buyValue.value
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: _supportStoreController.buyValue.value
                                  ? AppConstants.mainColor
                                  : Colors.grey),
                          getSpaceWidth(10),
                          Text('Buying'.tr,
                              style: const TextStyle(
                                  color: AppConstants.mainColor,
                                  fontSize: AppConstants.mediumFontSize)),
                          getSpaceWidth(5),
                          SizedBox(
                            width: getWidgetWidth(80),
                            child: TextField(
                              controller:
                              _supportStoreController.buyingController,
                              textAlign: TextAlign.center,
                              // enabled: isEnabled,
                              decoration:
                              const InputDecoration(hintText: '100'),
                            ),
                          ),
                          getSpaceWidth(5),
                          Text('Default_currency'.tr,
                              style: const TextStyle(
                                  color: AppConstants.mainColor,
                                  fontSize: AppConstants.mediumFontSize)),
                        ],
                      ),
                    ),
                  ),

                  /// Discount
                  Obx(
                        () => InkWell(
                      // onPressed: () {
                      //   _supportStoreController.updateDiscountValue(
                      //       _supportStoreController.discountValue.value =
                      //           !_supportStoreController.discountValue.value);
                      // },
                      child: Row(
                        children: [
                          Icon(
                              _supportStoreController.discountValue.value
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: _supportStoreController.discountValue.value
                                  ? AppConstants.mainColor
                                  : Colors.grey),
                          getSpaceWidth(10),
                          Text('Discount'.tr,
                              style: const TextStyle(
                                  color: AppConstants.mainColor,
                                  fontSize: AppConstants.mediumFontSize)),
                          getSpaceWidth(5),
                          SizedBox(
                            width: getWidgetWidth(80),
                            child: TextField(
                              controller:
                              _supportStoreController.discountController,
                              textAlign: TextAlign.center,
                              // enabled: isEnabled,
                              decoration: const InputDecoration(hintText: '80'),
                            ),
                          ),
                          getSpaceWidth(5),
                          const Text('%',
                              style: TextStyle(
                                  color: AppConstants.mainColor,
                                  fontSize: AppConstants.mediumFontSize)),
                        ],
                      ),
                    ),
                  ),

                  /// Free_Subscription
                  Obx(
                        () => InkWell(
                      // onPressed: () {
                      //   _supportStoreController.updateSubscriptionValue(
                      //       _supportStoreController.subscriptionValue.value =
                      //           !_supportStoreController.subscriptionValue.value);
                      // },
                      child: Row(
                        children: [
                          Icon(
                              _supportStoreController.subscriptionValue.value
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: _supportStoreController
                                  .subscriptionValue.value
                                  ? AppConstants.mainColor
                                  : Colors.grey),
                          getSpaceWidth(10),
                          Text('Free_Subscription'.tr,
                              style: const TextStyle(
                                  color: AppConstants.mainColor,
                                  fontSize: AppConstants.mediumFontSize)),
                          getSpaceWidth(5),
                          SizedBox(
                            width: getWidgetWidth(80),
                            child: TextField(
                              controller: _supportStoreController
                                  .subscriptionController,
                              textAlign: TextAlign.center,
                              // enabled: isEnabled,
                              decoration: const InputDecoration(hintText: '30'),
                            ),
                          ),
                          getSpaceWidth(5),
                          Text('Days'.tr,
                              style: const TextStyle(
                                  color: AppConstants.mainColor,
                                  fontSize: AppConstants.mediumFontSize)),
                        ],
                      ),
                    ),
                  ),

                  getSpaceHeight(15),

                  /// Contact Info
                  Text(
                    '${'Contact_Information'.tr}:',
                    style: const TextStyle(
                        color: AppConstants.mainColor,
                        fontSize: AppConstants.mediumFontSize),
                  ),
                  getSpaceHeight(10),

                  /// Owner Name
                  TextField(
                    controller: _supportStoreController.ownerNameController,
                    // enabled: isEnabled,
                    decoration: InputDecoration(hintText: 'Owner_name'.tr),
                  ),
                  getSpaceHeight(15),

                  /// Phone Number
                  TextField(
                    controller: _supportStoreController.phoneNumberController,
                    // enabled: isEnabled,
                    decoration: InputDecoration(hintText: 'Phone'.tr),
                  ),
                  getSpaceHeight(15),

                  /// Email
                  TextField(
                    controller: _supportStoreController.emailController,
                    // enabled: isEnabled,
                    decoration: InputDecoration(hintText: 'Email'.tr),
                  ),
                  getSpaceHeight(15),

                  /// Website
                  TextField(
                    controller: _supportStoreController.websiteController,
                    // enabled: isEnabled,
                    decoration: InputDecoration(hintText: 'Website'.tr),
                  ),
                  getSpaceHeight(15),

                  /// Map_Link
                  InkWell(
                    onTap: () => Get.to(() => const GoogleMapHomePage(
                        lat: 24.848828483572962, lng: 46.781538713540385)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Map_Link'.tr,
                            style: const TextStyle(
                              color: Colors.grey,
                            )),
                        GetBuilder(
                          builder: (SupportStoreController controller) {
                            return TextField(
                              enabled: false,
                              controller: _supportStoreController
                                  .selectedLocationController,
                              // enabled: isEnabled,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Click_to_choose_your_location'.tr,
                              ),
                            );
                          },
                        ),
                        getSpaceHeight(5),
                        Container(
                          height: 0.5,
                          width: SharedText.screenWidth,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  getSpaceHeight(15),

                  /// Social_Media
                  Text(
                    '${'Social_Media'.tr}:',
                    style: const TextStyle(
                        color: AppConstants.mainColor,
                        fontSize: AppConstants.mediumFontSize),
                  ),
                  getSpaceHeight(10),

                  /// Instagram
                  TextField(
                    controller: _supportStoreController.instagramController,
                    // enabled: isEnabled,
                    decoration: InputDecoration(
                      hintText: 'Instagram'.tr,
                      suffixIcon: Obx(
                            () => InkWell(
                          onTap: () {
                            _supportStoreController.updateInstagramValue();
                            setState(() {});
                          },
                          child: FaIcon(
                              _supportStoreController.instagramValue.value
                                  ? FontAwesomeIcons.circle
                                  : FontAwesomeIcons.circleH,
                              color:
                              _supportStoreController.instagramValue.value
                                  ? AppConstants.mainColor
                                  : Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  getSpaceHeight(15),

                  /// Snapchat
                  TextField(
                    controller: _supportStoreController.snapchatController,
                    // enabled: isEnabled,
                    decoration: InputDecoration(
                      hintText: 'Snapchat'.tr,
                      suffixIcon: InkWell(
                        onTap: () {
                          _supportStoreController.updateSnapchatValue();
                          setState(() {});
                        },
                        child: FaIcon(
                            _supportStoreController.snapchatValue.value
                                ? FontAwesomeIcons.circle
                                : FontAwesomeIcons.circleH,
                            color: _supportStoreController.snapchatValue.value
                                ? AppConstants.mainColor
                                : Colors.grey),
                      ),
                    ),
                  ),
                  getSpaceHeight(15),

                  /// Tiktok
                  TextField(
                    controller: _supportStoreController.tiktokController,
                    // enabled: isEnabled,
                    decoration: InputDecoration(
                      hintText: 'TikTok'.tr,
                      suffixIcon: InkWell(
                        onTap: () {
                          _supportStoreController.updateTiktokValue();
                          setState(() {});
                        },
                        child: FaIcon(
                            _supportStoreController.tiktokValue.value
                                ? FontAwesomeIcons.circle
                                : FontAwesomeIcons.circleH,
                            color: _supportStoreController.tiktokValue.value
                                ? AppConstants.mainColor
                                : Colors.grey),
                      ),
                    ),
                  ),
                  Text(
                      '${'One_will_be_shown_to_the_users'.tr} ,'
                          '${'Choose_your_favorite'.tr}',
                      style: const TextStyle(color: Colors.red)),
                  getSpaceHeight(15),

                  if (SharedText.userModel.role == 0) ...[
                    Obx(() {
                      return InkWell(
                        onTap: () {
                          _supportStoreController.updateActiveValue();
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              _supportStoreController.activeValue.value
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: _supportStoreController.activeValue.value
                                  ? AppConstants.mainColor
                                  : Colors.grey,
                              size: 20.0,
                            ),
                            getSpaceWidth(10),
                            Text('Active'.tr,
                                style: TextStyle(
                                    color: _supportStoreController
                                        .activeValue.value
                                        ? AppConstants.mainColor
                                        : Colors.grey,
                                    fontSize: AppConstants.mediumFontSize)),
                          ],
                        ),
                      );
                    }),
                  ],
                  getSpaceHeight(25),

                  /// Confirm Button
                  GetBuilder(
                    builder: (SupportStoreController controller) {
                      if (controller.rxIsLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Center(
                        child: CommonButton(
                          text: SharedText.userModel.role == 0
                              ? 'Confirm'.tr
                              : 'Send'.tr,
                          onPressed: () async {
                            // if (widget.userRole == 'admin' &&
                            //     widget.supportStoreModel != null) {
                            //   _supportStoreController
                            //       .updateSupportStoreActivation(
                            //           docID: widget.supportStoreModel!.id!);
                            //   return;
                            // } else
                            if (widget.supportStoreModel == null) {
                              await _supportStoreController.addSupportStore();
                            } else {
                              debugPrint(
                                  'buying: ${_supportStoreController.buyingController.text}');
                              await _supportStoreController.editSupportStore(
                                  docID: widget.supportStoreModel!.id!);
                            }
                          },
                          textColor: Colors.white,
                          width: SharedText.screenWidth * 0.5,
                          backgroundColor: AppConstants.mainColor,
                          fontSize: AppConstants.mediumFontSize,
                        ),
                      );
                    },
                  ),
                  getSpaceHeight(25),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
