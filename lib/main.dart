import 'package:flutter/material.dart';
import 'drawer/drawer_home.dart';
import 'drawer/pages/Home_Page.dart';
import 'drawer/pages/profile.dart';
import 'landingPage/landingPage.dart';
import 'splash_screen.dart';
import 'ui/signin.dart';
import 'ui/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/constants.dart';

void main() {
  runApp(MaterialApp(
    title: "Home Services",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.white,
    ),
    routes: <String, WidgetBuilder>{
      SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
      SIGN_IN: (BuildContext context) => SignInPage(),
      SIGN_UP: (BuildContext context) => SignUpScreen(),
//      Mainpage: (BuildContext context) => MainPage(),
      Landing_Page: (BuildContext context) => landingPage(),
      "/profilepage": (context) => Profile(),
      "/homePage": (context) => HomeMap(),
      "/drawerHome": (context) => DrawerHome(),
    },
    initialRoute: SPLASH_SCREEN,
  ));
}

//class MainPage extends StatefulWidget {
//  @override
//  _MainPageState createState() => _MainPageState();
//}
//
//class _MainPageState extends State<MainPage> {
//  SharedPreferences sharedPreferences;
//
//  @override
//  void initState() {
//    super.initState();
//    checkLoginStatus();
//  }
//
//  checkLoginStatus() async {
//    sharedPreferences = await SharedPreferences.getInstance();
//    if (sharedPreferences.getString("message") == null) {
//      Navigator.of(context).pushAndRemoveUntil(
//          MaterialPageRoute(builder: (BuildContext context) => SplashScreen()),
//          (Route<dynamic> route) => false);
//    } else {
//      Navigator.of(context).pushAndRemoveUntil(
//          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
//          (Route<dynamic> route) => false);
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold();
//  }
//}

