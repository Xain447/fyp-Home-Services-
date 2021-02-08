import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<String> _products = [
    'Electrical Serives needed',
    'Plumber Serives needed',
    'Mechanic Serives needed',
    'Painting Serives needed',
    'Electrical Serives needed',
    'Plumber Serives needed',
    'Mechanic Serives needed',
    'Painting Serives needed',
    'Electrical Serives needed',
    'Plumber Serives needed',
    'Mechanic Serives needed',
    'Painting Serives needed',
  ];
  List<String> _description = [
    'i need plumber service.here is a problem in our toilet',
    'i need plumber service.here is a problem in our toilet',
    'i need plumber service.here is a problem in our toilet',
    'i need plumber service.here is a problem in our toilet',
    'i need plumber service.here is a problem in our toilet',
    'i need plumber service.here is a problem in our toilet',
    'i need plumber service.here is a problem in our toilet',
    'i need plumber service.here is a problem in our toilet',
    'i need plumber service.here is a problem in our toilet',
    'i need plumber service.here is a problem in our toilet',
    'i need plumber service.here is a problem in our toilet',
    'i need plumber service.here is a problem in our toilet',
  ];
//  final  List<IconData> icons = [
//    Icons.home,
//    Icons.drafts,
//    Icons.backspace,
//
//  ];

  final  List<String> icons = [
    "assets/images/logoo.png",
    "assets/images/slide_2.png",
    "assets/images/slide_1.png",
    "assets/images/logoo.png",
    "assets/images/slide_3.png",
    "assets/images/slide_4.png",
    "assets/images/logoo.png",
    "assets/images/slide_2.png",
    "assets/images/slide_1.png",
    "assets/images/logoo.png",
    "assets/images/slide_2.png",
    "assets/images/slide_1.png",

  ];

//  Widget _buildProductItem(BuildContext context, int index) {
//    return Card(
//      child: Column(
//        children: <Widget>[
////          Image.asset('assets/profile.jpg'),
//        Icon(icons[index]),
//          Text(_products[index], style: TextStyle(color: Colors.deepPurple))
//        ],
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView.builder(
        itemBuilder: (context, index){
          return Card(
            elevation: 3,
            child: ListTile(
              title: Text(_products[index], style: TextStyle( color: Colors.black, fontSize: 20),),
              leading: CircleAvatar(
                radius: 30,

                backgroundImage: AssetImage(icons[index]),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Text(_description[index], style: TextStyle(color: Colors.grey,),),
              ),
              onTap: (){
                showToast('${_products[index]}');
                Navigator.of(context).pop();
              },
            ),
          );
        },
        itemCount: _products.length,

      )
    );
  }

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
}