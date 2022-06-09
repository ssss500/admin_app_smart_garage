import 'package:admin_app/add_new_garage_view.dart';
import 'package:admin_app/custom_text_field.dart';
import 'package:admin_app/home_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddNewGarageView());
          },
        child: Icon(Icons.add),
        ),

      body: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (c) => ListView.builder(
            shrinkWrap: true,
            itemCount: c.listData.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  c.indexOfListMarker = index;
                  openCostDialog(
                      onPressed: () async {
                        c.editCostGarage();
                      },
                      cost: c.listData[index]['cost'].toString());
                },
                child: Container(
                  height: 120,
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width - 50,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          c.listData[index]['imageUrl'],
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.listData[index]['title'],
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'cost by hour : ${c.listData[index]['cost'].toString()}',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),


    );
  }

  openCostDialog({onPressed, cost}) {
    HomeController homeController = Get.put(HomeController());

    homeController.costController.text = cost.toString();
    return showDialog(
        context: Get.context!,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Note !'),
            content: SizedBox(
              height: 127,
              child: Column(
                children: [
                  const Text(
                    'Set New Cost',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  CustomTextField(
                    title: 'cost',
                    controller: homeController.costController,
                    maxLength: 4,
                  )
                ],
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                child: const Text(
                  'cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              MaterialButton(
                child: const Text(
                  'update Cost',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () => onPressed(),
              ),
            ],
          );
        });
  }
}
