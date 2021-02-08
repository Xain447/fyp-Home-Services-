import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_home_service_customer/repository/api_calling.dart';
import 'signin.dart';
import 'package:image_picker/image_picker.dart';
import "package:http/http.dart" as http;
import 'package:toast/toast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var _formkey = GlobalKey<FormState>();
  bool checkBoxValue = false;
  double _height;

  File _image;
  var proImage = null;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      proImage = image;


    });

  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Center(child: Text("WELCOME",style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Colors.white),)),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.lightBlueAccent,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Stack( children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 130.0,
                              height: 130.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100.0),
                                border: Border.all(color: Colors.grey ,width: 2)
                              ),
                              child:  _image != null
                                  ? ClipOval(
                                  child: Image.file(_image, height: 100,
                                      width: 100,
                                      fit: BoxFit.cover)
                              )
                                  : ClipOval(
                                  child: Image.asset('assets/images/logoo.png', height: 100,
                                      width: 100,
                                      fit: BoxFit.cover)
                              )

                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 80.0, right: 90.0),
                          child: FlatButton(
                            onPressed: (){
                              getImage();

                            },
                            child: Center(
                              child: Icon(
                                Icons.camera_alt,
                              ),
                            ),
                          )),
                    ]),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.white
                ),
                child: TextFormField(
                  
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'User Name',
                      labelStyle: TextStyle(color:Colors.black),
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 5.0,),
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,

                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          // width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "username is required";
                      }
                      return null;
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.white
                ),
                child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color:Colors.black),
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 5.0,),
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,

                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          // width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "email is required";
                      }
                      return null;
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white
                ),
                child: TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color:Colors.black),
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 5.0,),
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,

                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          // width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "phoneNo is required";
                      }
                      return null;
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white
                ),
                child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color:Colors.black),
                        errorStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 5.0,),
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,

                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          // width: 2.0,
                        ),
                      ),
                    ),

                    keyboardType: TextInputType.text,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "password is required";
                      }
                      return null;
                    }),
              ),
            ),
            acceptTermsTextRow(),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(70.0, 0.0, 70.0, 0.0),
              child: SizedBox(
                height: 40,
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      if (_formkey.currentState.validate()) {
                        APICalling().saveData(nameController.text, emailController.text, phoneController.text, passwordController.text, proImage, context);
                      }
                    });
                  },
                  child: Text(
                    'SignUp',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  textColor: Colors.black,
                  color: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            signInTextRow(),
            SizedBox(height: 20.0),
          ],
        ),
      )
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Checkbox(
                activeColor: Colors.lightBlueAccent[200],
                value: checkBoxValue,
                onChanged: (bool newValue) {
                  setState(() {
                    checkBoxValue = newValue;
                  });
                }),
            Text(
              "I accept all terms and conditions.",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 15,
                fontStyle: FontStyle.italic
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  ));
              print("Routing to SignIn screen");
            },
            child: Text(
              "SignIn",
              style: TextStyle(
//                fontFamily: Constants.OPEN_SANS,
                fontWeight: FontWeight.w800,
                color: Colors.deepPurple,
                fontSize: 14,
                fontStyle: FontStyle.italic
              ),
            ),
          )
        ],
      ),
    );
  }
}
