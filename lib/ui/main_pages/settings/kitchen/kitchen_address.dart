import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kitchly_chef/ui/main_pages/settings/locations/districts.dart';
import 'package:kitchly_chef/ui/main_pages/settings/locations/states.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KitchenAddress extends StatefulWidget {
  KitchenAddress({Key key}) : super(key: key);
  @override
  _KitchenAddressState createState() => _KitchenAddressState();
}

class _KitchenAddressState extends State<KitchenAddress> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false, loading = false, firstTime = true;
  SharedPreferences prefs;
  AppBloc appBloc;
  String country, city, district, address, landMark;
  final formPadding = EdgeInsets.symmetric(vertical: 7.0, horizontal: 20);
  var stateController = TextEditingController(),
      districtController = TextEditingController(),
      landMarkController = TextEditingController(),
      addressController = TextEditingController();
  File imageFile;
  CompressImage compress = CompressImage();
  ScrollController scrollController = ScrollController();
  final border = Radius.circular(15);
  @override
  void initState() {
    scrollController.addListener(() {
      checkScrollExtent();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    if (PublicVar.accountApproved && firstTime) {
      stateController.text = appBloc.kitchenDetails['city'];
      districtController.text = appBloc.kitchenDetails['district'];
      landMarkController.text = appBloc.kitchenDetails['landmark'];
      addressController.text = appBloc.kitchenDetails['addr'];
      firstTime = false;
    }
    if (appBloc.state != null) {
      stateController.text = appBloc.state['state'];
    }
    if (appBloc.district != null) {
      districtController.text = appBloc.district['name'];
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
        child: Wrap(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Kitchen Location",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Please provide every details about your kitchen location.",
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
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 50),
              child: ButtonWidget(
                onPress: () => validate(),
                width: double.infinity,
                fontSize: 20.0,
                height: 50.0,
                loading: loading,
                txColor: Colors.white,
                bgColor: Color(PublicVar.primaryColor),
                text: PublicVar.accountApproved
                    ? 'Update Location'
                    : 'Save Location',
              ),
            ),
            SizedBox(height: 500)
          ],
        ),
      ),
    );
  }

  Widget FormUI() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Padding(
              padding: formPadding,
              child: TextFormField(
                keyboardType: TextInputType.text,
                enabled: false,
                controller: TextEditingController(
                    text:
                        'Nigeria'), //  appBloc.countries.length==0?'':appBloc.country['name']
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  if (await AppActions().checkInternetConnection()) {
                    AppActions().showErrorToast(
                      text:
                          'We are only available in Nigeria for now!\n please select your state/city in Nigeria',
                      context: context,
                    );
                  } else {
                    AppActions().showErrorToast(
                      text: PublicVar.checkInternet,
                      context: context,
                    );
                  }
                  //NextPage().nextRoute(context, Countries());
                },
                validator: Validation().text,
                onSaved: (String val) {
                  country = val;
                },
                decoration: InputDecoration(
                  labelText: 'Your Country',
                  helperText: 'e.g Nigeria, Kenya',
                ),
              )),
          Padding(
              padding: formPadding,
              child: TextFormField(
                keyboardType: TextInputType.text,
                validator: Validation().text,
                controller: stateController,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  if (await AppActions().checkInternetConnection()) {
                    appBloc.country = {
                      "name": "Nigeria",
                      "code": "ng",
                      "currency": "naira",
                      "symbol": "₦"
                    };
                    if (appBloc.country != null) {
                      NextPage().nextRoute(context, States());
                    } else {
                      AppActions().showErrorToast(
                        text: 'Please select your country first',
                        context: context,
                      );
                    }
                  } else {
                    AppActions().showErrorToast(
                      text: PublicVar.checkInternet,
                      context: context,
                    );
                  }
                },
                onSaved: (String val) {
                  city = val;
                },
                decoration: InputDecoration(
                  labelText: 'Business City/State',
                  helperText: 'e.g Abuja, Lagos',
                ),
              )),
          Padding(
            padding: formPadding,
            child: TextFormField(
              keyboardType: TextInputType.text,
              autofocus: false,
              controller: districtController,
              onTap: () async {
                FocusScope.of(context).unfocus();
                if (await AppActions().checkInternetConnection()) {
                  if (appBloc.country != null &&
                      appBloc.state != null &&
                      appBloc.states.length > 0) {
                    NextPage().nextRoute(context, Districts());
                  } else {
                    AppActions().showErrorToast(
                      text: 'Please select the city where you do business',
                      context: context,
                    );
                  }
                } else {
                  AppActions().showErrorToast(
                    text: PublicVar.checkInternet,
                    context: context,
                  );
                }
              },
              validator: Validation().text,
              onSaved: (String val) {
                district = val;
              },
              decoration: InputDecoration(
                labelText: 'Business District',
                helperText: "e.g Asokoro, Maitama, Wuse, Lugbe.... ",
              ),
            ),
          ),
          Padding(
            padding: formPadding,
            child: TextFormField(
              keyboardType: TextInputType.text,
              autofocus: false,
              textCapitalization: TextCapitalization.sentences,
              validator: Validation().text,
              controller: landMarkController,
              onSaved: (String val) {
                landMark = val;
              },
              decoration: InputDecoration(
                labelText: 'Closest landmark to your kitchen',
                helperText: "e.g Name of a Hotel, Mall, Park e.t.c ",
              ),
            ),
          ),
          Padding(
            padding: formPadding,
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              autofocus: false,
              maxLines: null,
              controller: addressController,
              textCapitalization: TextCapitalization.sentences,
              validator: Validation().text,
              onSaved: (String val) {
                address = val;
              },
              decoration: InputDecoration(
                labelText: 'Kitchen full address',
                helperText:
                    "e.g No 13 Winston Church-hill street, Asokoro, Abuja",
              ),
            ),
          ),
        ],
      ),
    );
  }

  validate() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
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
    } else {
      setState(() => _autoValidate = true);
    }
  }

  sendToServer() async {
    Map data = {
      "country": {
        "name": "Nigeria",
        "code": "ng",
        "currency": "naira",
        "symbol": "₦"
      },
      "city": stateController.text ?? "",
      "district": districtController.text ?? "",
      "addr": address ?? "",
      'landmark': landMark ?? "",
      "position": {"longitude": 9.030472, "latitude": 7.493467}
    };

    if (!PublicVar.onProduction) print(data);
    if (await Server().putAction(
        url: Urls.getKitchens + '${PublicVar.kitchenID}/location',
        data: data,
        bloc: appBloc)) {
      PublicVar.kitchenLocation = address;
      PublicVar.kitchenHasAddress = true;
      await Server().queryKitchen(appBloc: appBloc);
      SharedStore().setData(type: 'bool', key: 'kitchenHasAddress', data: true);
      showLoading();
      appBloc.kitchenDetails = appBloc.kitchenDetails;
      appBloc.kitchenDetails['city'] = stateController.text;
      appBloc.kitchenDetails['district'] = districtController.text;
      appBloc.kitchenDetails['addr'] = address;
      AppActions().showSuccessToast(
        text: 'Kitchen location updated',
        context: context,
      );
      showLoading();
      Navigator.pop(context);
    } else {
      showLoading();
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
  }

  showLoading() {
    if (loading) {
      loading = false;
    } else {
      loading = true;
    }
    setState(() {});
  }

  checkScrollExtent() {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels > 0) {
        FocusScope.of(context).unfocus();
      }
    }
  }

  getData() async {
    Map data = {
      "query": {"country": appBloc.country['code']}
    };
    var received = await Server()
        .postAction(bloc: appBloc, url: Urls.getStates, data: data);
    if (received) {
      appBloc.states = appBloc.mapSuccess;
    }
    return received;
  }
}
