import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../Helpers/Responsive_UI/shared.dart';

Widget commonCachedImageWidget({
  required BuildContext context,
  required String imageUrl,
  double? height,
  double? width,
  double radius = 10.0,
  BoxFit fit = BoxFit.contain,
}) {
  double imageHeight = getWidgetHeight(height ?? 108);
  double imageWidth = getWidgetWidth(width ?? 108);

  return CachedNetworkImage(
    imageUrl: imageUrl,
    imageBuilder: (context, imageProvider) => Container(
      height: imageHeight,
      width: imageWidth,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        image: DecorationImage(
          image: imageProvider,
          fit: fit,
        ),
      ),
    ),
    placeholder: (context, img) => Container(
      height: imageHeight,
      width: imageWidth,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        image: DecorationImage(
          image: const AssetImage("assets/images/loading.gif"),
          fit: fit,
        ),
      ),
    ),
    errorWidget: (context, url, error) => Image.asset(
      'assets/images/profile.png',
      fit: BoxFit.fill,
      height: imageHeight,
      width: imageHeight,
    ),
  );
}
