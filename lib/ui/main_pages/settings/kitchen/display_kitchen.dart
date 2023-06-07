import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayKitchen extends StatefulWidget {
  DisplayKitchen({Key key}) : super(key: key);

  @override
  _DisplayKitchenState createState() => _DisplayKitchenState();
}

class _DisplayKitchenState extends State<DisplayKitchen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(),
      _sheetScaffoldKey = GlobalKey();
  bool _autoValidate = false,
      loading = false,
      firstTime = false,
      onlineView1 = false,
      onlineView2 = false,
      onlineView3 = false,
      onlineView4 = false,
      onlineBanner = false,
      updateView1 = false,
      updateView2 = false,
      updateView3 = false,
      updateView4 = false,
      updateBanner = false,
      onlineData = false;
  Map device, app;
  File videoFile, videoThumb, bannerFile;
  var imageFiles = {
    'view1': "",
    'view2': "",
    'view3': "",
    'view4': "",
  };
  SharedPreferences prefs;
  AppBloc appBloc;
  String kitchenName, address;
  final formPadding = EdgeInsets.symmetric(vertical: 10.0, horizontal: 30);
  List _myActivities;
  String _myActivitiesResult, bannerUrl;
  final border = Radius.circular(15);
  double iconSize = 18.0;
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    if (PublicVar.accountApproved && !firstTime) {
      onlineView1 = true;
      onlineView2 = true;
      onlineView3 = true;
      onlineView4 = true;
      onlineBanner = true;
      onlineData = true;
      if (!PublicVar.onProduction) print(appBloc.kitchenDetails['views']);
      imageFiles['view1'] = appBloc.kitchenDetails['views']['1'];
      imageFiles['view2'] = appBloc.kitchenDetails['views']['2'];
      imageFiles['view3'] = appBloc.kitchenDetails['views']['3'];
      imageFiles['view4'] = appBloc.kitchenDetails['views']['4'];
      bannerUrl = appBloc.kitchenDetails['large'] ?? '';
      firstTime = true;
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Feather.arrow_left,
            size: 30,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Kitchen Gallery",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Provide other images of your kitchen",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                "1) Photos of your kitchen or foods you offer (4)*",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: formPadding,
              child: Center(
                child: Stack(alignment: Alignment.center, children: [
                  Column(children: [
                    Row(children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(1.0),
                          child: InkWell(
                            onTap: () => chooseImageSource(name: 'view1'),
                            child: Container(
                              alignment: Alignment.center,
                              height: 80,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20)),
                                  color: Colors.green,
                                  image: getFiles(
                                      imageUrl: imageFiles['view1'],
                                      onlineImages: onlineView1)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(1.0),
                          child: InkWell(
                            onTap: () => chooseImageSource(name: 'view2'),
                            child: Container(
                              alignment: Alignment.center,
                              height: 80,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20)),
                                  color: Colors.green,
                                  image: getFiles(
                                      imageUrl: imageFiles['view2'],
                                      onlineImages: onlineView2)),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Row(children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(1.0),
                          child: InkWell(
                            onTap: () => chooseImageSource(name: 'view3'),
                            child: Container(
                              alignment: Alignment.center,
                              height: 80,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20)),
                                  color: Colors.green,
                                  image: getFiles(
                                      imageUrl: imageFiles['view3'],
                                      onlineImages: onlineView3)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(1.0),
                          child: InkWell(
                            onTap: () => chooseImageSource(name: 'view4'),
                            child: Container(
                              alignment: Alignment.center,
                              height: 80,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20)),
                                  color: Colors.green,
                                  image: getFiles(
                                      imageUrl: imageFiles['view4'],
                                      onlineImages: onlineView4)),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ]),
                ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                "2) Kitchen Banner Image",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: formPadding,
              child: Center(
                child: InkWell(
                  onTap: () => chooseImageSource(name: 'banner'),
                  child: Container(
                    alignment: Alignment.center,
                    height: 200,
                    width: 450,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                        image: DecorationImage(
                            image: bannerFile == null
                                ? onlineBanner
                                    ? bannerUrl == null
                                        ? AssetImage(
                                            PublicVar.defaultKitchenImage)
                                        : NetworkImage(bannerUrl)
                                    : AssetImage(PublicVar.defaultKitchenImage)
                                : FileImage(bannerFile),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),

            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 15.0),
            //   child: Text(
            //     "2)  Half a minute (30 sec) video of your kitchen",
            //     textAlign: TextAlign.left,
            //     style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 16,
            //         fontWeight: FontWeight.w600),
            //   ),
            // ),
            // Padding(
            //   padding: formPadding,
            //   child: Center(
            //     child: Container(
            //         alignment: Alignment.center,
            //         height: 250,
            //         width: 450,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(20),
            //             color: Colors.green,
            //             image: DecorationImage(
            //                 image: videoThumb == null
            //                     ? AssetImage(
            //                         PublicVar.defaultKitchenImage,
            //                       )
            //                     : FileImage(videoThumb),
            //                 fit: BoxFit.cover)),
            //         child: Container(
            //           height: 60,
            //           width: 60,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(20),
            //             color: Colors.white,
            //           ),
            //           child: IconButton(
            //             icon: Icon(
            //               Icons.play_arrow,
            //               size: 40,
            //             ),
            //             color: Color(PublicVar.primaryColor),
            //             onPressed: () => videoThumb == null
            //                 ? chooseVideo()
            //                 : showVideoSheet(),
            //           ),
            //         )),
            //   ),
            // ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 50),
              child: ButtonWidget(
                onPress: () {
                  if (onlineData) {
                    // checkInternet();
                    checkFiles();
                  } else {
                    checkFiles();
                  }
                },
                width: double.infinity,
                fontSize: 20.0,
                height: 50.0,
                txColor: Colors.white,
                loading: loading,
                bgColor: Color(PublicVar.primaryColor),
                text: 'Update Kitchen',
              ),
            ),
            SizedBox(height: 500)
          ],
        ),
      ),
    );
  }

  getFiles({imageUrl, bool onlineImages}) {
    if (onlineImages) {
      return DecorationImage(
          image: imageUrl == '' || imageUrl == null
              ? AssetImage(PublicVar.defaultKitchenImage)
              : NetworkImage(imageUrl ?? ""),
          fit: BoxFit.cover);
    } else {
      return DecorationImage(
          image: imageUrl == '' || imageUrl == null
              ? AssetImage(PublicVar.defaultKitchenImage)
              : FileImage(File(imageUrl)),
          fit: BoxFit.cover);
    }
  }

  chooseImageSource({String name}) async {
    try {
      var imgFile;
      var img = await MediaPicker().selectFromPickers();
      if (img != null)
        imgFile = await CompressImage().compressAndGetFile(
            file: File(img), name: "upload_image", extention: ".jpg");
      switch (name) {
        case "view1":
          imageFiles['view1'] = imgFile.path;
          onlineView1 = false;
          updateView1 = true;
          break;
        case "view2":
          imageFiles['view2'] = imgFile.path;
          onlineView2 = false;
          updateView2 = true;
          break;
        case "view3":
          imageFiles['view3'] = imgFile.path;
          onlineView3 = false;
          updateView3 = true;
          break;
        case "view4":
          imageFiles['view4'] = imgFile.path;
          onlineView4 = false;
          updateView4 = true;
          break;
        case "banner":
          onlineBanner = false;
          updateBanner = true;
          bannerFile = imgFile;
          break;
      }
      setState(() {
        imageFiles = imageFiles;
      });
    } catch (e) {
      AppActions().showErrorToast(
        text: '${e.toString()}',
        context: context,
      );
    }
  }

  chooseVideo() async {
    try {
      var file = await MediaPicker().selectOneVideo();
      if (file != null) {
        setState(() {
          videoFile = File(file['videoPath']);
          videoThumb = File(file['thumbPath']);
        });
      }
    } catch (e) {
      AppActions().showErrorToast(
        text: '${e.toString()}',
        context: context,
      );
    }
  }

  checkFiles() async {
    if (imageFiles['view1'] == null) {
      AppActions().showErrorToast(
        text: 'Please you have to provide all four(4) images of your kitchen',
        context: context,
      );
    }
    if (imageFiles['view2'] == null) {
      AppActions().showErrorToast(
        text: 'Please you have to provide all four(4) images of your kitchen',
        context: context,
      );
    }
    if (imageFiles['view3'] == null) {
      AppActions().showErrorToast(
        text: 'Please you have to provide all four(4) images of your kitchen',
        context: context,
      );
    }
    if (imageFiles['view4'] == null) {
      AppActions().showErrorToast(
        text: 'Please you have to provide all four(4) images of your kitchen',
        context: context,
      );
    } else if (bannerFile == null && updateBanner) {
      AppActions().showErrorToast(
        text: 'Please you have to add a banner image for your kitchen',
        context: context,
      );
    }
    //  else if (videoFile == null) {
    //   AppActions().showErrorToast(
    //       text: 'Please you have to  show a 30-sec video of your kitchen');
    // }
    else {
      checkInternet();
    }
  }

  checkInternet() async {
    showLoading();
    if (await AppActions().checkInternetConnection()) {
      sendToServer();
    } else {
      showLoading();
      AppActions().showErrorToast(
        text: PublicVar.checkInternet,
        context: context,
      );
    }
  }

  sendToServer() async {
    Map data = {};
    if (!onlineView1 && updateView1)
      data.addAll({
        'view1': File(imageFiles['view1']),
      });
    if (!onlineView2 && updateView2)
      data.addAll({
        'view2': File(imageFiles['view2']),
      });
    if (!onlineView3 && updateView3)
      data.addAll({
        'view3': File(imageFiles['view3']),
      });
    if (!onlineView4 && updateView4)
      data.addAll({
        'view4': File(imageFiles['view4']),
      });
    if (updateBanner) data.addAll({'large': bannerFile});
    if (!PublicVar.onProduction) print(data);
    if (data.isNotEmpty) {
      if (await Server().uploadImg(
          url: Urls.getKitchens + '${PublicVar.kitchenID}/resources',
          appBloc: appBloc,
          data: data)) {
        await SharedStore()
            .setData(type: 'bool', data: true, key: 'kitchenHasDisplay');
        PublicVar.kitchenHasDisplay = true;
        await Server().queryKitchen(appBloc: appBloc);
        appBloc.kitchenDetails = appBloc.kitchenDetails;
        showLoading();
        AppActions().showSuccessToast(
          text: 'Display saved!',
          context: context,
        );
        Navigator.pop(context);
      } else {
        showLoading();
        AppActions().showErrorToast(
          text: "${appBloc.errorMsg}",
          context: context,
        );
      }
    } else {
      AppActions().showErrorToast(
        text: "Upload images before updating!",
        context: context,
      );
    }

    showLoading();
  }

  showLoading() {
    if (loading) {
      loading = false;
    } else {
      loading = true;
    }
    if (mounted) setState(() {});
  }

  showVideoSheet() {
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
              key: _sheetScaffoldKey,
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 4,
                              width: 100,
                              color: Colors.grey[300],
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 14.0),
                          child: Text(
                            'Choose an action',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.black.withOpacity(0.7)),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey[200],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Ionicons.ios_play,
                                  size: iconSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Play Video',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              playVideo();
                            },
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey[200],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Ionicons.ios_videocam,
                                  size: iconSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Change Video',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {
                              chooseVideo();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey[200],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w800),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey[200],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  playVideo() {
    NextPage().nextRoute(
        context,
        PlayVideo(
          online: false,
          url: videoFile.path,
        ));
  }
}
