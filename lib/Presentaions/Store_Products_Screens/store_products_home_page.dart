import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/product_controller.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/support_store_model.dart';
import 'package:iamluckydemo/Presentaions/Store_Products_Screens/product_widget_page.dart';

class StoreProductsHomePage extends StatefulWidget {
  // final StoreModel? storeModel;
  final SupportStoreModel? storeModel;
  final String docID;
  final String attributeName;

  const StoreProductsHomePage(
      {Key? key,
        this.storeModel,
        required this.docID,
        required this.attributeName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StoreProductsHomePageState();
}

class _StoreProductsHomePageState extends State<StoreProductsHomePage> {
  final _productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        title: Text('Products'.tr),
      ),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Support_Stores'.tr,
                style: const TextStyle(
                  color: AppConstants.tealColor,
                  fontSize: AppConstants.largeFontSize,
                ),
              ),
              const SizedBox(height: 22),
              StreamBuilder(
                stream: _productController.loadStoreProducts(
                    attributeName: widget.attributeName, docID: widget.docID),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_productController.storeProducts.isEmpty) {
                    return SizedBox(
                      height: SharedText.screenHeight - (kToolbarHeight * 5),
                      width: SharedText.screenWidth,
                      child: Center(
                        child: Text(
                            'There are no offers in this store at the moment'
                                .tr),
                      ),
                    );
                  }

                  return ListView.separated(
                      itemBuilder: (context, index) {
                        return ProductWidget(
                          productModel: _productController.storeProducts[index],
                          storeModel: widget.storeModel == null
                              ? null
                              : widget.storeModel!,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Container(height: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _productController.storeProducts.length);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
