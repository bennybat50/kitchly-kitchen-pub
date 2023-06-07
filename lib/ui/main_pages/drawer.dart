import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ordermodule/ordermodule.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settings/account.dart';
import 'settings/feedback.dart';
import 'settings/settings.dart';
import 'settings/terms.dart';

class KitchlyDrawer extends StatefulWidget {
  @override
  _KitchlyDrawerState createState() => _KitchlyDrawerState();
}

class _KitchlyDrawerState extends State<KitchlyDrawer> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  CapitalizeText capitalizeText = CapitalizeText();
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  AppBloc appBloc;
  //DynamicLinksService dynamicLinksService = DynamicLinksService();
  @override
  void initState() {
    _initPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceFont = deviceHeight * 0.01;
    double iconSize = 3.0 * deviceFont, fontSize = 2.2 * deviceFont;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: deviceHeight * 0.03,
            ),
            ListTile(
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Account()));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: deviceHeight * 0.20,
                      width: deviceWidth * 0.16,
                      child: GetImageProvider(
                        url: appBloc.kitchenDetails['profile'],
                        placeHolder: PublicVar.defaultKitchenImage,
                      ),
                    ),
                  )),
              title: Text(
                "${capitalizeText.capitalize(appBloc.kitchenDetails['kitchen_name'] ?? "User Name")}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 2.2 * deviceFont,
                    fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "@${capitalizeText.capitalize(appBloc.kitchenDetails['username'] ?? "User name")}",
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 1.9 * deviceFont,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // ListTile(
                  //   leading: Icon(
                  //     Ionicons.ios_wallet,
                  //     color: Colors.black87,
                  //     size: iconSize,
                  //   ),
                  //   title: Text(
                  //     "My Wallet",
                  //     style: TextStyle(fontSize: fontSize),
                  //   ),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  ListTile(
                    leading: Icon(
                      Icons.dashboard,
                      color: Colors.black87,
                      size: iconSize,
                    ),
                    title: Text(
                      "Order Summary",
                      style: TextStyle(fontSize: fontSize),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      NextPage().nextRoute(context, OrderSummary());
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Ionicons.ios_card,
                      color: Colors.black87,
                      size: iconSize,
                    ),
                    title: Text(
                      "My Earnings",
                      style: TextStyle(fontSize: fontSize),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      NextPage().nextRoute(
                          context,
                          EarningView(
                            single: true,
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Ionicons.ios_settings,
                      color: Colors.black87,
                      size: iconSize,
                    ),
                    title: Text(
                      "Settings",
                      style: TextStyle(fontSize: fontSize),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      NextPage().nextRoute(context, Settings());
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Ionicons.ios_help_circle,
                      color: Colors.black87,
                      size: iconSize,
                    ),
                    title: Text(
                      "Send FeedBack",
                      style: TextStyle(fontSize: fontSize),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      NextPage().nextRoute(context, FeedBackPage());
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Ionicons.ios_information_circle,
                      color: Colors.black87,
                      size: iconSize,
                    ),
                    title: Text(
                      "Terms & Privacy",
                      style: TextStyle(fontSize: fontSize),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      NextPage().nextRoute(context, TermsView());
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Ionicons.ios_call,
                      color: Colors.black87,
                      size: iconSize,
                    ),
                    title: Text(
                      "Call Support",
                      style: TextStyle(fontSize: fontSize),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      callSupport();
                    },
                  ),

                  ListTile(
                    leading: Icon(
                      Ionicons.ios_share_alt,
                      color: Colors.black87,
                      size: iconSize,
                    ),
                    title: Text(
                      "Tell A Friend",
                      style: TextStyle(fontSize: fontSize),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      tellFriend();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonWidget(
        onPress: () => goToKitchlyAPP(),
        radius: 0.0,
        fontSize: 16.0,
        height: 40.0,
        txColor: Colors.white,
        bgColor: Color(PublicVar.primaryColor),
        text: 'Order Food ? Use client app',
      ),
    );
  }

  callSupport() async {
    var url = "tel:07036326018";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  goToWebsite() async {
    await launch('http://www.reworktechnologies.com/');
  }

  goToKitchlyAPP() async {
    await launch('https://play.google.com/store/apps/details?id=com.kitchly');
  }

  tellFriend() async {
    // var link = await dynamicLinksService.createDynamicLink(
    //     link: 'https://kitchly.co/kitchen',
    //     surfix: 'https://kitchlychef.page.link',
    //     packageName: 'com.kitchly_chef');
    // String shareText =
    //     "Hi there!.\n\n ${PublicVar.firstName.toUpperCase() ?? ""} ${PublicVar.lastName.toUpperCase() ?? ""} has invited you to order your meals on KITCHLY. \nIt's and app that allows you to order and get food delivered to you from Kitchens nearby.\n \n Download and sign up with this link $link";
    // final RenderBox box = context.findRenderObject();
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
