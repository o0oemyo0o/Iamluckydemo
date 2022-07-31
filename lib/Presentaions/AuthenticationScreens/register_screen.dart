import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/Helpers/Responsive_UI/shared.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Helpers/validations.dart';
import 'package:iamluckydemo/Models/city_model.dart';
import 'package:iamluckydemo/Services/firebase_auth.dart';
import 'package:iamluckydemo/Widgets/common_button.dart';
import 'package:iamluckydemo/Widgets/common_snackbar_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firebaseAuthClass = Get.put(FirebaseAuthClass());
  final _adminController = Get.put(AdminController());
  final _formKey = GlobalKey<FormState>();

  CityModel? dropdownValue;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signUp() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        dropdownValue == null ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      showSnackBar(message: 'Please_fill_in_all_fields'.tr);
      return;
    }
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      showSnackBar(message: 'The_passwords_dose_not_match'.tr);
      return;
    }

    _firebaseAuthClass.signUp(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      city: dropdownValue!.name!,
      password: passwordController.text.trim(),
      rememberMe: _firebaseAuthClass.rxIsLoading.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppConstants.mainColor,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('I am lucky'),
        ),
        body: SizedBox(
          height: SharedText.screenHeight,
          width: SharedText.screenWidth,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 29),
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// Title
                Text('We_are_glad_to_have_you_join_us'.tr,
                    style: const TextStyle(
                        fontSize: AppConstants.titleFontSize,
                        color: AppConstants.mainColor)),
                const SizedBox(height: 40),

                /// City
                StreamBuilder(
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      dropdownValue ??= _adminController.cities[0];
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(
                                AppConstants.defaultButtonRadius)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButton<CityModel>(
                            hint: Text(dropdownValue == null
                                ? 'Select_your_city'.tr
                                : dropdownValue!.name!),
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            isExpanded: true,
                            underline:
                                Container(height: 2, color: Colors.transparent),
                            onChanged: (CityModel? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
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
                      );
                    },
                    stream: _adminController.loadCities()),
                const SizedBox(height: 40),

                /// Name
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'User_name'.tr),
                ),
                const SizedBox(height: 40),

                /// Email
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'.tr),
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      if (!ValidationFunctions.validateEmail(value)) {
                        return 'The_email_is_incorrect'.tr;
                      } else {
                        return null;
                      }
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 40),

                /// Phone Number
                TextFormField(
                  controller: phoneController,
                  decoration:
                      InputDecoration(labelText: 'Phone'.tr, hintText: '05'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                const SizedBox(height: 40),

                /// Password
                GetBuilder(
                  builder: (FirebaseAuthClass auth) {
                    return TextFormField(
                      controller: passwordController,
                      obscureText: _firebaseAuthClass.isShowPassword.value,
                      decoration: InputDecoration(
                        labelText: 'Password'.tr,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _firebaseAuthClass.showPassword(
                                _firebaseAuthClass.isShowPassword.value);
                          },
                          icon: Icon(
                              _firebaseAuthClass.isShowPassword.value
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye,
                              color: _firebaseAuthClass.isShowPassword.value
                                  ? Colors.green
                                  : Colors.red,
                              size: 20),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                /// Confirm_password
                GetBuilder(
                  builder: (FirebaseAuthClass auth) {
                    return TextFormField(
                      controller: confirmPasswordController,
                      obscureText:
                          _firebaseAuthClass.isShowConfirmPassword.value,
                      decoration: InputDecoration(
                        labelText: 'Confirm_password'.tr,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _firebaseAuthClass.showConfirmPassword(
                                _firebaseAuthClass.isShowConfirmPassword.value);
                          },
                          icon: Icon(
                              _firebaseAuthClass.isShowConfirmPassword.value
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye,
                              color:
                                  _firebaseAuthClass.isShowConfirmPassword.value
                                      ? Colors.green
                                      : Colors.red,
                              size: 20),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                /// Remember_me
                Obx(
                  () => TextButton(
                    onPressed: () {
                      _firebaseAuthClass.changeCheckBoxValue();
                    },
                    child: Row(
                      children: [
                        Icon(
                            _firebaseAuthClass.checkBoxValue.value
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: _firebaseAuthClass.checkBoxValue.value
                                ? AppConstants.mainColor
                                : Colors.grey),
                        getSpaceWidth(10),
                        Text('Remember_me'.tr,
                            style: TextStyle(
                                color: _firebaseAuthClass.checkBoxValue.value
                                    ? AppConstants.mainColor
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: AppConstants.mediumFontSize)),
                      ],
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.zero),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                /// SignUp Button
                GetBuilder(builder: (FirebaseAuthClass auth) {
                  if (auth.rxIsLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CommonButton(
                      text: 'Sign_up'.tr,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signUp();
                        }
                      },
                      backgroundColor: AppConstants.mainColor,
                      radius: AppConstants.roundedRadius,
                      elevation: 5.0,
                      fontSize: AppConstants.largeFontSize,
                      textColor: Colors.white,
                      width: 197.33);
                }),
                const SizedBox(height: 103),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
