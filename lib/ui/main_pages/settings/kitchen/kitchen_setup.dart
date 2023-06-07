import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kitchly_chef/ui/main_pages/settings/kitchen/add_kitchen.dart';
import 'package:kitchly_chef/ui/main_pages/settings/kitchen/display_kitchen.dart';
import 'package:kitchly_chef/ui/registration_pages/login.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/utils/sharedStore.dart';
import '../../base.dart';
import 'kitchen_address.dart';
import 'kitchen_delivery.dart';
import 'kitchen_time.dart';
import 'package:provider/provider.dart';

class KitchenSetup extends StatefulWidget {
  @override
  _KitchenSetupState createState() => _KitchenSetupState();
}

class _KitchenSetupState extends State<KitchenSetup> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  double deviceHeight, deviceWidth, deviceFont;
  AppBloc appBloc;
  bool loading=false;
  var testStyle;
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    deviceFont = deviceHeight * 0.01;
    testStyle = TextStyle(fontSize: 2.7 * deviceFont);
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
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                'Kitchen Settings',
                style: TextStyle(
                    fontSize: 4.4 * deviceFont, fontWeight: FontWeight.w700),
              ),
            ),
            ListTile(
              leading: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black),
                child: Text(
                  '1',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Row(
                children: <Widget>[
                  Text(
                    PublicVar.accountApproved
                        ? 'Update Kitchen'
                        : 'Create Kitchen',
                  )
                ],
              ),
              onTap: () {
                NextPage().nextRoute(context, AddKitchen());
              },
              trailing: PublicVar.kitchenCreated
                  ? Icon(
                      PublicVar.accountApproved
                          ? Ionicons.ios_settings
                          : Feather.check_circle,
                      color: Color(PublicVar.primaryColor),
                    )
                  : Icon(
                      Feather.info,
                      color: Colors.red,
                    ),
            ),
            Divider(),
            ListTile(
              leading: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black),
                child: Text(
                  '2',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                'Gallery',
              ),
              onTap: () {
                if (PublicVar.kitchenCreated) {
                  NextPage().nextRoute(context, DisplayKitchen());
                } else {
                  AppActions().showErrorToast(
                    text: 'Please Create your kitchen first',
                    context: context,
                  );
                }
              },
              trailing: PublicVar.kitchenHasDisplay
                  ? Icon(
                      PublicVar.accountApproved
                          ? Ionicons.ios_settings
                          : Feather.check_circle,
                      color: Color(PublicVar.primaryColor),
                    )
                  : Icon(
                      Feather.info,
                      color: Colors.red,
                    ),
            ),
            Divider(),
            ListTile(
              leading: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black),
                child: Text(
                  '3',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text('Location'),
              onTap: () {
                if (PublicVar.kitchenCreated) {
                  NextPage().nextRoute(context, KitchenAddress());
                } else {
                  AppActions().showErrorToast(
                    text:
                        'Please create your kitchen first then include few images in gallery.',
                    context: context,
                  );
                }
              },
              trailing: PublicVar.kitchenHasAddress
                  ? Icon(
                      PublicVar.accountApproved
                          ? Ionicons.ios_settings
                          : Feather.check_circle,
                      color: Color(PublicVar.primaryColor),
                    )
                  : Icon(
                      Feather.info,
                      color: Colors.red,
                    ),
            ),
            Divider(),
            ListTile(
              leading: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black),
                child: Text(
                  '4',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text('Working Hours'),
              onTap: () {
                if (PublicVar.kitchenCreated) {
                  NextPage().nextRoute(
                      context,
                      KitchenTime(
                        onlineTime: appBloc.kitchenDetails['openings'],
                      ));
                } else {
                  AppActions().showErrorToast(
                    text: 'Please Create your kitchen first',
                    context: context,
                  );
                }
              },
              trailing: PublicVar.kitchenHasHours
                  ? Icon(
                      PublicVar.accountApproved
                          ? Ionicons.ios_settings
                          : Feather.check_circle,
                      color: Color(PublicVar.primaryColor),
                    )
                  : Icon(
                      Feather.info,
                      color: Colors.red,
                    ),
            ),
            Divider(),
            ListTile(
              leading: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black),
                child: Text(
                  '5',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text('Set-up Delivery'),
              onTap: () {
                if (PublicVar.kitchenCreated) {
                  NextPage().nextRoute(context, KitchenDelivery());
                } else {
                  AppActions().showErrorToast(
                    text: 'Please Create your kitchen first',
                    context: context,
                  );
                }
              },
              trailing: PublicVar.kitchenHasDelivery
                  ? Icon(
                      PublicVar.accountApproved
                          ? Ionicons.ios_settings
                          : Feather.check_circle,
                      color: Color(PublicVar.primaryColor),
                    )
                  : Icon(
                      Feather.info,
                      color: Colors.red,
                    ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}

class KitchenSettings extends StatefulWidget {
  @override
  _KitchenSettingsState createState() => _KitchenSettingsState();
}

class _KitchenSettingsState extends State<KitchenSettings> {
  AppBloc appBloc;
bool loading=false;
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceFont = deviceHeight * 0.01;
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey[300],
                offset: Offset(1.0, 1.0),
                blurRadius: 30.0,
              ),
            ],
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Ionicons.ios_settings,
                        color: Color(PublicVar.primaryColor),
                        size: 15,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: (){
                          NextPage().nextRoute(context, Login());
                        },
                                              child: Text(
                          'Kitchen Setup',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'Please set up your kitchen account so you can start receiving orders',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black),
                child: Text(
                  '1',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Row(
                children: <Widget>[
                  Text(PublicVar.accountApproved
                      ? 'Update Kitchen'
                      : 'Create Kitchen')
                ],
              ),
              onTap: () {
                NextPage().nextRoute(context, AddKitchen());
              },
              trailing: PublicVar.kitchenCreated
                  ? Icon(
                      PublicVar.accountApproved
                          ? Ionicons.ios_settings
                          : Feather.check_circle,
                      color: Color(PublicVar.primaryColor),
                    )
                  : Icon(
                      Feather.info,
                      color: Colors.red,
                    ),
            ),
            Divider(),
            ListTile(
              leading: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black),
                child: Text(
                  '2',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text('Kitchen Gallery'),
              onTap: () {
                if (PublicVar.kitchenCreated) {
                  NextPage().nextRoute(context, DisplayKitchen());
                } else {
                  AppActions().showErrorToast(
                    text: 'Please complete kitchen creation',
                    context: context,
                  );
                }
              },
              trailing: PublicVar.kitchenHasDisplay
                  ? Icon(
                      PublicVar.accountApproved
                          ? Ionicons.ios_settings
                          : Feather.check_circle,
                      color: Color(PublicVar.primaryColor),
                    )
                  : Icon(
                      Feather.info,
                      color: Colors.red,
                    ),
            ),
            Divider(),
            ListTile(
              leading: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black),
                child: Text(
                  '3',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text('Location'),
              onTap: () {
                if (PublicVar.kitchenCreated && PublicVar.kitchenHasDisplay) {
                  NextPage().nextRoute(context, KitchenAddress());
                } else {
                  AppActions().showErrorToast(
                    text: 'Please complete kitchen creation and gallery setup',
                    context: context,
                  );
                }
              },
              trailing: PublicVar.kitchenHasAddress
                  ? Icon(
                      PublicVar.accountApproved
                          ? Ionicons.ios_settings
                          : Feather.check_circle,
                      color: Color(PublicVar.primaryColor),
                    )
                  : Icon(
                      Feather.info,
                      color: Colors.red,
                    ),
            ),
            Divider(),
            ListTile(
              leading: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black),
                child: Text(
                  '4',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text('Working Hours'),
              onTap: () {
                if (PublicVar.kitchenCreated &&
                    PublicVar.kitchenHasDisplay &&
                    PublicVar.kitchenHasAddress) {
                  NextPage().nextRoute(context, KitchenTime());
                } else {
                  AppActions().showErrorToast(
                    text:
                        'Please complete kitchen creation, gallery setup, and location',
                    context: context,
                  );
                }
              },
              trailing: PublicVar.kitchenHasHours
                  ? Icon(
                      Feather.check_circle,
                      color: Color(PublicVar.primaryColor),
                    )
                  : Icon(
                      Feather.info,
                      color: Colors.red,
                    ),
            ),
            Divider(),
            ListTile(
              leading: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black),
                child: Text(
                  '5',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                  '${PublicVar.kitchenHasDelivery ? 'Update Delivery' : 'Set-up Delivery'}'),
              onTap: () {
                if (PublicVar.kitchenCreated) {
                  NextPage().nextRoute(context, KitchenDelivery());
                } else {
                  AppActions().showErrorToast(
                    text: 'Please Create your kitchen first',
                    context: context,
                  );
                }
              },
              trailing: PublicVar.kitchenHasDelivery
                  ? Icon(
                      Feather.check_circle,
                      color: Color(PublicVar.primaryColor),
                    )
                  : Icon(
                      Feather.info,
                      color: Colors.red,
                    ),
            ),
            Divider(),
            completeWidget(context),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  completeWidget(context) {
    if (PublicVar.kitchenCreated &&
        PublicVar.kitchenHasDisplay &&
        PublicVar.kitchenHasAddress &&
        PublicVar.kitchenHasHours &&
        PublicVar.kitchenHasDelivery &&
        !PublicVar.accountApproved) {
      return ListTile(
          title: Text(
            loading?PublicVar.wait:'Click to complete kitchen setup',
            style: TextStyle(color: Colors.blue, fontSize: 18),
          ),
          onTap: () {
            if (PublicVar.kitchenCreated) {
              checkSetups(context);
            } else {
              AppActions().showErrorToast(
                text: 'Please Create your kitchen first',
                context: context,
              );
            }
          },
          trailing: Icon(
            Feather.log_out,
            color: Color(PublicVar.primaryColor),
          ));
    } else {
      return SizedBox();
    }
  }

  checkSetups(context){
    if(!PublicVar.kitchenHasDisplay){
      AppActions().showErrorToast(text: "Please add images to your gallery",context: context,);
      Navigator.pop(context);
    }else if(!PublicVar.kitchenHasHours){
      AppActions().showErrorToast(text: "Please provide your opening and closing hours",context: context,);
      Navigator.pop(context);
    }else if(!PublicVar.kitchenHasAddress){
      AppActions().showErrorToast(text: "Please provide your kitchen address",context: context,);
      Navigator.pop(context);
    }else {
       finishDelivery(context);
    }
  }

  finishDelivery(context)async {
    await Server().queryKitchen(appBloc: appBloc);
    appBloc.kitchenDetails = appBloc.kitchenDetails;
    await SharedStore().setData(type: 'bool', data: true, key: 'accountApproved');
    PublicVar.accountApproved = true;
    showLoading();
     AppActions().showSuccessToast(text:'Kitchen setup completed! \nYou can start by creating your menus then open your kitchen for business',context: context,);
     NextPage().clearPages(context, Base(firstEntry: true,));
  }

   showLoading() {
    if (loading) {
      loading = false;
    } else {
      loading = true;
    }
   if(mounted) setState(() {});
  }
}
