import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/shared_preferences.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Presentaions/IntroScreens/intro_home_page.dart';
import 'package:iamluckydemo/Presentaions/NavigatorScreens/bmb_home_page.dart';
import 'package:iamluckydemo/Services/firebase_auth.dart';

class SplashScreenHomePage extends StatefulWidget {
  const SplashScreenHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashScreenHomePageState();
}

class _SplashScreenHomePageState extends State<SplashScreenHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  final FirebaseAuthClass _firebaseAuthClass = FirebaseAuthClass();

  goToNextPage() async {
    SharedText.isLogged = await DefaultSharedPreferences.getIsLogged() ?? false;
    bool isFirstUse = await DefaultSharedPreferences.getIsFirstUse() ?? true;
    String email = await DefaultSharedPreferences.getEmail() ?? '';
    String password = await DefaultSharedPreferences.getPassword() ?? '';
    String provider = await DefaultSharedPreferences.getProvider() ?? '';

    if (SharedText.isLogged) {
      if (provider == 'Google') {
        _firebaseAuthClass.getUserDataWithNavigation();
      } else {
        await _firebaseAuthClass.signIn(
            email: email, password: password, currentScreen: 'splash_screen');
      }
    } else if (!isFirstUse) {
      return Timer(const Duration(milliseconds: 2500), () {
        Get.offAll(() => const BMBHomePage());
      });
    } else {
      return Timer(const Duration(milliseconds: 2500), () {
        Get.offAll(() => const IntroHomePage());
      });
    }
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.linear);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();

    goToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: customWidget(),
      ),
    );
  }

  Widget customWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Container(
                color: Colors.white,
                child: Image.asset('assets/images/logo.png',
                    fit: BoxFit.contain, width: SharedText.screenWidth),
              ),
            ),
          ),
        ),
        Text(
          'version: ' + SharedText.appVersion.toString(),
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
