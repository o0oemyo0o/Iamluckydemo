import 'dart:io';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../Constants/app_constants.dart';
import '../../GetControllers/tasks_controller.dart';
import '../../Widgets/common_cached_image_widget.dart';

Widget imageWidget(
    {required BuildContext context,
    required Function() onTap,
    Rx<XFile>? xFile,
    String? imageUrl}) {
  final _tasksServices = Get.put(TasksController());

  return InkWell(
    onTap: onTap,
    child: Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultButtonRadius),
      ),
      child: Container(
        height: 80,
        width: 80,
        decoration: DottedDecoration(
          shape: Shape.box,
          borderRadius: BorderRadius.circular(AppConstants.defaultButtonRadius),
        ),
        child: _tasksServices.isLoading.isTrue
            ? Obx(() => const Center(
                  child: CircularProgressIndicator(),
                ))
            : imageUrl == null || imageUrl.isEmpty
                ? Obx(
                    () => xFile.obs.value == null
                        ? const Icon(Icons.add)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(
                                AppConstants.defaultButtonRadius),
                            child: Image.file(
                              File(xFile!.value.path),
                              fit: BoxFit.fill,
                              height: 75,
                              width: 75,
                            ),
                          ),
                  )
                : ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppConstants.defaultButtonRadius),
                    child: commonCachedImageWidget(
                      context: context,
                      imageUrl: imageUrl,
                      fit: BoxFit.fill,
                      height: 75,
                      width: 75,
                    ),
                  ),
      ),
    ),
  );
}
