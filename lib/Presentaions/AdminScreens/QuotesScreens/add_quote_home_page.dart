import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/challenges_controller.dart';
import 'package:iamluckydemo/GetControllers/quotes_controller.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/quote_model.dart';
import 'package:iamluckydemo/Widgets/common_button.dart';

class AddQuoteHomePage extends StatefulWidget {
  final QuoteModel? quoteModel;

  const AddQuoteHomePage({Key? key, this.quoteModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddQuoteHomePageState();
}

class _AddQuoteHomePageState extends State<AddQuoteHomePage> {
  final _quoteController = Get.put(QuotesController());

  void addChallenge() {
    if (widget.quoteModel == null) {
      _quoteController.addNewQuote();
    } else {
      _quoteController.editQuote(
        docID: widget.quoteModel!.id!,
        isActive: widget.quoteModel!.isActive!,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.quoteModel != null) {
      _quoteController.titleController.text = widget.quoteModel!.title!;
      _quoteController.descriptionController.text =
      widget.quoteModel!.description!;
    } else {
      _quoteController.titleController = TextEditingController();
      _quoteController.descriptionController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        centerTitle: true,
        title:
        Text(widget.quoteModel == null ? 'add_quote'.tr : 'Edit_quote'.tr),
      ),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              StreamBuilder(
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());

                    default:
                      return Column(
                        children: [
                          /// Title
                          TextFormField(
                            controller: _quoteController.titleController,
                            decoration: InputDecoration(labelText: 'Title'.tr),
                          ),
                          const SizedBox(height: 20),

                          /// Description
                          TextField(
                            controller: _quoteController.descriptionController,
                            minLines: 1,
                            maxLines: 10,
                            decoration: InputDecoration(
                              labelText: 'Description'.tr,
                            ),
                          ),
                          const SizedBox(height: 20),

                          /// Confirm Button
                          GetBuilder(builder: (ChallengesController auth) {
                            if (auth.rxIsLoading.value) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return CommonButton(
                                text: widget.quoteModel == null
                                    ? 'Add'.tr
                                    : 'Edit'.tr,
                                onPressed: () {
                                  addChallenge();
                                },
                                backgroundColor: AppConstants.mainColor,
                                radius: AppConstants.roundedRadius,
                                elevation: 5.0,
                                fontSize: AppConstants.mediumFontSize,
                                textColor: Colors.white,
                                width: 197.33);
                          }),
                        ],
                      );
                  }
                },
                stream: _quoteController.loadQuotes(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
