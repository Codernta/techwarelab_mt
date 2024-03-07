


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:techware_lab_mt/Utils/Utilities/utils.dart';
import 'package:techware_lab_mt/View/Registration/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController reEnterPasswordController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              lottie(),
              SizedBox(height: 16.0),
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
              SizedBox(height: 16.0),
              TextField(
                controller: reEnterPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: loginPageTitleStyle,
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                 if(reEnterPasswordController.text != passwordController.text){
                   Get.snackbar('Error', 'Password mismatch!');
                 }else if( emailController.text.isNotEmpty && passwordController.text.length >= 6 && passwordController.text == reEnterPasswordController.text){
                   signUp().then((value) {
                     Get.snackbar('Success!!', "Account created successfully.");
                     Get.to(LoginForm());
                   });
                 }
                },
                style:ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  padding: EdgeInsets.symmetric(horizontal: 100.0,vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
                child: loading? CircularProgressIndicator(color: Colors.white,): Text('Sign Up',style: cardNameStyle,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  lottie() {
    return Padding(padding: EdgeInsets.all(20),child:  Lottie.asset('assets/lotties/lottie_signup.json'), );
  }

  appbar() {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back,color: Colors.blue.shade900,size: 40,),
        onPressed: ()=> Get.back(),
      ),
    );
  }

  Future<void> signUp() async{
    final auth = FirebaseAuth.instance;
    setState((){
      loading = true;
    });
try{
  auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
} on FirebaseAuthException catch (e){
  Get.snackbar('Info', e.code);
}   setState(() {
      loading = false;
    });
  }
}