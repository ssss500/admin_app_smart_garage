import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List listData = [];
  late int indexOfListMarker;
  TextEditingController costController = TextEditingController();

  @override
  onInit() {
    getDataFromFirebase();
    super.onInit();
  }

  getDataFromFirebase() async {
    await FirebaseDatabase.instance.ref('markers').get().then((value) {
      listData = value.value as List;
      update();
    });
  }
  editCostGarage() async {
    listData[indexOfListMarker]['cost'] =
        costController.text;

    await FirebaseDatabase.instance
        .ref('markers')
        .set(listData);
    Get.back();
    update();
  }
}
