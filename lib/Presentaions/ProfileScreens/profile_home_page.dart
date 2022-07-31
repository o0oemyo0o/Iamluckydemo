import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/Constants/shared_preferences.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/Helpers/functions.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Helpers/validations.dart';
import 'package:iamluckydemo/Models/city_model.dart';
import 'package:iamluckydemo/Services/firebase_auth.dart';
import 'package:iamluckydemo/Widgets/common_button.dart';
import 'package:iamluckydemo/Widgets/common_snackbar_widget.dart';
import 'package:image_picker/image_picker.dart';
import '../../Constants/enums.dart';
import '../../GetControllers/image_controller.dart';
import '../TasksScreens/image_picker_widget.dart';

class ProfileHomePage extends StatefulWidget {
  final bool withAppBar;
  const ProfileHomePage({Key? key, this.withAppBar = true}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  final _firebaseAuthClass = Get.put(FirebaseAuthClass());
  final _adminController = Get.put(AdminController());
  final _imageController = Get.put(ImageController());

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String savedPassword = '';

  getSavedPassword() async {
    String? result = await DefaultSharedPreferences.getPassword();
    savedPassword = result!;
    debugPrint('savedPassword: $savedPassword');
  }

  @override
  void initState() {
    super.initState();
    _imageController.downloadImageUrl = '';

    if (SharedText.isLogged) {
      nameController.text = SharedText.userModel.name!;
      phoneController.text = SharedText.userModel.phone!;
      emailController.text = SharedText.userModel.email!;

      if (SharedText.userModel.image!.isNotEmpty) {
        _imageController.downloadImageUrl = SharedText.userModel.image!;
        _imageController.profileImage =
            Rx<XFile>(XFile(SharedText.userModel.image!));
      }

      if (SharedText.userModel.city!.isNotEmpty) {
        _firebaseAuthClass.authCityDropDownValue = _adminController.cities
            .where((element) => element.name! == SharedText.userModel.city!)
            .first;
      }
      getSavedPassword();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: widget.withAppBar
            ? AppBar(
          backgroundColor: AppConstants.mainColor,
          centerTitle: true,
          title: Text('Profile'.tr),
        )
            : null,
        body: SizedBox(
          height: widget.withAppBar
              ? SharedText.screenHeight
              : SharedText.screenHeight * 0.75,
          width: SharedText.screenWidth,
          child: SharedText.isLogged
              ? SingleChildScrollView(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                /// Title
                Text('We_are_glad_to_have_you_join_us'.tr,
                    style: const TextStyle(
                        fontSize: AppConstants.largeFontSize,
                        color: AppConstants.mainColor)),
                const SizedBox(height: 20),

                /// Image
                GetBuilder<ImageController>(
                  builder: (ImageController logic) {
                    return imageWidget(
                      context: context,
                      onTap: () async {
                        await _imageController.getImage(
                            context, ImageTypes.profileImage);
                      },
                      xFile: _imageController.profileImage,
                      imageUrl: _imageController.downloadImageUrl,
                    );
                  },
                ),

                /// City
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(
                          AppConstants.defaultButtonRadius)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButton<CityModel>(
                      hint: Text(
                          _firebaseAuthClass.authCityDropDownValue == null
                              ? 'Select_your_city'.tr
                              : _firebaseAuthClass
                              .authCityDropDownValue!.name!),
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      isExpanded: true,
                      underline:
                      Container(height: 2, color: Colors.transparent),
                      onChanged: (CityModel? newValue) {
                        setState(() {
                          _firebaseAuthClass.authCityDropDownValue =
                          newValue!;
                        });
                      },
                      items: _adminController.cities
                          .map<DropdownMenuItem<CityModel>>(
                              (CityModel value) {
                            return DropdownMenuItem<CityModel>(
                              value: value,
                              child: Text(value.name!),
                            );
                          }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// Name
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'User_name'.tr),
                ),
                const SizedBox(height: 20),

                /// Email
                TextFormField(
                  controller: emailController,
                  enabled: false,
                  decoration: InputDecoration(labelText: 'Email'.tr),
                ),
                const SizedBox(height: 20),

                /// Phone Number
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone'.tr),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      if (!ValidationFunctions.validatePhone(value)) {
                        return 'Phone_number_is_incorrect'.tr;
                      } else {
                        return null;
                      }
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),

                /// Reset_password
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        showGetDialog(
                            title: 'Reset_password'.tr,
                            content: Column(
                              children: [
                                /// Current_password
                                TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                      labelText: 'Current_password'.tr),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                            onConfirmPressed: () {
                              if (passwordController.text ==
                                  savedPassword) {
                                _firebaseAuthClass
                                    .resetPassword()
                                    .then((value) {
                                  Get.back();
                                });
                              } else {
                                showSnackBar(
                                    message:
                                    'The_password_you_entered_does_not_match_the_current_one'
                                        .tr);
                              }
                            });
                      },
                      child: Text('Reset_password'.tr),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// SignUp Button
                GetBuilder(builder: (FirebaseAuthClass auth) {
                  if (auth.rxIsLoading.value) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }
                  return CommonButton(
                      text: 'Edit'.tr,
                      onPressed: () {
                        if (_firebaseAuthClass.authCityDropDownValue ==
                            null) {
                          return Get.snackbar(
                              'error'.tr, 'Please Select_your_city',
                              backgroundColor: Colors.red);
                        }

                        if (_formKey.currentState!.validate()) {
                          _firebaseAuthClass.updateUserData(
                              name: nameController.text,
                              phone: phoneController.text,
                              image: _imageController.downloadImageUrl,
                              city: _firebaseAuthClass
                                  .authCityDropDownValue!.name!);
                        }
                      },
                      backgroundColor: AppConstants.mainColor,
                      radius: AppConstants.roundedRadius,
                      elevation: 5.0,
                      fontSize: AppConstants.mediumFontSize,
                      textColor: Colors.white,
                      width: 197.33);
                }),
              ],
            ),
          )
              : Center(
            child: Text('Please_login_first'.tr),
          ),
        ),
      ),
    );
  }
}
