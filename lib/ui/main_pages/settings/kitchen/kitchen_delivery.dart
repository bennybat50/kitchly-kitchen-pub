import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kitchly_chef/ui/main_pages/base.dart';
import 'package:kitchly_chef/ui/main_pages/settings/locations/districts.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

class KitchenDelivery extends StatefulWidget {
  @override
  _KitchenDeliveryState createState() => _KitchenDeliveryState();
}

class _KitchenDeliveryState extends State<KitchenDelivery> {
  bool pickup = false,
      delivery = false,
      eat_in = false,
      loading = false,
      firstTime = false,
      editingLocation = false,
      _autoValidate = false;
  final headingStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  String deliveryPriceField;
  var deliveryGroup = 1, deliveryIndex = 0;
  TextEditingController deliveryPriceCtrl = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  AppBloc appBloc;
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);

    if (PublicVar.accountApproved && !firstTime) {
      if (!PublicVar.onProduction) if (appBloc.kitchenDetails['delivery']
              ['self_pickup'] !=
          null) {
        pickup = appBloc.kitchenDetails['delivery']['self_pickup']['value'];
      }
      if (appBloc.kitchenDetails['delivery']['eat_in'] != null) {
        eat_in = appBloc.kitchenDetails['delivery']['eat_in']['value'];
      }
      if (appBloc.kitchenDetails['delivery']['self_delivery'] != null &&
          appBloc.kitchenDetails['delivery']['self_delivery'].length > 0) {
        delivery = true;
        appBloc.deliveryDistricts =
            appBloc.kitchenDetails['delivery']['self_delivery'];
      }
      appBloc.district = {"name": ""};
      firstTime = true;
    }

    @override
    void initState() {
      scrollController.addListener(() {
        checkScrollExtent();
      });

      super.initState();
    }

    return Scaffold(
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Wrap(
            alignment: WrapAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  NextPage().clearPages(
                      context,
                      Base(
                        firstEntry: true,
                      ));
                },
                child: Text(
                  PublicVar.accountApproved
                      ? "Update Delivery"
                      : "Setup Delivery",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                "Select delivery options your kitchen offers.",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 60,
              ),
              ListTile(
                subtitle: Text('Clients can pick up order from your location.'),
                title: Text(
                  'Pickup ?',
                  style: headingStyle,
                ),
                trailing: CupertinoSwitch(
                  value: pickup,
                  onChanged: (value) async {
                    if (await AppActions().checkInternetConnection()) {
                      changePickupStatus(active: value);
                    } else {
                      AppActions().showErrorToast(
                        text: PublicVar.checkInternet,
                        context: context,
                      );
                    }
                  },
                  activeColor: Color(PublicVar.primaryColor),
                ),
              ),
              Divider(),
              ListTile(
                subtitle:
                    Text('Clients can enjoy their order in your location.'),
                title: Text(
                  'Eat - In ?',
                  style: headingStyle,
                ),
                trailing: CupertinoSwitch(
                  value: eat_in,
                  onChanged: (value) async {
                    if (await AppActions().checkInternetConnection()) {
                      changeEatInStatus(active: value);
                    } else {
                      AppActions().showErrorToast(
                        text: PublicVar.checkInternet,
                        context: context,
                      );
                    }
                  },
                  activeColor: Color(PublicVar.primaryColor),
                ),
              ),
              Divider(),
              ListTile(
                subtitle: Text(
                    'Deliver order to clients close to you, by selecting the locations you would like to do business around'),
                title: Text(
                  'Offer Delivery ?',
                  style: headingStyle,
                ),
                trailing: CupertinoSwitch(
                  value: delivery,
                  onChanged: (value) {
                    setState(() {
                      delivery = value;
                    });
                  },
                  activeColor: Color(PublicVar.primaryColor),
                ),
              ),
              delivery
                  ? Column(
                      children: <Widget>[
                        Text(
                          'Set delivery locations', //Select your deliver type
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        //   Text(
                        //     'What kind of delivery do you offer?',
                        //     style: TextStyle(
                        //         fontSize: 14, fontWeight: FontWeight.w500),
                        //   ),
                        //   ListTile(
                        //     title: Text(
                        //       'Delivery by kitchen',
                        //       style: TextStyle(fontWeight: FontWeight.w700),
                        //     ),
                        //     trailing: Radio(
                        //         value: 1,
                        //         groupValue: deliveryGroup,
                        //         onChanged: (val) {
                        //           setState(() {
                        //             deliveryGroup = val;
                        //           });
                        //         }),
                        //   ),
                        //   ListTile(
                        //     title: Text('Third party delivery',
                        //         style:
                        //             TextStyle(fontWeight: FontWeight.w700)),
                        //             trailing: Radio(
                        //         value: 2,
                        //         groupValue: deliveryGroup,
                        //         onChanged: (val) {
                        //           setState(() {
                        //             deliveryGroup = val;
                        //           });
                        //         }),
                        //   ),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 20.0),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      onTap: () {
                                        appBloc.state = {
                                          "state": "Abuja",
                                          "id": "abuja"
                                        };
                                        appBloc.district = {"name": ""};
                                        NextPage()
                                            .nextRoute(context, Districts());
                                      },
                                      child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        alignment: Alignment.center,
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                appBloc.district["name"] == ""
                                                    ? "Select a Location "
                                                    : "${appBloc.district['name']}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(Icons.arrow_drop_down_circle)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    controller: deliveryPriceCtrl,
                                    onChanged: (value) => setState(() {}),
                                    validator: Validation().oneNumber,
                                    onSaved: (String val) {
                                      deliveryPriceField = val;
                                    },
                                    decoration: FormDecorator(
                                        hint: 'Delivery Cost',
                                        helper: 'e.g N200'),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ButtonWidget(
                                    width: appBloc.deliveryDistricts.length > 0
                                        ? 300.0
                                        : 200.0,
                                    height: 50.0,
                                    fontSize: 20.0,
                                    txColor: Colors.white,
                                    onPress: () async {
                                      var hasData = false;
                                      FocusScope.of(context).unfocus();
                                      if (appBloc.district.isEmpty ||
                                          appBloc.district["name"] == "") {
                                        AppActions().showErrorToast(
                                            context: context,
                                            text:
                                                "Please click the dropdown above to select a location !!!");
                                      } else if (deliveryPriceCtrl.text == "") {
                                        AppActions().showErrorToast(
                                            context: context,
                                            text:
                                                "Please set your delivery price for the location selected above!!! ");
                                      } else if (!appBloc.district.isEmpty &&
                                          deliveryPriceCtrl.text != "") {
                                        if (editingLocation) {
                                          appBloc.deliveryDistricts[
                                                  deliveryIndex]["name"] =
                                              appBloc.district["name"];
                                          appBloc.deliveryDistricts[
                                                  deliveryIndex]["id"] =
                                              appBloc.district["id"];
                                          appBloc.deliveryDistricts[
                                                  deliveryIndex]["price"] =
                                              deliveryPriceCtrl.text;
                                          editingLocation = false;
                                          deliveryIndex = 0;

                                          AppActions().showSuccessToast(
                                              context: context,
                                              text:
                                                  "${appBloc.district["name"]} updated");
                                        } else {
                                          for (var i = 0;
                                              i <
                                                  appBloc
                                                      .deliveryDistricts.length;
                                              i++) {
                                            if (appBloc.deliveryDistricts[i]
                                                    ['name'] ==
                                                appBloc.district["name"]) {
                                              setState(() {
                                                hasData = true;
                                              });
                                              AppActions().showErrorToast(
                                                  context: context,
                                                  text:
                                                      "${appBloc.district["name"]} already exists");
                                            }
                                          }
                                          if (!hasData) {
                                            AppActions().showSuccessToast(
                                                context: context,
                                                text:
                                                    "${appBloc.district["name"]} added");
                                            appBloc.deliveryDistricts.add({
                                              "name": appBloc.district["name"],
                                              "id": appBloc.district["id"],
                                              "price": deliveryPriceCtrl.text
                                            });
                                          }
                                        }
                                        appBloc.deliveryDistricts =
                                            appBloc.deliveryDistricts;
                                        appBloc.district = {
                                          "name": "",
                                          "id": ""
                                        };
                                        appBloc.district = appBloc.district;
                                        deliveryPriceCtrl.text = "";
                                        setState(() {});
                                      }
                                    },
                                    bgColor: deliveryPriceCtrl.text == ""
                                        ? Colors.grey
                                        : Color(PublicVar.primaryColor),
                                    text: editingLocation
                                        ? "Update Location"
                                        : appBloc.deliveryDistricts.length > 0
                                            ? 'Add Another Location'
                                            : "Add Location",
                                  ),
                                  Divider(),
                                  appBloc.deliveryDistricts.length > 0
                                      ? Center(
                                          child: Text(
                                            "Delivery Locations Added",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    reverse: true,
                                    physics: ScrollPhysics(),
                                    itemCount: appBloc.deliveryDistricts.length,
                                    itemBuilder: (ctx, i) {
                                      return ListTile(
                                          leading: Icon(Icons.pin_drop_rounded,
                                              color: Colors.black),
                                          title: Text(
                                              appBloc.deliveryDistricts[i]
                                                  ['name'],
                                              style: TextStyle(fontSize: 18)),
                                          subtitle: Text(
                                              "N${appBloc.deliveryDistricts[i]['price']}",
                                              style: TextStyle(fontSize: 15)),
                                          trailing: Container(
                                              width: 100,
                                              child: Row(children: [
                                                IconButton(
                                                    onPressed: () {
                                                      deliveryPriceCtrl.text =
                                                          "${appBloc.deliveryDistricts[i]["price"]}";
                                                      appBloc.district = {
                                                        "name": appBloc
                                                                .deliveryDistricts[
                                                            i]["name"],
                                                        "id": appBloc
                                                                .deliveryDistricts[
                                                            i]["id"]
                                                      };
                                                      editingLocation = true;
                                                      deliveryIndex = i;
                                                      setState(() {});
                                                    },
                                                    icon: Icon(Icons.edit)),
                                                IconButton(
                                                    onPressed: () {
                                                      AppActions().showSuccessToast(
                                                          context: context,
                                                          text:
                                                              "${appBloc.deliveryDistricts[i]["name"]} removed");
                                                      appBloc.deliveryDistricts
                                                          .removeAt(i);
                                                      appBloc.deliveryDistricts =
                                                          appBloc
                                                              .deliveryDistricts;
                                                    },
                                                    icon: Icon(Icons
                                                        .delete_sweep_rounded))
                                              ])));
                                    },
                                  )
                                ],
                              )),
                        )
                      ],
                    )
                  : SizedBox(),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 50),
                child: ButtonWidget(
                  width: double.infinity,
                  height: 50.0,
                  fontSize: 20.0,
                  txColor: Colors.white,
                  loading: loading,
                  onPress: () async {
                    if (appBloc.deliveryDistricts.length == 0) {
                      AppActions().showErrorToast(
                          context: context,
                          text: "Add Delivery Locations of your choice");
                    } else if (appBloc.deliveryDistricts.length > 0) {
                      AppActions().showAppDialog(context,
                          title: "Add Delivery Locations?",
                          descp:
                              "Are you sure you are done adding delivery locations of your choice",
                          okText: "Save Delivery",
                          okAction: () async {
                            Navigator.pop(context);
                            if (!loading) {
                              showLoading();
                              if (await AppActions()
                                  .checkInternetConnection()) {
                                checkDelivery(active: delivery);
                              } else {
                                showLoading();
                                AppActions().showErrorToast(
                                  text: PublicVar.checkInternet,
                                  context: context,
                                );
                              }
                            }
                          },
                          cancleText: "Add Locations",
                          danger: false,
                          cancleAction: () {
                            AppActions().showSuccessToast(
                                context: context,
                                text: "Add More Delivery Locations");
                            Navigator.pop(context);
                          });
                    }
                  },
                  bgColor: appBloc.deliveryDistricts.length > 0
                      ? Color(PublicVar.primaryColor)
                      : Colors.grey,
                  text: PublicVar.accountApproved
                      ? 'Update Delivery'
                      : 'Save Delivery',
                ),
              ),
              SizedBox(
                height: 500,
              )
            ],
          ),
        ),
      ),
    );
  }

  checkDelivery({bool active}) async {
    if (active) {
      if (await activateDelivery(active)) {
        changeDeliveyStatus();
      } else {
        showLoading();
      }
    } else {
      if (await activateDelivery(active)) {
        await finishDelivery();
      } else {
        showLoading();
      }
    }
  }

  changeDeliveyStatus() async {
    var data = {"id": PublicVar.kitchenID, "routes": appBloc.deliveryDistricts};

    if (await Server()
        .postAction(bloc: appBloc, url: Urls.setUpDeliveryRoutes, data: data)) {
      AppActions().showSuccessToast(
        text: "Delivery locations updated",
        context: context,
      );
      checkSetups();
    } else {
      showLoading();
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
  }

  checkSetups() {
    if (!PublicVar.kitchenHasDisplay) {
      AppActions().showErrorToast(
        text: "Please add images to your gallery",
        context: context,
      );
      Navigator.pop(context);
    } else if (!PublicVar.kitchenHasHours) {
      AppActions().showErrorToast(
        text: "Please provide your opening and closing hours",
        context: context,
      );
      Navigator.pop(context);
    } else if (!PublicVar.kitchenHasAddress) {
      AppActions().showErrorToast(
        text: "Please provide your kitchen address",
        context: context,
      );
      Navigator.pop(context);
    } else {
      finishDelivery();
    }
  }

  activateDelivery(bool active) async {
    var data = {"id": PublicVar.kitchenID, "status": active}, done = false;
    print(data);
    print(Urls.enableDeliveryRoutes);
    if (await Server().postAction(
        bloc: appBloc, url: Urls.enableDeliveryRoutes, data: data)) {
      done = true;
    } else {
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
    return done;
  }

  changeEatInStatus({bool active}) async {
    AppActions().showLoadingToast(
      text: PublicVar.wait,
      context: context,
    );
    var data = {
      "nokey": {"kitchen_id": PublicVar.kitchenID},
      "token": PublicVar.getToken
    };
    if (await Server().postAction(
        bloc: appBloc,
        url: active ? Urls.activiteEatIn : Urls.deactivateEatIn,
        data: data)) {
      await Server().queryKitchen(appBloc: appBloc);
      appBloc.kitchenDetails = appBloc.kitchenDetails;
      AppActions().showSuccessToast(
        text: 'Eat in status updated',
        context: context,
      );
      setState(() {
        eat_in = active;
      });
    } else {
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
  }

  changePickupStatus({bool active}) async {
    AppActions().showLoadingToast(
      text: PublicVar.wait,
      context: context,
    );
    var data = {
      "nokey": {"kitchen_id": PublicVar.kitchenID},
      "token": PublicVar.getToken
    };
    if (await Server().postAction(
        bloc: appBloc,
        url: active ? Urls.activatePickUp : Urls.deactivatePickUp,
        data: data)) {
      await Server().queryKitchen(appBloc: appBloc);
      appBloc.kitchenDetails = appBloc.kitchenDetails;
      AppActions().showSuccessToast(
        text: 'Pick Up status updated',
        context: context,
      );
      setState(() {
        pickup = active;
      });
    } else {
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
  }

  finishDelivery() async {
    await Server().queryKitchen(appBloc: appBloc);
    appBloc.kitchenDetails = appBloc.kitchenDetails;

    if (PublicVar.accountApproved) {
      AppActions().showSuccessToast(
        text: 'Kitchen delivery updated successfully',
        context: context,
      );
      Navigator.pop(context);
    } else {
      await SharedStore()
          .setData(type: 'bool', data: true, key: 'kitchenHasDelivery');
      PublicVar.kitchenHasDelivery = true;
      await SharedStore()
          .setData(type: 'bool', data: true, key: 'accountApproved');
      PublicVar.accountApproved = true;
      showLoading();
      AppActions().showSuccessToast(
        text:
            'Kitchen setup completed! \nYou can start by creating your menus then open your kitchen for business',
        context: context,
      );
      NextPage().clearPages(
          context,
          Base(
            firstEntry: true,
          ));
    }
  }

  showLoading() {
    if (loading) {
      loading = false;
    } else {
      loading = true;
    }
    if (mounted) setState(() {});
  }

  checkScrollExtent() {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels > 0) {
        FocusScope.of(context).unfocus();
      }
    }
  }
}
