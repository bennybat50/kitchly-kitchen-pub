import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kitchlykitchendb/kitchlykitchendb.dart';

import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddKitchen extends StatefulWidget {
  AddKitchen({Key key}) : super(key: key);

  @override
  _AddKitchenState createState() => _AddKitchenState();
}

class _AddKitchenState extends State<AddKitchen>
    with SingleTickerProviderStateMixin<AddKitchen> {
  AppBloc appBloc;
  final border = Radius.circular(15);
  int currentIndex = 0;

  var editingName = TextEditingController(),
      editingUserName = TextEditingController(),
      editingCaption = TextEditingController(),
      imageUrl;

  final formPadding = EdgeInsets.symmetric(vertical: 7.0);
  File imageFile;
  SharedPreferences prefs;
  ScrollController scrollController = ScrollController();
  List tabs = ['Independent', 'Registered'];
  String kitchenName, caption, userName;

  bool _autoValidate = false, loading = false, firstTime = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(),
      sheetScaffoldKey = new GlobalKey();

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    _tabController.addListener(handleTabs);
    scrollController.addListener(() {checkScrollExtent();});
        super.initState();
      }

      Widget formUI() {
        return Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                child: Text(
                  "Kitchen image or Logo",
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
                  child: Container(
                    alignment: Alignment.center,
                    height: 150,
                    width: 250,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                        image: DecorationImage(
                            image: imageFile == null
                                ? PublicVar.accountApproved
                                    ? imageUrl == null
                                        ? AssetImage(PublicVar.defaultKitchenImage)
                                        : NetworkImage(imageUrl)
                                    : AssetImage(PublicVar.defaultKitchenImage)
                                : FileImage(imageFile),
                            fit: BoxFit.cover)),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: Icon(FontAwesome.camera),
                        iconSize: 18,
                        color: Color(PublicVar.primaryColor),
                        onPressed: () {
                          chooseImageSource();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: formPadding,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          validator: Validation().text,
                          controller: editingName,
                          textCapitalization: TextCapitalization.sentences,
                          onSaved: (String val) {
                            kitchenName = val;
                          },
                          decoration: InputDecoration(
                              labelText: 'Name of kitchen',
                              helperText: 'e.g Exquisite Kitchen',
                              icon: Icon(
                                Feather.user,
                                size: 18.0,
                                color: Colors.black,
                              )),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Feather.help_circle),
                        color: Colors.green[400],
                        iconSize: 18.0,
                      )
                    ],
                  )),
              Padding(
                  padding: formPadding,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          controller: editingUserName,
                          validator: Validation().validateUserName,
                          onSaved: (String val) {
                            userName = val;
                          },
                          decoration: InputDecoration(
                              labelText: 'User Name',
                              helperText:
                                  "e.g\"Exquisite01\", \"Exquisite_kitchen\"",
                              icon: Icon(
                                Feather.user,
                                size: 18.0,
                                color: Colors.black,
                              )),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Feather.help_circle),
                        color: Colors.green[400],
                        iconSize: 18.0,
                      )
                    ],
                  )),
              Padding(
                  padding: formPadding,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          controller: editingCaption,
                          textCapitalization: TextCapitalization.sentences,
                          onSaved: (String val) {
                            caption = val;
                          },
                          decoration: InputDecoration(
                              labelText: 'Kitchen Caption',
                              helperText: "e.g \"Kitchen on the go\"",
                              icon: Icon(
                                Feather.message_circle,
                                size: 18.0,
                                color: Colors.black,
                              )),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Feather.help_circle),
                        color: Colors.green[400],
                        iconSize: 18.0,
                      )
                    ],
                  )),
              ListTile(
                title: Padding(
                  padding:  EdgeInsets.symmetric(vertical:8.0),
                  child: Row(children: [
                    Icon(Icons.food_bank_outlined),SizedBox(width: 10,),
                    Expanded(child: Text("Are you an independent or a registered kitchen?")),
    
                  ]),
                ),
                subtitle: Container(
                  height: 40,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        alignment: Alignment.center,
                        child: PreferredSize(
                            preferredSize:
                                Size.fromHeight(20), // here the desired height
                            child: TabBar(
                              isScrollable: true,
                              controller: _tabController,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey[300],
                              ),
                              unselectedLabelColor: Colors.black,
                              unselectedLabelStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                              labelStyle: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                              labelColor: Colors.black,
                              indicatorSize: TabBarIndicatorSize.label,
                              tabs: List.generate(tabs.length, (i) {
                                return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Colors.grey[300], width: 1)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: Tab(text: '${tabs[i]}'),
                                    ));
                              }),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      handleTabs() {
        setState(() {
          currentIndex = _tabController.index;
        });
      }

      checkImage() async {
        if (PublicVar.accountApproved) {
          validate();
        } else {
          if (imageFile == null) {
            AppActions().showErrorToast(
              text: 'Please provide a profile picture or logo for your kitchen',
              context: context,
            );
          } else {
            validate();
          }
        }
      }

      validate() async {
        var form = _formKey.currentState;
        if (form.validate()) {
          form.save();
          showLoading();
          if (await AppActions().checkInternetConnection()) {
            if (PublicVar.accountApproved) {
              updateKitchen();
            if (!PublicVar.onProduction) print("Enter Approved");
            } else if (PublicVar.kitchenCreated) {
              updateKitchen();
              if (!PublicVar.onProduction) print("Enter Kitchen Created");
            } else {
              createKitchen();
              if (!PublicVar.onProduction) print("Enter Creating Kitchen");
            }
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

      createKitchen() async {
        Map data = {
          "user_id": PublicVar.userKitchlyID,
          "kitchen_name": kitchenName,
          "user_name": userName,
          "email": PublicVar.userEmail ?? "",
          "phone": PublicVar.userPhone ?? "",
          "caption": caption ?? ""
        };
        if (!PublicVar.onProduction) print(data);
        if (await Server().postAction(url: Urls.createKitchen, data: data, bloc: appBloc)) {
          var res = appBloc.mapSuccess;
          if (!PublicVar.onProduction) print(res);
          PublicVar.kitchenID = res['kitchen_id'];
          appBloc.kitchenDetails['kitchen_name'] = kitchenName;
          appBloc.kitchenDetails['caption'] = caption;
          appBloc.kitchenDetails['username'] = userName;
          UsersDb(databaseProvider: DatabaseProvider()).update(UserDoa().fromMap({
            'id': 1,
            'kitchenId': PublicVar.kitchenID,
            'firstName': PublicVar.firstName,
            'lastName': PublicVar.lastName,
            'token': PublicVar.getToken,
            'userKitchlyID': PublicVar.userKitchlyID,
            'email': PublicVar.userEmail,
            'phone': PublicVar.userPhone,
            'password': PublicVar.userPass
          }));
          PublicVar.kitchenCreated = true;
          PublicVar.kitchenCaption = caption;
          if (!PublicVar.onProduction)print('Done Creating Kitchen');
          await SharedStore().setData(type: 'bool', key: 'kitchenCreated', data: true);
          uploadImage();
        } else {
          if (!PublicVar.onProduction)print('Error Creating Kitchens >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
          showLoading();
          AppActions().showErrorToast(
            text: appBloc.errorMsg,
            context: context,
          );
        }
      }

      updateKitchen() async {
        Map data = {
          "kitchen_name": kitchenName,
          "user_name": userName,
          "email": PublicVar.userEmail,
          "phone": PublicVar.userPhone,
          "caption": caption
        };
        if (await Server().putAction(
            url: Urls.getKitchens + '${PublicVar.kitchenID}',
            data: data,
            bloc: appBloc)) {
          if (imageFile != null) {
            uploadImage();
          } else {
            await Server().queryKitchen(appBloc: appBloc);
            appBloc.kitchenDetails['kitchen_name'] = kitchenName;
            appBloc.kitchenDetails['caption'] = caption;
            appBloc.kitchenDetails['username'] = userName;
            showLoading();
            Navigator.pop(context);
            AppActions().showSuccessToast(
              text: "Update Successful",
              context: context,
            );
          }
          PublicVar.kitchenCreated = true;
          await SharedStore()
              .setData(type: 'bool', key: 'kitchenCreated', data: true);
        } else {
          showLoading();
          AppActions().showErrorToast(
            text: appBloc.errorMsg,
            context: context,
          );
        }
      }

      uploadImage() async {
        var imgFile = await CompressImage().compressAndGetFile(file: imageFile, name: "upload_image", extention: ".jpg");
        Map data = {'profile': imgFile};
        var uploaded = await Server().uploadImg(
            url: Urls.getKitchens + '${PublicVar.kitchenID}/resources',
            data: data,
            appBloc: appBloc);
        if (uploaded) {
          await Server().queryKitchen(appBloc: appBloc);
          appBloc.kitchenDetails = appBloc.kitchenDetails;
          showLoading();
          Navigator.pop(context);
        } else {
          showLoading();
          AppActions().showErrorToast(
            text: '${appBloc.errorMsg}',
            context: context,
          );
        }
      }

      getApprovedData() {}

      showLoading() {
        if (loading) {
          loading = false;
        } else {
          loading = true;
        }
        setState(() {});
      }

      chooseImageSource() async {
        try {
         var path = await MediaPicker().selectFromPickers();
         
          if (path != null) {
            setState(() {
              imageFile = File(path);
            });
          }
        } catch (e) {
          if(!PublicVar.onProduction)print(e.toString());
        }
      }

      checkScrollExtent(){
      if(scrollController.position.atEdge){
      if(scrollController.position.pixels > 0){
        FocusScope.of(context).unfocus();
      }
    }
  }

      @override
      Widget build(BuildContext context) {
        appBloc = Provider.of<AppBloc>(context);
        if (PublicVar.accountApproved && !firstTime) {
          editingName.text = appBloc.kitchenDetails['kitchen_name'] ?? '';
          editingUserName.text = appBloc.kitchenDetails['username'] ?? '';
          editingCaption.text = appBloc.kitchenDetails['caption'] ?? '';
          imageUrl = appBloc.kitchenDetails['profile'];
          firstTime = true;
        }
    
        return Scaffold(
          resizeToAvoidBottomInset: false,
          
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
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    PublicVar.accountApproved
                        ? "Update Your Kitchen"
                        : "Register Your Kitchen",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "Tell us more about your cooking, which includes your kitchen.",
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
                    child: formUI(),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:18.0,vertical: 50),
                  child: ButtonWidget(
            width: double.infinity,
            fontSize: 20.0,
            height: 50.0,
            txColor: Colors.white,
            loading: loading,
            onPress: () {
              if (!loading) {
                  checkImage(); // uploadImage checkImage
              }
            },
            bgColor: Color(PublicVar.primaryColor),
            text: PublicVar.accountApproved ? 'Update Kitchen' : 'Create Kitchen',
          ),
                ),
                SizedBox(height: 500),
              ],
            ),
          ),
          
        );
      }
}
