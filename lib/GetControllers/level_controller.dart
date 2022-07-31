import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:iamluckydemo/Constants/keys.dart';
import 'package:iamluckydemo/Helpers/shared_texts.dart';
import 'package:iamluckydemo/Models/level_model.dart';

class LevelController extends GetxController {
  RxBool isLoading = false.obs;
  List<LevelModel> levels = [];

  Stream<QuerySnapshot> loadLevels() {
    var result = FirebaseFirestore.instance
        .collection(Keys.levelsCollection)
        .snapshots();

    result.forEach((element) {
      levels.clear();
      for (var i in element.docs) {
        LevelModel model = LevelModel()
          ..id = i.id
          ..from = (i['from'])
          ..to = (i['int']);

        levels.add(model);
      }
    });

    return result;
  }

  updateUserLevel(int level) async {
    await FirebaseFirestore.instance
        .collection(Keys.usersCollection)
        .doc(SharedText.userModel.email!)
        .set({"level": level});
  }
}
