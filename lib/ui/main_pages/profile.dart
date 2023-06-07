import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kitchly_chef/ui/main_pages/settings/account.dart';
import 'package:kitchly_chef/ui/main_pages/settings/kitchen/add_kitchen.dart';
import 'package:kitchly_chef/ui/main_pages/settings/kitchen/display_kitchen.dart';
import 'package:kitchly_chef/ui/main_pages/settings/kitchen/kitchen_address.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';
// import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settings/kitchen/kitchen_setup.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.scaffoldKey}) : super(key: key);

  final scaffoldKey;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>
    with SingleTickerProviderStateMixin<Profile> {
  bool activeKitchen = false, firstTime = false;
  AppBloc appBloc = AppBloc();
  int currentIndex = 0;
  double iconSize = 18.0, deviceHeight, deviceWidth, deviceFont;

  final titleStyle =
      TextStyle(fontWeight: FontWeight.w700, color: Colors.black45);

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  //DynamicLinksService dynamicLinksService = DynamicLinksService();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(),
      sheetScaffoldKey = new GlobalKey();

  @override
  void initState() {
    _initPackageInfo();
    super.initState();
  }

  Widget aboutTab() {
    return Column(
      children: <Widget>[
        // ListTile(
        //   onTap: () => goToAccount(),
        //   leading: Text(
        //     'Name',
        //     style: titleStyle,
        //   ),
        //   title:
        //       Text('${PublicVar.firstName ?? ""} ${PublicVar.lastName ?? ""}'),
        //   trailing: Icon(
        //     Feather.edit_2,
        //     size: iconSize,
        //   ),
        // ),
        // Divider(),
        ListTile(
          leading: Text(
            'UserName',
            style: titleStyle,
          ),
          title: Text("@${appBloc.kitchenDetails['username'] ?? 'None'}"),
        ),
        Divider(),
        ListTile(
          leading: Text(
            'Email',
            style: titleStyle,
          ),
          title: Text(appBloc.kitchenDetails['email'] ?? 'None'),
        ),
        Divider(),
        ListTile(
          onTap: () => goToAccount(),
          leading: Text(
            'Phone',
            style: titleStyle,
          ),
          title: Text(appBloc.kitchenDetails['phone'] ?? 'None'),
          trailing: Icon(
            Feather.edit_2,
            size: iconSize,
          ),
        ),
        Divider(),
        ListTile(
          onTap: () => goToAddress(),
          leading: Text(
            'Address',
            style: titleStyle,
          ),
          title: Text(appBloc.kitchenDetails['addr'] ?? 'None'),
          trailing: Icon(
            Feather.edit_2,
            size: iconSize,
          ),
        ),
        // Divider(),
        // ListTile(
        //   onTap: () => goToAddress(),
        //   leading: Text(
        //     'Land Mark',
        //     style: titleStyle,
        //   ),
        //   title: Text(appBloc.kitchenDetails['landmark'] ?? 'None'),
        //   trailing: Icon(
        //     Feather.edit_2,
        //     size: iconSize,
        //   ),
        // ),
        // Divider(),
        // ListTile(
        //   onTap: () => goToAddress(),
        //   leading: Text(
        //     'District',
        //     style: titleStyle,
        //   ),
        //   title: Text(appBloc.kitchenDetails['district'] ?? 'None'),
        //   trailing: Icon(
        //     Feather.edit_2,
        //     size: iconSize,
        //   ),
        // ),
        // Divider(),
        // ListTile(
        //   onTap: () => goToAddress(),
        //   leading: Text(
        //     'City',
        //     style: titleStyle,
        //   ),
        //   title: Text(appBloc.kitchenDetails['city'] ?? 'None'),
        //   trailing: Icon(
        //     Feather.edit_2,
        //     size: iconSize,
        //   ),
        // ),
      ],
    );
  }

  goToKitchenUser() {
    NextPage().nextRoute(context, AddKitchen());
  }

  goToAddress() {
    NextPage().nextRoute(context, KitchenAddress());
  }

  goToAccount() {
    NextPage().nextRoute(context, Account());
  }

  showActionSelectorSheet({String action}) {
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
              key: _scaffoldKey,
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
                          padding: EdgeInsets.all(8.0),
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Ionicons.ios_eye,
                                  size: iconSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'View ${sheetViewSection(action)}',
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
                              sheetViewAction(action);
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
                                  Ionicons.ios_photos,
                                  size: iconSize,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    //Upload from gallery'
                                    'Update file',
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
                              sheetGalleryAction(action);
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

  sheetViewSection(String action) {
    switch (action) {
      case 'profile':
        return 'Photo';
        break;
      case 'large':
        return 'Banner Image';
        break;
      case 'display':
        return 'Photos';
        break;
      case 'video':
        return 'Tour video';
        break;
    }
  }

  sheetViewAction(String action) {
    switch (action) {
      case 'profile':
        NextPage().nextRoute(
            context,
            ViewPhotos(
              single: true,
              online: true,
              singleImg: appBloc.kitchenDetails['profile'],
            ));
        break;
      case 'large':
        NextPage().nextRoute(
            context,
            ViewPhotos(
              single: true,
              online: true,
              singleImg: appBloc.kitchenDetails['large'],
            ));
        break;
      case 'display':
        if (PublicVar.kitchenViews != null &&
            PublicVar.kitchenViews.length > 0) {
          NextPage().nextRoute(
              context,
              ViewPhotos(
                single: false,
                online: true,
                imgList: PublicVar.kitchenViews,
              ));
        }

        break;
      case 'video':
        if (PublicVar.kitchenTourFile == null) {
          NextPage().nextRoute(
              context,
              PlayVideo(
                online: true,
                url: PublicVar.kitchenVideoUrl,
              ));
        } else {
          NextPage().nextRoute(
              context,
              PlayVideo(
                online: false,
                url: PublicVar.kitchenTourFile.path,
              ));
        }

        break;
    }
  }

  sheetGalleryAction(String action) {
    switch (action) {
      case 'profile':
        chooseSingleSource(isVideo: false, isLarge: false);
        break;
      case 'large':
        chooseSingleSource(isVideo: false, isLarge: true);
        break;
      case 'display':
        chooseMultiImagesSource();
        break;
      case 'video':
        chooseSingleSource(isVideo: true, isLarge: false);
        break;
    }
  }

  //for singlePhotos
  chooseSingleSource({bool isVideo, isLarge}) async {
    try {
      var uploadFile;
      if (isVideo) {
        var path = await MediaPicker().selectOneVideo();
        uploadFile = File(path['videoPath']);
      } else {
        var path = await MediaPicker().selectFromPickers();
        uploadFile = await CompressImage().compressAndGetFile(
            file: File(path), name: "upload_image", extention: ".jpg");
      }
      AppActions().showLoadingToast(
        text:
            'Updating ${isVideo ? 'Tour Video' : isLarge ? 'Banner Image' : 'Profile image'}.....',
        context: context,
      );
      await fileUpload(file: uploadFile, isVideo: isVideo, isLarge: isLarge);
    } catch (e) {
      AppActions().showErrorToast(
        text: '${e.toString()}',
        context: context,
      );
    }
  }

  fileUpload({File file, bool isVideo, isLarge}) async {
    Map data = {
      isVideo
          ? 'tour'
          : isLarge
              ? 'large'
              : 'profile': file
    };
    var uploaded = await Server().uploadImg(
        url: Urls.getKitchens + '${PublicVar.kitchenID}/resources',
        data: data,
        appBloc: appBloc);
    if (uploaded) {
      await Server().queryKitchen(appBloc: appBloc);

      appBloc.kitchenDetails = appBloc.kitchenDetails;
      setState(() {});
      AppActions().showSuccessToast(
        text: "Update Successful",
        context: context,
      );
    } else {
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
  }

  //for multiplePhotos
  chooseMultiImagesSource() async {
    try {
      var files = [];
      var imgs = await MediaPicker().selectImages(crop: true, count: 4);
      if (imgs != null) {
        for (var i = 0; i < imgs.length; i++) {
          files.add(File(imgs[i]));
        }
        if (files.length == 4) {
          uploadMultiple(imageFiles: files);
        } else {
          AppActions().showErrorToast(
            text: 'Please you have to select four(4) images',
            context: context,
          );
        }
      }
    } catch (e) {
      AppActions().showErrorToast(
        text: '${e.toString()}',
        context: context,
      );
    }
  }

  uploadMultiple({List imageFiles}) async {
    AppActions().showSuccessToast(
      text: 'Updating Kitchen profile display ',
      context: context,
    );
    Map data = {
      'view1': imageFiles[0],
      'view2': imageFiles[1],
      'view3': imageFiles[2],
      'view4': imageFiles[3],
    };
    if (await Server().uploadImg(
        url: Urls.getKitchens + '${PublicVar.kitchenID}/resources',
        appBloc: appBloc,
        data: data)) {
      Server().queryKitchen(appBloc: appBloc);
      AppActions().showSuccessToast(
        text: 'Kitchen profile display updated!',
        context: context,
      );
    } else {
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
  }

  goToWebsite() async {
    await launch('http://kitchly.co/');
  }

  tellFriend() async {
    // var link = await dynamicLinksService.createDynamicLink(
    //     link: 'https://kitchly.co/kitchen',
    //     surfix: 'https://kitchlychef.page.link',
    //     packageName: 'com.kitchly_chef');
    // String shareText =
    //     "Hi there!.\n\n ${PublicVar.firstName.toUpperCase() ?? ""} ${PublicVar.lastName.toUpperCase() ?? ""} has invited you to order your meals on KITCHLY. \nIt's and app that allows you to order and get food delivered to you from Kitchens nearby.\n \n Download and sign up with this link $link";
    // final RenderBox box = context.findRenderObject();
    // Share.share("$shareText",
    //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  customerInvite() async {
    var link =
        "https://kitchlyuser.page.link/?link=https://kitchly.co/kitchen?_id=${appBloc.kitchenDetails['kitchen_id']}&apn=com.kitchly&amv=0";
    String shareText =
        "Hi there!. this is ${appBloc.kitchenDetails['kitchen_name']}\n\nI want to use this medium to invite you too order your meals from us using Kitchly platform and this is the link to my kitchen. Use the link to download the app, open the app and use the link to open our page to order your favorite meal.\n$link";
    final RenderBox box = context.findRenderObject();
    // Share.share("$shareText",
    //     sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future<Null> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget GetViewsContainer({url}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              var data = [
                appBloc.kitchenDetails['large'],
                appBloc.kitchenDetails['views']['1'],
                appBloc.kitchenDetails['views']['2'],
                appBloc.kitchenDetails['views']['3'],
                appBloc.kitchenDetails['views']['4']
              ];
              NextPage().nextRoute(
                  context,
                  ViewPhotos(
                    single: false,
                    online: true,
                    imgList: data,
                    gotoPage: DisplayKitchen(),
                  ));
            },
            child: Container(
              height: 80,
              width: 80,
              child: GetImageProvider(
                url: url,
                placeHolder: PublicVar.defaultKitchenImage,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    if (appBloc.kitchenDetails['is_active'] != null && !firstTime) {
      activeKitchen = appBloc.kitchenDetails['is_active'];
      firstTime = true;
    }
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    deviceFont = deviceHeight * 0.01;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Feather.menu,
                size: 25,
              ),
              onPressed: () {
                widget.scaffoldKey.currentState.openDrawer();
              }),
          centerTitle: true,
          title: Text(
            "Kitchen Info",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                  size: deviceHeight * 0.027,
                ),
                onPressed: () => NextPage().nextRoute(context, KitchenSetup())),
          ],
          elevation: 0.0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () =>
                                showActionSelectorSheet(action: 'profile'),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(120),
                                      border: Border.all(
                                          width: 2, color: Colors.grey[200])),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(120),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      child: GetImageProvider(
                                        url: appBloc.kitchenDetails['profile'],
                                        placeHolder:
                                            PublicVar.defaultKitchenImage,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => showActionSelectorSheet(
                                      action: 'profile'),
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: Icon(Ionicons.ios_camera,
                                          color: Colors.grey[100]),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Column(
                              children: <Widget>[
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      appBloc.kitchenDetails['kitchen_name'] ??
                                          '', //Kitchen Name
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                    ),
                                  )
                                ]),
                                Row(children: [
                                  Expanded(
                                    child: Text(
                                      appBloc.kitchenDetails['caption'] ??
                                          '', //Caption
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                    ),
                                  )
                                ]),
                              ],
                            ),
                          ),
                        )
                      ]),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 100,
                    child: Row(
                      children: [
                        Expanded(
                            child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children: [
                            GetViewsContainer(
                                url: appBloc.kitchenDetails['large']),
                            GetViewsContainer(
                                url: appBloc.kitchenDetails['views']['1']),
                            GetViewsContainer(
                                url: appBloc.kitchenDetails['views']['2']),
                            GetViewsContainer(
                                url: appBloc.kitchenDetails['views']['3']),
                            GetViewsContainer(
                                url: appBloc.kitchenDetails['views']['4']),
                          ],
                        ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                    child: ButtonWidget(
                      onPress: () => customerInvite(),
                      width: double.infinity,
                      height: 45.0,
                      text: "Share customer invite",
                      textIcon: Icons.share_rounded,
                      txColor: Colors.black,
                      border: Border.all(
                        width: 1.0,
                        color: Colors.black,
                      ),
                      radius: 10.0,
                      iconColor: Colors.black,
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey[200],
                  ),
                  aboutTab()
                ]),
              )),
        ));
  }
}
