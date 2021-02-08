import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_home_service_customer/constants/constants.dart';
import 'package:fyp_home_service_customer/model/login_data.dart';
import 'package:fyp_home_service_customer/model/user_data.dart';
import 'package:fyp_home_service_customer/ui/signup.dart';
import 'package:fyp_home_service_customer/ui/widgets/textformfield.dart';

import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'widgets/custom_shape.dart';
import 'widgets/responsive_ui.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  List loginData;
  double percentage = 0.0;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      child: ListView(
        scrollDirection:Axis.vertical,
        children: [
          Container(
            height: _height,
            width: _width,
            padding: EdgeInsets.only(bottom: 5),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  clipShape(),
                  welcomeTextRow(),
                  signInTextRow(),
                  form(),
                  forgetPassTextRow(),
                  SizedBox(height: _height / 12),
                  button(),
                  signUpTextRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.white10],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
              fontFamily: Constants.POPPINS,
              fontWeight: FontWeight.w800,
              fontSize: 37.5,
              color: Colors.lightBlueAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Sign in to your account",
            style: TextStyle(
              fontFamily: Constants.OPEN_SANS,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: Colors.lightBlueAccent,
              fontSize: 15.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height / 40.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: passwordController,
      icon: Icons.lock,
      obscureText: true,
      hint: "Password",
    );
  }

  Widget forgetPassTextRow() {
    return GestureDetector(
        onTap: () {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Recover Password')));
        },
        child: Container(
          margin: EdgeInsets.only(top: _height / 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Forgot your password?",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: _large ? 14 : (_medium ? 12 : 10)),
              ),
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Recover Password')));
                },
                child: Text(
                  "Recover",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.lightBlueAccent[200]),
                ),
              )
            ],
          ),
        ));
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      onPressed: () {
//        print("Routing to your account");
        setState(() {
          if (_formkey.currentState.validate()) {
         signIn(emailController.text, passwordController.text);
          }
        });
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.cyan, Colors.lightBlueAccent],
          ),
        ),
        padding: const EdgeInsets.all(14.0),
        child: Text('SIGN IN',
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top:  40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 16 : (_medium ? 14 : 12)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(),
                  ));
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.lightBlueAccent[200],
                  fontSize: _large ? 19 : (_medium ? 17 : 15)),
            ),
          )
        ],
      ),
    );
  }

  signIn(String email, String password) async {
//    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'password': password
    };
    Map jsonResponse;
    var response = await http.post(Constants.baseUrl+"customerLogin", body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      setState(() {
              loginData = jsonResponse['data'];
            });
      //loginData = jsonResponse['data'];
      if(jsonResponse['message']=='login success') {
//        setState(() {
// //          _isLoading = false;
//        });

//        sharedPreferences.setString("message", jsonResponse['message']);
        int id = loginData[0]['customer_id'];
        String name = loginData[0]['customer_name'];
        String email = loginData[0]['customer_email'];
        String phone = loginData[0]['customer_phone'];
        String password = loginData[0]['customer_password'];
        String image = loginData[0]['customer_image'];

        Toast.show(jsonResponse["message"], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

//        Toast.show(id.toString()+" "+name+" "+email+" "+phone+" "+password, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);


        LoginInfo info = new LoginInfo();
        info.setId = id.toString();
        info.setName = name;
        info.setEmail = email;
        info.setPhone = phone;
        info.setPassword = password;
        info.setProfileImage = image;


        print("email.....#########################"+loginData[0]['customer_email']);
        UserData.id = id.toString();

        // UserData.name = name;
        // UserData.email = email;
        // UserData.phone = phone;
        // UserData.password = password;
        // UserData.profileImage = image;
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeMap()));
        Navigator.pushReplacementNamed(context, '/homePage', arguments: {
          'id': id.toString(),
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'profileImage': info.profileImage
        }
       );

      }
      print("LOGIN DATA:::::::::::"+loginData.toString());
    }
    else {
//      setState(() {
////        _isLoading = false;
//      });
      print(response.body);
    }
  }


}
