import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/enums.dart';
import 'package:iamluckydemo/GetControllers/admin_controller.dart';
import 'package:iamluckydemo/Helpers/functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ImageController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final AdminController adminController = Get.put(AdminController());

  String downloadImageUrl = '';
  Rx<XFile>? pickedImageRxFile;
  Rx<XFile>? firstAchieveImage;
  Rx<XFile>? secondAchieveImage;
  Rx<XFile>? thirdAchieveImage;
  Rx<XFile>? categoryImage;
  Rx<XFile>? achievementVideo;
  Rx<XFile>? storeImage;
  Rx<XFile>? challengeImage;
  Rx<XFile>? profileImage;

  Future<String> getImage(BuildContext context, ImageTypes imageTypes,
      {bool isVideo = false}) async {
    XFile? pickedFile;

    if (isVideo) {
      pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    } else {
      pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      /// Check file size
      if (convertFileSizeToMB(pickedFile) > 2) {
        showGetDialog(
          title: 'error'.tr,
          content: Text('file_size_is_too_big.'.tr),
          onConfirmPressed: () => Get.back(),
        );
      } else {
        pickedImageRxFile = Rx<XFile>(pickedFile);
        update();

        switch (imageTypes) {
          case ImageTypes.firstTaskImage:
            {
              firstAchieveImage = pickedImageRxFile;
            }
            break;
          case ImageTypes.secondTaskImage:
            {
              secondAchieveImage = pickedImageRxFile;
            }
            break;
          case ImageTypes.thirdTaskImage:
            {
              thirdAchieveImage = pickedImageRxFile;
            }
            break;
          case ImageTypes.categoryImage:
            {
              categoryImage = pickedImageRxFile;
            }
            break;
          case ImageTypes.achievementVideo:
            {
              achievementVideo = pickedImageRxFile;
            }
            break;
          case ImageTypes.storeImage:
            {
              storeImage = pickedImageRxFile;
            }
            break;
          case ImageTypes.challengeImage:
            {
              challengeImage = pickedImageRxFile;
            }
            break;
          case ImageTypes.profileImage:
            {
              profileImage = pickedImageRxFile;
            }
            break;

          default:
            {}

            break;
        }

        await uploadFileWithProgressIndicator(context, pickedImageRxFile!)
            .then((value) {
          adminController.addAchievementVideo(url: value);
        });
      }
    }
    return downloadImageUrl;
  }

  Future<String> uploadFileWithProgressIndicator(
      BuildContext context, Rx<XFile> image,
      {bool isVideo = false}) async {
    Reference reference;

    String fileName = image.value.path.split('/').last;

    if (isVideo) {
      reference =
          FirebaseStorage.instance.ref('+00_VIDEOS/admin').child(fileName);
    } else {
      reference = FirebaseStorage.instance.ref(fileName);
    }

    UploadTask uploading = reference.putFile(
        File(image.value.path),
        SettableMetadata(customMetadata: {
          'uploaded_by': 'A bad guy',
          'description': 'Some description...'
        }));

    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          double bytesTransferred(TaskSnapshot snapshot) {
            double res = snapshot.bytesTransferred / 1024.0;
            double res2 = snapshot.totalBytes / 1024.0;
            debugPrint('${((res / res2) * 100).roundToDouble().toString()} %');
            return ((res / res2) * 100).roundToDouble();
          }

          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  // key: _keyLoader,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: StreamBuilder(
                          stream: uploading.snapshotEvents,
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              final TaskSnapshot snap = uploading.snapshot;

                              return openUploadDialog(
                                context: context,
                                percent: bytesTransferred(snap) / 100,
                                title: 'sending'.tr,
                                subtitle:
                                "${((((snap.bytesTransferred / 1024) / 1000) * 100).roundToDouble()) / 100}/${((((snap.totalBytes / 1024) / 1000) * 100).roundToDouble()) / 100} " +
                                    "MB".tr,
                              );
                            } else {
                              return openUploadDialog(
                                context: context,
                                percent: 0.0,
                                title: 'sending'.tr,
                                subtitle: '',
                              );
                            }
                          }),
                    ),
                  ]));
        });

    TaskSnapshot downloadTask = await uploading;
    downloadImageUrl = await downloadTask.ref.getDownloadURL();

    Navigator.of(context, rootNavigator: true).pop();
    return downloadImageUrl;
  }

  openUploadDialog(
      {required BuildContext context,
        double? percent,
        required String title,
        required String subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircularPercentIndicator(
          radius: 55.0,
          lineWidth: 4.0,
          percent: percent ?? 0.0,
          center: Text(
            percent == null ? '0%' : "${(percent * 100).roundToDouble()}%",
            style: const TextStyle(fontSize: 11),
          ),
          progressColor: Colors.green[400],
        ),
        Container(
          width: 195,
          padding: const EdgeInsets.only(left: 3),
          child: ListTile(
            dense: false,
            title: Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  height: 1.3, fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Text(
              subtitle,
              textAlign: TextAlign.left,
              style: const TextStyle(height: 2.2, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
