import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_home_service_customer/drawer/pages/aboutuspage.dart';
import 'package:fyp_home_service_customer/drawer/pages/any_suggestion.dart';
import 'package:fyp_home_service_customer/drawer/pages/notifications.dart';
import 'package:fyp_home_service_customer/drawer/pages/term_and_condition.dart';
import 'package:fyp_home_service_customer/model/login_data.dart';
import 'package:fyp_home_service_customer/ui/signin.dart';


import 'package:shared_preferences/shared_preferences.dart';

class DrawerHome extends StatefulWidget {
  @override
  _DrawerHomeState createState() => _DrawerHomeState();
}

class _DrawerHomeState extends State<DrawerHome> {
  Map data={};
  //LoginInfo _info = LoginInfo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print("##############"+UserData().info.toString());
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    //print(data.toString());
//    print('***********************'+data.toString());

//    data.isNotEmpty ? data :
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            color: Colors.lightBlueAccent,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 120,
                    margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image:  NetworkImage('http://192.168.43.238/FYP_API/uploads/'+LoginInfo().profileImage),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  Text(data['name'], style: TextStyle(fontSize: 22, color: Colors.white),),
                  Text(data['email'], style: TextStyle(color: Colors.white),)
                ],
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.notifications, color: Colors.lightBlueAccent,),
            title: Text('Notifications', style: TextStyle(fontSize: 18.0, color: Colors.lightBlueAccent),),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Notifications()));
            },
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle, color: Colors.lightBlueAccent,),
            title: Text('About Us', style: TextStyle(fontSize: 18.0,color: Colors.lightBlueAccent,),),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AboutUsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.lightBlueAccent,),
            title: Text('Profile', style: TextStyle(fontSize: 18.0,color: Colors.lightBlueAccent,),),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/profilepage', arguments: {
                'id': data['id'],
                'name': data['name'],
                'email': data['email'],
                'phone': data['phone'],
                'password': data['password'],
                'profileImage': data['profileImage']
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.email, color: Colors.lightBlueAccent),
            title: Text('Any Suggestion', style: TextStyle(fontSize: 18.0, color: Colors.lightBlueAccent),),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AnySuggestionsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.chat_bubble_outline, color: Colors.lightBlueAccent),
            title: Text('Terms & Conditions', style: TextStyle(fontSize: 18.0, color: Colors.lightBlueAccent),),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TermsAndCondition()));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.lightBlueAccent),
            title: Text('Log out', style: TextStyle(fontSize: 18.0, color: Colors.lightBlueAccent),),
            onTap: (){
//              SharedPreferences sharedPreferences;
//              sharedPreferences.clear();
//              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => SignInScreen()), (Route<dynamic> route) => false);

            },
          ),
        ],
      ),
    );
  }


}