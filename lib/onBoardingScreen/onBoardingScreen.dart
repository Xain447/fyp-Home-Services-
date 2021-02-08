import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyp_home_service_customer/constants/constants.dart';
import 'package:fyp_home_service_customer/landingPage/landingPage.dart';




class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({Key key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final int _totalPages = 4;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget _buildPageContent({
    String image,
    String title,
    String body,
  }) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width * 0.6,
              width: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(image))),
            ),
            SizedBox(
              height: 60.0,
            ),
            Text(
              title,
              style: TextStyle(
                fontFamily: Constants.POPPINS,
                fontWeight: FontWeight.w700,
                fontSize: 20.5,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  body,
                  style: TextStyle(
                    fontFamily: Constants.OPEN_SANS,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                    fontSize: 12.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ));
  }

  // Future checkFirstSeen() async {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     bool _seen = (prefs.getBool('seen') ?? true);

  //     if (_seen) {
  //     Navigator.of(context).pushReplacement(
  //         new MaterialPageRoute(builder: (context) => new LoginPage()));
  //     } else {
  //     await prefs.setBool('seen', true);
  //     Navigator.of(context).pushReplacement(
  //         new MaterialPageRoute(builder: (context) => new OnBoardingPage()));
  //     }
  // }
  //  @override
  //   void initState() {
  //       super.initState();
  //       new Timer(new Duration(milliseconds: 200), () {
  //       checkFirstSeen();
  //       });
  //   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: PageView(
          controller: _pageController,
          onPageChanged: (int page) {
            _currentPage = page;
            setState(() {});
          },
          children: <Widget>[
            _buildPageContent(
                image: 'assets/images/slide_1.png',
                title: 'Welcome to Home Services',
                body: 'We are so glad you are here in home services app'),
            _buildPageContent(
                image: 'assets/images/slide_2.png',
                title: 'Yay,You did it',
                body:
                    'Starting today, you will never have to look anywhere else for all your home releated services. This app will do everything for you '),
            _buildPageContent(
                image: 'assets/images/slide_3.png',
                title: 'Share your Location',
                body:
                    'Share your location with us,so that our Professionals can reach to your destination and done your job'),
            _buildPageContent(
                image: 'assets/images/slide_4.png',
                title: '10+ Home Services',
                body:
                    'Ever needed Handyman, Car wash, Electrician, Plumber, home cleaning, Mechanic or Home appliances repair?'),
          ],
        ),
      ),
      bottomSheet: _currentPage != 3
          ? Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      // _pageController.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.linear);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => landingPage(),
                          ));
                      setState(() {});
                    },
                    splashColor: Colors.green[50],
                    child: Text(
                      'SKIP',
                      style: TextStyle(
                          color: Colors.blue[600], fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Row(children: [
                      for (int i = 0; i < _totalPages; i++)
                        i == _currentPage
                            ? _buildPageIndicator(true)
                            : _buildPageIndicator(false)
                    ]),
                  ),
                  FlatButton(
                    onPressed: () {
                      _pageController.animateToPage(_currentPage + 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                      setState(() {});
                    },
                    splashColor: Colors.green[50],
                    child: Text(
                      'NEXT',
                      style: TextStyle(
                          color: Colors.blue[600], fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          : InkWell(
              onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => landingPage(),
                  )),
              child: Container(
                height: Platform.isIOS ? 70 : 60,
                color: Colors.blue[600],
                alignment: Alignment.center,
                child: Text(
                  'GET STARTED NOW',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
    );
  }
}


