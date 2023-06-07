import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kitchly_chef/ui/main_pages/profile.dart';
import 'package:menumodule/menumodule.dart';
import 'package:ordermodule/ordermodule.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'drawer.dart';
import 'home.dart';
import 'settings/kitchen/kitchen_setup.dart';

class Base extends StatefulWidget {
  Base({Key key, this.firstEntry}) : super(key: key);
  bool firstEntry;
  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin<Base> {
  AppBloc appBloc = AppBloc();
  List bottomItems = [
    {'icon': Ionicons.ios_home, 'text': "Home"},
    {'icon': Ionicons.ios_cart, 'text': "Order"},
    {'icon': Ionicons.ios_book, 'text': "Menu"},
    {'icon': Ionicons.ios_person, 'text': "Profile"},
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentPage;
  // FlutterLocalNotificationsPlugin flutterLocationNotificatioPlugin =
  //     FlutterLocalNotificationsPlugin();

  final Key key1 = PageStorageKey('page1');
  final Key key2 = PageStorageKey('page2');
  final Key key3 = PageStorageKey('page3');
  final Key key4 = PageStorageKey('page4');
  final navigationIconSize = 18.0;
  Home page1;
  Order page2;
  Menu page3;
  Profile page4;
  List<Widget> pages = [];
  SharedPreferences prefs;

  GlobalKey _fabKey = GlobalObjectKey("fab");
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  List ratingWords = [
    "",
    "I am very Dissatisfied",
    "I am Dissatisfied",
    "I am ok",
    "I am Satisfied",
    "I am very Satisfied"
  ];
  var ratingIndex, index;
  String commentField;
  TextEditingController commentController = TextEditingController();
  List<String> attachments = [];
  bool isHTML = false;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    if (widget.firstEntry == null) {
      widget.firstEntry = false;
    }
    WidgetsBinding.instance.addObserver(this);
    page1 = Home(
      scaffoldKey: _scaffoldKey,
      key: key1,
    );
    page2 = Order(
      scaffoldKey: _scaffoldKey,
      key: key2,
    );
    page3 = Menu(
      scaffoldKey: _scaffoldKey,
      key: key3,
    );
    page4 = Profile(
      key: key4,
      scaffoldKey: _scaffoldKey,
    );
    pages = [page1, page2, page3, page4];
    currentPage = page1;
    if (PublicVar.accountApproved) {
      if (widget.firstEntry) {
        checkForMenu();
      }
      loadData();
      //sort();
    }
    checkAppInfo();
    if (Platform.isIOS) {
      //requestIosPermission();
    }
    // void onDidReceiveNotificationResponse(
    //     NotificationResponse notificationResponse) async {
    //   final String payload = notificationResponse.payload;
    //   if (notificationResponse.payload != null) {
    //     debugPrint('notification payload: $payload');
    //   }
    //   await Navigator.push(
    //     context,
    //     MaterialPageRoute<void>(builder: (context) => Base()),
    //   );
    // }

    //Local notification initialization
    // var initializationSettingsAndroid =
    //     AndroidInitializationSettings('app_icon');
    // var initializationSettingsIos = IOSInitializationSettings(
    //     requestAlertPermission: true,
    //     requestBadgePermission: true,
    //     requestSoundPermission: true,
    //     onDidReceiveLocalNotification: (id, title, body, payload) async {});
    // var initializationSettings = InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIos);
    // flutterLocationNotificatioPlugin.initialize(initializationSettings,
    //     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    //Local notification initialization
    super.initState();
    Timer.periodic(new Duration(minutes: 1), (_) async {
      Map pending = {
        "query": {"kitchen_id": PublicVar.kitchenID, "status": "PENDING"},
        "page": 1,
        "limit": 100,
        "token": PublicVar.getToken
      };
      await OrderServer().getPendingOrders(appBloc: appBloc, data: pending);
      appBloc.pendingOrders = appBloc.pendingOrders;
      if (appBloc.pendingOrders.length > 0) {
        // showNotification({
        //   "data": {
        //     "title": "New Orders",
        //     "descp":
        //         "You just received ${appBloc.pendingOrders.length} order(s), click please attend to them.",
        //   }
        // });
      }
    });
  }

  // requestIosPermission() {
  //   flutterLocationNotificatioPlugin
  //       .resolvePlatformSpecificImplementation<
  //           IOSFlutterLocalNotificationsPlugin>()
  //       .requestPermissions(alert: false, badge: true, sound: true);
  // }

  // Future showNotification(Map<String, dynamic> message) async {
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //     'channel id',
  //     'channel name',
  //     channelDescription: "${message['data']['descp']}",
  //     importance: Importance.max,
  //     priority: Priority.max,
  //     icon: 'app_icon',
  //     enableLights: true,
  //   );
  //   var iosPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = new NotificationDetails(
  //       android: androidPlatformChannelSpecifics,
  //       iOS: iosPlatformChannelSpecifics);
  //   await flutterLocationNotificatioPlugin.show(
  //     0,
  //     '${message['data']['title']}',
  //     '${message['data']['descp']}',
  //     platformChannelSpecifics,
  //     payload: 'Default_Sound',
  //   );
  // }
  //
  // Future selectNotification(String payload) async {
  //   await flutterLocationNotificatioPlugin.cancelAll();
  // }

  loadData() {
    Future.delayed(Duration(milliseconds: 1), () async {
      if (!appBloc.firstSyncedKitchen) {
        await Server().queryKitchen(appBloc: appBloc);
      }
      await getMenus();
      //await downloadVideo();
    });
  }

  downloadVideo() async {
    var path = await DownloadFile().downloadVideo(
        url: PublicVar.kitchenVideoUrl, filename: 'kitchen_tour');
    if (path != null) {
      if (!PublicVar.onProduction) print(path);
      PublicVar.kitchenTourFile = File(path);
      setState(() {});
    }
  }

  getMenus() async {
    if (!appBloc.hasDish) {
      await Server().getDishes(appBloc: appBloc, data: PublicVar.queryKitchen);
      if (!PublicVar.hasMenu && !widget.firstEntry) {
        checkForMenu();
      }
    }
    if (!appBloc.hasPendingOrder) {
      await OrderServer().getAllOrders(appBloc: appBloc);
    }
    if (!appBloc.hasExtras) {
      await Server().getExtras(appBloc: appBloc, data: PublicVar.queryKitchen);
    }
    if (!appBloc.hasMeals) {
      await Server().getMeals(appBloc: appBloc);
    }

    setState(() {});
  }

  sort() async {
    await Future.delayed(Duration(seconds: 3), () {
      for (var i = appBloc.orders.length - 1; i >= 0; i--) {
        for (var j = i; j >= 0; j--) {
          if (appBloc.orders[i]['pos'] < appBloc.orders[j]['pos']) {
            var t = appBloc.orders[i];
            appBloc.orders[i] = appBloc.orders[j];
            appBloc.orders[j] = t;
          }
        }
      }
      appBloc.orders = appBloc.orders;
      //sortAgain();
    });
  }

  sortAgain() {
    if (!PublicVar.onProduction) print('Sorting Again ooo...');
    sort();
  }

  checkForMenu() {
    Future.delayed(Duration(milliseconds: 1), () {
      AppActions().showAppDialog(context,
          child: Column(
            children: [
              Image.asset(
                "assets/images/menuimg1.png",
                height: 240,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "Welcome to kitchly kitchen, Start your business by creating your menu",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          title: "Create Kitchen Menu",
          singlAction: true, okAction: () {
        Navigator.pop(context);
        setState(() {
          PublicVar.basePage = 2;
          currentPage = pages[2];
        });
      }, okText: "Create menu");
    });
  }

  checkAppInfo() {
    Future.delayed(Duration(seconds: 1), () async {
      var app = await DeviceInfo().getPackageInfo();
      if (await Server().getAction(appBloc: appBloc, url: Urls.getAppInfo)) {
        var info = appBloc.mapSuccess;
        if (info['app']['v_code'] != app['v_code']) {
          AppActions().showAppDialog(context,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/icons/update_icon.png",
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "A new version of Kitchly Kitchens is availble, and its very important you update before you can continue your business",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
              title: "New Version Available",
              singlAction: true, okAction: () async {
            Navigator.pop(context);
            await launch(
                'https://play.google.com/store/apps/details?id=com.kitchly_chef');
          }, okText: "Update");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return WillPopScope(
      onWillPop: onwillPop,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: KitchlyDrawer(),
        ),
        drawerEdgeDragWidth: 15.0,
        drawerScrimColor: Colors.black12,
        body: PublicVar.accountApproved
            ? PageStorage(
                bucket: bucket,
                child: currentPage,
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 80),
                child: KitchenSettings(),
              ),
        bottomNavigationBar: PublicVar.accountApproved
            ? BottomNavigationBar(
                key: _fabKey,
                backgroundColor: Colors.white,
                showSelectedLabels: true,
                selectedItemColor: Color(PublicVar.primaryColor),
                unselectedItemColor: Colors.black54,
                showUnselectedLabels: true,
                elevation: 2.5,
                unselectedFontSize: 12,
                selectedFontSize: 14,
                type: BottomNavigationBarType.fixed,
                iconSize: navigationIconSize,
                currentIndex: PublicVar.basePage,
                onTap: (int index) {
                  setState(() {
                    PublicVar.basePage = index;
                    currentPage = pages[index];
                  });
                  if (!PublicVar.hasMenu && !widget.firstEntry) {
                    checkForMenu();
                  }
                },
                items: List.generate(bottomItems.length, (i) {
                  return BottomNavigationBarItem(
                      icon: Icon(bottomItems[i]['icon']),
                      label: bottomItems[i]['text']);
                }),
              )
            : SizedBox(),
      ),
    );
  }

  Future<bool> onwillPop() async {
    bool exit;
    if (PublicVar.basePage != 0) {
      setState(() {
        PublicVar.basePage = 0;
        currentPage = pages[0];
      });
      exit = false;
    } else if (PublicVar.basePage == 0) {
      openRatingDialog();
    }

    return exit;
  }

  openRatingDialog() {
    AppActions().showAppDialog(context,
        title: "Rate App",
        descp: "How has your experience with Kitchly Kitchen been so far",
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: 10,
                ),
                RatingBar.builder(
                  initialRating: 0,
                  itemCount: 5,
                  updateOnDrag: true,
                  allowHalfRating: false,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: Colors.red,
                        );
                      case 1:
                        return Icon(
                          Icons.sentiment_dissatisfied,
                          color: Colors.orangeAccent,
                        );
                      case 2:
                        return Icon(
                          Icons.sentiment_neutral,
                          color: Colors.yellow,
                        );
                      case 3:
                        return Icon(
                          Icons.sentiment_satisfied,
                          color: Colors.lightGreen,
                        );
                      case 4:
                        return Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.green,
                        );
                      default:
                        return SizedBox();
                    }
                  },
                  onRatingUpdate: (rating) {
                    print(rating);
                    setState(() {
                      ratingIndex = rating.round();
                    });
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${ratingIndex == null ? "" : ratingWords[ratingIndex]}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(
                  height: 20,
                  width: double.infinity,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: commentController,
                    textCapitalization: TextCapitalization.sentences,
                    onSaved: (String val) {
                      commentField = val;
                    },
                    decoration: FormDecorator(
                        fillColor: Colors.white,
                        hint: 'Leave a comment...',
                        helper: 'e.g I love the app.'),
                  ),
                ),
              ]),
            ),
          ),
        ),
        okAction: () async {
          if (ratingIndex != null) {
            final Email email = Email(
              body:
                  "KITCHEN:${appBloc.kitchenDetails['kitchen_name']}  \n\nCHEF: ${appBloc.kitchenDetails['username']} \n\n REACTION: ${ratingWords[ratingIndex]}  \n\nCOMMENT: ${commentController.text}",
              subject: "Kitchen App Feedback",
              recipients: [
                "kitchly.kitchens@gmail.com",
                "benny.bat51@gmail.com",
                "geo.stephone@gmail.com"
              ],
              attachmentPaths: attachments,
              isHTML: isHTML,
            );

            String platformResponse;

            try {
              await FlutterEmailSender.send(email);
              platformResponse = 'success';
            } catch (error) {
              platformResponse = error.toString();
            }
            if (!mounted) return;

            AppActions()
                .showSuccessToast(context: context, text: platformResponse);
            exit(0);
          } else {
            AppActions().showErrorToast(
                context: context,
                text:
                    "Please you have to  choose one of the emojis,and you can also comment too.");
          }
        },
        okText: "Send Feedback",
        cancleText: "Later",
        danger: false,
        normal: true,
        cancleAction: () {
          exit(0);
        });
  }
}

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final String body;
  final int id;
  final String payload;
  final String title;
}
