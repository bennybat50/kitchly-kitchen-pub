import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

class RestEmail extends StatefulWidget {
  @override
  _RestEmailState createState() => _RestEmailState();
}

class _RestEmailState extends State<RestEmail> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  GlobalKey<ScaffoldState> buttonKey = new GlobalKey();
  TextEditingController emailController = TextEditingController();
  bool _autoValidate = false;

  String _emailField;
  int state = 0, networkStatus = 0;
  var dataUser;
  bool btnEnabled = true, completed = true, _reset = false;

  @override
  void initState() {
    // emailController.text=PublicVar.UserEmail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return btnEnabled;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Center(
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
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_backspace,
            color: Color(PublicVar.primaryColor),
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50, bottom: 10.0),
              child: Text(
                "Reset Your Email",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                "Please provide your email address and a verification code will be sent to you",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        //CREATE ACCOUNT TEXT END

        //EMAIL TEXT
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
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
        ),
        //EMAIL TEXT END

        //CREATE ACCOUNT BTN
        actionBtn(screenHeight)
        //CREATE ACCOUNT BTN END

        //ALREADY HAVE ACC

        // //ALREADY HAVE ACC END
      ],
    );
  }

  Widget actionBtn(screenHeight) {
    if (_reset) {
      return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "<<< Go Back",
          style:
              TextStyle(color: Color(PublicVar.primaryColor), fontSize: 18.0),
        ),
      );
    } else {
      return Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: ButtonWidget(
            onPress: () => _validateFields(),
            width: double.infinity,
            height: 50.0,
            txColor: Colors.white,
            bgColor: Color(PublicVar.primaryColor),
            child: buildButtonChild(),
          ));
    }
  }

  Widget buildButtonChild() {
    if (state == 0) {
      return Text('Reset Email',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600));
    } else if (state == 1) {
      return SizedBox(
          height: 25.0, width: 25.0, child: ShowProcessingIndicator());
    } else if (state == 2) {
      return Icon(
        Icons.check,
        color: Colors.white,
      );
    }
  }

  _validateFields() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      //sendToServer();
    } else {
      setState(() => _autoValidate = true);
    }
  }

//  sendToServer()async {
//    _isLoading();
//    Map data = {
//      "user_id":"${PublicVar.UserDoubletID}",
//      "email":"$_emailField",
//    };
//    var _msg, reset;
//     reset=await registrationBloc.resetEmail(data,Routes.RESETEMAIL);
//    if(reset){
//      alert.showIOSDialog(context, "Reset Successful", "Go back to verification page and use the new code sent to $_emailField", "OK");
//      PublicVar.UserEmail=_emailField;
//      setState(()=>_reset=true);
//      _stopLoading();
//    }else{
//      _msg = registrationBloc.errorMsg;
//      alert.showIOSDialog(context, "Reset Error", "${_msg.toString()} ", "OK");
//      _stopLoading();
//    }
//  }

  _stopLoading() {
    setState(() {
      state = 0;
      btnEnabled = true;
    });
  }

  _isLoading() {
    setState(() {
      state = 1;
      btnEnabled = false;
    });
  }
}
