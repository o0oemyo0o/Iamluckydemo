import '../Models/user_model.dart';
import 'Responsive_UI/device_info.dart';

class SharedText {
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;

  static DeviceInfo? deviceType;

  static bool isLogged = false;
  static String currentLocale = 'ar';
  static String userToken = '';
  // static String userEmail = '';
  static String phoneNumber = '';

  static String appVersion = '';
  static String appName = '';
  static String packageName = '';
  static String buildNumber = '';

  /// On_Will_Pop app close time
  static DateTime? currentBackPressTime;

  /// Logged User
  static UserModel userModel = UserModel();
}
