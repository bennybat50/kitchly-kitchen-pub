import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter/material.dart';
import 'package:menumodule/menumodule.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:intl/intl.dart';

class PackageDetails extends StatefulWidget {
  final packageIndex;
  PackageDetails({Key key, this.packageIndex}) : super(key: key);

  @override
  _PackageDetailsState createState() => _PackageDetailsState();
}

class _PackageDetailsState extends State<PackageDetails> {
  AppBloc appBloc = AppBloc();
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
              alignment: Alignment.center,
              child: GetImageProvider(
                height: 1200.0,
                placeHolder: PublicVar.defaultKitchenImage,
                url: appBloc.packages[widget.packageIndex]['image'],
              )),
          Positioned.fill(
            child: Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10.0,
                  sigmaY: 10.0,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                    Text(
                      "Package Details",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    IconButton(
                            onPressed: () => showMoreMenu(
                                  dix: widget.packageIndex,
                                ),
                            icon: Icon(
                              Icons.more_horiz_rounded,
                              color: Colors.white,
                            ))
                  ],
                ),
              )),
          Align(
              alignment: Alignment.center,
              child: GetImageProvider(
                placeHolder: PublicVar.defaultKitchenImage,
                url: appBloc.packages[widget.packageIndex]['image'],
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black,
                ],
              )),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    "${appBloc.packages[widget.packageIndex]['caption']}",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${appBloc.packages[widget.packageIndex]['descp']}",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Divider(
                    thickness: 0.7,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'], number: appBloc.packages[widget.packageIndex]['price'])}",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${getDateValue(appBloc.packages[widget.packageIndex]['start_date']??0)}  -  ${getDateValue(appBloc.packages[widget.packageIndex]['end_date']??0)}",
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String getDateValue(timestamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var day = date.day, year = date.year, month = date.month;
    return '$day/${getMonth(month)}/$year';
  }

  getMonth(data) {
    switch (data) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
  }

  askDeletePackage({
    dix,
  }) async {
    AppActions().showAppDialog(context,
        title: 'Delete Package?',
        descp:
            'Are you sure you want to delete ${appBloc.packages[dix]['caption']} from your special packages?',
        okText: "Delete",
        cancleText: "Cancel",
        danger: true,
        cancleAction: () => Navigator.pop(context),
        okAction: () async {
          Navigator.pop(context);
          if (await Server().deleteAction(
              bloc: appBloc,
              url: Urls.packageActions,
              data: {"dish_id": appBloc.packages[dix]['id']})) {
            appBloc.packages.removeAt(dix);
            appBloc.packages = appBloc.packages;
            AppActions().showSuccessToast(
              text: 'Package deleted',
              context: context,
            );
            Navigator.pop(context);
          } else {
            AppActions().showErrorToast(
              text: '${appBloc.errorMsg}',
              context: context,
            );
          }
        });
  }

  showMoreMenu({
    dix,
  }) async {
    AppActions().showAppDialog(
      context,
      title: 'More Actions',
      child: Column(
        children: [
          ListTile(
            title: Text("Go ${appBloc.packages[widget.packageIndex]['status']?"Offline <<":"Online >>"}",style: TextStyle(fontSize: 20),),
            trailing: Icon(Icons.remove_red_eye_rounded,color:appBloc.packages[widget.packageIndex]['status']? Colors.black:Colors.grey,),
            onTap: () {
              Navigator.pop(context);
              if (appBloc.packages[widget.packageIndex]['status']) {
                AppActions().showAppDialog(context,
                    title: 'Set Package Offline?',
                    descp:
                        'Your customers will not be able to see this packages, are you sure you want to take if offline?',
                    okText: "Confirm",
                    cancleText: "Cancel",
                    danger: true,
                    cancleAction: () => Navigator.pop(context),
                    okAction: () async {
                      changeActiveStatus(
                          pix: widget.packageIndex,
                          online: false,
                          packageId: appBloc.packages[widget.packageIndex]['id']);
                      Navigator.pop(context);
                    });
              } else {
                changeActiveStatus(pix: widget.packageIndex, online: true, packageId: appBloc.packages[widget.packageIndex]['id']);
              }
            },
          ),
           Divider(),
          ListTile(
            title: Text("Edit Package",style: TextStyle(fontSize: 20),),
            trailing: Icon(Icons.edit,color: Colors.black,),
            onTap: () {
              Navigator.pop(context);
              NextPage().nextRoute(
                  context,
                  PackagesAction(
                    update: true,
                    packageIndex: widget.packageIndex,
                    aPackage: appBloc.packages[widget.packageIndex],
                  ));
            },
          ),
          Divider(),
          ListTile(
            title: Text("Delete Package",style: TextStyle(fontSize: 20),),
            trailing: Icon(Icons.delete_forever,color: Colors.black,),
            onTap: () {
              Navigator.pop(context);
              askDeletePackage(dix: dix);
            },
          ),
        ],
      ),
      okText: "Cancel",
      singlAction: true,
    );
  }

  changeActiveStatus({pix, packageId, bool online}) async {
    if (await Server().putAction(
        bloc: appBloc,
        url: '${Urls.packageActions}/$packageId',
        data:{
          "caption":appBloc.packages[pix]['caption'],
          "kitchen_id":PublicVar.kitchenID,
          "start_date":appBloc.packages[pix]['start_date'],
          "end_date":appBloc.packages[pix]['end_date'],
          "continual":appBloc.packages[pix]['continual'],
          "active":online,
          "descp":appBloc.packages[pix]['descp'],
          "price":appBloc.packages[pix]['price']
        },)) {
      appBloc.packages[pix]['status'] = online;
      appBloc.packages = appBloc.packages;
      AppActions().showSuccessToast(
        text: online ? 'Package is online' : 'Packages is now offline',
        context: context,
      );
    } else {
      AppActions().showErrorToast(
        text: '${appBloc.errorMsg}',
        context: context,
      );
    }
  }
}
