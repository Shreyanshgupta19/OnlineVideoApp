import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:online_video_app/otpverification.dart';
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
import 'package:online_video_app/Utils/utils.dart';
import 'package:online_video_app/login.dart';
import 'package:online_video_app/Utils.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class entermobilenumber extends StatefulWidget {
  const entermobilenumber({super.key});

  @override
  State<entermobilenumber> createState() => _entermobilenumberState();
}

class _entermobilenumberState extends State<entermobilenumber> {

  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final numbercontroller = TextEditingController();

  String countryCode = '';

  @override
  void dispose (){

    numbercontroller.dispose();
    super.dispose();
  }


  bool _isLoading = false;
 // var phone = "";
  // void _handleClick (){
  //   setState(() {
  //     _isLoading = true;
  //     Future.delayed(Duration(seconds: 2),
  //         (){
  //       setState(() {
  //         _isLoading = false;
  //         Navigator.push(context, MaterialPageRoute(builder: (context){return otpverification();}));
  //       });
  //         }
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/otpverificationbackground.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Lottie.asset("assets/animations/mobilenumberanimation.json"),
                ),
                Container(
                  height: 300,
                  width: 340,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(width: 2,color: Colors.white,),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20,bottom: 4,left: 0,right: 0),
                        child: Container(
                          width: 260,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [


                                IntlPhoneField(
                                  controller: numbercontroller,

                                  // onChanged: (value){
                                  //   phone = value;
                                  // },

                                  // validator: (value){
                                  //   if(value!.isEmpty){  // ! is called null check
                                  //     return "please enter mobile number";
                                  //   }if(value.length < 10 ){
                                  //     return "Please enter valid mobile number";
                                  //   }
                                  //   if(value.length>=11){
                                  //     return "Please enter 10 digit mobile number";
                                  //   }
                                  //   else{
                                  //     return null;
                                  //   }
                                  // },

                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      errorStyle: TextStyle(color: Colors.blue),
                                      hintText: "Enter your mobile number",
                                      hintStyle: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w400,),
                                      suffixIcon: Icon(Icons.call_sharp,color: Colors.black,),
                                      helperText: "  123456789  ",
                                      helperStyle: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w400,)
                                  ),
                                  onChanged: (phone) {
                                    countryCode = phone.countryCode;
                                  },
                                  initialCountryCode: 'IN',

                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 18,bottom: 0,left: 0,right: 0),
                                  child: Text("We will send you a one time sms message.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25,bottom: 0,left: 0,right: 0),
                        child: SizedBox(
                          height: 60,
                          width: 320,
                          child: ElevatedButton(
                          onPressed: _isLoading ?null
                              : (){
                            if( _formKey.currentState!.validate() ){
                              String phoneNumber = numbercontroller.text;
                              String fullPhoneNumber = '+$countryCode$phoneNumber';
                              // If the form is valid, you can proceed with your logic here
                              setState(() {
                                _isLoading = true;
                              });
                              _auth.verifyPhoneNumber(
                                  phoneNumber: fullPhoneNumber,
                                  verificationCompleted: (PhoneAuthCredential credential){

                                  },
                                  verificationFailed: (FirebaseAuthException e){
                                    print('Verification failed: ${e.message}');
                                   // Utils().toastMessage( e.toString() );
                                  },
                                  codeSent: ( String verificationId  , int? token)async{
                                    Navigator.push(context, MaterialPageRoute(builder: (context){return otpverification(verificationId: verificationId,phoneNumber: fullPhoneNumber,);}));


                                  },
                                  codeAutoRetrievalTimeout: (String verificationId){
                                    Utils().toastMessage(verificationId);
                                    // Utils().toastMessage( e.toString() );
                                  }
                              );
                              //     .then((value) {
                              //   setState(() {
                              //     _isLoading = false;
                              //     Navigator.push(context, MaterialPageRoute(builder: (context){return MyHomePage(title: 'Chat Room');;}));
                              //
                              //   });
                              // }).onError((error, stackTrace) {
                              //   Utils().toastMessage( error.toString() );
                              //   setState(() {
                              //     _isLoading = false;
                              //   });
                              //
                              // });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),

                            ),
                          ),
                          child: _isLoading? CircularProgressIndicator()
                              : Text("Submit"),
                        ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}