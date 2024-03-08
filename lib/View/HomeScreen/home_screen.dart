import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:techware_lab_mt/Utils/utils.dart';
import 'package:techware_lab_mt/View/AddNewItem/add_item_screen.dart';
import 'package:techware_lab_mt/View/ListItems/items_list.dart';
import 'package:techware_lab_mt/View/Registration/login_screen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawers(),
      appBar: appBar(),
      body: homeScreenBody(),
    );
  }

  appBar() {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(8),
            transform: Matrix4.translationValues(16, 0, 0),
            child: InkWell(
              onTap: () =>  _scaffoldKey.currentState!.openDrawer(),
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade900,
                radius: 16,
                child: Icon(Icons.person,color: Colors.white,),
              ),
            ),
          );
        }
      ),
      actions: [
        InkWell(
          onDoubleTap: ()=>FirebaseAuth.instance.signOut().then((value) => Get.to(LoginForm())),
            onTap: () => Get.snackbar('Info', 'Double tap to logout'), child: Icon(Iconsax.logout,color: Colors.blue.shade900,size: 30,)),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  homeScreenBody() {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SizedBox(
          height: size.height * 0.78,
          width: size.width,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              hiText(),
              lottie(),
              widthBox(),
              ButtonCard(iconName: Icons.add,cardName: 'Add Item',onPress: ()=> Get.to(()=> AddNewItemScreen()),),
              widthBox(),
              ButtonCard(iconName: Icons.list,cardName: 'List Items',onPress: ()=> Get.to(()=> ItemsList()),),
            ],
          )
        ),
      )
    );
  }


widthBox(){
    return SizedBox(
      height: 30,
    );
}

  hiText() {
    return Padding(
      padding: const EdgeInsets.only(top: 30,bottom: 20),
      child: Text('Hi,',style: primaryStyle,),
    );
  }

  drawers() {
    return Drawer(
      child: DrawerHeader(

        child: Text(FirebaseAuth.instance.currentUser!.email.toString(),style: loginPageTitleStyle,),
      ),
    );
  }

  lottie() {
    return Lottie.asset('assets/lotties/welcome_back.json');
  }
}

class ButtonCard extends StatefulWidget {

  final IconData iconName;
  final String cardName;
  final VoidCallback onPress;

  ButtonCard({required this.cardName, required this.iconName, required this.onPress});
  @override
  State<ButtonCard> createState() => _ButtonCardState();
}

class _ButtonCardState extends State<ButtonCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: widget.onPress,
      child: Container(
        width: size.width * 0.9, // 90% of the screen width
        height: size
            .height * 0.2, // 15% of the screen height
        decoration: BoxDecoration(
          color: Colors.blue.shade900, // Set your desired background color
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.iconName, // Replace with your desired icon
                color: Colors.white, // Set your desired icon color
              ),
              SizedBox(width: 8.0), // Add some space between icon and text
              Text(
                widget.cardName, // Replace with your desired text
                style: cardNameStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
