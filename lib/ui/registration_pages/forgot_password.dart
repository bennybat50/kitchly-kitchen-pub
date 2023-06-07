import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

import 'login.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  GlobalKey<ScaffoldState> buttonKey = new GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController verifyController = TextEditingController();
  AppBloc appBloc;
  String _emailField, _verifyCode, _passField;
  int state = 0, networkStatus = 0;
  var dataUser;
  bool btnEnabled = true,
      completed = true,
      verify = false,
      _autoValidate = false,
      showLoading = false,
      showPassword = false;

  @override
  void initState() {
    emailController.text = PublicVar.userEmail ?? "";
    if (PublicVar.forGotStage == "1") {
      verify = false;
    } else if (PublicVar.forGotStage == "2") {
      verify = true;
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
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              if (!showLoading) {
                NextPage().clearPages(context, Login());
              }
            },
            icon: Icon(
              Ionicons.ios_close,
              size: 45,
              color: Colors.black,
            ),
          ),
          actions: [
            verify
                ? TextButton(
                    onPressed: () => setState(() => verify = false),
                    child: Text("Reset Email"))
                : SizedBox()
          ],
        ),
        body: Center(
          child: ListView(
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
    return Column(
      children: <Widget>[
        //CREATE ACCOUNT TEXT
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50, bottom: 10.0),
              child: Text(
                verify ? "Reset Your password" : "Forgot Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text(
                verify
                    ? "A Verification code has been sent to ${PublicVar.userEmail}. Please enter the verification code your new password in the fields below."
                    : "Please provide your registered email address",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        //CREATE ACCOUNT TEXT END

        formFields(),
        //CREATE ACCOUNT BTN
        Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: ButtonWidget(
              width: double.infinity,
              height: 50.0,
              loading: showLoading,
              onPress: () => validateFields(),
              txColor: Colors.white,
              bgColor: Color(PublicVar.primaryColor),
              text: verify ? 'Reset Password' : 'Verify Email',
            )),

        //ALREADY HAVE ACC

        // //ALREADY HAVE ACC END
      ],
    );
  }

  Widget formFields() {
    if (verify) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                autofocus: true,
                maxLength: 8,
                controller: verifyController,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w900),
                validator: Validation().validateCode,
                onSaved: (String val) {
                  _verifyCode = val;
                },
                decoration: InputDecoration(
                    labelText: 'Enter verification code',
                    labelStyle: TextStyle(fontSize: 15.0),
                    hintText: "- - - - -",
                    icon: Icon(
                      Feather.user_check,
                      size: 18.0,
                      color: Colors.black,
                    )),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      obscureText: showPassword,
                      style: TextStyle(letterSpacing: 1),
                      validator: validatePass,
                      onSaved: (String val) {
                        _passField = val;
                      },
                      decoration: InputDecoration(
                          labelText: 'Enter New Password',
                          labelStyle: TextStyle(letterSpacing: 0.1),
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
              )
            ],
          ));
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          controller: emailController,
          validator: Validation().email,
          onSaved: (String val) {
            _emailField = val;
          },
          decoration: InputDecoration(
              labelText: 'Enter Your Email Address',
              hintText: " Email ",
              icon: Icon(
                Feather.mail,
                size: 18.0,
                color: Colors.black,
              )),
        ),
      );
      //EMAIL TEXT END
    }
  }

  String validatePass(value) => Validation().password(value, 8);

  validateFields() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (verify) {
        verifyAccount();
      } else {
        sendCodeToEmail();
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  sendCodeToEmail() async {
    isLoading();
    Map data = {
      "email": "$_emailField",
    };

    if (await Server().postAction(
      bloc: appBloc,
      data: data,
      url: Urls.resendCode,
    )) {
      if (!PublicVar.onProduction) print(appBloc.mapSuccess);
      verify = true;
      AppActions().showAppDialog(context,
          title: "Email Verification",
          descp:
              "A Verification code has been sent to ${emailController.text}. Please enter the verification code and then your new password in the fields below.",
          okText: "OK",
          singlAction: true);
      PublicVar.forGotStage = '2';
      PublicVar.userEmail = emailController.text;
      await SharedStore()
          .setData(type: 'string', key: 'email', data: emailController.text);
      await SharedStore().setData(
          type: 'string', key: 'forGotStage', data: PublicVar.forGotStage);
      isLoading();
    } else {
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
      isLoading();
    }
  }

  verifyAccount() async {
    isLoading();
    Map data = {
      "email": PublicVar.userEmail,
      "code": int.parse(_verifyCode),
      "passwd": _passField
    };
    if (!PublicVar.onProduction) print(data);
    if (await Server().postAction(
      bloc: appBloc,
      data: data,
      url: Urls.resetPassword,
    )) {
      isLoading();
      if (!PublicVar.onProduction) print(appBloc.mapSuccess);
      AppActions().showAppDialog(
        context,
        title: 'Verify Email',
        descp:
            'Your password has reset successful,\n Please login with the new password you just created',
        okText: 'OK',
        okAction: () async {
          PublicVar.forGotStage = '1';
          await SharedStore()
              .setData(type: 'string', key: 'forGotStage', data: "1");
          Navigator.pop(context);
          Navigator.pop(context);
        },
        singlAction: true,
      );
    } else {
      isLoading();
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
  }

  isLoading() {
    setState(() {
      if (showLoading) {
        showLoading = false;
        btnEnabled = true;
      } else {
        showLoading = true;
        btnEnabled = false;
      }
    });
  }
}
