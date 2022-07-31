import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/GetControllers/city_controller.dart';
import 'package:iamluckydemo/GetControllers/product_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/functions.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/city_model.dart';
import 'package:iamluckydemo/Presentaions/Store_Products_Screens/store_products_home_page.dart';
import 'package:iamluckydemo/Widgets/common_cached_image_widget.dart';

class CoinsReplacementHomePage extends StatefulWidget {
  const CoinsReplacementHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CoinsReplacementHomePageState();
}

class _CoinsReplacementHomePageState extends State<CoinsReplacementHomePage> {
  final _adminController = Get.put(AdminController());
  final _productController = Get.put(ProductController());
  final _cityController = Get.put(CityController());

  // CityModel? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        elevation: 0.0,
        title: Text('Replace_points'.tr),
      ),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// City Title
              Text(
                'City_name'.tr,
                style: const TextStyle(
                    fontSize: AppConstants.largeFontSize,
                    color: AppConstants.mainColor),
              ),
              const SizedBox(height: 10),

              /// City Stores
              StreamBuilder(
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    _cityController.dropdownValue ??= _adminController.cities
                        .where((element) =>
                    element.name! == SharedText.userModel.city!)
                        .first
                        .obs;

                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                  AppConstants.defaultButtonRadius)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton<CityModel>(
                              hint: Text(_cityController.dropdownValue == null
                                  ? 'Select_your_city'.tr
                                  : _cityController.dropdownValue!.value.name!),
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              isExpanded: true,
                              underline: Container(
                                  height: 2, color: Colors.transparent),
                              onChanged: (CityModel? newValue) {
                                setState(() {
                                  _cityController.dropdownValue = newValue!.obs;
                                  _productController.loadProducts();
                                });
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
                        ),

                        /// Stores
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Stores_in '.tr,
                              style: const TextStyle(
                                  fontSize: AppConstants.largeFontSize,
                                  color: AppConstants.mainColor),
                            ),
                            if (_cityController.dropdownValue != null)
                              Obx(
                                    () => Text(
                                  _cityController.dropdownValue!.value.name!,
                                  style: const TextStyle(
                                      fontSize: AppConstants.largeFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.tealColor),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        StreamBuilder(
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return SizedBox(
                              child: ListView.separated(
                                itemCount:
                                _adminController.storesPerCity.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(() => StoreProductsHomePage(
                                          attributeName: 'store',
                                          docID: _adminController
                                              .storesPerCity[index].id!,
                                          storeModel: _adminController
                                              .storesPerCity[index]));
                                    },
                                    child: Container(
                                      // height: 167,
                                      width: SharedText.screenWidth,
                                      decoration: DottedDecoration(
                                        color: AppConstants.tealColor,
                                        shape: Shape.box,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(
                                              AppConstants.roundedRadius),
                                          bottomLeft: Radius.circular(
                                              AppConstants.roundedRadius),
                                          bottomRight: Radius.circular(
                                              AppConstants.roundedRadius),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            /// Store_name and Image
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    _adminController
                                                        .storesPerCity[index]
                                                        .storeName!,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: AppConstants
                                                            .largeFontSize,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                ),
                                                commonCachedImageWidget(
                                                    context: context,
                                                    imageUrl: _adminController
                                                        .storesPerCity[index]
                                                        .image!,
                                                    fit: BoxFit.fill,
                                                    height: 60,
                                                    width: 60),
                                              ],
                                            ),

                                            /// City_name
                                            Text(
                                                _adminController
                                                    .storesPerCity[index]
                                                    .cityName!,
                                                style: const TextStyle(
                                                    color:
                                                    AppConstants.mainColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: AppConstants
                                                        .mediumFontSize)),
                                            getSpaceHeight(10),

                                            /// Owner Name and Category
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const FaIcon(
                                                        FontAwesomeIcons
                                                            .userLarge,
                                                        size: 20),
                                                    Text(
                                                        ' ' +
                                                            _adminController
                                                                .storesPerCity[
                                                            index]
                                                                .ownerName!,
                                                        style: const TextStyle(
                                                            color:
                                                            Colors.grey)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const FaIcon(
                                                        FontAwesomeIcons.tag,
                                                        size: 20),
                                                    Text(
                                                        ' ' +
                                                            _adminController
                                                                .storesPerCity[
                                                            index]
                                                                .catName!,
                                                        style: const TextStyle(
                                                            color:
                                                            Colors.grey)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            getSpaceHeight(10),

                                            /// Website
                                            GestureDetector(
                                              onTap: () {
                                                final Uri toLaunch = Uri(
                                                    scheme: 'https',
                                                    host: _adminController
                                                        .storesPerCity[index]
                                                        .website,
                                                    path: 'headers/');
                                                launchInBrowser(toLaunch);
                                              },
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    const FaIcon(
                                                        FontAwesomeIcons.globe,
                                                        size: 20),
                                                    Text(
                                                        ' ' +
                                                            _adminController
                                                                .storesPerCity[
                                                            index]
                                                                .website!,
                                                        style: const TextStyle(
                                                            color:
                                                            Colors.grey)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          stream: _adminController.loadStoresPerCity(
                              _cityController.dropdownValue!.value.id!),
                        ),
                      ],
                    );
                  },
                  stream: _adminController.loadCities()),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
