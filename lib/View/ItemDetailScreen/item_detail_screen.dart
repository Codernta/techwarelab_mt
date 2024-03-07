import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:techware_lab_mt/Utils/Utilities/utils.dart';

class ProductDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBars(),
      body: productDetailBody()
    );
  }

  productDetailBody() {
    Map data = (Get.arguments) as Map<String, dynamic>;
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 250.0,
              height: 250.0,
              child: QrImageView(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade900,
                data: data['name'], // Replace with actual QR code data
                version: QrVersions.auto,
              ),
            ),
          ),
          SizedBox(height: 50.0),
          Text(
            'Name : '+ data['name'],
            style: loginPageTitleStyle,
          ),
          SizedBox(height: 10.0),
          Text(
              "Measurement : " + data['measurement'],
              style: loginPageTitleStyle
          ),
          SizedBox(height: 10.0),
          Text(
            'Price : '+ data['price'] , // Replace with actual price
            style: loginPageTitleStyle,
          ),
          SizedBox(height: 20.0),

        ],
      ),
    );
  }

  appBars() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back,color: Colors.blue.shade900,),
        onPressed: ()=>Get.back(),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text('Product details',style: loginPageTitleStyle,),
      toolbarHeight: 90,
    );
  }
}
