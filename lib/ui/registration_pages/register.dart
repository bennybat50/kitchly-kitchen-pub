import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kitchly_chef/ui/main_pages/settings/terms.dart';
import 'package:kitchlykitchendb/kitchlykitchendb.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'verification.dart';

class Registration extends StatefulWidget {
  Registration({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  DeviceInfo deviceInfo = DeviceInfo();
  AppBloc appBloc;
  SharedPreferences prefs;
  Map device, app;
  bool _autoValidate = false, showPassword = true, loading = false;
  String _fNameField, _lNameField, _phoneField, _emailField, _passField;
  final formPadding = EdgeInsets.symmetric(vertical: 10.0);
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Ionicons.ios_close,
            size: 45,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: Text(
                "Tell Us About Yourself.",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                'This information will help us serve you better.',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: formUi(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget formUi() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: formPadding,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    validator: Validation().text,
                    textCapitalization: TextCapitalization.sentences,
                    onSaved: (String val) {
                      _fNameField = val;
                    },
                    decoration: InputDecoration(
                        labelText: 'First name',
                        icon: Icon(
                          Feather.user,
                          size: 18.0,
                          color: Colors.black,
                        )),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    style: TextStyle(fontWeight: FontWeight.w500),
                    validator: Validation().text,
                    textCapitalization: TextCapitalization.sentences,
                    onSaved: (String val) {
                      _lNameField = val;
                    },
                    decoration: InputDecoration(
                        labelText: 'Last name',
                        icon: Icon(
                          Feather.user,
                          size: 18.0,
                          color: Colors.black,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: formPadding,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              validator: Validation().email,
              onSaved: (String val) {
                _emailField = val;
              },
              decoration: InputDecoration(
                  labelText: 'Email address',
                  icon: Icon(
                    Feather.mail,
                    size: 18.0,
                    color: Colors.black,
                  )),
            ),
          ),
          Padding(
            padding: formPadding,
            child: TextFormField(
              keyboardType: TextInputType.phone,
              autofocus: false,
              validator: Validation().phone,
              onSaved: (String val) {
                _phoneField = val;
              },
              decoration: InputDecoration(
                  labelText: 'Phone number',
                  icon: Icon(
                    Feather.phone,
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
                      validator: validatePass,
                      obscureText: showPassword,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        if (!loading) {
                          _validateFields();
                        }
                      },
                      onSaved: (String val) {
                        _passField = val;
                      },
                      decoration: InputDecoration(
                          labelText: 'Password',
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            child: ButtonWidget(
              width: double.infinity,
              height: 50.0,
              onPress: () {
                if (!loading) {
                  _validateFields();
                }
              },
              txColor: Colors.white,
              bgColor: Color(PublicVar.primaryColor),
              text: "Create Account",
              loading: loading,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: InkWell(
              onTap: () {
                NextPage().nextRoute(context, TermsView());
              },
              child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "By clicking \"create account\", you agree to our",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          NextPage().nextRoute(context, TermsView());
                        },
                        child: Text("Terms and Conditions ",
                            style: TextStyle(color: Colors.blueGrey)),
                      ),
                    ],
                  )),
            ),
          ),
          TextButton(
            child: Text(
              "Already have an account?",
              style: TextStyle(color: Color(PublicVar.primaryColor)),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
        ],
      ),
    );
  }

  String validatePass(value) => Validation().password(value, 7);

  _validateFields() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      showLoading();
      device = await deviceInfo.getInfo(context);
      app = await deviceInfo.getPackageInfo();
      var connected = await AppActions().checkInternetConnection();
      if (connected) {
        sendToServer();
        // NextPage().nextRoute(context, Verification());
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
    //      "user_name":"$_fNameField $_lNameField",
    Map data = {
      "first_name": "${_fNameField.trim()}",
      "last_name": "${_lNameField.trim()}",
      "email": "${_emailField.trim()}",
      "phone": "${_phoneField.trim()}",
      "passwd": "${_passField.trim()}",
      "device": device,
      "app": app
    };
    if (!PublicVar.onProduction) print(Urls.create);
    var created = await Server().postAction(
      bloc: appBloc,
      data: data,
      url: Urls.create,
    );
    if (created && appBloc.mapSuccess['token'] != null) {
      if (!PublicVar.onProduction) print(appBloc.mapSuccess);
      var res = appBloc.mapSuccess;
      PublicVar.getToken = res['token'];
      PublicVar.userKitchlyID = res['user_id'];
      PublicVar.userEmail = res['email'];
      PublicVar.userPhone = res['phone'];
      PublicVar.firstName = "${_fNameField.trim()}";
      PublicVar.lastName = "${_lNameField.trim()}";
      showLoading();
      nextPage();
    } else {
      showLoading();
      AppActions().showErrorToast(
        text: "${appBloc.errorMsg}",
        context: context,
      );
    }
  }

  nextPage() async {
    await UsersDb(databaseProvider: DatabaseProvider())
        .insert(UserDoa().fromMap({
      'firstName': PublicVar.firstName,
      'lastName': PublicVar.lastName,
      'token': PublicVar.getToken,
      'userKitchlyID': PublicVar.userKitchlyID,
      'email': PublicVar.userEmail,
      'phone': PublicVar.userPhone,
      'password': _passField.trim()
    }));
    await SharedStore()
        .setData(type: 'bool', data: true, key: 'firstRegistration');
    await SharedStore()
        .setData(type: 'string', key: 'email', data: PublicVar.userEmail);
    PublicVar.isRegistration = true;
    PublicVar.accountApproved = false;
    NextPage().nextRoute(
        context,
        Verification(
          reverify: false,
        ));
  }

  showTermsDialog() {
    AppActions().showAppDialog(context,
        title: "Email Verification",
        descp: "",
        okText: "Accept",
        okAction: () {},
        cancleText: "Cancel",
        child: ListView(children: [Text("")]));
  }

  showLoading() {
    if (loading) {
      loading = false;
    } else {
      loading = true;
    }
    setState(() {});
  }
}
