import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techware_lab_mt/View/HomeScreen/home_screen.dart';
import 'package:techware_lab_mt/View/PinScreen/check_pin_screen.dart';
import 'package:techware_lab_mt/View/Registration/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Techwarelab MT',
      home:  StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot){
          if(snapshot.hasData && snapshot.data != null){
            return const CheckPinScreen();
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade900,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          } else{
            return LoginForm();
          }
        },
      ),
    );
  }
}

