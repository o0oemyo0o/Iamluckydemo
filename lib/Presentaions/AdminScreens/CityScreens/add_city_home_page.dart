import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/city_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/city_model.dart';
import 'package:iamluckydemo/Widgets/common_button.dart';

class AddCityHomePage extends StatefulWidget {
  final CityModel? cityModel;

  const AddCityHomePage({Key? key, this.cityModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddCityHomePageState();
}

class _AddCityHomePageState extends State<AddCityHomePage> {
  final _cityController = Get.put(CityController());

  TextEditingController nameController = TextEditingController();

  void addCityFun() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('error'.tr, 'Please_fill_in_all_fields'.tr,
          backgroundColor: Colors.red);
    } else if (widget.cityModel == null) {
      /// Add_city
      _cityController.addNewCity(name: nameController.text);
      return;
    }

    /// Update City
    _cityController.editCity(
        cityID: widget.cityModel!.id!, name: nameController.text);
  }

  @override
  void initState() {
    super.initState();
    if (widget.cityModel != null) {
      nameController.text = widget.cityModel!.name!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        title: Text(widget.cityModel == null ? 'Add_city'.tr : 'Edit_city'.tr),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        height: SharedText.screenHeight,
        width: SharedText.screenWidth,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Name
              Text('City_name'.tr,
                  style: const TextStyle(
                      color: AppConstants.tealColor,
                      fontSize: AppConstants.largeFontSize)),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultButtonRadius)),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: 'City_name'.tr, border: InputBorder.none),
                ),
              ),
              getSpaceHeight(25),

              /// Add | Edit Button
              CommonButton(
                text: widget.cityModel == null ? 'Add_city'.tr : 'Edit_city'.tr,
                onPressed: () {
                  addCityFun();
                },
                backgroundColor: AppConstants.mainColor,
                textColor: Colors.white,
                fontSize: AppConstants.mediumFontSize,
              ),
              getSpaceHeight(50),
            ],
          ),
        ),
      ),
    );
  }
}
