
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:techware_lab_mt/Utils/Utilities/utils.dart';
import 'package:techware_lab_mt/View/HomeScreen/home_screen.dart';
import 'package:techware_lab_mt/View/ItemDetailScreen/item_detail_screen.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({super.key});

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {

  TextEditingController searchController = TextEditingController();

  final CollectionReference items =
  FirebaseFirestore.instance.collection('items');

  String searchKeyword = '';

  List _allResults = [];
  List _resultList = [];

  getItemStream() async {
    var data = await FirebaseFirestore.instance.collection('items').orderBy('name').get();

    setState(() {
      _allResults  = data.docs;
    });
    searchResultList();
  }

  @override
  void initState() {
    // TODO: implement initState
    networkCheck();
    super.initState();
  }

  searchResultList(){
    var showResult = [];
    if(searchController.text != ''){
      for (var clientSnapShot in _allResults){
        var name = clientSnapShot['name'].toString().toLowerCase();
        if(name.contains(searchController.text.toLowerCase())){
          showResult.add(clientSnapShot);
        };
      }
    }else{
      showResult = List.from(_allResults);
    }
    setState(() {
      _resultList = showResult;
    });
  }

  networkCheck() async{
    bool hasInternetConnection =
    await InternetConnectionChecker().hasConnection;
    if (hasInternetConnection) {
      setState(() {
        // getItemStream();
        searchController.addListener(_onSearchChanged);
      });
    } else {
      SnackBar(content: Text('Connect to internet!'),);
    }
  }

  _onSearchChanged(){
    searchResultList();
    print(searchController.text);
  }


  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getItemStream();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: productListBody(),
      appBar: appBar(),
    );
  }

  productListBody() {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            searchBar(),
            itemsList()
          ],
        ),
      ),
    );
  }

  searchBar() {
    return Expanded(
        flex: 1,
        child:  Container(
          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (val){
                    setState(() {
                      searchKeyword = val;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: InputBorder.none,
                    hintText: 'Enter text...',
                  ),
                ),
              ),
              Material(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.0),
                  onTap: () {
                    // QR code scanner icon functionality here
                    // You can implement the QR code scanning logic
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.qr_code,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0), //
              Material(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.blue.shade900,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.0),
                  onTap: () {
                    setState(() {
                      searchKeyword = searchController.text;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0)
            ],
          ),
        )
    );
  }
  appBar() {
    return AppBar(
      leading: IconButton(
          onPressed: ()=> Get.off(Homescreen()),
          icon: Icon(Icons.arrow_back,color: Colors.blue.shade900,)),
      centerTitle: true,backgroundColor:Colors.white ,
      title: Text('Items List',style:loginPageTitleStyle,),
      toolbarHeight: 80,
      elevation: 0,

    );
  }



  itemsList() {
    return Expanded(
      flex: 10,
      child: StreamBuilder(
          stream: items.orderBy('name').snapshots(),
          builder: (context,  AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: _resultList.length,
                  itemBuilder: (context, index) {
                    return itemCard(index,_resultList[index]['name'], _resultList[index]['measurement'], _resultList[index]['price']);
                  });
            } else if(snapshot.connectionState == ConnectionState.waiting){
              return loader();
            } else {
              return Container(
                child: Text('No Data'),
              );
            }
          })
    );
  }

  itemCard( int index, String names, String measurement, String price) {
    return InkWell(
      onTap: ()=>Get.to(()=> ProductDetails(),arguments: {"name": names, "measurement": measurement,"price":price}),
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25)
          ),
          child: Center(child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              qrImage(names),
              divider(),
              customerNameAndDetail( names,measurement,price,index),
            ],
          )),
        ),
      ),
    );
  }

  qrImage(String names) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Center(child: QrImageView(
          foregroundColor: Colors.blue.shade900,
          data: names,size: 80,)),
      ),
    );
  }

  customerNameAndDetail( String names, String measurement, String price, int index) {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            itemName(index,names),
            measurements(index,measurement),
            prices(index,price),
          ],
        ),
      ),
    );
  }

  itemName( int index,String names) {
    return Expanded(
      flex: 1,
      child: Text("Name : $names",style: notSignedInStyle),
    );
  }

  divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: VerticalDivider(
        width: 2,
        thickness: 2,
        color: Colors.grey.shade300,
      ),
    );
  }



  measurements( int index, String measurement) {
    return Expanded(
      flex: 1,
      child: Text('Measurement : $measurement' , style: notSignedInStyle,),
    );
  }


  prices( int index, String price) {
    return Expanded(
      flex: 1,
      child: Text('Price : $price' ,style: notSignedInStyle),
    );
  }

  chatAndWhatsapp() {
    return Row(
      children: [
        InkWell(onTap: (){}, child: CircleAvatar(radius: 15,child: Icon(Icons.call,color: Colors.white,size: 15,),)),
        SizedBox(width: 10,),
        InkWell(onTap: (){}, child: Image.asset('assets/images/icon_whatsapp.png',)),
      ],
    );
  }
  loader() {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
          color: Colors.blue.shade900, size: 50),
    );
  }
}

addPersonSheet(BuildContext context) {

  return FractionallySizedBox(
    heightFactor: 1.1,
    child: Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Add Customer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(labelText: 'Text Field 1'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Text Field 2'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Text Field 3'),
          ),
          SizedBox(height: 20),
          Text(
            'Address',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(labelText: 'Text Field 4'),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(labelText: 'Text Field 4'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(labelText: 'Text Field 4'),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(labelText: 'Text Field 4'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(labelText: 'Text Field 4'),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(labelText: 'Text Field 4'),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Container(
            height: 50,
            child: Center(
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blue.shade900)
                          )
                      )
                  ),
                  onPressed: (){}, child: Text('Submit',style: TextStyle(color: Colors.white),)),
            ),
          ),

        ],
      ),
    ),
  );

}
