import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/product_controller.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/ProductScreens/add_product_home_page.dart';

class ProductsHomePage extends StatefulWidget {
  const ProductsHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductsHomePageState();
}

class _ProductsHomePageState extends State<ProductsHomePage> {
  final _productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        centerTitle: true,
        title: const Text('Products'),
      ),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: StreamBuilder(
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                return ListView.separated(
                  separatorBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 20, right: 10),
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Get.to(() => AddProductHomePage(
                          productModel: _productController.products[index])),
                      child: Container(
                        width: SharedText.screenWidth,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(
                                AppConstants.defaultButtonRadius)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              _productController.products[index].name!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppConstants.mediumFontSize),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Category:',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppConstants.mainColor,
                                      fontSize: AppConstants.smallFontSize),
                                ),
                                Text(
                                  _productController.products[index].catName!
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: AppConstants.tealColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppConstants.mediumFontSize),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Store:',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppConstants.mainColor,
                                      fontSize: AppConstants.smallFontSize),
                                ),
                                Text(
                                  _productController.products[index].storeName!
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: AppConstants.tealColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppConstants.mediumFontSize),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Rating:',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppConstants.mainColor,
                                      fontSize: AppConstants.smallFontSize),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: AppConstants.pointsColor),
                                    Text(
                                      _productController.products[index].points!
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: AppConstants.tealColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppConstants.smallFontSize),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: _productController.products.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                );
            }
          },
          stream: _productController.loadProducts(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppConstants.mainColor,
        onPressed: () => Get.to(() => const AddProductHomePage()),
        label: Row(
          children: const [
            Icon(Icons.add, color: Colors.white),
            Text('Add'),
          ],
        ),
      ),
    );
  }
}
