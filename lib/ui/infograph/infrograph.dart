import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:providermodule/providermodule.dart';
import 'package:kitchly_chef/ui/registration_pages/login.dart';
import 'package:kitchly_chef/ui/registration_pages/register.dart';


class InfoGraph extends StatefulWidget {
  InfoGraph({Key key}) : super(key: key);

  @override
  _InfoGraphState createState() => _InfoGraphState();
}

class _InfoGraphState extends State<InfoGraph> {
  PageController pageController;
  List introList = [
    {
      "icon": "assets/images/slide/icon1.png",
      "text_intro": "Register your Kitchen",
      "text_sub": "Start a local kitchen business where ever you are even at home.",
    },
    {
      "icon": "assets/images/slide/icon2.png",
      "text_intro": "Receive and prepare orders ",
      "text_sub":
          "Get orders to prepare food from people close to you.",
    },
    {
      "icon": "assets/images/slide/icon3.png",
      "text_intro": "Pickup, Eat-in or Deliver \n at your customers door step.",
      "text_sub":
          "Use any option comfortable for you to deliver orders to your clients",
    },  
  ];
double iconSize = 18.0, deviceHeight, deviceWidth, deviceFont;
  @override
  void initState() {
    pageController = new PageController(keepPage: true, viewportFraction: 1.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    deviceFont = deviceHeight * 0.01;
    return Scaffold(

      backgroundColor: Colors.white,
      bottomNavigationBar: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(20.0),
                child: ButtonWidget(
                  onPress:()=> NextPage().nextRoute(context, Registration()),
                  width: 120.0,
                  height: 40.0,
                  txColor: Colors.white,
                  bgColor: Color(PublicVar.primaryColor),
                  text: 'Register',
                )),
            Padding(
                padding: EdgeInsets.all(20.0),
                child: ButtonWidget(
                  onPress: ()=>NextPage().nextRoute(context, Login()),
                  width: 120.0,
                  border: Border.all(width:1.5,color:Color(PublicVar.primaryColor)),
                  height: 40.0,
                  txColor: Color(PublicVar.primaryColor),
                  bgColor: Colors.white,
                  text: 'Login',
                ))
          ]),
      body: PageView.builder(
          controller: pageController,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: introList.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Stack(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset('assets/images/logo_long.png',width: 120,)),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: <Widget>[
                       SizedBox(height: deviceHeight * 0.2,),
                        Center(
                          child: Image.asset(
                            introList[index]["icon"],
                            height: deviceHeight * 0.3,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Center(
                          child: Container(
                              padding: EdgeInsets.only(top: 20, bottom: 10),
                              child: Text(introList[index]["text_intro"],
                              textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black))),
                        ),
                        Center(
                          child: Container(
                            width: 280.0,
                            height: deviceHeight * 0.2,
                            // padding: EdgeInsets.only(left: 70.0,right: 70.0),
                            child: Text(introList[index]["text_sub"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        getProgressDots(index),
                      ],
                    ),
                  ),

                ],
              ),
            );
          }),
    );
  }

  getProgressDots(index) {
    switch (index) {
      case 0:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 3.0, right: 3.0),
                width: 10.0,
                height: 5.0,
                decoration: BoxDecoration(
                    color: Color(PublicVar.primaryColor),
                    borderRadius: BorderRadius.circular(10.0))),
            Container(
                margin: EdgeInsets.only(left: 3.0, right: 3.0),
                width: 8.0,
                height: 5.0,
                decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(10.0))),
            Container(
                margin: EdgeInsets.only(left: 5.0),
                width: 8.0,
                height: 5.0,
                decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(10.0))),
          ],
        );
        break;
      case 1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 3.0, right: 3.0),
                width: 8.0,
                height: 5.0,
                decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(10.0))),
            Container(
                margin: EdgeInsets.only(left: 3.0, right: 3.0),
                width: 10.0,
                height: 5.0,
                decoration: BoxDecoration(
                    color: Color(PublicVar.primaryColor),
                    borderRadius: BorderRadius.circular(10.0))),
            Container(
                margin: EdgeInsets.only(left: 5.0),
                width: 8.0,
                height: 5.0,
                decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(10.0))),
          ],
        );
        break;
      case 2:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 3.0, right: 3.0),
                width: 8.0,
                height: 5.0,
                decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(10.0))),
            Container(
                margin: EdgeInsets.only(left: 3.0, right: 3.0),
                width: 8.0,
                height: 5.0,
                decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(10.0))),
            Container(
                margin: EdgeInsets.only(left: 5.0),
                width: 10.0,
                height: 5.0,
                decoration: BoxDecoration(
                    color: Color(PublicVar.primaryColor),
                    borderRadius: BorderRadius.circular(10.0))),
          ],
        );
        break;
    }
  }
}
