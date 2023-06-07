import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kitchly_chef/ui/splash.dart';
import 'package:kitchlykitchendb/kitchlykitchendb.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';
// import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../base.dart';
import 'account.dart';
import 'feedback.dart';
import 'kitchen/kitchen_setup.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool loading = false, activeKitchen = false, firstTime = false;
  AppBloc appBloc;
  double deviceHeight, deviceWidth, deviceFont;
  DeviceInfo deviceInfo = DeviceInfo();
  UsersDb userDB;
  Map device, app;
  var testStyle;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  @override
  void initState() {
    _initPackageInfo();
    userDB = UsersDb(databaseProvider: DatabaseProvider());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    deviceFont = deviceHeight * 0.01;
    testStyle = TextStyle(fontSize: 2.7 * deviceFont);
    if (appBloc.kitchenDetails['is_active'] != null && !firstTime) {
      activeKitchen = appBloc.kitchenDetails['is_active'];
      firstTime = true;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Feather.arrow_left,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        'Settings',
                        style: TextStyle(
                            fontSize: 4.4 * deviceFont,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Feather.settings,
                      size: 2.8 * deviceFont,
                      color: Color(PublicVar.primaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: deviceHeight * 0.02),
              ListTile(
                title: Text(
                  'Account Settings',
                ),
                onTap: () {
                  NextPage().nextRoute(context, Account());
                },
                trailing: Icon(
                  Feather.chevron_right,
                  color: Colors.black,
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Kitchen Settings',
                ),
                onTap: () {
                  NextPage().nextRoute(context, KitchenSetup());
                },
                trailing: Icon(
                  Feather.chevron_right,
                  color: Colors.black,
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Send Feedback',
                ),
                onTap: () {
                  NextPage().nextRoute(context, FeedBackPage());
                },
                trailing: Icon(
                  Feather.chevron_right,
                  color: Colors.black,
                ),
              ),
              Divider(),
              ListTile(
                trailing: Icon(
                  Ionicons.ios_share_alt,
                  color: Colors.black87,
                  size: 3.2 * deviceFont,
                ),
                title: Text(
                  "Tell A Friend",
                ),
                onTap: () {
                  Navigator.pop(context);
                  tellFriend();
                },
              ),
              Divider(),
              ListTile(
                subtitle: Text(
                  'Chose when you want to be open or close for business',
                  style: TextStyle(fontSize: 12),
                ),
                title: Text(
                  appBloc.kitchenDetails['opened_for_order']
                      ? 'Close Kitchen'
                      : 'Open Kitchen',
                ),
                trailing: CupertinoSwitch(
                  value: appBloc.kitchenDetails['opened_for_order'],
                  onChanged: (value) async {
                    if (await AppActions().checkInternetConnection()) {
                      changeOrderStatus();
                    } else {
                      AppActions().showErrorToast(
                        text: PublicVar.checkInternet,
                        context: context,
                      );
                    }
                  },
                  activeColor: Color(PublicVar.primaryColor),
                ),
              ),

              Divider(),

              ListTile(
                subtitle: Text(
                  'if you want your kitchen to be seen in public or not',
                  style: TextStyle(fontSize: 12),
                ),
                title: Text(
                  '${activeKitchen ? "Deactivate Kitchen" : "Activate Kitchen"}',
                ),
                trailing: CupertinoSwitch(
                  value: activeKitchen,
                  onChanged: (value) async {
                    if (await AppActions().checkInternetConnection()) {
                      changeActiveStatus(active: value);
                    } else {
                      AppActions().showErrorToast(
                        text: PublicVar.checkInternet,
                        context: context,
                      );
                    }
                  },
                  activeColor: Color(PublicVar.primaryColor),
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Order Food? Use client app',
                ),
                onTap: () async {
                  await launch(
                      'https://play.google.com/store/apps/details?id=com.kitchly');
                },
                trailing: Icon(
                  Feather.chevron_right,
                  color: Colors.black,
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Log out',
                ),
                onTap: () {
                  AppActions().showAppDialog(context,
                      title: 'Log Out?',
                      descp: 'Are you sure you want to logout of kitchly?',
                      okText: 'Logout',
                      cancleText: "Cancel",
                      danger: true, okAction: () async {
                    Navigator.pop(context);
                    AppActions().showLoadingToast(
                      text: PublicVar.wait,
                      context: context,
                    );
                    if (await AppActions().checkInternetConnection()) {
                      logout();
                    } else {
                      AppActions().showErrorToast(
                        text: PublicVar.checkInternet,
                        context: context,
                      );
                    }
                  });
                },
                trailing: Icon(
                  Feather.log_out,
                  color: Colors.redAccent,
                  size: 3.2 * deviceFont,
                ),
              ),
              // Divider(),
              // ListTile(
              //   leading: Text(
              //     'Payments',
              //     style: testStyle,
              //   ),
              //   onTap: () {
              //     NextPage().nextRoute(context, Payments());
              //   },
              //   trailing: Icon(
              //     Feather.chevron_right,
              //     color: Colors.black,
              //   ),
              // ),
              // Divider(),
              // ListTile(
              //   leading: Text(
              //     'Location',
              //     style: testStyle,
              //   ),
              //   onTap: () {
              //     NextPage().nextRoute(context, Location_Settings());
              //   },
              //   trailing: Icon(
              //     Feather.chevron_right,
              //     color: Colors.black,
              //   ),
              // ),
              // Divider(),
              // ListTile(
              //   leading: Text(
              //     'Support',
              //     style: testStyle,
              //   ),
              //   onTap: () {
              //     NextPage().nextRoute(context, Support());
              //   },
              //   trailing: Icon(
              //     Feather.chevron_right,
              //     color: Colors.black,
              //   ),
              // ),
              // Divider(),
              // ListTile(
              //   leading: Text(
              //     'Tell A Friend',
              //     style: testStyle,
              //   ),
              //   trailing: Icon(
              //     Feather.share_2,
              //     color: Colors.black,
              //   ),
              // ),
              // Divider(),
              // ListTile(
              //   leading: Text(
              //     'Notifications',
              //     style: testStyle,
              //   ),
              //   onTap: () {
              //     NextPage().nextRoute(context, Notifications());
              //   },
              //   trailing: Icon(
              //     Feather.chevron_right,
              //     color: Colors.black,
              //   ),
              // ),
              // Divider(),
              // ListTile(
              //   leading: Text(
              //     'Terms & Conditons',
              //     style: testStyle,
              //   ),
              //   onTap: () {
              //     NextPage().nextRoute(context, Terms());
              //   },
              //   trailing: Icon(
              //     Feather.chevron_right,
              //     color: Colors.black,
              //   ),
              // ),
              // Divider(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TextButton(
        onPressed: () => goToWebsite(),
        child: Text(
          "From\nRework Technologies",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 11.0),
        ),
      ),
    );
  }

  goToWebsite() async {
    await launch('http://www.reworktechnologies.com/');
  }

  changeActiveStatus({bool active}) async {
    AppActions().showLoadingToast(
      text: PublicVar.wait,
      context: context,
    );
    var data = {
      "nokey": {"kitchen_id": PublicVar.kitchenID},
      "token": PublicVar.getToken
    };
    if (!PublicVar.onProduction)
      print("${active ? Urls.activiteKitchen : Urls.deactivateKitchen}");
    if (await Server().postAction(
        bloc: appBloc,
        url: active ? Urls.activiteKitchen : Urls.deactivateKitchen,
        data: data)) {
      await Server().queryKitchen(appBloc: appBloc);
      appBloc.kitchenDetails = appBloc.kitchenDetails;
      if (!PublicVar.onProduction) print(appBloc.kitchenDetails);
      AppActions().showSuccessToast(
        text: active
            ? 'Kitchen is active!... Your customers can now see you '
            : 'Your kitchen is no longer active!!! Your customers can no longer see you.',
        context: context,
      );
      firstTime = false;
      activeKitchen = active;
      setState(() {});
    } else {
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
  }

  changeOrderStatus() async {
    if (PublicVar.hasDish) {
      var status = 0;
      appBloc.kitchenDetails['opened_for_order'] ? status = 0 : status = 1;
      AppActions().showLoadingToast(
        text: PublicVar.wait,
        context: context,
      );
      if (await Server().postAction(
          bloc: appBloc,
          url: Urls.changeKitchenOrderStatus,
          data: {"kitchen_id": PublicVar.kitchenID, "status": status})) {
        await Server().postAction(
            bloc: appBloc,
            url: Urls.activiteKitchen,
            data: PublicVar.queryKitchenNoKey);
        appBloc.kitchenDetails['opened_for_order']
            ? appBloc.kitchenDetails['opened_for_order'] = false
            : appBloc.kitchenDetails['opened_for_order'] = true;
        AppActions().showSuccessToast(
          text: appBloc.kitchenDetails['opened_for_order']
              ? 'You can now accept orders'
              : 'You can no longer accept orders',
          context: context,
        );
        setState(() {});
      } else {
        AppActions().showErrorToast(
          text: appBloc.errorMsg,
          context: context,
        );
      }
    } else {
      AppActions().showAppDialog(context,
          descp:
              "Please you have to create a menu for your before you can start accepting orders.",
          title: "Kitchen has no dish",
          singlAction: true, okAction: () {
        NextPage().clearPages(
            context,
            Base(
              firstEntry: true,
            ));
      }, okText: "Create menu");
    }
  }

  logout() async {
    device = await deviceInfo.getInfo(context);
    Map data = {
      "user_id": PublicVar.userKitchlyID,
      "device_id": device['device_id'],
    };
    if (!PublicVar.onProduction) print(data);
    if (await Server()
        .postAction(bloc: appBloc, url: Urls.logOut, data: data)) {
      if (!PublicVar.onProduction) print(appBloc.mapSuccess);
      getOut();
    } else {
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
  }

  getOut() async {
    appBloc.hasOrders = false;
    appBloc.orders = [];
    appBloc.hasPendingOrder = false;
    appBloc.pendingOrders = [];
    appBloc.hasAcceptedOrder = false;
    appBloc.acceptedOrders = [];
    appBloc.hasRejectedOrder = false;
    appBloc.rejectedOrders = [];
    appBloc.hasReadyOrder = false;
    appBloc.readyOrders = [];
    appBloc.hasIntransitOrders = false;
    appBloc.inTransitOrders = [];
    appBloc.hasDeliveredOrder = false;
    appBloc.deliveredOrders = [];
    appBloc.hasCategory = false;
    appBloc.hasDish = false;
    appBloc.hasExtras = false;
    appBloc.hasMeals = false;
    appBloc.firstSyncedKitchen = false;
    await userDB.deleteAll();
    await SharedStore().removeData(key: 'firstMenu');
    await SharedStore().removeData(key: 'firstCategory');
    await SharedStore().removeData(key: 'firstExtra');
    await SharedStore().removeData(key: 'firstDish');
    await SharedStore().removeData(key: 'firstRegistration');
    await SharedStore().removeData(key: 'firstVerification');
    await SharedStore().removeData(key: 'accountApproved');
    await SharedStore().removeData(key: 'kitchenCreated');
    await SharedStore().removeData(key: 'kitchenHasDisplay');
    await SharedStore().removeData(key: 'kitchenHasAddress');
    await SharedStore().removeData(key: 'kitchenHasHours');
    await SharedStore().removeData(key: 'kitchenHasDelivery');
    await SharedStore().removeData(key: 'email');
    await SharedStore().removeData(key: 'cachedDish');
    await SharedStore().removeData(key: 'cachedKitchen');
    await SharedStore().removeData(key: 'cachedSummary');
    PublicVar.hasMenu = false;
    PublicVar.hasCategory = false;
    PublicVar.hasExtra = false;
    PublicVar.hasDish = false;
    PublicVar.isRegistration = false;
    PublicVar.isVerified = false;
    PublicVar.accountApproved = false;
    PublicVar.kitchenCreated = false;
    PublicVar.kitchenHasDisplay = false;
    PublicVar.kitchenHasDelivery = false;
    PublicVar.kitchenHasAddress = false;
    PublicVar.kitchenHasHours = false;
    PublicVar.userKitchlyID = null;
    PublicVar.kitchenID = null;
    PublicVar.firstName = null;
    PublicVar.lastName = null;
    PublicVar.userPhone = null;
    PublicVar.userEmail = null;
    setState(() {});
    NextPage().clearPages(context, SplashScreen());
  }

  tellFriend() {
    String shareText =
        "HEY.\n\n KITCHLY is an online Food Ordering system, focused on bringing local and private kitchens online, we believe that the best foods are cooked in our local kitchens. KITCHLY allow you to order and get food delivered to you from Kitchens nearby.\n \n Download and sign up with this link https://play.google.com/store/apps/details?id=${_packageInfo.packageName}";
    final RenderBox box = context.findRenderObject();
    // Share.share("$shareText",
    //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future<Null> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }
}
