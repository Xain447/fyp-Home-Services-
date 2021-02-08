import 'package:flutter/material.dart';


class AboutUsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.lightBlueAccent,
        title: Text("About Us"),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: ListView(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage('assets/images/logoo.png'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Home Services Center",
                        style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600]),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 30,
                        thickness: 0.5,
                        color: Colors.blue.withOpacity(1),
                        indent: 32,
                        endIndent: 32,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Flexible(
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
                          style: TextStyle(color: Colors.blue[600]),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 30,
                        thickness: 0.5,
                        color: Colors.blue.withOpacity(1),
                        indent: 32,
                        endIndent: 32,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.email, size: 25.0, color: Colors.lightBlueAccent),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            "kzain3714@gmail.com",
                            style: TextStyle(fontSize: 16.0, color: Colors.blue[600]),
                          )
                        ],
                      ),

                      Divider(
                        height: 40,
                        thickness: 0.5,
                        color: Colors.blue.withOpacity(0.4),
                        indent: 32,
                        endIndent: 32,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.phone, size: 25.0, color: Colors.lightBlueAccent),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            "054678843982932",
                            style: TextStyle(fontSize: 16.0, color: Colors.blue[600]),
                          )
                        ],
                      ),

                      Divider(
                        height: 40,
                        thickness: 0.5,
                        color: Colors.blue.withOpacity(0.4),
                        indent: 22,
                        endIndent: 42,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.location_on, size: 25.0, color: Colors.lightBlueAccent),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            "Pakistan",
                            style: TextStyle(fontSize: 16.0, color: Colors.blue[600]),
                          )
                        ],
                      ),

                    ],
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}
