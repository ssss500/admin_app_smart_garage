import 'package:admin_app/add_new_garage_controller.dart';
import 'package:admin_app/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNewGarageView extends StatelessWidget {
  AddNewGarageController addNewGarageController =
      Get.put(AddNewGarageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add new garage'),
        centerTitle: true,
      ),
      body: GetBuilder<AddNewGarageController>(
        init: AddNewGarageController(),
        builder: (c) => Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  hint: 'title',
                  onChanged: (text) {
                    addNewGarageController.title = text;
                  },
                ),
                CustomTextField(
                  hint: 'title server',
                  onChanged: (text) {
                    addNewGarageController.serverTitle = text;
                  },
                ),
                CustomTextField(
                  hint: 'cost',
                  onChanged: (text) {
                    addNewGarageController.cost = text;
                  },
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: addNewGarageController.image == null
                      ? Container(
                          height: 120,
                          width: 120,
                          color: Colors.black12,
                          child: MaterialButton(
                              onPressed: () {
                                addNewGarageController.getImage();
                              },
                              child: const Text('add image')),
                        )
                      : Image.file(
                          c.image,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                ),
               const SizedBox(
                  height: 30,
                ),
                MaterialButton(
                    onPressed: () async {
                      await addNewGarageController.getLocation();
                      print(addNewGarageController.position!.latitude);
                      print(addNewGarageController.position!.longitude);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      height: 50,
                      width: 250,
                      child: const Center(child: Text('Get Location')),
                    )),
                const SizedBox(
                  height: 20,
                ),
                addNewGarageController.position==null?Container():Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Expanded(child: Text("longitude : ${addNewGarageController.position!.longitude.toString()}")),
                    const SizedBox(width: 20,),
                  Expanded(child: Text("latitude : ${addNewGarageController.position!.latitude.toString()}")),
                ],),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                    onPressed: () {
                      addNewGarageController.saveMarkers();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      height: 50,
                      width: 250,
                      child: const Center(child: Text('save')),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
