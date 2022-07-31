import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

const kEmptyColor = 0XFFF2F2F2;

/// check if the environment is web
const bool kIsWeb = identical(0, 0.0);

class Tools {
  /// check tablet screen
  static bool isTablet(MediaQueryData query) {
    if (kIsWeb) {
      return true;
    }

    if (Platform.isWindows || Platform.isMacOS) {
      return false;
    }

    var size = query.size;
    var diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));

    var isTablet = diagonal > 1090.0;
    return isTablet;
  }

  static String formatImage(String url, [kSize size = kSize.medium]) {
    return url;
  }
}

enum kSize { small, medium, large }
