import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/product_controller.dart';
import 'package:iamluckydemo/GetControllers/rating_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/functions.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Helpers/validations.dart';
import 'package:iamluckydemo/Models/product_model.dart';
import 'package:iamluckydemo/Models/support_store_model.dart';
import 'package:iamluckydemo/Presentaions/Google_Map_Screens/google_map_home_page.dart';
import 'package:iamluckydemo/Services/firebase_auth.dart';
import 'package:iamluckydemo/Services/send_direct_email_service.dart';
import 'package:iamluckydemo/Widgets/common_snackbar_widget.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel productModel;
  final SupportStoreModel? storeModel;

  const ProductWidget({Key? key, required this.productModel, this.storeModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ratingController = Get.put(RatingController());
    final _productController = Get.put(ProductController());
    final _firebaseController = Get.put(FirebaseAuthClass());
    TextEditingController emailController = TextEditingController();

    return Container(
      height: 167,
      width: SharedText.screenWidth,
      decoration: DottedDecoration(
        color: AppConstants.tealColor,
        shape: Shape.box,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(AppConstants.roundedRadius),
          bottomLeft: Radius.circular(AppConstants.roundedRadius),
          bottomRight: Radius.circular(AppConstants.roundedRadius),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 30,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                              5,
                                  (index) => const Icon(Icons.star,
                                  color: AppConstants.routineTaskColor))
                              .toList(),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          productModel.name!,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: AppConstants.largeFontSize,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (storeModel != null)
                        CommonIconButton(
                            image: 'assets/images/location.png',
                            onTap: () {
                              Get.to(() => GoogleMapHomePage(
                                  lat: double.parse(storeModel!.lat!),
                                  lng: double.parse(storeModel!.lng!)));
                            }),
                      CommonIconButton(
                          image: 'assets/images/instagram.png', onTap: () {}),
                      CommonIconButton(
                          image: 'assets/images/cart.png',
                          onTap: () {},
                          height: 50,
                          width: 50),
                      CommonIconButton(
                          image: 'assets/images/favorite.png', onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 34,
            decoration: const BoxDecoration(
              color: AppConstants.mainColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppConstants.roundedRadius),
                bottomRight: Radius.circular(AppConstants.roundedRadius),
              ),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Exchange
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showGetDialog(
                        title: 'replacing'.tr,
                        content: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text('Points_to_be_exchanged'.tr)),
                                getSpaceWidth(15),
                                SizedBox(
                                  width: getWidgetWidth(80),
                                  child: TextField(
                                    controller:
                                    _productController.pointsController,
                                    decoration:
                                    InputDecoration(hintText: 'Points'.tr),
                                  ),
                                ),
                              ],
                            ),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(hintText: 'Email'.tr),
                            ),
                          ],
                        ),
                        onConfirmPressed: () {
                          if (_productController
                              .pointsController.text.isEmpty) {
                            showSnackBar(
                                message:
                                'Please_enter_the_number_of_points'.tr);
                            return;
                          }

                          int point = int.parse(
                              _productController.pointsController.text);

                          if (num.parse(point.toString()) >
                              SharedText.userModel.point!) {
                            showSnackBar(
                                message:
                                'Your_current_points_are_less_than_required'
                                    .tr);
                          }
                          if (emailController.text.trim().isEmpty) {
                            showSnackBar(
                                message: 'Write down the e-mail sent to'.tr);
                            return;
                          }

                          if (ValidationFunctions.validateEmail(
                              emailController.text.trim())) {
                            Get.put(SendDirectEmailService()).sendEmail(
                              points: _firebaseController.currentPoints.value -
                                  point,
                              emailAddress: emailController.text.trim(),
                            );
                            _firebaseController.changeUserPoints(
                                _firebaseController.currentPoints.value -
                                    point);
                            Get.back();
                          } else {
                            showSnackBar(message: 'The_email_is_incorrect'.tr);

                            return;
                          }
                        },
                      );
                    },
                    splashColor: Colors.white,
                    child: Center(
                      child: Text(
                        'Exchange'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.mediumFontSize,
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  color: Colors.white,
                  height: 34,
                  width: 1,
                ),

                /// Evaluation
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showGetDialog(
                        title: 'Evaluation'.tr,
                        content: Column(
                          children: [
                            /// Visited
                            Obx(
                                  () => TextButton(
                                onPressed: () {
                                  _ratingController.changeVisit();
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                        _ratingController.isVisited.value
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: _ratingController.isVisited.value
                                            ? AppConstants.mainColor
                                            : Colors.grey,
                                        size: 15),
                                    getSpaceWidth(10),
                                    Text('I_visited_you_before'.tr,
                                        style: TextStyle(
                                            color: _ratingController
                                                .isVisited.value
                                                ? AppConstants.mainColor
                                                : Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                            AppConstants.smallFontSize)),
                                  ],
                                ),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(EdgeInsets.zero),
                                ),
                              ),
                            ),

                            /// Received
                            Obx(
                                  () => TextButton(
                                onPressed: () {
                                  _ratingController.changeRewardReceived();
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                        _ratingController.isRewardReceived.value
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: _ratingController
                                            .isRewardReceived.value
                                            ? AppConstants.mainColor
                                            : Colors.grey,
                                        size: 15),
                                    getSpaceWidth(10),
                                    Text(
                                        'I_visited_him_to_receive_the_reward'
                                            .tr,
                                        style: TextStyle(
                                            color: _ratingController
                                                .isRewardReceived.value
                                                ? AppConstants.mainColor
                                                : Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                            AppConstants.smallFontSize)),
                                  ],
                                ),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(EdgeInsets.zero),
                                ),
                              ),
                            ),

                            /// Comment
                            TextField(
                              controller: _ratingController.commentController,
                              decoration:
                              InputDecoration(hintText: 'Comment'.tr),
                            ),
                            getSpaceHeight(10),

                            /// Rating Bar
                            GetBuilder(
                              builder: (RatingController controller) {
                                return RatingBar.builder(
                                  initialRating: 1,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber),
                                  onRatingUpdate: (rating) {
                                    _ratingController.changeRating(rating);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        onConfirmPressed: () {
                          if (_ratingController
                              .commentController.text.isEmpty) {
                            showSnackBar(message: 'Write_your_comment'.tr);
                            return;
                          }
                          _ratingController.addNewRating(
                              productID: productModel.id!,
                              productName: productModel.name!,
                              isVisited: _ratingController.isVisited.value,
                              isRewardReceived:
                              _ratingController.isRewardReceived.value,
                              comment: _ratingController.commentController.text,
                              rating: _ratingController.rating.value);
                        },
                      );
                    },
                    splashColor: Colors.white,
                    child: Center(
                      child: Text(
                        'Evaluation'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.mediumFontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommonIconButton extends StatelessWidget {
  final Function() onTap;
  final String image;
  final double? height;
  final double? width;

  const CommonIconButton(
      {Key? key,
        required this.image,
        required this.onTap,
        this.height,
        this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        image,
        height: height ?? 35,
        width: width ?? 35,
        fit: BoxFit.fill,
      ),
    );
  }
}
