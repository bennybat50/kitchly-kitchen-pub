import 'dart:io';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:reworkutils/rework_utils.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class PackagesAction extends StatefulWidget {
  final bool update;
  final packageIndex, aPackage;
  PackagesAction({Key key, this.update, this.packageIndex, this.aPackage})
      : super(key: key);

  @override
  _PackagesActionState createState() => _PackagesActionState();
}

class _PackagesActionState extends State<PackagesAction> {
  Validation _validation = Validation();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File imageFile;
  bool loading = false,
      update,
      continual = false,
      _showTitleActions = true,
      dateBtn1 = true;
  CompressImage compress = CompressImage();
  AppBloc appBloc = AppBloc();
  TextEditingController nameController = TextEditingController(),
      desController = TextEditingController(),
      priceController = TextEditingController();
  final formPadding = EdgeInsets.symmetric(vertical: 8.0);
  String pacId,
      imageUrl,
      nameField,
      packageId,
      descField,
      priceField,
      startDateField,
      endDateField;
  int pIndex;
  var aPackage;
  DateTime _dateTime;
  String _lang = 'en', _format = 'yyyy-mm-dd';
  int _year = 2021, _month = 11, _day = 11,realStartDate,realEndDate;
 

  @override
  void initState() {
    if (widget.update) {
      update = true;
      pIndex = widget.packageIndex;
      aPackage = widget.aPackage;
      pacId = "${aPackage['id']}";
      nameController.text = "${aPackage['caption']}";
      desController.text = "${aPackage['descp']}";
      priceController.text = '${aPackage['price']}';
      imageUrl = '${aPackage['image']}';
      startDateField = '${getDateValue(aPackage['start_date'])}';
      endDateField = '${getDateValue(aPackage['end_date'])}';
    } else {
      update = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          update ? 'Update Package' : 'Create Package',
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: Icon(
            Ionicons.ios_close,
            size: 45,
          ),
          onPressed: () {
            if (!loading) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                child: Text(
                  'Describe your package using the form below',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.0, color: Colors.black87),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 200,
                width: double.infinity,
                child: IconButton(
                    onPressed: () {
                      pickImages();
                    },
                    icon: Icon(Feather.camera)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: imageFile == null
                            ? update
                                ? imageUrl == null
                                    ? AssetImage(PublicVar.defaultKitchenImage)
                                    : NetworkImage(
                                        imageUrl,
                                      )
                                : AssetImage(PublicVar.defaultKitchenImage)
                            : FileImage(imageFile),
                        fit: BoxFit.cover),
                    color: Colors.grey[100]),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: formPadding,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  validator: _validation.text,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                  onSaved: (String val) {
                    nameField = val;
                  },
                  decoration: FormDecorator(
                      hint: 'Package Name', helper: 'e.g Special Combo'),
                ),
              ),
              Padding(
                padding: formPadding,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: desController,
                  textCapitalization: TextCapitalization.sentences,
                  validator: _validation.text,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                  autofocus: false,
                  maxLines: null,
                  onSaved: (String val) {
                    descField = val;
                  },
                  decoration: FormDecorator(
                      helper: 'e.g King sized bugger with fresh toppings',
                      hint: 'Describe Package'),
                ),
              ),
              Padding(
                padding: formPadding,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  validator: _validation.oneNumber,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                  onSaved: (String val) {
                    priceField = val;
                  },
                  decoration:
                      FormDecorator(hint: 'Package Price', helper: 'e.g N1500'),
                ),
              ),
              Padding(
                padding: formPadding,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              dateBtn1 = true;
                            });
                            _showDatePicker();
                          },
                          child: Column(
                            children: [
                              Text("Start Date",
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 14)),
                              Text(
                                startDateField ?? "dd-mm-yy",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 2,
                      color: Colors.grey[200],
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              dateBtn1 = false;
                            });
                            _showDatePicker();
                          },
                          child: Column(
                            children: [
                              Text("End Date",
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 14)),
                              Text(
                                endDateField ?? "dd-mm-yy",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: formPadding,
                  child: ListTile(
                    leading: Checkbox(
                      value: continual,
                      onChanged: (changed) {
                        continual = changed;
                        if(continual){
                          endDateField = 'Continous';
                          realEndDate=0;
                        }
                        setState(() {});
                      },
                    ),
                    title: Text("Show Continous"),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 60),
                child: ButtonWidget(
                  height: 50.0,
                  fontSize: 20.0,
                  onPress: () {
                    if (!loading) {
                      validate();
                    }
                  },
                  loading: loading,
                  txColor: Colors.white,
                  bgColor: Color(PublicVar.primaryColor),
                  text: update ? 'Update Package' : 'Save Package',
                ),
              ),
              SizedBox(
                height: 500,
              ),
            ])),
      ),
    );
  }

  pickImages() async {
    try {
      var path = await MediaPicker().selectOneImage(crop: true);
      if (path != null) {
        setState(() {
          imageFile = File(path);
        });
      }
    } catch (e) {
      AppActions().showErrorToast(
        text: '${e.toString()}',
        context: context,
      );
    }
  }

  validate() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      isLoading();
      if (await AppActions().checkInternetConnection()) {
        savePackage();
      } else {
        isLoading();
        AppActions().showErrorToast(
          text: PublicVar.checkInternet,
          context: context,
        );
      }
    }
  }

  savePackage() async {
    Map data = {
      "caption": nameController.text,
      "kitchen_id": PublicVar.kitchenID,
      "descp": desController.text,
      "price": double.parse(priceField).toStringAsFixed(2),
      "continual": continual,
      "start_date": realStartDate,
      "end_date": realEndDate,
    };
    if(update){
      data.addAll({"active":aPackage['active']});
    }

    if (!PublicVar.onProduction) print(data);

    if (update
        ? await Server().putAction(
            bloc: appBloc, data: data, url: Urls.packageActions + "/" + pacId)
        : await Server()
            .postAction(bloc: appBloc, data: data, url: Urls.packageActions)) {
      if (!PublicVar.onProduction) print(appBloc.mapSuccess);

       if (imageFile != null) {
        updateDishImage(dishId: appBloc.mapSuccess['id']);
      } else {
        finishAction();
      }
    }
  }

  updateDishImage({String dishId}) async {
    var imgFile = await CompressImage().compressAndGetFile(
        file: imageFile, name: "upload_image", extention: ".jpg");
    var data = {'img': imgFile};
    if (await Server().uploadImg(
        appBloc: appBloc,
        url: '${Urls.packageActions}/$dishId/${PublicVar.kitchenID}/resources',
        data: data)) {
      finishAction();
    } else {
      isLoading();
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
  }

  finishAction() async {
    if(update){
      appBloc.packages[pIndex]['caption'] = nameController.text;
      appBloc.packages[pIndex]['descp'] = desController.text;
      appBloc.packages[pIndex]['price'] = priceController.text;
      appBloc.packages = appBloc.packages;
    }
    await Server().getPackages(appBloc: appBloc, data: PublicVar.queryKitchen);
    Navigator.pop(context);
  }

  /// Display date picker.
  _showDatePicker() {
    const String MIN_DATETIME = '2000-01-01';
    const String MAX_DATETIME = '2040-11-25';

    final bool showTitleActions = false;
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.parse(MIN_DATETIME),
        maxTime: DateTime.parse(MAX_DATETIME), 
        onChanged: (date) {
          _changeDatetime(date.year, date.month,date.day, date.millisecondsSinceEpoch);
    }, onConfirm: (date) {
     _changeDatetime(date.year, date.month,date.day,date.millisecondsSinceEpoch);
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  _changeDatetime(int year, int month, int date, int realDate) {
    setState(() {
      _year = year;
      _month = month;
      _day = date;
      if (dateBtn1) {
        startDateField = '$date-$month-$year';
        realStartDate=realDate;
      } else {
       if(continual){
          endDateField = 'Continous';
       }else{
          endDateField = '$date-$month-$year';
       }
        realEndDate=realDate;
      }
    });
  }

  String getDateValue(timestamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var day = date.day, year = date.year, month = date.month;
    return '$day-$month-$year';
  }

  isLoading() {
    if (mounted) {
      setState(() {
        if (loading) {
          loading = false;
        } else {
          loading = true;
        }
      });
    }
  }
}
