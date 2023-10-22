import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:online_video_app/entermobilenumber.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_video_app/login.dart';
import 'package:online_video_app/Utils.dart';
import 'package:get/utils.dart';

import 'Utils/Utils.dart';

class enteremailandpassword extends StatefulWidget {
  const enteremailandpassword({super.key});

  @override
  State<enteremailandpassword> createState() => _enteremailandpasswordState();
}

class _enteremailandpasswordState extends State<enteremailandpassword> {


  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  final _formKey = GlobalKey<FormState>();


  bool _obscureText1 = true;

  void _passwordVisibility1(){
    setState(() {
      _obscureText1 =! _obscureText1;
    });
  }



  bool _isLoading0 = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/signupbackground.jpeg'),
              fit: BoxFit.cover
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 50,bottom: 10,left: 0,right: 0),
                    child: Container(
                      height: 65,
                      width: 250,
                      child: Lottie.asset("assets/animations/welcomeanimation.json"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0,bottom: 50,left: 0,right: 0),
                    child: Container(
                      height: 300,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(width: 2,color: Colors.white30),
                      ),
                      child: Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(left: 0,right:0 ,bottom:0 ,top:25 ),
                            child: Container(
                              width: 280,
                              child: TextFormField(
                                controller: emailController,
                                validator: (value){
                                  if(value!.isEmpty){  // ! is called null check
                                    return "please enter email";
                                  }
                                  else if(!value.contains('@gmail.com')){
                                    return "Please enter a valid email address (e.g., example@gmail.com)";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.blue,),
                                  suffixIcon: IconButton(
                                    onPressed: (){

                                    },
                                    icon: Icon(CupertinoIcons.mail,color: Colors.black,),),
                                  hintText: "Enter your email ",
                                  hintStyle: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w400),
                                  helperText: "   e.g., example@gmail.com",
                                  helperStyle: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 0,right:0 ,bottom:0 ,top:5 ),
                            child: Container(
                              width: 280,
                              child: TextFormField(
                                controller: passwordController,
                                validator: (value){
                                  if(value!.isEmpty){  // ! is called null check
                                    return "Please enter password";
                                   }

                                  if (value.length < 8) {
                                    return "Password is too short"; // Password is too short
                                  }

                                  // Check for at least one uppercase letter
                                  if (!value.contains(RegExp(r'[A-Z]'))) {
                                    return "Please enter at least one uppercase letter"; // Password lacks an uppercase letter
                                  }

                                  // Check for at least one lowercase letter
                                  if (!value.contains(RegExp(r'[a-z]'))) {
                                    return "Please enter at least one lowercase letter"; // Password lacks a lowercase letter
                                  }

                                  // Check for at least one digit
                                  if (!value.contains(RegExp(r'[0-9]'))) {
                                    return "Please enter at least one digit"; // Password lacks a digit
                                  }

                                  // Check for at least one special character (e.g., @, #, $, etc.)
                                  if (!value.contains(RegExp(r'[!@#\$%^&*()_+{}[\]:;<>,.?~]'))) {
                                    return "Please enter at least one special character (e.g., @, #, \$, etc.)"; // Password lacks a special character
                                  }

                                  return null; // Password meets all criteria
                                  // else{
                                  //   return null;
                                  // }
                                },
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.blue,),
                                    suffixIcon: IconButton(
                                      onPressed: _passwordVisibility1,
                                      icon: Icon(_obscureText1?CupertinoIcons.eye:CupertinoIcons.eye_slash,color: Colors.blue,),),
                                    hintText: "Enter your password",
                                    hintStyle: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w400,),
                                    helperText: "  Your password should be at least 8 characters ( e.g., Sunshine2023! )",
                                    helperStyle: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,)
                                ),
                                obscureText: _obscureText1,
                                obscuringCharacter: "*",
                              ),
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(left: 0,right:0 ,bottom:0 ,top:25 ),
                            child: SizedBox(
                              height: 60,
                              width: 320,
                              child: ElevatedButton(
                                onPressed: _isLoading0 ?null
                                    : (){
                                  if( _formKey.currentState!.validate() ){
                                    // If the form is valid, you can proceed with your logic here
                                    setState(() {
                                      _isLoading0 = true;
                                    });
                                    _auth.createUserWithEmailAndPassword(
                                      email: emailController.text.toString(),
                                      password: passwordController.text.toString(),
                                    ).then((value) {
                                      setState(() {
                                        _isLoading0 = false;
                                        Navigator.push(context, MaterialPageRoute(builder: (context){return login();}));
                                      });
                                    }).onError((error, stackTrace) {
                                      Utils().toastMessage( error.toString() );
                                      setState(() {
                                        _isLoading0 = false;
                                      });

                                    });
                                  }
                                },
                                child: _isLoading0 ?CircularProgressIndicator()
                                    : Text("Sign Up"),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    )
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
