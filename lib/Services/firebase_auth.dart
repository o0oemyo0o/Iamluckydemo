import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Constants/keys.dart';
import '../Constants/shared_preferences.dart';
import '../Helpers/shared_texts.dart';
import '../Models/city_model.dart';
import '../Models/user_model.dart';
import '../Presentaions/AdminScreens/admin_home_page.dart';
import '../Presentaions/AuthenticationScreens/login_screen.dart';
import '../Presentaions/NavigatorScreens/bmb_home_page.dart';
import '../Presentaions/SplashScreens/splash_screen_home_page.dart';
import '../Widgets/common_snackbar_widget.dart';

class FirebaseAuthClass extends GetxController {
  UserCredential? userCredential;
  bool hasError = false;
  String errorMessage = '';
  RxBool checkBoxValue = false.obs;
  RxInt currentPoints = 0.obs;
  RxBool rxIsLoading = false.obs;
  RxBool isShowPassword = true.obs;
  RxBool isShowConfirmPassword = true.obs;

  CityModel? authCityDropDownValue;

  TextEditingController resetPasswordController = TextEditingController();

  /// Social Init
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  void showPassword(bool value) {
    isShowPassword = RxBool(!value);
    update();
  }

  void showConfirmPassword(bool value) {
    isShowConfirmPassword = RxBool(!value);
    update();
  }

  void changeCheckBoxValue() {
    checkBoxValue.value = !checkBoxValue.value;
    update();
  }

  void updateIsLoading(bool value) {
    rxIsLoading.value = value;
    update();
  }

  /// Login
  Future<bool> signIn(
      {required String email,
      required String password,
      required String currentScreen}) async {
    try {
      hasError = false;
      debugPrint('currentScreen: $currentScreen');

      updateIsLoading(true);

      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (userCredential == null) {
        hasError = true;

        updateIsLoading(false);

        errorMessage = 'something went error';
        showSnackBar(message: errorMessage);

        debugPrint('go to LoginPage');
        Get.off(const LoginScreen());
        return false;
      } else {
        DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
            .instance
            .collection(Keys.usersCollection)
            .doc(email)
            .get();

        if (data['isActive'] == false) {
          Get.snackbar('Error', 'this_account_isnot_active',
              backgroundColor: Colors.red);

          if (currentScreen == 'splash_screen') {
            Get.offAll(() => const LoginScreen());
          }

          updateIsLoading(false);
          return false;
        }

        SharedText.userModel = UserModel(
          role: data['role'],
          userID: data['userID'],
          email: userCredential!.user!.email!,
          name: data['name'],
          phone: data['phone'],
          image: data['image'],
          city: data['city'],
          provider: data['provider'],
          level: data['level'],
          point: data['points'],
          lastVideoWatchedTimeStamp: data['lastVideoWatchedTimeStamp'],
          watchedVideosCount: data['watchedVideosCount'],
          watchingVideosAvailableCount: data['watchingVideosAvailableCount'],
          isActive: data['isActive'],
        );

        currentPoints = RxInt(data['points']);
        update();

        await DefaultSharedPreferences.setIsLogged(true);
        await DefaultSharedPreferences.setEmail(email);
        await DefaultSharedPreferences.setPassword(password);
        await DefaultSharedPreferences.setLoginProvider('Email');
        debugPrint('SharedText.userModel.role: ${SharedText.userModel.role}');

        if (SharedText.userModel.role == 0) {
          debugPrint('go to HomePage as an admin');
          Get.off(() => const AdminHomePage());
        } else if (SharedText.userModel.role == 1) {
          debugPrint('go to BNB as a user');
          Get.off(() => const BMBHomePage());
        }

        updateIsLoading(false);

        SharedText.isLogged = true;

        return true;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('sign-in error: ${e.code}');

      SharedText.isLogged = false;
      errorMessage = e.message!;
      Get.snackbar('error'.tr, errorMessage, backgroundColor: Colors.red);
      updateIsLoading(false);
      return false;
    }
  }

  /// Register
  Future<bool> signUp(
      {required String name,
      required String email,
      required String phone,
      required String city,
      required String password,
      required bool rememberMe,
      String? docID}) async {
    try {
      updateIsLoading(true);

      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user == null) {
          FirebaseFirestore.instance
              .collection(Keys.usersCollection)
              .doc(docID)
              .update({
            'users': {
              'name': name,
              'city': city,
              'email': email,
              'phone': phone,
            }
          });
        } else {
          DocumentReference ref = FirebaseFirestore.instance
              .collection(Keys.usersCollection)
              .doc(email);

          ref.set({
            'name': name,
            'email': email,
            'phone': phone,
            'city': city,
            'password': password,
            'provider': 'Email',
            'userID': value.user!.uid,
            'isActive': true,
            'points': 0,
            'role': 1,
            'level': 1,
            'lastVideoWatchedTimeStamp': 0,
            'watchedVideosCount': 0,
            'watchingVideosAvailableCount': 2,
            'image':'',
          });

          updateIsLoading(false);

          SharedText.userModel = UserModel(
            role: 1,
            userID: value.user!.uid,
            email: userCredential!.user!.email!,
            name: name,
            phone: userCredential!.user!.phoneNumber!,
            provider: 'Email',
            isActive: true,
            level: 1,
            point: 1,
            lastVideoWatchedTimeStamp: 0,
            watchedVideosCount: 0,
            watchingVideosAvailableCount: 2,
            image:'',

          );
        }

        return value;
      });

