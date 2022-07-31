import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'Constants/shared_preferences.dart';
import 'Helpers/Lang/translation_service.dart';
import 'Helpers/Responsive_UI/ui_components.dart';
import 'Helpers/logger.dart';
import 'Helpers/shared_texts.dart';
import 'Presentaions/SplashScreens/splash_screen_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getSavedLang() async {
    SharedText.currentLocale = await DefaultSharedPreferences.getLang() ??
        Get.deviceLocale!.languageCode;
    debugPrint('currentLang: 3 ${SharedText.currentLocale}');
  }

  @override
  void initState() {
    super.initState();
    getSavedLang();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'I am lucky',
      debugShowCheckedModeBanner: false,
      enableLog: true,
      logWriterCallback: Logger.write,
      locale: SharedText.currentLocale.isEmpty
          ? TranslationService.locale
          : SharedText.currentLocale == ('en')
          ? const Locale('en')
          : const Locale('ar'),
      fallbackLocale: TranslationService.fallbackLocale,
      translations: TranslationService(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Georgia',
      ),

      /// widget that calculate width, height and type of current device
      home: InfoComponents(
        builder: (infoComponentsContext, deviceInfo) {
          SharedText.screenHeight = deviceInfo.screenHeight;
          SharedText.screenWidth = deviceInfo.screenWidth;
          SharedText.deviceType = deviceInfo;
          // SharedText.currentLocale =
          //     LangCubit.get(context).appLocal!.languageCode;

          PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
            SharedText.appVersion = packageInfo.version;
            SharedText.appName = packageInfo.appName;
            SharedText.packageName = packageInfo.packageName;
            SharedText.buildNumber = packageInfo.buildNumber;
          });

          return const SplashScreenHomePage();
        },
      ),
    );
  }
}
