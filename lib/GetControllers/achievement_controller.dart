import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/keys.dart';
import 'package:iamluckydemo/Models/achievement_model.dart';

class AchievementController extends GetxController {
  RxInt totalAchievements = 0.obs;
  List<AchievementModel> achievements = [];

  Stream<QuerySnapshot> loadAchievements() {
    var result = FirebaseFirestore.instance
        .collection(Keys.achievementsCollection)
        .snapshots();

    result.forEach((element) {
      achievements.clear();
      totalAchievements = 0.obs;
      totalAchievements = RxInt(element.docs.length);
      for (var i in element.docs) {
        AchievementModel model = AchievementModel()
          ..id = i.id
          ..downloadUrl = i['downloadUrl']
          ..uploadedBy = i['uploaded_by']
          ..description = i['description'];

        achievements.add(model);
      }
    });

    return result;
  }
}
