import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:providermodule/providermodule.dart';

import 'widgets/global-widgets.dart';

class AppActions {
  showSuccessToast({String text, BuildContext context}) {
    showAppToast(context: context, color: Colors.black, text: text);
  }

  showErrorToast({String text, BuildContext context}) {
    showAppToast(context: context, color: Colors.redAccent, text: text);
  }

  showLoadingToast({String text, BuildContext context}) {
    showAppToast(context: context, color: Colors.black, text: text);
  }

  showAppToast({color, String text, BuildContext context}) {
    try {
      showToast(text,
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.bottom,
          backgroundColor: color,
          toastHorizontalMargin: 20,
          duration: Duration(seconds: 5),
          curve: Curves.bounceInOut,
          reverseCurve: Curves.easeInOutCubic);
    } catch (e) {}
  }

  Future<bool> checkInternetConnection() async {
    bool internet;
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(Duration(seconds: 10));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internet = true;
      }
    } on SocketException catch (e) {
      internet = false;
    }
    return internet;
  }

  showDeleteSheet({context, scaffold, text, accept, deny}) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return Scaffold(
              key: scaffold,
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 18.0, bottom: 10, left: 20, right: 20),
                          child: Text(
                            text,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: ButtonWidget(
                                onPress: deny,
                                width: 100.0,
                                height: 35.0,
                                txColor: Colors.white,
                                bgColor: Colors.redAccent,
                                text: 'Cancel',
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: ButtonWidget(
                                onPress: accept,
                                width: 100.0,
                                height: 35.0,
                                txColor: Colors.white,
                                bgColor: Color(PublicVar.primaryColor),
                                text: 'Save',
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  showAppDialog(context,
      {Function okAction,
      cancleAction,
      editAction,
      String title,
      descp,
      cancleText,
      okText,
      bool singlAction,
      danger,
      normal,
      topClose,
      topEdit,
      Widget child}) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceFont = deviceHeight * 0.01;
    if (singlAction == null) {
      singlAction = false;
    }
    if (danger == null) {
      danger = false;
    }
    if (normal == null) {
      normal = false;
    }
    if (topClose == null) {
      topClose = false;
    }
    if (topEdit == null) {
      topEdit = false;
    }
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 50,
                    height: MediaQuery.of(context).size.height * 0.70,
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 38.0),
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20)),
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    topClose
                                        ? InkWell(
                                            onTap: () => Navigator.pop(context),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.black,
                                                    child: Icon(Icons.close,
                                                        size: 15,
                                                        color: Colors.white)),
                                              ),
                                            ))
                                        : SizedBox(),
                                    Expanded(
                                        child: Text(title ?? "",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold))),
                                    topEdit
                                        ? InkWell(
                                            onTap: editAction,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(Feather.edit_2,
                                                  size: 20,
                                                  color: Colors.black),
                                            ))
                                        : SizedBox()
                                  ],
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.01,
                                ),
                                Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: deviceWidth * 0.03),
                                        child: Text(
                                          "${descp ?? ""}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black87
                                                  .withOpacity(0.8)),
                                        ),
                                      ),
                                      SizedBox(
                                  height: deviceHeight * 0.01,
                                ),
                                child == null
                                    ? SizedBox()
                                    : child,
                                Divider(),
                                singlAction
                                    ? TextButton(
                                        onPressed: okAction ??
                                            () => Navigator.pop(context),
                                        child: Text(
                                          okText ?? "",
                                          style: TextStyle(
                                              color: danger
                                                  ? Colors.redAccent
                                                  : Colors.black,
                                              fontSize: 2.2 * deviceFont,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          TextButton(
                                            onPressed: cancleAction ??
                                                () => Navigator.pop(context),
                                            child: Text(
                                              cancleText ?? "",
                                              style: TextStyle(
                                                  color: danger
                                                      ? Colors.black
                                                      : normal?Colors.black:Colors.redAccent,
                                                  fontSize: 2.2 * deviceFont,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: okAction ??
                                                () => Navigator.pop(context),
                                            child: Text(
                                              okText ?? "",
                                              style: TextStyle(
                                                  color: danger
                                                      ? Colors.redAccent
                                                      : Colors.black,
                                                  fontSize: 2.2 * deviceFont,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
                                      )
                              ]),
                        ),
                      ),
                    )),
                  ),
                ),
              );
            },
          );
        });
  }
}
