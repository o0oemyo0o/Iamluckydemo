import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/quotes_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/QuotesScreens/add_quote_home_page.dart';

class QuotesHomePage extends StatefulWidget {
  final bool withAppBar;
  const QuotesHomePage({Key? key, this.withAppBar = true}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuotesHomePageState();
}

class _QuotesHomePageState extends State<QuotesHomePage> {
  final _quoteController = Get.put(QuotesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.withAppBar
          ? AppBar(
        backgroundColor: AppConstants.mainColor,
        centerTitle: true,
        title: Text('quotes'.tr),
      )
          : null,
      body: SizedBox(
        height: widget.withAppBar
            ? SharedText.screenHeight * 0.75
            : SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: StreamBuilder(
          stream: _quoteController.loadQuotes(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('${'error'.tr}: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());

              default:
                return ListView.separated(
                    itemBuilder: (context, index) {
                      final model = _quoteController.quotes[index];

                      return InkWell(
                        onTap: widget.withAppBar
                            ? () {
                          Get.to(
                                  () => AddQuoteHomePage(quoteModel: model));
                        }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          decoration: BoxDecoration(
                              color: AppConstants.lightGreyColor,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.defaultButtonRadius)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Title
                              Text(model.title!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: AppConstants.mainColor,
                                      fontSize: AppConstants.mediumFontSize)),
                              getSpaceHeight(10),

                              /// Description
                              Text(model.description!,
                                  style: const TextStyle(
                                      color: AppConstants.mainColor,
                                      fontSize: AppConstants.smallFontSize)),
                              getSpaceHeight(10),

                              /// Active || DeActive
                              if (widget.withAppBar) ...[
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      _quoteController.updateIsActive(
                                        docID:
                                        _quoteController.quotes[index].id!,
                                        value: !_quoteController
                                            .quotes[index].isActive!,
                                      );
                                    },
                                    child: Text(
                                        _quoteController.quotes[index].isActive!
                                            ? 'DeActive'.tr
                                            : 'Active'.tr,
                                        style: TextStyle(
                                            fontSize:
                                            AppConstants.mediumFontSize,
                                            color: _quoteController
                                                .quotes[index].isActive!
                                                ? AppConstants
                                                .finishedEasyTaskColor
                                                : AppConstants.mainColor)),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 2.5),
                      );
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _quoteController.quotes.length);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddQuoteHomePage());
        },
        backgroundColor: AppConstants.mainColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
