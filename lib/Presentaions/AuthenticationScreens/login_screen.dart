import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/app_constants.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Helpers/validations.dart';
import 'package:iamluckydemo/Presentaions/AuthenticationScreens/register_screen.dart';
import 'package:iamluckydemo/Services/firebase_auth.dart';
import 'package:iamluckydemo/Widgets/common_button.dart';
import 'package:iamluckydemo/Widgets/common_snackbar_widget.dart';
import 'package:iamluckydemo/Widgets/social_button.dart';

import '../../Helpers/Responsive_UI/shared.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _firebaseAuthClass = Get.put(FirebaseAuthClass());
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firebaseAuthClass.updateIsLoading(false);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: SharedText.screenHeight,
          width: SharedText.screenWidth,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: FutureBuilder(
                initialData: FirebaseAuthClass,
                builder: (context, snapshot) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!SharedText.isLogged) ...[
                        const SizedBox(height: 30),
                        Row(
                          children: [
                           // getSpaceWidth(20),
                            Expanded(
                              child: InkWell(
                                  onTap: () => Get.back(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),

                                      child: Text('Back'.tr,
                                          textAlign: SharedText.currentLocale == 'ar'?TextAlign.end:TextAlign.start,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: AppConstants.mediumFontSize,
                                            fontWeight: FontWeight.w400,
                                          )),

                                  )),
                            ),
                          ],
                        )
                      ],

                      /// Logo
                      Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.fill,
                        height: 145,
                        width: SharedText.screenWidth,
                      ),
                      const SizedBox(height: 20),

                      /// Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Text(
                          'Welcome_back'.tr,
                          style: const TextStyle(
                              color: AppConstants.mainColor,
                              fontSize: AppConstants.xLargeFontSize,
                              fontWeight: FontWeight.w400),
                        ),
                      ),

                      /// Email TextField
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 33),
                        child: TextFormField(
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
                      ),
                      const SizedBox(height: 20),

                      /// Password TextField
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 33),
                        child: GetBuilder(builder: (FirebaseAuthClass auth) {
                          return TextFormField(
                            controller: passwordController,
                            obscureText:
                            _firebaseAuthClass.isShowPassword.value,
                            decoration: InputDecoration(
                                labelText: 'Password'.tr,
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      _firebaseAuthClass.showPassword(
                                          _firebaseAuthClass
                                              .isShowPassword.value);
                                    },
                                    icon: Icon(
                                      _firebaseAuthClass.isShowPassword.value
                                          ? Icons.remove_red_eye_outlined
                                          : Icons.remove_red_eye,
                                      color: _firebaseAuthClass
                                          .isShowPassword.value
                                          ? Colors.green
                                          : Colors.red,
                                      size: 20,
                                    ))),
                          );
                        }),
                      ),
                      const SizedBox(height: 26),

                      /// Forget_password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: InkWell(
                              onTap: () {
                                showGetDialog(
                                    title: 'Enter_your_email'.tr,
                                    content: TextField(
                                      controller: Get.put(FirebaseAuthClass())
                                          .resetPasswordController,
                                      decoration: InputDecoration(
                                          hintText: 'Enter_your_email'.tr),
                                    ),
                                    onConfirmPressed: () {
                                      _firebaseAuthClass.resetPassword();
                                    });
                              },
                              child: Text(
                                'Forget_password'.tr,
                                style: const TextStyle(
                                  color: AppConstants.mainColor,
                                  fontSize: AppConstants.mediumFontSize,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 46),

                      /// Login
                      GetBuilder(
                        builder: (FirebaseAuthClass auth) {
                          if (auth.rxIsLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 36),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// Login
                                Expanded(
                                    child: CommonButton(
                                      text: 'Login'.tr,
                                      onPressed: () {
                                        if (emailController.text.trim().isEmpty ||
                                            passwordController.text
                                                .trim()
                                                .isEmpty) {
                                          showSnackBar(
                                              message:
                                              'Enter_your_email_and_password'
                                                  .tr);
                                          return;
                                        }

                                        if (_formKey.currentState!.validate()) {
                                          _firebaseAuthClass.signIn(
                                              email: emailController.text,
                                              password: passwordController.text,
                                              currentScreen: 'login_screen');
                                        }
                                      },
                                      borderColor: AppConstants.mainColor,
                                      radius: AppConstants.roundedRadius,
                                      elevation: 5.0,
                                      fontSize: AppConstants.mediumFontSize,
                                      textColor: AppConstants.mainColor,
                                    )),
                                const SizedBox(width: 5),

                                /// Register
                                Expanded(
                                  child: CommonButton(
                                    text: 'Register'.tr,
                                    onPressed: () =>
                                        Get.to(const RegisterScreen()),
                                    backgroundColor: AppConstants.mainColor,
                                    radius: AppConstants.roundedRadius,
                                    elevation: 5.0,
                                    fontSize: AppConstants.mediumFontSize,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 18),

                      /// Google Login Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 39),
                        child: Row(
                          children: [
                            Expanded(
                              child: SocialButton(
                                onPressed: () {
                                  _firebaseAuthClass.signInWithGoogle(
                                      context: context);
                                },
                                text: 'Connect_with_Google'.tr,
                                image: 'assets/images/google.png',
                                textColor: AppConstants.mainColor,
                                bgColor: Colors.white,
                                elevation: 5.0,
                                radius: AppConstants.roundedRadius,
                                height: 48,
                                imageWidth: SharedText.screenWidth,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}

void showGetDialog({
  required String title,
  required Widget content,
  required Function() onConfirmPressed,
}) {
  Get.defaultDialog(
      title: title,
      content: content,
      confirm: TextButton(
        onPressed: onConfirmPressed,
        child: Text('OK'.tr,
            style: const TextStyle(color: AppConstants.mainColor)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text('Cancel'.tr, style: const TextStyle(color: Colors.red)),
      ),
      radius: AppConstants.defaultButtonRadius);
}
