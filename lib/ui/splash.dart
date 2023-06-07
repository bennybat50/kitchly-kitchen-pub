import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kitchly_chef/ui/registration_pages/forgot_password.dart';
import 'package:kitchlykitchendb/kitchlykitchendb.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

import 'infograph/infrograph.dart';
import 'main_pages/base.dart';
import 'registration_pages/verification.dart';

class SplashScreen extends StatefulWidget {
  //this.analytics, this.observer
  const SplashScreen({
    Key key,
  }) : super(key: key);

  // final FirebaseAnalytics analytics;
  // final FirebaseAnalyticsObserver observer;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppBloc appBloc;
  var page;

  @override
  void initState() {
    super.initState();
    checkStore();
  }

  checkStore() async {
    PublicVar.useServer = true;
    //await clearStore();
    PublicVar.hasMenu =
        await SharedStore().getData(type: 'bool', key: 'firstMenu');
    PublicVar.hasCategory =
        await SharedStore().getData(type: 'bool', key: 'firstCategory');
    PublicVar.hasExtra =
        await SharedStore().getData(type: 'bool', key: 'firstExtra');
    PublicVar.hasDish =
        await SharedStore().getData(type: 'bool', key: 'firstDish');
    PublicVar.hasPackages =
        await SharedStore().getData(type: 'bool', key: 'firstPackage');
    PublicVar.isRegistration =
        await SharedStore().getData(type: 'bool', key: 'firstRegistration');
    PublicVar.isVerified =
        await SharedStore().getData(type: 'bool', key: 'firstVerification');
    PublicVar.accountApproved =
        await SharedStore().getData(type: 'bool', key: 'accountApproved');
    PublicVar.kitchenCreated =
        await SharedStore().getData(type: 'bool', key: 'kitchenCreated');
    PublicVar.kitchenHasDisplay =
        await SharedStore().getData(type: 'bool', key: 'kitchenHasDisplay');
    PublicVar.kitchenHasAddress =
        await SharedStore().getData(type: 'bool', key: 'kitchenHasAddress');
    PublicVar.kitchenHasHours =
        await SharedStore().getData(type: 'bool', key: 'kitchenHasHours');
    PublicVar.kitchenHasDelivery =
        await SharedStore().getData(type: 'bool', key: 'kitchenHasDelivery');
    PublicVar.forGotStage =
        await SharedStore().getData(type: 'string', key: 'forGotStage');
    PublicVar.userEmail =
        await SharedStore().getData(type: 'string', key: 'email');
    if (PublicVar.hasMenu == null) PublicVar.hasMenu = false;
    if (PublicVar.hasCategory == null) PublicVar.hasCategory = false;
    if (PublicVar.hasExtra == null) PublicVar.hasExtra = false;
    if (PublicVar.hasDish == null) PublicVar.hasDish = false;
    if (PublicVar.hasPackages == null) PublicVar.hasPackages = false;
    if (PublicVar.isRegistration == null) PublicVar.isRegistration = false;
    if (PublicVar.isVerified == null) PublicVar.isVerified = false;
    if (PublicVar.accountApproved == null) PublicVar.accountApproved = false;
    if (PublicVar.kitchenCreated == null) PublicVar.kitchenCreated = false;
    if (PublicVar.kitchenHasDisplay == null)
      PublicVar.kitchenHasDisplay = false;
    if (PublicVar.kitchenHasAddress == null)
      PublicVar.kitchenHasAddress = false;
    if (PublicVar.kitchenHasHours == null) PublicVar.kitchenHasHours = false;
    if (PublicVar.kitchenHasDelivery == null)
      PublicVar.kitchenHasDelivery = false;
    if (PublicVar.forGotStage == null) PublicVar.forGotStage = '1';
    if (PublicVar.userEmail == null) PublicVar.userEmail = '';
    //appBloc.kitchenDetails['opened_for_order'] = false;
    getDbData();
  }

  getDbData() async {
    UsersDb userDB = UsersDb(databaseProvider: DatabaseProvider());
    //userDB.deleteAll();
    var data = await userDB.getData(1);
    if (!PublicVar.onProduction) print("DB_ID$data");
    if (data != null) {
      PublicVar.firstName = data.firstName;
      PublicVar.lastName = data.lastName;
      PublicVar.getToken = data.token;
      PublicVar.userKitchlyID = data.userKitchlyID;
      PublicVar.userEmail = data.email;
      PublicVar.userPhone = data.phone;
      PublicVar.kitchenID = data.kitchenId;
      if (!PublicVar.onProduction)
        print("${PublicVar.kitchenID}=======${PublicVar.userKitchlyID}");
    }
    switchPages();
  }

  switchPages() async {
    bool home;
    if (PublicVar.isRegistration && PublicVar.isVerified) {
      page = Base();
      home = true;
    } else if (PublicVar.isRegistration && !PublicVar.isVerified) {
      page = Verification();
      home = false;
    } else {
      home = false;
      if (PublicVar.forGotStage == '2') {
        page = ForgotPassword();
      } else {
        page = InfoGraph(); //DisplayKitchen InfoGraph Profile
      }
    }
    //getCountriesData();
    if (home == false) {
      Timer(Duration(seconds: 6), () => NextPage().clearPages(context, page));
    } else {
      NextPage().clearPages(context, page);
      await syncServer();
    }
  }

  syncServer() async {
    if (PublicVar.accountApproved &&
        await AppActions().checkInternetConnection()) {
      await Server().queryKitchen(appBloc: appBloc)
          ? appBloc.firstSyncedKitchen = true
          : appBloc.firstSyncedKitchen = false;
      await Future.wait([
        OrderServer().getAllOrders(appBloc: appBloc),
        Server().getDishes(appBloc: appBloc, data: PublicVar.queryKitchen),
        Server().getExtras(appBloc: appBloc, data: PublicVar.queryKitchen),
        Server().getPackages(appBloc: appBloc, data: PublicVar.queryKitchen),
        Server().getMeals(appBloc: appBloc),
        Server().getDurations(appBloc: appBloc),
      ]);
      if (mounted) setState(() {});
    } else {
      if (PublicVar.accountApproved)
        AppActions()
            .showErrorToast(text: PublicVar.checkInternet, context: context);
    }
  }

  getCountriesData() async {
    Map data = {
      "query": {"country": "all"}
    };
    var received = await Server()
        .postAction(bloc: appBloc, url: Urls.getCountries, data: data);
    if (received) {
      appBloc.countries = appBloc.mapSuccess;
    }
  }

  Future clearStore() async {
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
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo_long.png',
                    height: 40,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Kitchen',
                    style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 15,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 28.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'From',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 11),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Rework Technologies',
                        style: TextStyle(
                            color: Color(PublicVar.primaryColor),
                            fontWeight: FontWeight.w500,
                            fontSize: 12),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