      if (userCredential!.user == null) {
        updateIsLoading(false);
        return true;
      }

      await DefaultSharedPreferences.setIsLogged(rememberMe);
      await DefaultSharedPreferences.setEmail(email);
      await DefaultSharedPreferences.setPassword(password);
      await DefaultSharedPreferences.setLoginProvider('Email');
      updateIsLoading(false);

      Get.to(const BMBHomePage());
      return false;
    } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          debugPrint('The password provided is too weak.');
          Get.snackbar('error'.tr, 'The password provided is too weak'.tr,
              backgroundColor: Colors.red);
        } else if (e.code == 'email-already-in-use') {
          debugPrint('The account already exists for that email.');
          Get.snackbar('error'.tr, 'The account already exists for that email'.tr,
              backgroundColor: Colors.red);
      }

      updateIsLoading(false);
      return true;
    }
  }

  /// Sign-Out of Email&Password Login
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    await DefaultSharedPreferences.setIsLogged(false);
    await DefaultSharedPreferences.setEmail('');
    await DefaultSharedPreferences.setPassword('');
    await DefaultSharedPreferences.setLoginProvider('');

    SharedText.userModel = UserModel();

    Get.offAll(const SplashScreenHomePage());
  }

  Future changeUserPoints(int points) async {
    await FirebaseFirestore.instance
        .collection(Keys.usersCollection)
        .doc(SharedText.userModel.email!)
        .set({"points": points}, SetOptions(merge: true));
    await getUserPoints();
  }

  Future getUserPoints() async {
    var data = await FirebaseFirestore.instance
        .collection(Keys.usersCollection)
        .doc(SharedText.userModel.email!)
        .get();

    currentPoints = RxInt(data['points']);
    update();

    debugPrint('currentPoints: $currentPoints');
  }

  /// Get Home Page User points
  Stream<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserPoints() {
    var result = FirebaseFirestore.instance
        .collection(Keys.usersCollection)
        .doc(SharedText.userModel.email!)
        .snapshots();

    result.forEach((element) {
      currentPoints = RxInt(element.data()!['points']);
      update();
      debugPrint('getCurrentUserPoints: $currentPoints');
    });

    return result;
  }

  /// Google Sign-In
  Future<User?> signInWithGoogle({required BuildContext context}) async {
    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);
        user = userCredential.user;

        if (user != null) {
          SharedText.userModel = UserModel()
            ..email = userCredential.user!.email!
            ..userID = userCredential.user!.uid
            ..name = userCredential.user!.displayName!
            ..phone = userCredential.user!.phoneNumber ?? ''
            ..provider = 'Google'
            ..city = ''
            ..role = 1
            ..level = 1
            ..point = 0
            ..watchedVideosCount = 0
            ..watchingVideosAvailableCount = 2
            ..lastVideoWatchedTimeStamp = 0
            ..isActive = true;
        } else {
          await FirebaseFirestore.instance
              .collection(Keys.usersCollection)
              .doc(userCredential.user!.email!)
              .set({
            'name': userCredential.user!.displayName!,
            'email': userCredential.user!.email!,
            'phone': userCredential.user!.phoneNumber ?? '',
            'city': '',
            'password': '',
            'provider': 'Google',
            'userID': userCredential.user!.uid,
            'isActive': true,
            'point': 0,
            'role': 1,
            'level': 1,
            'watchedVideosCount': 0,
            'watchingVideosAvailableCount': 2,
            'lastVideoWatchedTimeStamp': 0,
          }).then((value) {
            SharedText.userModel = UserModel()
              ..email = userCredential.user!.email!
              ..userID = userCredential.user!.uid
              ..name = userCredential.user!.displayName!
              ..phone = userCredential.user!.phoneNumber ?? ''
              ..provider = 'Google'
              ..city = ''
              ..role = 1
              ..level = 1
              ..point = 0
              ..watchedVideosCount = 0
              ..watchingVideosAvailableCount = 2
              ..lastVideoWatchedTimeStamp = 0
              ..isActive = true;
          });
        }

        update();

        final String data = json.encode(SharedText.userModel);

        await DefaultSharedPreferences.setUserData(data);
        await DefaultSharedPreferences.setIsLogged(true);
        await DefaultSharedPreferences.setEmail(userCredential.user!.email!);
        await DefaultSharedPreferences.setPassword('');
        await DefaultSharedPreferences.setLoginProvider('Google');
        updateIsLoading(false);

        Get.offAll(() => const BMBHomePage());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          Get.snackbar(
              'error'.tr, 'account-exists-with-different-credential.'.tr,
              backgroundColor: Colors.red);
        } else if (e.code == 'invalid-credential') {
          Get.snackbar('error'.tr,
              'Error occurred while accessing credentials. Try again.'.tr,
              backgroundColor: Colors.red);
        }
        updateIsLoading(false);
      } catch (e) {
        Get.snackbar('error'.tr, e.toString().tr, backgroundColor: Colors.red);
        updateIsLoading(false);
      }
    }

    return user;
  }

  /// Google Sign-Out
  Future<void> googleSignOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      Get.snackbar('error'.tr, 'Error signing out. Try again.'.tr,
          backgroundColor: Colors.red);
    }
  }

  /// Reset Password || Forget Password
  Future<void> resetPassword() async {
    updateIsLoading(true);
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth
          .sendPasswordResetEmail(email: 'haysamessam1477@gmail.com')
          .then((value) {
        updateIsLoading(false);

        auth.authStateChanges().listen((event) {
          if (event == null) {
            Get.snackbar('error'.tr, 'something_went_wrong.'.tr,
                backgroundColor: Colors.red);
          } else {
            Get.snackbar('Success'.tr,
                'verification_email_has_been_sent_to_your_entered_email.'.tr,
                backgroundColor: Colors.green);
          }
        });
      }).catchError((e) {
        updateIsLoading(false);
        showSnackBar(message: e.toString());
        Get.snackbar('error'.tr, e.tr, backgroundColor: Colors.red);
      });
    } catch (e) {
      debugPrint('error: ${e.toString()}');
    }
  }

  Future<bool> updateUserData(
      {required String name,
        required String phone,
        required String image,
        required String city}) async {
    try {
      updateIsLoading(true);

      await FirebaseFirestore.instance
          .collection(Keys.usersCollection)
          .doc(SharedText.userModel.email!)
          .update({
        'name': name,
        'phone': phone,
        'image': image,
        'city': city,
      });

      await getUserDataWithNavigation().then((value) => Get.back());

      updateIsLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Add_Task exception: ${e.code}');
      Get.snackbar('error'.tr, e.message!.tr, backgroundColor: Colors.red);
      updateIsLoading(false);

      return false;
    }
  }

  Future<bool> getUserDataWithNavigation() async {
    try {
      String? email = await DefaultSharedPreferences.getEmail();

      if (email == null) {
        Get.offAll(() => const BMBHomePage());
        return false;
      }

      var result = await FirebaseFirestore.instance
          .collection(Keys.usersCollection)
          .doc(email)
          .get();

      SharedText.userModel = UserModel()
        ..userID = result.id
        ..email = result.data()!['email'] ?? ''
        ..image = result.data()!['image'] ?? ''
        ..name = result.data()!['name'] ?? ''
        ..phone = result.data()!['phone'] ?? ''
        ..provider = 'Google'
        ..city = result.data()!['city'] ?? ''
        ..role = result.data()!['role'] ?? 1
        ..level = result.data()!['level'] ?? 1
        ..point = result.data()!['point'] ?? 0
        ..lastVideoWatchedTimeStamp =
            result.data()!['lastVideoWatchedTimeStamp'] ?? 0
        ..watchedVideosCount = result.data()!['watchedVideosCount'] ?? 0
        ..watchingVideosAvailableCount =
            result.data()!['watchingVideosAvailableCount'] ?? 2
        ..role= result.data()!['role'] ?? 1
        ..isActive = result.data()!['isActive'] ?? true;

      debugPrint('SharedText.userModel: ${SharedText.userModel.toJson()}');

      Timer(const Duration(milliseconds: 2500),
              () => Get.offAll(() => const BMBHomePage()));

      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('error'.tr, e.message!.tr, backgroundColor: Colors.red);
      Get.offAll(() => const BMBHomePage());

      return false;
    }
  }

  Future<bool> getCurrentUserData() async {
    try {
      var result = await FirebaseFirestore.instance
          .collection(Keys.usersCollection)
          .doc(SharedText.userModel.email!)
          .get();

      SharedText.userModel = UserModel()
        ..userID = result.id
        ..email = result.data()!['email'] ?? ''
        ..image = result.data()!['image'] ?? ''
        ..name = result.data()!['name'] ?? ''
        ..phone = result.data()!['phone'] ?? ''
        ..provider = 'Google'
        ..city = result.data()!['city'] ?? ''
        ..role = result.data()!['role'] ?? 1
        ..level = result.data()!['level'] ?? 1
        ..point = result.data()!['point'] ?? 0
        ..lastVideoWatchedTimeStamp =
            result.data()!['lastVideoWatchedTimeStamp'] ?? 0
        ..watchedVideosCount = result.data()!['watchedVideosCount'] ?? 0
        ..watchingVideosAvailableCount =
            result.data()!['watchingVideosAvailableCount'] ?? 2
        ..role= result.data()!['role'] ?? 1
        ..isActive = result.data()!['isActive'] ?? false;

      debugPrint('SharedText.userModel: ${SharedText.userModel.toJson()}');
      update();

      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('error'.tr, e.message!.tr, backgroundColor: Colors.red);
      Get.offAll(() => const BMBHomePage());

      return false;
    }
  }
}
