
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techware_lab_mt/Utils/Utilities/utils.dart';
import 'package:techware_lab_mt/View/ListItems/items_list.dart';


class AddNewItemScreen extends StatefulWidget {
  const AddNewItemScreen({super.key});

  @override
  State<AddNewItemScreen> createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> {
  final CollectionReference items =
  FirebaseFirestore.instance.collection('items');

  TextEditingController nameController = TextEditingController();
  TextEditingController measurementController = TextEditingController();
  TextEditingController priceController = TextEditingController();



  addItem() {
    final data = {'name': nameController.text, 'measurement': measurementController.text, 'price': priceController.text};
    items.add(data).then((value) => Get.to(ItemsList()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon:  Icon(
              Icons.arrow_back,
              color: Colors.blue.shade900,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Add New Item',
            style: notSignedInStyle),
          ),
        body: itemAddBody(),
      ),
    );
  }

  itemAddBody() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.5,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          textFields(),
          const SizedBox(
            height: 50,
          ),
          addButton()
        ],
      ),
    );
  }

  textFields() {
    return Expanded(
      flex: 3,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration:  InputDecoration(
                  labelText: 'Name',
                    labelStyle: loginPageTitleStyle
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: measurementController,
                decoration:  InputDecoration(
                  labelText: 'Measurement',
                    labelStyle: loginPageTitleStyle
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: priceController,
                decoration:  InputDecoration(
                  labelText: 'Price',
                    labelStyle: loginPageTitleStyle
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addButton() {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {
          if(nameController.text.isEmpty){
            Get.snackbar('Info', 'Enter name');
          } else if(measurementController.text.isEmpty){
            Get.snackbar('Info', 'Enter Measurement');
          } else if(priceController.text.isEmpty){
            Get.snackbar('Info', 'Enter Price');
          }else{
            addItem();
          }
          },
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade900, width: 1),
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.shade900),
            child: Center(
              child: Text(
                'Add Item',
                style:cardNameStyle,
              ),
            )),
      ),
    );
  }
}
