


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:techware_lab_mt/Utils/Utilities/utils.dart';
import 'package:techware_lab_mt/View/HomeScreen/home_screen.dart';

class CheckPinScreen extends StatefulWidget {
  const CheckPinScreen({super.key});

  @override
  State<CheckPinScreen> createState() => _CheckPinScreenState();
}

class _CheckPinScreenState extends State<CheckPinScreen> {

  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  String pins = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultPin();
  }

  defaultPin() async{
    var uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid.toString()).get().then((value){
      pins = value.get('pin').toString();
      print('**************************print pins****************');
      print(pins);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBars(),
      body: pinBody(),
    );
  }

  pinBody() {
    final size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            lottie(),
            pin(),
            sizedBox(),
          ],
        ),
      ),
    );
  }

  pin() {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
    return Directionality(
      // Specify direction if desired
      textDirection: TextDirection.ltr,
      child: Pinput(
        controller: pinController,
        focusNode: focusNode,
        androidSmsAutofillMethod:
        AndroidSmsAutofillMethod.smsUserConsentApi,
        listenForMultipleSmsOnAndroid: true,
        defaultPinTheme: defaultPinTheme,
        separatorBuilder: (index) => const SizedBox(width: 8),
        validator: (value) {
           return value == pins ? null : 'Pin is incorrect';
        },
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        onCompleted: (pin) {
         setState(() {
           if(pins == pin){
             Get.to(()=> Homescreen());
           }else{
             Get.snackbar('Info', 'Pin Incorrrect');
           }
         });
        },
        onChanged: (value) {
        },
        cursor: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 9),
              width: 22,
              height: 1,
              color: focusedBorderColor,
            ),
          ],
        ),
        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: focusedBorderColor),
          ),
        ),
        submittedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            color: fillColor,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: focusedBorderColor),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyBorderWith(
          border: Border.all(color: Colors.redAccent),
        ),
      ),
    );
  }

  lottie() {
    return Padding(padding: EdgeInsets.all(20),
      child: Lottie.asset('assets/lotties/pin_lock.json'),);
  }

  appBars() {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text('Enter 4 digit pin', style: loginPageTitleStyle,),
      leading: null,
    );
  }






  sizedBox() {
    return SizedBox(height: 50,);
  }
}
