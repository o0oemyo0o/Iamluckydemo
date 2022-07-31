import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoinsController extends GetxController {
  RxString selectedValue = "USA".obs;

  List<DropdownMenuItem<RxString>> get dropdownItems {
    List<DropdownMenuItem<RxString>> menuItems = [
      DropdownMenuItem(child: const Text("USA"), value: "USA".obs),
      DropdownMenuItem(child: const Text("Canada"), value: "Canada".obs),
      DropdownMenuItem(child: const Text("Brazil"), value: "Brazil".obs),
      DropdownMenuItem(child: const Text("England"), value: "England".obs),
    ];
    return menuItems;
  }

  onChanged(RxString value) {
    selectedValue = value;
    update();
  }
}
