import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_home_service_customer/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'delayed_animation.dart';

class landingPage extends StatefulWidget {
  @override
  _landingPageState createState() => _landingPageState();
}

class _landingPageState extends State<landingPage> with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.2,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    _scale = 1 - _controller.value;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.lightBlueAccent,
          body: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Center(
                child: Column(
                  children: <Widget>[
                    AvatarGlow(
                      endRadius: 140,
                      duration: Duration(seconds: 2),
                      glowColor: Colors.white,
                      repeat: true,
                      repeatPauseDuration: Duration(seconds: 1),
                      startDelay: Duration(seconds: 1),
                      child: Material(
                          elevation: 12.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            backgroundImage: ExactAssetImage('assets/images/logoo.png'),
                            // minRadius: 30,
                            // maxRadius: 70,
                            radius: 60.0,
                          )),
                    ),
                    DelayedAnimation(
                      child: Text(
                        "Hi There",
                        style: TextStyle(
                            fontFamily: Constants.POPPINS,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            fontSize: 35.5,
                            color: Colors.white
                        ),
                      ),
                      delay: delayedAmount + 1000,
                    ),

                    SizedBox(
                      height: 30.0,
                    ),
                    DelayedAnimation(
                      child: Text(
                        "Your New Personal",
                        style: TextStyle(
                          fontFamily: Constants.OPEN_SANS,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontSize: 21.5,
                        ),
                      ),
                      delay: delayedAmount + 3000,
                    ),
                    DelayedAnimation(
                      child: Text(
                        "Home Services App",
                        style: TextStyle(
                          fontFamily: Constants.OPEN_SANS,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontSize: 21.5,
                        ),
                      ),
                      delay: delayedAmount + 3000,
                    ),
                    SizedBox(
                      height: 100.0,
                    ),
                    DelayedAnimation(
                      child: GestureDetector(
                        onTapDown: _onTapDown,
                        onTapUp: _onTapUp,
                        child: Transform.scale(
                          scale: _scale,
                          child: _animatedButtonUI,
                        ),
                      ),
                      delay: delayedAmount + 4000,
                    ),
                    SizedBox(
                      height: 80.0,
                    ),
                    DelayedAnimation(
                      child: FlatButton(
                        onPressed: (){
//                      showToast("Sign In");
                          Navigator.of(context).pushReplacementNamed(SIGN_IN);
                        },
                        color: Colors.lightBlueAccent,
                        child: Text(
                          "I Already have An Account".toUpperCase(),
                          style: TextStyle(
                              fontSize: 13.0,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              color: color),
                        ),
                      ),
                      delay: delayedAmount + 5000,
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget get _animatedButtonUI => Container(
    height: 60,
    width: 270,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.0),
      color: Colors.white,
    ),
    child: Center(
      child: FlatButton(
        onPressed: () {
//          showToast("Sign Up");
          Navigator.of(context).pushReplacementNamed(SIGN_UP);
        },
        color: Colors.white,
        child: Text(
          'Sign up or Register',
          style: TextStyle(
            fontSize: 20.0,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlueAccent,
          ),
        ),
      ),
    ),
  );

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

//  void showToast(message) {
//    Fluttertoast.showToast(
//        msg: message,
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.BOTTOM,
//        timeInSecForIos: 1,
//        backgroundColor: Colors.red,
//        textColor: Colors.white,
//        fontSize: 16.0);
//  }
}
