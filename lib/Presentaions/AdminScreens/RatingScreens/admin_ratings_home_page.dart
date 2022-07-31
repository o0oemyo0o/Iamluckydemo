import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/rating_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/rating_model.dart';

class AdminRatingsHomePage extends StatefulWidget {
  const AdminRatingsHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminRatingsHomePageState();
}

class _AdminRatingsHomePageState extends State<AdminRatingsHomePage> {
  final _ratingController = Get.put(RatingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        title: Text('Ratings'.tr),
      ),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: StreamBuilder(
          stream: _ratingController.loadRatings(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return ListView.builder(
              itemBuilder: (context, index) {
                RatingModel model = _ratingController.ratings[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          AppConstants.defaultButtonRadius),
                      color: AppConstants.lightGreyColor),
                  child: Column(
                    children: [
                      /// UserName
                      Text(model.userName!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppConstants.mainColor,
                              fontSize: AppConstants.smallFontSize)),

                      /// ProductName
                      Text(model.productName!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppConstants.mainColor,
                              fontSize: AppConstants.mediumFontSize)),

                      /// Rating
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppConstants.routineTaskColor),
                          getSpaceWidth(5),
                          Text(model.rating!.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppConstants.tealColor,
                                  fontSize: AppConstants.largeFontSize)),
                        ],
                      ),

                      /// Approvals
                      if (model.isVisited!) ...[
                        Text('I_visited_you_before'.tr,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: AppConstants.smallFontSize)),
                      ],
                      if (model.isRewardReceived!) ...[
                        Text('I_visited_him_to_receive_the_reward'.tr,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: AppConstants.smallFontSize)),
                      ],

                      /// Comment
                      Text(model.comment!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppConstants.newInterestColor,
                              fontSize: AppConstants.smallFontSize)),

                      /// Confirm Button
                      TextButton(
                        onPressed: () {
                          _ratingController.editRatingStatus(
                              rateID: _ratingController.ratings[index].id!);
                        },
                        child: Text('Confirm'.tr,
                            style:
                            const TextStyle(color: AppConstants.mainColor)),
                      ),
                    ],
                  ),
                );
              },
              itemCount: _ratingController.ratings.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            );
          },
        ),
      ),
    );
  }
}
