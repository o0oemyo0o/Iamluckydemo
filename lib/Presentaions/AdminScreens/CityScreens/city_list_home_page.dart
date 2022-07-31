import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Presentaions/AdminScreens/CityScreens/add_city_home_page.dart';

class CityListHomePage extends StatefulWidget {
  const CityListHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CityListHomePageState();
}

class _CityListHomePageState extends State<CityListHomePage> {
  final _adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        title: Text('Cities'.tr),
      ),
      body: SizedBox(
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: StreamBuilder(
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('${'error'.tr}: ${snapshot.error}');
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());

              default:
                return ListView.separated(
                  separatorBuilder: (context, index) => Container(
                    height: 1.5,
                    width: SharedText.screenWidth * 0.75,
                    margin: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 20, right: 10),
                    color: Colors.grey[200],
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () => Get.to(AddCityHomePage(
                          cityModel: _adminController.cities[index])),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      title: Text(
                        _adminController.cities[index].name!,
                        style: const TextStyle(
                            color: AppConstants.tealColor,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                  itemCount: _adminController.cities.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                );
            }
          },
          stream: _adminController.loadCities(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppConstants.mainColor,
        onPressed: () => Get.to(const AddCityHomePage()),
        label: Row(
          children: const [
            Icon(Icons.add, color: Colors.white),
            Text('Add'),
          ],
        ),
      ),
    );
  }
}
