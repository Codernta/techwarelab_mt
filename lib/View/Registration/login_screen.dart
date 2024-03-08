

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:techware_lab_mt/Utils/Utilities/utils.dart';
import 'package:techware_lab_mt/View/HomeScreen/home_screen.dart';
import 'package:techware_lab_mt/View/Registration/signup_screen.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginBody()
    );
  }

  loginBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          lottie(),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: loginPageTitleStyle,
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: loginPageTitleStyle
            ),
          ),
          SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              if(emailController.text.isNotEmpty && passwordController.text.length >= 6){
                login();
              } else if (emailController.text.isEmpty){
                Get.snackbar('Error', 'Enter your email');
              }else {
                Get.snackbar('Error', 'Password must be greater than 5 letters');
              }
            },
            style:ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              padding: EdgeInsets.symmetric(horizontal: 100.0,vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              ),
            ),
            child: loading ? CircularProgressIndicator(color: Colors.white,): Text('Login',style: cardNameStyle,),
          ),
          SizedBox(height: 16.0),
          TextButton(
            onPressed: () => Get.to(SignUpScreen()),
            child: Text('Not logged in? Sign up',style: notSignedInStyle,),
          ),
        ],
      ),
    );
  }

  lottie() {
    return Padding(padding: EdgeInsets.all(20),child:  Lottie.asset('assets/lotties/lottie_login.json'), );
  }

  Future<void> login ()async {
    setState(() {
      loading = true;
    });
    try{
      final auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) => Get.to(()=>Homescreen()));
    }  catch (e){
      Get.snackbar('Info', e.toString());
    }
    setState(() {
      loading = false;
    });
  }


}