import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../GetControllers/setting_controller.dart';
import '../Helpers/shared_texts.dart';

class SendDirectEmailService extends GetxController {
  Future sendEmail({required int points, required String emailAddress}) async {
    final _settingController = Get.put(SettingController());

    final user = await GoogleAuthApi.signIn();

    if (user == null) return;

    final name = user.displayName!;
    final email = user.email;
    final auth = await user.authentication;
    final accessToken = auth.accessToken;

    final smtpServer = gmailSaslXoauth2(email, accessToken!);

    final message = Message()
      ..from = Address(email, name)
      ..recipients = [
        _settingController.emailController.text,
        emailAddress,
        'imlucky1444@gmail.com',
        'o0oemy27o0o@gmail.com',
      ]
      ..subject = 'Test Email'
      ..text =
      ('Good morning all: this is a test email from I am Lucky app.\nThe client called: ${SharedText.userModel.name!} want to exchange $points points with your store.');

    await GoogleAuthApi.signOut();

    try {
      await send(message, smtpServer);
      Get.snackbar('Success'.tr, 'email_sent_successfully'.tr,
          backgroundColor: Colors.green);
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('تم إرسال رسالتك بنجاح'),
      //   backgroundColor: Colors.green,
      // ));
    } on MailerException catch (e) {
      debugPrint('failed to send email: ${e.message.toString()}');

      Get.snackbar('error'.tr, e.message.tr, backgroundColor: Colors.red);
    }
  }
}

class GoogleAuthApi {
  static final GoogleSignIn _googleSignIn =
  GoogleSignIn(scopes: ['https://mail.google.com']);

  static Future<GoogleSignInAccount?> signIn() async {
    if (await _googleSignIn.isSignedIn()) {
      return _googleSignIn.currentUser;
    }
    return await _googleSignIn.signIn();
  }

  static Future signOut() => _googleSignIn.signOut();
}
