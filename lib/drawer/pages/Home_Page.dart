import 'dart:convert';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp_home_service_customer/constants/constants.dart';
import 'package:fyp_home_service_customer/model/engaged_worker_model.dart';
import 'package:fyp_home_service_customer/model/login_data.dart';
import 'package:fyp_home_service_customer/model/user_data.dart';
import 'package:fyp_home_service_customer/model/worker_data_model.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:stopper/stopper.dart';
import "package:http/http.dart" as http;
import '../drawer_home.dart';

class HomeMap extends StatefulWidget {

  @override
  _HomeMapState createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  final _isHours = true;
  TextEditingController paymentController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  String work_duration;
  final _scrollController = ScrollController();


 StopWatchTimer _stopWatchTimer = null;

  final List<String> service = [];
  Map jsonData;
  List userData;
  List<WorkerData> workerList = [];
  List<EngagedWorkerData> engagedList = [];
  List<Marker> markerList = [];
  Map jsonResponse;
  List WorkerList;

  bool isGetCurrentLoc = true;
  Map workerData;
  List workerDataList;
  String payments= "";

  GoogleMapController _googleMapController;
  static LatLng _initialPosition = LatLng(38.008, 41.57849);
  Location _location = Location();
  StreamSubscription _locationSubscription;
  Marker marker;
  Circle circle;
  Map data={};
  Timer timer;
  String latitude;
  String longitude;

  bool isReached = true;
  double distanceBetween;
  double temLati, temLongi;

  String currentDate;
  String currentTime;
  String serviceId;
  String workerId;
  String currentLati, currentLongi;
  LoginInfo _info = LoginInfo();

