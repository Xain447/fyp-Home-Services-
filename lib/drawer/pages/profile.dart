import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fyp_home_service_customer/constants/constants.dart';
import 'package:fyp_home_service_customer/model/login_data.dart';
import 'package:image_picker/image_picker.dart';
import "package:http/http.dart" as http;
import 'package:toast/toast.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _status = true;
  Map data = {};
  final FocusNode myFocusNode = FocusNode();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  bool _obscureText = true;
  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
    updateProfilePicture(_image, data["id"]);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    _nameController.text = data['name'];
    _emailController.text = data['email'];
    _phoneController.text = data['phone'];
    _passwordController.text = data['password'];
   setState(() {
     //proImage = data['profileImage'];
   });
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Profile"),
      ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 190.0,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Stack(fit: StackFit.loose, children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    width: 160.0,
                                    height: 160.0,
                                    child:  _image != null
                                        ? ClipOval(
                                        child: Image.file(_image, height: 100,
                                            width: 100,
                                            fit: BoxFit.cover)
                                    )
                                        : ClipOval(
                                      child: Image.network('http://192.168.43.238/FYP_API/uploads/'+data['profileImage'], height: 100,
                                          width: 100,
                                          fit: BoxFit.cover)
                                    )

                                ),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 100.0, right: 100.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.lightBlueAccent,
                                      radius: 25.0,
                                      child: FlatButton(
                                        onPressed: (){
                                          getImage();

                                        },
                                        child: Center(
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    )
                                  ],
                                )),
                          ]),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Parsonal Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status ? _getEditIcon() : Container(),
                                    ],
                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Name",
                                      ),
                                      enabled: !_status,
                                      autofocus: !_status,
                                      controller: _nameController,

                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Email ID',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email ID"),
                                      enabled: !_status,
                                      controller: _emailController,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter Mobile Number"),
                                      enabled: !_status,
                                      controller: _phoneController,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        'Password',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),

                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: TextField(
                                        obscureText: _obscureText,
                                        controller: _passwordController,
                                        decoration: InputDecoration(
                                          labelText: "Password",
                                          enabled: !_status,
                                          suffixIcon: FlatButton(
                                              onPressed: _toggle,
                                              child: new Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.lightBlueAccent,)),
                                        ),
                                      ),
                                    ),
                                    flex: 2,
                                  ),

                                ],
                              )),
                          !_status ? _getActionButtons() : Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: RaisedButton(
                    child: Text("Save"),
                    textColor: Colors.white,
                    color: Colors.lightBlueAccent,
                    onPressed: () {

                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(FocusNode());
                        //Toast.show('profile updated', context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                      });
                      updateRecord(data['id'], _nameController.text, _emailController.text, _phoneController.text, _passwordController.text);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: RaisedButton(
                    child: Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(FocusNode());
                      });

                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.lightBlueAccent,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  updateProfilePicture(File profileImage, String id) async{

    var request = http.MultipartRequest("PUT", Uri.parse(Constants.baseUrl+"updateUserProfilePic"));
    var pic = await http.MultipartFile.fromPath("profileImage", profileImage.path);
    request.files.add(pic);
    request.fields["id"] = id;
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("Image"+responseString);
    Map myData = json.decode(responseString);
    Toast.show(myData["message"], context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

    LoginInfo info = new LoginInfo();
    info.setId = id.toString();
    info.setProfileImage = profileImage.path.split('/').last;


    Navigator.pushReplacementNamed(context, '/homePage', arguments: {
      'id': data['id'],
      'name': _nameController.text,
      'email': _emailController.text,
      'phone':_phoneController.text,
      'password': _passwordController.text,
      "profileImage":info.profileImage
    });

   //Navigator.of(context).pop();

//    Navigator.pushReplacementNamed(context, '/drawerHome', arguments: {
//      'id': info.id,
//      'profileImage': info.profileImage
//    });
  }

  updateRecord(String id, String name, String email, String phone, String password) async{
    Map data1 = {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "id": id
    };

    _nameController.text = name;
    _emailController.text = email;
    _phoneController.text = phone;
    _passwordController.text = password;

    var request = http.MultipartRequest("PUT", Uri.parse(Constants.baseUrl+"updateUserData"));

    request.fields["name"] = name;
    request.fields["email"] = email;
    request.fields["phone"] = phone;
    request.fields["password"] = password;
    request.fields["id"] = id;
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    Map isSave = json.decode(responseString);

    Toast.show(isSave["message"], context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);


    LoginInfo info = new LoginInfo();
    info.setId = id.toString();
    info.setName = name;
    info.setEmail = email;
    info.setPhone = phone;
    info.setPassword = password;
    Toast.show(id.toString()+" "+name+" "+email+" "+phone+" "+password, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    Navigator.pushReplacementNamed(context, '/homePage', arguments: {
      'id': info.id,
      'name': info.name,
      'email': info.email,
      'phone': info.phone,
      'password': info.password,
      "profileImage":data['profileImage']
    });

  }
}
