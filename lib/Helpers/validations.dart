import 'package:flutter/cupertino.dart';

class ValidationFunctions {
  static final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static final RegExp myRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9]");

  static final RegExp phoneRegExp = RegExp(r'((([0]{2}|[+])966)|0)5\d{8}');

  /// Email Validation
  static bool validateEmail(String email) {
    if (email.isEmpty) {
      return false;
    } else if (!emailRegExp.hasMatch(email)) {
      return false;
    } else if (!email.startsWith(myRegExp, 0)) {
      return false;
    } else {
      return true;
    }
  }

  /// Phone Validation
  static bool validatePhone(String phone) {
    if (phone.isEmpty) {
      return false;
    }
    if (phone.length < 11) {
      debugPrint('phone is less than 11');
      return false;
    }
    if (!phoneRegExp.hasMatch(phone)) {
      debugPrint('phone has not match');
      return false;
    }
    return true;
  }
}
