import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_home_service_customer/constants/constants.dart';
import "package:http/http.dart" as http;

class AnySuggestionsPage extends StatefulWidget {

  @override
  _AnySuggestionsPageState createState() => _AnySuggestionsPageState();
}

class _AnySuggestionsPageState extends State<AnySuggestionsPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  var _formkeyComent = GlobalKey<FormState>();

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Feedback"),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Form(
            key: _formkeyComent,
            child: ListView(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                    child: Text(
                      "Feedback",
                      style: TextStyle(
                          fontSize: 33.0,
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    child: Text(
                      "Components and services repositories are important to meet cost-effectiveness and productivity goals in Software Reuse. These repositories need to provide diversified mechanisms to help services and components management and development processes.If you have any issue or give suggestion about our service then you are able to send us your suggestions and issue report.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0,),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                        errorStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 15.0,
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
                SizedBox(height: 16,),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        errorStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 15.0,
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
                SizedBox(height: 16,),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: TextFormField(
                      maxLines: 4,
                      controller: commentController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Comment',
                        errorStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 15.0,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "comment is required";
                        }
                        return null;
                      }),
                ),
                SizedBox(height: 16,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    child: RaisedButton(
                      color: Colors.lightBlueAccent,
                      child: Text(
                        "Send feedback",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                      onPressed: (){
                        postComents(nameController.text, emailController.text, commentController.text);
                      },
                    ),
                  ),
                ),
              ],
            ))
    );
  }

  postComents(String name, String email, String comment) async{

    Map userData = {
      "name": name,
      "email":email,
      "comment": comment
    };

    var response = await http.post(Constants.baseUrl+"feedback", body: userData);
    if(response.statusCode == 200){
      Map isSave = json.decode(response.body);
      String result="";
      setState(() {
        result = isSave['message'];
        if(result == "success"){
//          Toast.show("Feedback sent", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
          showToast("Feedback sent");
          Navigator.of(context).pop();
        }
      });

    }

  }
}