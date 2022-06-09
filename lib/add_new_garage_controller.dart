import 'dart:io';

import 'package:admin_app/home_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class AddNewGarageController extends GetxController {
  ///get image
  var image, title, serverTitle, cost;
  Position? position;
  var pickedFile, uploadTask, imageUrl = '';

  @override
  onInit() {
    // getLocation();
    super.onInit();
  }

  void getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      image = File(result.files.single.path.toString());
      print("image  : " + image.toString());
    } else {}
    update();
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    position = await Geolocator.getCurrentPosition();
    update();
  }

  Future<void> saveMarkers() async {
    HomeController homeController = Get.put(HomeController());

    Reference reference = FirebaseStorage.instance
        .ref()
        .child("title" + DateTime.now().toString());
    uploadTask = reference.putFile(image);

    await uploadTask.whenComplete(() async {
      try {
        print("complete");
        imageUrl = await reference.getDownloadURL();
      } catch (e) {
        print(e);
      }
    });
    final data = {
      "cost": cost,
      "imageUrl": imageUrl,
      "latitude": position!.latitude,
      "longitude": position!.longitude,
      "serveTitle": serverTitle,
      "title": title,
    };
    List l = [data];

    l.addAll(homeController.listData);

    homeController.listData = l;

    await FirebaseDatabase.instance.ref('markers').set(homeController.listData);
  }
}
