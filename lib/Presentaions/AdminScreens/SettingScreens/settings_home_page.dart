import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/GetControllers/setting_controller.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Widgets/common_button.dart';

import '../../../Constants/app_constants.dart';

class SettingsHomePage extends StatefulWidget {
  const SettingsHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsHomePageState();
}

class _SettingsHomePageState extends State<SettingsHomePage> {
  final _settingController = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        title: Text('Settings'.tr),
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
                    return Text('${'error'.tr}: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());

                    default:
                      return Column(
                        children: [
                          /// Email
                          TextFormField(
                            controller: _settingController.emailController,
                            decoration: InputDecoration(labelText: 'Email'.tr),
                          ),
                          const SizedBox(height: 40),

                          /// Phone
                          TextFormField(
                            controller: _settingController.phoneController,
                            decoration: InputDecoration(labelText: 'Phone'.tr),
                          ),

                          const SizedBox(height: 40),

                          /// Confirm Button
                          GetBuilder(builder: (SettingController auth) {
                            if (auth.rxIsLoading.value) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return CommonButton(
                                text: 'Confirm'.tr,
                                onPressed: () {
                                  _settingController.editSettings();
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
                stream: _settingController.loadSettings(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
