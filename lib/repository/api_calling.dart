import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyp_home_service_customer/constants/constants.dart';
import 'package:fyp_home_service_customer/model/login_data.dart';
import 'package:fyp_home_service_customer/ui/signin.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
class APICalling{
  static List loginData;

  saveData(String name, String email, String phone, String password, File profileImage, BuildContext context) async{

    var request = http.MultipartRequest("POST", Uri.parse(Constants.baseUrl+"saveCustomerRecord"));
    var pic = await http.MultipartFile.fromPath("profileImage", profileImage.path);
    request.files.add(pic);
    request.fields["name"] = name;
    request.fields["email"] = email;
    request.fields["phone"] = phone;
    request.fields["password"] = password;
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("Image"+responseString);
    Map myData = json.decode(responseString);
    if(myData['message'] == "Account Created..."){
      Toast.show(myData["message"], context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(),
          ));
    }
    else{
      Toast.show(myData["error"], context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
    }
  }
   signIn(String email, String password, BuildContext context) async {
//    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'password': password
    };
    Map jsonResponse;
    var response = await http.post(Constants.baseUrl+"customerLogin", body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      // setState(() {
      //         loginData = jsonResponse['data'];
      //       });
      //loginData = jsonResponse['data'];
      if(jsonResponse['message']=='login success') {
//        setState(() {
// //          _isLoading = false;
//        });

//        sharedPreferences.setString("message", jsonResponse['message']);
        int id = loginData[0]['id'];
        String name = loginData[0]['name'];
        String email = loginData[0]['email'];
        String phone = loginData[0]['phone'];
        String password = loginData[0]['password'];
        String image = loginData[0]['profileImage'];

        Toast.show(jsonResponse["message"], context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

//        Toast.show(id.toString()+" "+name+" "+email+" "+phone+" "+password, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

        LoginInfo info = new LoginInfo();
        info.setId = id.toString();
        info.setName = name;
        info.setEmail = email;
        info.setPhone = phone;
        info.setPassword = password;
        info.setProfileImage = image;
        Navigator.pushReplacementNamed(context, '/homePage', arguments: {
          'id': id.toString(),
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'profileImage': info.profileImage
        });

      }
    }
    else {
//      setState(() {
////        _isLoading = false;
//      });
      print(response.body);
    }
  }
}