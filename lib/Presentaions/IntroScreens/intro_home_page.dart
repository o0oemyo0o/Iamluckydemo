import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/shared_preferences.dart';
import 'package:iamluckydemo/Presentaions/AuthenticationScreens/login_screen.dart';
//import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
//import 'package:intro_slider/slide_object.dart';

class IntroHomePage extends StatefulWidget {
  const IntroHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IntroHomePageState();
}

class _IntroHomePageState extends State<IntroHomePage> {
  List<Slide> slides = [];

  late Function goToTab;

  TextStyle styleTitle = const TextStyle(
      color: Color(0xff3da4ab), fontSize: 30.0, fontWeight: FontWeight.bold);
  TextStyle styleDescription = const TextStyle(
      color: Color(0xfffe9c8f), fontSize: 20.0, fontStyle: FontStyle.italic);

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        title: "Buy".tr,
        styleTitle: styleTitle,
        description:
        "Browse_the_menu_and_order_directly_from_the_application".tr,
        styleDescription: styleDescription,
        pathImage: "assets/images/intro.png",
      ),
    );
    slides.add(
      Slide(
        title: "Delivery".tr,
        styleTitle: styleTitle,
        description: "Your_order_will_be_immediately_collected",
        styleDescription: styleDescription,
        pathImage: "assets/images/intro.png",
      ),
    );
    slides.add(
      Slide(
        title: "Finish".tr,
        styleTitle: styleTitle,
        description: "Start_your_journey_in_the_app".tr,
        styleDescription: styleDescription,
        pathImage: "assets/images/intro.png",
      ),
    );
  }

  void onDonePress() async {
    DefaultSharedPreferences.setIsFirstUse(false);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
    log("onTabChangeCompleted, index: $index");
  }

  Widget renderNextBtn() {
    return Text('Next'.tr);
  }

  Widget renderDoneBtn() {
    return const Icon(
      Icons.done,
      color: Color(0xffffcc5c),
    );
  }

  Widget renderSkipBtn() {
    return Text('Skip'.tr);
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor:
      MaterialStateProperty.all<Color>(const Color(0x33ffcc5c)),
      overlayColor: MaterialStateProperty.all<Color>(const Color(0x33ffcc5c)),
    );
  }

  List<Widget> renderListCustomTabs() {
    return List.generate(
      slides.length,
          (index) => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: const EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                child: Image.asset(
                  slides[index].pathImage!,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: Text(
                  slides[index].title!,
                  style: slides[index].styleTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: Text(
                  slides[index].description ?? '',
                  style: slides[index].styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      // Skip button
      renderSkipBtn: renderSkipBtn(),
      // skipButtonStyle: myButtonStyle(),

      // Next button
      renderNextBtn: renderNextBtn(),
      // nextButtonStyle: myButtonStyle(),

      // Done button
      renderDoneBtn: renderDoneBtn(),
      onDonePress: onDonePress,
      // doneButtonStyle: myButtonStyle(),

      // Dot indicator
      colorDot: const Color(0xffffcc5c),
      sizeDot: 7.5,
      //typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: renderListCustomTabs(),
      backgroundColorAllSlides: Colors.white,
      refFuncGoToTab: (refFunc) {
        goToTab = refFunc;
      },

      // Behavior
      scrollPhysics: const BouncingScrollPhysics(),

      // Show or hide status bar
      hideStatusBar: true,

      // On tab change completed
      onTabChangeCompleted: onTabChangeCompleted,
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:iamlucky/Helpers/shared_texts.dart';
//
// class IntroHomePage extends StatefulWidget {
//   const IntroHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _IntroHomePageState();
// }
//
// class _IntroHomePageState extends State<IntroHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         height: SharedText.screenHeight,
//         width: SharedText.screenWidth,
//       ),
//     );
//   }
// }