  // intialize the controller on Map Create
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _googleMapController = controller;
      _location.onLocationChanged().listen((l) {
        _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(l.latitude, l.longitude), zoom: 15)),
        );
      });
    });
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
    await DefaultAssetBundle.of(context).load("assets/images/logoo.png");
    return byteData.buffer.asUint8List();
  }

  Future showServices() async {
    http.Response response =
    await http.get(Constants.baseUrl+"getServices");
    jsonData = json.decode(response.body);
    setState(() {
      userData = jsonData['data'];
    });
    debugPrint(userData.toString());
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _location.getLocation();
      updateMarkerAndCircle(location, imageData);
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _location.onLocationChanged().listen((newLocalData) {
            if (_googleMapController != null) {
              currentLati = newLocalData.latitude.toString();
              currentLongi = newLocalData.longitude.toString();
              _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                  new CameraPosition(
                      bearing: 192.8334901395799,
                      target: LatLng(
                          newLocalData.latitude, newLocalData.longitude),
                      tilt: 0,
                      zoom: 12.00)));

          if(isGetCurrentLoc){
            setState(() {
              isGetCurrentLoc = false;
              temLati = double.parse(currentLati);
              temLongi = double.parse(currentLongi);
            });
          }

        if(isReached){
          if(engagedList.isNotEmpty){
            findDistance(temLati, temLongi,double.parse(engagedList[0].latitude), double.parse(engagedList[0].longitude));
            if(distanceBetween < 35.0){
              isReached = false;
              AwesomeDialog(
                dismissOnBackKeyPress: true,
                dismissOnTouchOutside: false,
                headerAnimationLoop: false,
                context: context,
                dialogType: DialogType.NO_HEADER,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Distance matched...',
                desc: 'Dialog description here.............',

                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Stop Watch", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      /// Display stop watch time
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: StreamBuilder<int>(
                          stream: _stopWatchTimer.rawTime,
                          initialData: _stopWatchTimer.rawTime.value,
                          builder: (context, snap) {
                            final value = snap.data;
                            final displayTime =
                            StopWatchTimer.getDisplayTime(value, hours: _isHours);

                            work_duration = displayTime;

                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    displayTime,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),


                      /// Button
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Container(
                                      width: 50,
                                      child: RaisedButton(
                                        padding: const EdgeInsets.all(4),
                                        color: Colors.lightBlue,
                                        shape: const StadiumBorder(),
                                        onPressed: () async {
                                          _stopWatchTimer.onExecute
                                              .add(StopWatchExecute.start);
                                        },
                                        child: const Text(
                                          'Start',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Container(
                                      width: 50,
                                      child: RaisedButton(
                                        padding: const EdgeInsets.all(4),
                                        color: Colors.green,
                                        shape: const StadiumBorder(),
                                        onPressed: () async {
                                          _stopWatchTimer.onExecute
                                              .add(StopWatchExecute.stop);
                                        },
                                        child: const Text(
                                          'Stop',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Container(
                                      width: 50,
                                      child: RaisedButton(
                                        padding: const EdgeInsets.all(4),
                                        color: Colors.red,
                                        shape: const StadiumBorder(),
                                        onPressed: () async {
                                          _stopWatchTimer.onExecute
                                              .add(StopWatchExecute.reset);
                                        },
                                        child: const Text(
                                          'Reset',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            onPressed: (){
                              paymentDailog();
                            },
                            child: Text("Work Done"),
                          )
                      )
                    ],
                  ),
                ),
              ).show();
            }
          }
        }
              setState(() {
                getEngagedWorker('engaged', workerId);

              });
            }
          });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        showToast("Permission Denied");
      }
    }
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    latitude = newLocalData.latitude.toString();
    longitude = newLocalData.longitude.toString();
    debugPrint("&&&&&&&&&&&&***************&&&&&&&&&" +
        latitude +
        "*********" +
        longitude);

    this.setState(() {
      marker = Marker(
        markerId: MarkerId("home"),
        position: latlng,
        infoWindow: InfoWindow(title: '${latlng}'),
      );
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.lightBlueAccent,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  findDistance(double startLati, double startLongi, double endtLati, double endtLongi ) async{
    distanceBetween = await Geolocator().distanceBetween(startLati, startLongi, endtLati, endtLongi);
    print("##################   #####  DISTANCE::::::::::::::::::::"+distanceBetween.toString());
  }

  @override
  void dispose() async {
    super.dispose();
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    await _stopWatchTimer.dispose();
  }

  @override
  void initState() {
     _stopWatchTimer = StopWatchTimer(
      isLapHours: true,
      onChange: (value) {
       setState(() {
         work_duration = StopWatchTimer.getDisplayTime(value, hours: true, minute: true, second: true);
       });
        print('onChange $value');
      },
      onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
      onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
    );
    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));
    getCurrentLocation();
    showServices();
    getCurrentDate();
    super.initState();
  }

  Widget serviceSelectionBar(BuildContext context, double h) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 45.0,
          child: MaterialButton(
            color: Colors.lightBlueAccent,
            child: Text(
              "Select Service",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            onPressed: () {
              showServices();
              showStopper(
                context: context,
                stops: [0.4 * h, h],
                builder: (context, scrollController, scrollPhysics, stop) {
                  return ClipRRect(
                    borderRadius: stop == 0
                        ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )
                        : BorderRadius.only(),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      color: Colors.white,
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverAppBar(
                            title: Center(
                                child: Text(
                                  "Which Service do You Need?",
                                  style: TextStyle(color: Colors.white),
                                )),
                            backgroundColor: Colors.lightBlueAccent,
                            automaticallyImplyLeading: false,
                            primary: false,
                            floating: true,
                            pinned: true,
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (context, services_id) =>
                                  Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              30, 0, 0, 0),
                                          child: Image.network(
                                              "http://192.168.43.238/Adminpanel/uploads/" +
                                                  userData[services_id]['service_icon']),
                                        ),
                                        title: Text(
                                          '${userData[services_id]['service_name']}',
                                          style: TextStyle(
                                            color: Colors.lightBlueAccent,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        onTap: () {
                                          markerList.clear();
                                          serviceId = userData[services_id]['service_id'].toString();
                                          showToast(
                                              'you selected: ${userData[services_id]['service_name']}');
                                          getProjectDetails(
                                              userData[services_id]['service_name']);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                              childCount: userData.length,
                            ),
                          )
                        ],
                        controller: scrollController,
                        physics: scrollPhysics,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 45.0,
          child: MaterialButton(
            onPressed: () {
              AwesomeDialog(
                dismissOnBackKeyPress: true,
                dismissOnTouchOutside: false,
                headerAnimationLoop: false,
                context: context,
                dialogType: DialogType.NO_HEADER,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Distance method...',
                desc: 'Dialog description here.............',

                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Stop Watch", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      /// Display stop watch time
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: StreamBuilder<int>(
                          stream: _stopWatchTimer.rawTime,
                          initialData: _stopWatchTimer.rawTime.value,
                          builder: (context, snap) {
                            final value = snap.data;
                            final displayTime =
                            StopWatchTimer.getDisplayTime(value, hours: _isHours);

                            work_duration = displayTime;

                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    displayTime,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),


                      /// Button
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Container(
                                      width: 50,
                                      child: RaisedButton(
                                        padding: const EdgeInsets.all(4),
                                        color: Colors.lightBlue,
                                        shape: const StadiumBorder(),
                                        onPressed: () async {

                                          _stopWatchTimer.onExecute
                                              .add(StopWatchExecute.start);
                                        },
                                        child: const Text(
                                          'Start',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Container(
                                      width: 50,
                                      child: RaisedButton(
                                        padding: const EdgeInsets.all(4),
                                        color: Colors.green,
                                        shape: const StadiumBorder(),
                                        onPressed: () async {

                                          _stopWatchTimer.onExecute
                                              .add(StopWatchExecute.stop);
                                        },
                                        child: const Text(
                                          'Stop',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Container(
                                      width: 50,
                                      child: RaisedButton(
                                        padding: const EdgeInsets.all(4),
                                        color: Colors.red,
                                        shape: const StadiumBorder(),
                                        onPressed: () async {

                                          _stopWatchTimer.onExecute
                                              .add(StopWatchExecute.reset);
                                        },
                                        child: const Text(
                                          'Reset',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                              paymentDailog();
                            },
                            child: Text("Work Done"),
                          )
                      )
                    ],
                  ),
                ),
              ).show();

            },
            color: Colors.lightBlueAccent,
            child: Text(
              "Confirm",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue[600],
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    print('***********************'+data.toString());
//    data.isNotEmpty ? data :
//    debugPrint(data.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Builder(
        builder: (context) {
          final h = MediaQuery
              .of(context)
              .size
              .height;
          return Stack(
            children: <Widget>[
              GoogleMap(
                markers: Set.of((markerList != null) ? markerList : []),
                circles: Set.of((circle != null) ? [circle] : []),
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  //zoom: 5,
                ),
                onMapCreated: _onMapCreated,
                mapType: MapType.normal,
                myLocationEnabled: true,
                compassEnabled: false,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        serviceSelectionBar(context, h),
                      ],
                    )),
              ),
            ],
          );
        },
      ),
      drawer: DrawerHome(),
    );
  }
  paymentDailog(){
    return AwesomeDialog(

      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: false,
      headerAnimationLoop: false,
      context: context,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Distance mathed...',
      desc: 'Dialog description here.............',

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Payment", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.only(top: 20,bottom: 10,left: 20,right: 20),
              child: Container(
                  child: TextField(
                    controller: paymentController,
                    decoration: InputDecoration(
                      prefix: Icon(Icons.attach_money_outlined, color: Colors.red,),
                      hintText: "Enter Rupees"
                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(

                height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: remarksController,
                    decoration: InputDecoration(
                        prefix: Icon(Icons.star, color: Colors.red,),
                        hintText: "Enter Remarks"
                    ),
                  )
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 40,right: 40),
              child: Container(

                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: (){
                      print("DURATION::::::::::::::"+paymentController.text);
                      serviceDone(Constants.request_ID, work_duration, remarksController.text);
                    setState(() {
                      payments = paymentController.text;
                    });
                      print("PAYMENTS:::::::::::::::::::::::::::::::::::::::::::"+payments);
                      savePayments(UserData.id, workerId, payments, currentDate);
                    },
                    color: Colors.teal,
                    child: Text("DONE"),
                  )
              ),
            ),
          ],
        ),
      ),
    ).show();
  }

  void getWorker(userData) async {
    Map dataa = {
      "service": userData,
      "status": 'free'
    };
    http.Response response =
    await http.post(Constants.baseUrl+"getWorker", body: dataa);
    workerData = json.decode(response.body);
    workerDataList.clear();
    setState(() {
      workerDataList = workerData['data'];
    });

    debugPrint('WORKER DATA  : ' + workerDataList.toString());
  }

  Future getProjectDetails(userData) async {
    var data = {
      "service": userData,
      "status": 'free'
    };
    http.Response response =
    await http.post(Constants.baseUrl+"getWorker", body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      workerList.clear();

      if (jsonResponse['message'] == 'login success') {
        for (var data in jsonResponse['data']) {
          workerList.add(new WorkerData(
              data['worker_id'],
              data['worker_name'],
              data['worker_email'],
              data['worker_phone'],
              data['worker_password'],
              data['worker_service_type'],
              data['worker_status'],
              data['worker_cnic'],
              data['worker_address'],
              data['worker_image'],
              data['worker_lati'],
              data['worker_longi']));
        }
        workerList.forEach(
                (someData) => print("Services----: ${someData.selectjob}"));

        loadMarker(workerList);
        //debugPrint(sessionList.toString());
      }
    } else {
      print('Something went wrong');
    }
  }

  void loadMarker(List<WorkerData> workerList) {
    for (int i = 0; i < workerList.length; i++) {
      markerList.add(Marker(
          markerId: MarkerId(workerList[i].name),
          position: LatLng(double.parse(workerList[i].latitude),
              double.parse(workerList[i].longitude)),
          // infoWindow: InfoWindow(title: workerList[i].name),
          onTap: () {
            AwesomeDialog(
              dismissOnBackKeyPress: true,
              dismissOnTouchOutside: false,
              headerAnimationLoop: false,
              context: context,
              dialogType: DialogType.NO_HEADER,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Dialog Title',
              desc: 'Dialog description here.............',
              body: Column(
                children: <Widget>[
                  //Text('Worker Details', style: TextStyle(fontSize: 18.0),),

                  ClipOval(
                      child: Image.network(
                          'http://192.168.43.85/Adminpanel/uploads/' +
                              workerList[i].profilepic, height: 100,
                          width: 100,
                          fit: BoxFit.cover)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Name: ' + workerList[i].name,
                          style: TextStyle(fontSize: 18.0),),
                        Text('Phone: ' + workerList[i].phone,
                          style: TextStyle(fontSize: 18.0),),
                        Text('Profession: ' + workerList[i].selectjob,
                          style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                  )
                ],
              ),
              btnOkText: 'Send Request',
              btnCancelOnPress: () {},
              btnOkOnPress: () {
                workerId = workerList[i].w_id.toString();
                sendRequest(data['id'], currentLati, currentLongi, workerList[i].w_id.toString(), serviceId, currentDate, currentTime, 'pending');
//                Toast.show('Request Sent', context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                showToast('Request Sent');
              },
            ).show();
          }));
    }

    print(markerList.toString());
  }

  sendRequest(String customerId, String customerLati, String customerLongi, String workerId, String serviceId, String requestDate, String requestTime, String requestStatus) async{

    Map userData = {
      "customerId":     customerId,
      "customerLati":   customerLati,
      "customerLongi" : customerLongi,
      "workerId":       workerId,
      "serviceId":      serviceId,
      "requestDate":    requestDate,
      "requestTime":    requestTime,
      "requestStatus":  requestStatus,
    };

    var response = await http.post(Constants.baseUrl+"sendRequest", body: userData);
    if(response.statusCode == 200){
      Map isSave = json.decode(response.body);
      String result="";
      setState(() {
        result = isSave['message'];
        if(result == "Request Sent..."){
//          Toast.show("Feedback sent", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
        Constants.request_ID = isSave['request_ID'].toString();
        print("REQUEST ID:::::::::::::::"+Constants.request_ID);
          showToast("Request sent");
          //Navigator.of(context).pop();
        }
      });

    }

  }

  getEngagedWorker(String status, String workerID) async{

    Map userData = {
      "status": status,
      "id":     workerID
    };

    var response = await http.post(Constants.baseUrl+"getEngagedWorker", body: userData);
    if (response.statusCode == 200) {
//      String responeBody = response.body;
//      var jsonBody = json.decode(responeBody);
      jsonResponse = json.decode(response.body);
      if (jsonResponse['message'] == 'login success') {
        for (var data in jsonResponse['data']) {
          engagedList.add(new EngagedWorkerData(
              data['worker_id'],
              data['worker_name'],
              data['worker_email'],
              data['worker_phone'],
              data['worker_password'],
              data['worker_service_type'],
              data['worker_status'],
              data['worker_cnic'],
              data['worker_address'],
              data['worker_image'],
              data['worker_lati'],
              data['worker_longi']));
        }
        engagedList.forEach(
                (someData) => print("Services----: ${someData.selectjob}"));
print("######################::::::::"+engagedList[0].latitude);
        markerList.clear();
        markerList.add(Marker(
          markerId: MarkerId('Current Location'),
          infoWindow: InfoWindow(title: "Customer"),
          position: LatLng(double.parse(engagedList[0].latitude),
            double.parse(engagedList[0].longitude),),));
      }
    } else {
      print('Something went wrong');
    }

  }


  getCurrentDate(){
    final DateTime now = DateTime. now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    currentDate = formatter. format(now);
    currentTime = DateFormat('kk:mm:ss').format(now);
    print(currentDate); // something like 2013-04-20.
  }

  savePayments(String customer_id, String worker_id, String paid_amount, String paid_amount_date) async{

    Map userData = {
      "customer_id": customer_id,
      "worker_id":worker_id,
      "amount": payments,
      "paid_amount_date": paid_amount_date,
    };

    var response = await http.post(Constants.baseUrl+"savePayment", body: userData);
    if(response.statusCode == 200){
      Map isSave = json.decode(response.body);
      String result="";
      setState(() {
        result = isSave['message'];
        if(result == "payment saved"){
//          Toast.show("Feedback sent", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
        print("PAYMENTS:::::::::::::::::::"+response.body);
          showToast("Feedback sent");
          Navigator.of(context).pop();
        }
        else{
          print("############################## RESPONSE  "+response.body);
        }
      });

    }
    else{
      print("############################## .......... RESPONSE  "+response.body);
    }

  }

  serviceDone(String request_id, String work_duration, String remarks) async{

    Map userData = {
      "request_id": request_id,
      "work_duration":work_duration,
      "remark": remarks,

    };
    print("USER DATA:::::::::::::"+userData.toString());

    var response = await http.post(Constants.baseUrl+"workDone", body: userData);
    if(response.statusCode == 200){
      Map isSave = json.decode(response.body);
      print("RESPONSE::::::::::;"+response.body);
      String result="";
      setState(() {
        result = isSave['message'];
        if(result == "service done"){
          paymentController.clear();
          remarksController.clear();
          engagedList.clear();
          markerList.clear();
          isReached = true;
          workerList.clear();
          payments="";
          paymentController.clear();
          remarksController.clear();
          jsonResponse=null;
          //jsonData = null;
          isGetCurrentLoc=true;
          temLati=0.0;
          temLongi = 0.0;
          Constants.request_ID = null;
          updateWorkerStatus('free', workerId);
          showToast("Feedback sent");
          Navigator.of(context).pop();
        }
      });

    }
    else{
      print("RESPONSE::::::::::;"+response.body);
    }

  }

  updateWorkerStatus(String status, String workerID) async{

    Map userData = {
      "status": status,
      "id":     workerID
    };

    var response = await http.put(Constants.baseUrl+"updateWorkerStatus", body: userData);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse['message'] == 'Status Updated...') {
        print("######################::::::::"+jsonResponse['message']);
      }
    }
    else {
      print('Something went wrong');
    }
  }
}
