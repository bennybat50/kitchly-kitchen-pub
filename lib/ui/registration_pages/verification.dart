import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kitchly_chef/ui/main_pages/base.dart';
import 'package:kitchly_chef/ui/registration_pages/login.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Verification extends StatefulWidget {
  final bool reverify;

  const Verification({Key key, this.reverify}) : super(key: key);
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  GlobalKey<ScaffoldState> buttonKey = new GlobalKey();

  TextEditingController _verifyController = new TextEditingController();
  //var dataBase = DatabaseHelpers(), dataUser;
  int networkStatus = 0;
  bool btnEnabled = true,
      _autoValidate = true,
      btnState = false,
      isVerify = false,
      reverify,
      loading = false;
  SharedPreferences prefs;
  String verification_code, reply, email;
  AppBloc appBloc;

  @override
  void initState() {
    _verifyController.addListener(onKeyChange);
    reverify = widget.reverify;
    if (reverify == null) {
      reverify = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        return btnEnabled;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: Center(
          child: ListView(
            physics: PageScrollPhysics(),
            children: <Widget>[
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: FormUI(),
                ),
              ),
              SizedBox(height: 200)
            ],
          ),
        ),
      ),
    );
  }

  Widget FormUI() {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        //CREATE ACCOUNT TEXT
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 40.0, bottom: 25.0),
                child: Text(
                  "Verify Your Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
        //CREATE ACCOUNT TEXT END

        //CREATE ACCOUNT TEXT
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                "Hi ${PublicVar.userName ?? ""}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(children: [
                Text(
                  "A Verification code has been sent to ${PublicVar.userEmail}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "\"Please check your inbox or spam\"",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ]),
            ),
          ],
        ),
        //CREATE ACCOUNT TEXT END

        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
            child: Container(
              child: TextFormField(
                keyboardType: TextInputType.number,
                autofocus: false,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w900),
                validator: validateCode,
                controller: _verifyController,
                maxLength: 6,
                onSaved: (String val) {
                  verification_code = val;
                },
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                  if (btnState) {
                    _validateFields();
                  } else {
                    AppActions().showErrorToast(
                      text: 'Please provide verification code',
                      context: context,
                    );
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Enter verification code',
                    labelStyle: TextStyle(fontSize: 15.0),
                    hintText: "- - - - - -",
                    icon: Icon(
                      Feather.user_check,
                      size: 18.0,
                      color: Colors.black,
                    )),
              ),
            )),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Didn't receive a code, or Code Expires ?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        TextButton(
          onPressed: () async {
            if (btnEnabled) {
              if (await AppActions().checkInternetConnection()) {
                resendCode();
              } else {
                AppActions().showErrorToast(
                  text: PublicVar.checkInternet,
                  context: context,
                );
              }
            }
          },
          child: Text(
            "Resend code",
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14.0),
          ),
        ),
        finishButton(),
      ],
    );
  }

  Widget finishButton() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        child: ButtonWidget(
          onPress: () {
            if (btnState) {
              _validateFields();
            } else {
              AppActions().showErrorToast(
                text: 'Please provide verification code',
                context: context,
              );
            }
          },
          width: double.infinity,
          height: 50.0,
          loading: loading,
          txColor: Colors.white,
          bgColor: btnState ? Color(PublicVar.primaryColor) : Colors.grey,
          text: 'Verify',
        ));
  }

  Widget btnChildState() {
    return loading
        ? SizedBox(height: 25.0, width: 25.0, child: ShowProcessingIndicator())
        : Text(
            "Verify Account",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600),
          );
  }

  onKeyChange() {
    String text = _verifyController.text;
    if (text.length == 6) {
      setState(() => btnState = true);
    } else {
      setState(() => btnState = false);
    }
  }

  String validateCode(String value) {
    if (value.length == 0) {
      return "Please enter a verification code";
    } else if (value.length <= 5 || value.length > 6) {
      return "6 digits only";
    } else {
      return null;
    }
  }

  _validateFields() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      showLoading();
      if (await AppActions().checkInternetConnection()) {
        verify();
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

  verify() async {
    FocusScope.of(context).unfocus();
    Map data = {
      "code": int.parse(verification_code),
      "email": PublicVar.userEmail,
    };
    var verified =
        await Server().postAction(bloc: appBloc, url: Urls.verify, data: data);
    if (verified) {
      if (!PublicVar.onProduction) print(appBloc.mapSuccess);
      if (reverify) {
        AppActions().showAppDialog(context,
            title: 'Verification Successful',
            descp: 'Your kitchly account has been verified, please login again',
            okText: 'Login',
            singlAction: true, okAction: () {
          Navigator.pop(context);
          NextPage().clearPages(context, Login());
        });
      } else {
        choosePage(page: Base());
      }
    } else {
      showLoading();
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
  }

  resendCode() async {
    AppActions().showLoadingToast(
      text: PublicVar.wait,
      context: context,
    );
    Map data = {
      "email": PublicVar.userEmail,
    };
    if (await Server()
        .postAction(bloc: appBloc, url: Urls.resendCode, data: data)) {
      if (!PublicVar.onProduction) print(appBloc.mapSuccess);
      AppActions().showAppDialog(
        context,
        title: 'Account Verification',
        descp: 'Verification code has been sent to ${PublicVar.userEmail}',
        okText: "Ok",
        singlAction: true,
      );
    } else {
      showLoading();
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
  }

  choosePage({page}) async {
    await SharedStore()
        .setData(type: 'bool', data: true, key: 'firstVerification');
    PublicVar.isVerified = true;
    showLoading();
    NextPage().clearPages(context, page);
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
