import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/shared_preferences.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';

class LanguageController extends GetxController {
  void changeLanguage() async {
    String? currentLang = await DefaultSharedPreferences.getLang();

    debugPrint('currentLang: 1 $currentLang');

    await DefaultSharedPreferences.setLang(currentLang == 'ar' ? 'en' : 'ar');
    debugPrint('currentLang: 2 $currentLang');

    Locale locale =
        currentLang == 'ar' ? const Locale('en') : const Locale('ar');

    SharedText.currentLocale = locale.languageCode;

    update();

    Get.updateLocale(locale);
  }
}
