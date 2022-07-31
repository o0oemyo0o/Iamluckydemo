import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Presentaions/Achievement_Screens/achievements_home_page.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/QuotesScreens/quotes_home_page.dart';
import 'package:iamluckydemo/Presentaions/HomeScreens/home_page.dart';
import 'package:iamluckydemo/Presentaions/ProfileScreens/profile_home_page.dart';
import 'package:iamluckydemo/Presentaions/TasksScreens/tasks_home_page.dart';
import 'package:iamluckydemo/Shapes/bmb_nav_bar_widget.dart';
import 'package:iamluckydemo/Widgets/common_drawer_widget.dart';

import '../AdminScreens/ChallengesScreens/challenges_home_page.dart';

class BMBHomePage extends StatefulWidget {
  const BMBHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BMBHomePageState();
}

class _BMBHomePageState extends State<BMBHomePage> {
  int currentIndex = 0;
  String title = 'Task_list';

  List<Widget> widgets = [
    const HomePage(),//0
    const AchievementsHomePage(),//1
    const QuotesHomePage(withAppBar: false),//2
    const TasksHomePage(withAppBar: false),//3
    const ProfileHomePage(withAppBar: false),//4
    const ChallengesHomePage(),//5
  ];

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;

      switch (index) {
        case 0:
          title = 'I am lucky'.tr;
          break;
        case 1:
          title =  'Success_tasks'.tr;
          break;
        case 2:
          title = 'Quotes'.tr;
          break;
        case 3:
          title = 'Offers'.tr;
          break;
        case 4:
          title = 'Profile'.tr;
          break;
        case 5:
          title = 'Challenges'.tr;
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Get.put(AdminController()).loadCities();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        elevation: 0.0,
        centerTitle: true,
         title: Text(title),
        actions: [
          IconButton(onPressed: (){setBottomBarIndex(0);}, icon:const Icon(Icons.home)),
        ],
        //title: const Text('I am lucky'),
      ),
      drawer: const CommonDrawerWidget(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            height: SharedText.screenHeight - 80,
            width: SharedText.screenWidth,
            child: currentIndex == 0
                ? widgets[0]
                : currentIndex == 1
                ? widgets[1]
                : currentIndex == 2
                ? widgets[2]
                : currentIndex == 3
                ? widgets[3]
                : currentIndex == 4
                ? widgets[4]
                :widgets[5],
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: size.width,
              height: 80,
              child: Stack(
                children: [
                  /// BottomNavigationBar
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),

                  /// Center Icon
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(
                        backgroundColor: AppConstants.mainColor,
                        child: FaIcon(FontAwesomeIcons.wandMagicSparkles,
                            color: currentIndex == 5
                                ? AppConstants.easyTaskColor
                                : Colors.white),
                        elevation: 0.1,
                        onPressed: () {
                          setBottomBarIndex(5);
                        }),
                  ),

                  /// Icons
                  SizedBox(
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// Task_list
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.listCheck,
                              color: currentIndex == 1
                                  ? AppConstants.easyTaskColor
                                  : Colors.white),
                          onPressed: () {
                            setBottomBarIndex(1);
                          },
                          splashColor: Colors.white,
                        ),

                        /// Offers
                        IconButton(
                            icon: FaIcon(FontAwesomeIcons.tag,
                                color: currentIndex == 3
                                    ? AppConstants.easyTaskColor
                                    : Colors.white),
                            onPressed: () {
                              setBottomBarIndex(3);
                            }),
                        Container(
                          width: size.width * 0.20,
                        ),

                        /// quote
                        IconButton(
                            icon: FaIcon(FontAwesomeIcons.quoteRight,
                                color: currentIndex == 2
                                    ? AppConstants.easyTaskColor
                                    : Colors.white),
                            onPressed: () {
                              setBottomBarIndex(2);
                            }),

                        /// Profile
                        IconButton(
                            icon: FaIcon(FontAwesomeIcons.userLarge,
                                color: currentIndex == 4
                                    ? AppConstants.easyTaskColor
                                    : Colors.white),
                            onPressed: () {
                              setBottomBarIndex(4);
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
