
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:techware_lab_mt/Utils/Utilities/utils.dart';
import 'package:techware_lab_mt/View/PinScreen/lock_pin_screen.dart';
import 'package:techware_lab_mt/View/Registration/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPasswordController = TextEditingController();

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
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: loginPageTitleStyle,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: loginPageTitleStyle
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _reEnterPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: loginPageTitleStyle,
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                 if(_reEnterPasswordController.text != _passwordController.text){
                   Get.snackbar('Error', 'Password mismatch!');
                 }else if( _emailController.text.isNotEmpty && _passwordController.text.length >= 6 && _passwordController.text == _reEnterPasswordController.text){
                   signUp();
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
    setState((){
      loading = true;
    });
    try {
      final auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text).then((value) => Get.to(()=>AddPinScreen()));
    }catch(e) {
        Get.snackbar('Info', e.toString());
    }
  setState(() {
      loading = false;
    });
  }
}