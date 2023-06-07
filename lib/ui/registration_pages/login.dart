import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kitchly_chef/ui/main_pages/base.dart';
import 'package:kitchly_chef/ui/registration_pages/verification.dart';
import 'package:kitchlykitchendb/kitchlykitchendb.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_password.dart';
import 'register.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UsersDb userDB = UsersDb(databaseProvider: DatabaseProvider());
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _autoValidate = false, showPassword = true, loading = false;
  Map device, app;
  SharedPreferences prefs;
  AppBloc appBloc;
  String _emailField, _passField;
  final formPadding = EdgeInsets.symmetric(vertical: 15.0);
  final border = Radius.circular(15);
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white, // navigation bar color
        systemNavigationBarIconBrightness: Brightness.dark));
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            if (!loading) {
              Navigator.pop(context);
            }
          },
          icon: Icon(
            Ionicons.ios_close,
            size: 45,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "Welcome Back.",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "Securely login to your account",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: FormUI(),
            ),
          )
        ],
      ),
    );
  }

  Widget FormUI() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: formPadding,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator: Validation().email,
              autofocus: false,
              onSaved: (String val) {
                _emailField = val;
              },
              decoration: InputDecoration(
                  labelText: 'Email address',
                  labelStyle: TextStyle(letterSpacing: 0.1),
                  icon: Icon(
                    Feather.mail,
                    size: 18.0,
                    color: Colors.black,
                  )),
            ),
          ),
          Padding(
              padding: formPadding,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      autofocus: false,
                      obscureText: showPassword,
                      style: TextStyle(letterSpacing: 1),
                      validator: validatePass,
                      onEditingComplete: () {
                        if (!loading) {
                          _validateFields();
                        }
                      },
                      onSaved: (String val) {
                        _passField = val;
                      },
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(letterSpacing: 0.1),
                          helperText:
                              "Mininum of 8 characters. \n Password must contain at least\one capital letter e.g(A). \n Password must contain at least a digit e.g(1) \n Password must contain at least\none small letter e.g(a)",
                          icon: Icon(
                            Feather.lock,
                            size: 18.0,
                            color: Colors.black,
                          )),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (showPassword) {
                          showPassword = false;
                        } else {
                          showPassword = true;
                        }
                      });
                    },
                    icon: showPassword
                        ? Icon(Feather.eye_off)
                        : Icon(Feather.eye),
                    color: showPassword
                        ? Colors.grey
                        : Color(PublicVar.primaryColor),
                    iconSize: 18.0,
                  )
                ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    NextPage().nextRoute(context, ForgotPassword());
                  },
                  child: Text(
                    "Forgot Password?",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.black54),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            child: ButtonWidget(
              onPress: () {
                if (!loading) {
                  _validateFields();
                }
              },
              width: double.infinity,
              height: 50.0,
              txColor: Colors.white,
              bgColor: Color(PublicVar.primaryColor),
              loading: loading,
              text: "Login",
            ),
          ),
          TextButton(
              onPressed: () {
                if (!loading) {
                  NextPage().nextRoute(context, Registration());
                }
              },
              child: RichText(
                  text: TextSpan(
                      text: 'New here? ',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w600),
                      children: [
                    TextSpan(
                        text: "Create Account",
                        style: TextStyle(color: Color(PublicVar.primaryColor)))
                  ]))),
        ],
      ),
    );
  }

  String validatePass(value) => Validation().password(value, 7);
  showLoading() {
    if (loading) {
      loading = false;
    } else {
      loading = true;
    }
    setState(() {});
  }

  _validateFields() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      showLoading();
      device = await DeviceInfo().getInfo(context);
      app = await DeviceInfo().getPackageInfo();
      if (await AppActions().checkInternetConnection()) {
        sendToServer();
      } else {
        showLoading();
        AppActions().showErrorToast(
          text: PublicVar.checkInternet,
          context: context,
        );
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  sendToServer() async {
    Map data = {
      "email": "${_emailField.trim()}",
      "passwd": "${_passField.trim()}",
      "device": device,
      "app": app
    };
    if (await Server().postAction(url: Urls.login, data: data, bloc: appBloc)) {
      var res = appBloc.mapSuccess;
      if (res.toString().contains('UNVERIFIED_ACCOUNT')) {
        PublicVar.userEmail = "${_emailField.trim()}";
        AppActions().showAppDialog(context,
            title: 'Account Verification',
            descp:
                'Your kitchly account is not verified, Please verifiy account then login again',
            okText: 'Verify',
            cancleText: "Cancel", okAction: () {
          Navigator.pop(context);
          NextPage().nextRoute(
              context,
              Verification(
                reverify: true,
              ));
        });
      } else {
        PublicVar.getToken = res['token'];
        PublicVar.userKitchlyID = res['user_id'];
        PublicVar.firstName = res['first_name'];
        PublicVar.lastName = res['last_name'];
        PublicVar.userEmail = res['email'];
        PublicVar.userPhone = res['phone'];
        PublicVar.kitchenID = res['kitchen_id'];
        PublicVar.queryKitchenNoKey = {
          "nokey": {"kitchen_id": res['kitchen_id']},
          "token": res['token'],
        };
        PublicVar.queryKitchen = {
          "query": {"kitchen_id": res['kitchen_id']},
          "token": res['token'],
        };
        PublicVar.getOrderData['query']['kitchen_id'] = res['kitchen_id'];

        nextPage(res: res);
      }
    } else {
      showLoading();
      AppActions().showErrorToast(
        text: "${appBloc.errorMsg}",
        context: context,
      );
    }
  }

// Start Checking kitchen details
  nextPage({Map res}) async {
    await SharedStore()
        .setData(type: 'bool', data: true, key: 'firstRegistration');
    await SharedStore()
        .setData(type: 'bool', data: true, key: 'firstVerification');
    // Check if kitchen exists
    if (PublicVar.kitchenID != null && PublicVar.kitchenID != '') {
      await SharedStore()
          .setData(type: 'bool', data: true, key: 'kitchenCreated');
      PublicVar.kitchenCreated = true;
      await SharedStore()
          .setData(type: 'string', key: 'email', data: PublicVar.userEmail);
      PublicVar.userPass = _passField.trim();
      saveUserValues();
      // Check  kitchen details
      getKitchen();
    } else {
      showLoading();
      saveUserValues();
      NextPage().nextRoute(context, Base());
    }
  }

  saveUserValues() async {
    await userDB.deleteAll();
    await userDB.insert(UserDoa().fromMap({
      'kitchenId': PublicVar.kitchenID,
      'firstName': PublicVar.firstName,
      'lastName': PublicVar.lastName,
      'token': PublicVar.getToken,
      'userKitchlyID': PublicVar.userKitchlyID,
      'email': PublicVar.userEmail,
      'phone': PublicVar.userPhone,
      'password': PublicVar.userPass
    }));
  }

  // Check  kitchen details
  getKitchen() async {
    Map map = {
      "id": PublicVar.kitchenID,
      'token': PublicVar.getToken,
    };
    if (await Server().getKitchen(appBloc: appBloc, data: map)) {
      var alltrue = [], kData = appBloc.kitchenDetails;

      //Check if kitchens have display
      if (kData['large'] != '') {
        await SharedStore()
            .setData(type: 'bool', data: true, key: 'kitchenHasDisplay');
        PublicVar.kitchenHasDisplay = true;
        alltrue.add('1');
      }

      //Check if kitchens have Business Hours
      if (kData['openings'].length > 0) {
        await SharedStore()
            .setData(type: 'bool', data: true, key: 'kitchenHasHours');
        PublicVar.kitchenHasHours = true;
        alltrue.add('1');
      }

      //Check if kitchens have location
      if (kData['addr'] != '') {
        await SharedStore()
            .setData(type: 'bool', data: true, key: 'kitchenHasAddress');
        PublicVar.kitchenHasAddress = true;
        alltrue.add('1');
      }

      //Check if kitchens has set up delivery
      if (kData['delivery']['eat_in']['value'] != false &&
          kData['delivery']['self_pickup']['value'] != false &&
          kData['delivery']['shipment'].length > 0) {
        await SharedStore()
            .setData(type: 'bool', data: true, key: 'kitchenHasDelivery');
        PublicVar.kitchenHasDelivery = true;
        alltrue.add('1');
      }

      if (alltrue.length == 4) {
        await SharedStore()
            .setData(type: 'bool', data: true, key: 'accountApproved');
        PublicVar.accountApproved = true;
      }
      await getKitchenDatas();
      await getMenus();
      showLoading();
      NextPage().clearPages(context, Base());
    } else {
      showLoading();
      // NextPage().nextRoute(context, Base());
    }
  }

  getKitchenDatas() async {
    Map query = {
      "query": {"kitchen_id": PublicVar.kitchenID},
      'token': PublicVar.getToken,
    };
    await Server().queryKitchen(appBloc: appBloc);
    await Server().getDishes(appBloc: appBloc, data: query);
    await Server().getExtras(appBloc: appBloc, data: query);
  }

  getMenus() async {
    //GET PENDING ORDERS
    PublicVar.getOrderData['query']['status'] = "PENDING";
    await OrderServer()
        .getPendingOrders(appBloc: appBloc, data: PublicVar.getOrderData);
    //GET ACCEPTED ORDERS
    PublicVar.getOrderData['query']['status'] = "ACCEPTED";
    await OrderServer()
        .getAcceptedOrders(appBloc: appBloc, data: PublicVar.getOrderData);
    //GET READY ORDERS
    PublicVar.getOrderData['query']['status'] = "READY";
    await OrderServer()
        .getReadyOrders(appBloc: appBloc, data: PublicVar.getOrderData);
    //GET IN_TRANSIT ORDERS
    PublicVar.getOrderData['query']['status'] = "IN_TRANSIT";
    await OrderServer()
        .getIntransitOrders(appBloc: appBloc, data: PublicVar.getOrderData);
    //GET DELIVERED ORDERS
    PublicVar.getOrderData['query']['status'] = "DELIVERED";
    await OrderServer()
        .getDeliveredOrders(appBloc: appBloc, data: PublicVar.getOrderData);
    //GET REJECTED ORDERS
    PublicVar.getOrderData['query']['status'] = "REJECTED";
    await OrderServer()
        .getRejectedOrders(appBloc: appBloc, data: PublicVar.getOrderData);
  }
}
