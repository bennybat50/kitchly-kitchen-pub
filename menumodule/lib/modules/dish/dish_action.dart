import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:menumodule/menumodule.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

import 'meals.dart';

class DishAction extends StatefulWidget {
  final Map category;
  final bool update;
  final dishIndex, catIndex;
  const DishAction({
    Key key,
    this.category,
    this.update,
    this.dishIndex,
    this.catIndex,
  }) : super(key: key);
  @override
  _DishActionState createState() => _DishActionState();
}

class _DishActionState extends State<DishAction> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(),
      _sheetScaffoldKey = new GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(),
      _sheetFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController(),
      desController = TextEditingController(),
      packageController = TextEditingController(),
      priceController = TextEditingController(),
      durationController = TextEditingController(),
      deliveryController = TextEditingController(),
      itemNameController = TextEditingController(),
      itemPriceController = TextEditingController();
  final formPadding = EdgeInsets.symmetric(vertical: 8.0);
  bool _autoValidate = false,
      _autoValidateSheet = false,
      _btnEnabled = true,
      edit = false,
      isNetwork = true,
      loading = false,update;
  Validation _validation = Validation();
  File imageFile;
  CompressImage compress = CompressImage();
  AppBloc appBloc = AppBloc();
  List items = [];
  var selectedExtras = [],
      onlineExtras = [],
      categoryList = [],
      selectedCategory = [],
      onlineMeals = [];
  int index = 0, cix, dix;
  String nameField,
      dishId,
      descField,
      packageField="0.0",
      priceField,
      durationField,
      imageUrl,
      deliveryField;
  var durationsList = [
    {'name': '10 min', 'value': '10'},
    {'name': '20 min', 'value': '20'},
    {'name': '30 min', 'value': '30'},
    {'name': '45 min', 'value': '45'},
    {'name': '1 Hr', 'value': '60'},
    {'name': '1 Hr 15 min', 'value': '75'},
    {'name': '1 Hr 30 min', 'value': '90'},
    {'name': '1 Hr 45 min', 'value': '105'},
    {'name': '2 Hr', 'value': '120'},
  ];
  @override
  void initState() {
    if (widget.category != null) {
      selectedCategory.add(widget.category);
      cix = widget.catIndex;
    }
    if (widget.update) {
      update = true;
      dix = widget.dishIndex;
      dishId = "${widget.category['dishes'][widget.dishIndex]['id']}";
      nameController.text =
          "${widget.category['dishes'][widget.dishIndex]['name']}";
      desController.text =
          "${widget.category['dishes'][widget.dishIndex]['descp']}";
      priceController.text =
          '${widget.category['dishes'][widget.dishIndex]['price']}';
      durationController.text =
          "${widget.category['dishes'][widget.dishIndex]['duration']}";
      packageController.text =
          "${widget.category['dishes'][widget.dishIndex]['package_cost']}";
      imageUrl = widget.category['dishes'][widget.dishIndex]['image'];
      onlineMeals = widget.category['dishes'][widget.dishIndex]['meal_types'];
      onlineExtras = widget.category['dishes'][widget.dishIndex]['extras'];
    } else {
      update = false;
    }
    checkMeals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    categoryList = appBloc.dish;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          update ? 'Update Dish' : 'Create Dish',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: 30,
          ),
          onPressed: () {
            if (!loading) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                child: Text(
                  'Describe details about your dish by using the form below',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.0, color: Colors.black87),
                ),
              ),
              Padding(
                padding: formPadding,
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 80,
                      width: 80,
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
                                          ? AssetImage(
                                              PublicVar.defaultKitchenImage)
                                          : NetworkImage(
                                              imageUrl,
                                            )
                                      : AssetImage(
                                          PublicVar.defaultKitchenImage)
                                  : FileImage(imageFile),
                              fit: BoxFit.cover),
                          color: Colors.grey[100]),
                    ),
                  ),
                  Expanded(
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
                          hint: 'Enter Name',
                          
                          helper: 'e.g Egusi Soup'),
                    ),
                  ),
                ]),
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
                      helper:
                          'e.g Egusi soup cooked with snails,periwinkle \nand sea foods',
                      hint: 'Describe Dish'),
                ),
              ),
              Padding(
                padding: formPadding,
                child: Padding(
                  padding: formPadding,
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      goToMealPage();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: appBloc.selectedMeals.length == 0 ? 80 : null,
                      width: double.infinity,
                      child: appBloc.selectedMeals.length == 0
                          ? Text(
                              'Select Cuisine Type e.g Africa,launch,dinner,Intercontinental',
                              style: TextStyle(color: Colors.black54),
                            )
                          : Wrap(
                              children: List.generate(
                                appBloc.selectedMeals.length,
                                (i) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 1),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      color: Colors.black87,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Text(
                                        '${CapitalizeText().capitalize(appBloc.selectedMeals[i]['name'])}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[100]),
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        showAddCategorySheet();
                      },
                      child: Column(children:[
                        Container(
                        alignment: Alignment.centerLeft,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                        height: 60,
                        width: double.infinity,
                        child: selectedCategory.length == 0
                            ? Text(
                                'Category',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 16),
                              )
                            : Wrap(
                                children: List.generate(
                                  selectedCategory.length,
                                  (i) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 4),
                                    child: Text(
                                      '${selectedCategory[i]['name']}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200]),
                      ),
                    SizedBox(height:24)
                      ])),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.0),
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
                        decoration: FormDecorator(
                            hint: 'Dish Price', helper: 'e.g N1500'),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: durationController,
                          validator: _validation.oneNumber,
                          onTap: () {
                            showAddPeriodSheet();
                            FocusScope.of(context).unfocus();
                          },
                          onSaved: (String val) {
                            durationField = val;
                          },
                          decoration: FormDecorator(
                              hint: 'Delivery Period',
                              helper: 'include preparation time too'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: packageController,
                          validator: _validation.oneNumber,
                          onSaved: (String val) {
                            packageField = val;
                          },
                          decoration: FormDecorator(
                              hint: 'Package Cost', helper: 'e.g N20'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      appBloc.selectedExtra.length > 0
                          ? "Update Extras"
                          : 'Add Extras',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      color: Color(PublicVar.primaryColor),
                      iconSize: 30,
                      icon: Icon(Icons.add_circle_rounded),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        checkExtras();
                      },
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  checkExtras();
                },
                child: Container(
                    child: Wrap(
                  children: List.generate(
                    selectedExtras.length,
                    (i) => Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
                      child: Chip(
                        label: Text(selectedExtras[i]['name']),
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.black87,
                      ),
                    ),
                  ),
                )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal:8.0,vertical: 60),
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
        text: update ? 'Update Dish' : 'Save Dish',
      ),
              ),
              SizedBox(
                height: 500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkExtras() async {
    if (!PublicVar.hasExtra) {
      AppActions().showAppDialog(context,
          title: 'Kitchen dose not have extras yet.',
          descp:'Please add extras to your menu so you can include them in your dishes',
          okText: "Add Extra",
          cancleText: "Cancel",
          cancleAction: () => Navigator.pop(context),
          okAction: () async {
            Navigator.pop(context);
            appBloc.optionItems = [];
            NextPage().nextRoute(
                context,
                ExtraAction(
                  update: false,
            online: false,
            itemOnly: false,
                ));
          });
    } else if (appBloc.extras.length > 0) {
      showAddExtrasSheet();
    } else {
      await Server().getExtras(data: PublicVar.queryKitchen, appBloc: appBloc);
      showAddExtrasSheet();
    }
  }

  showAddExtrasSheet() {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
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
              bottomNavigationBar: Container(
                height: 130,
                child:Column(children:[
                   Divider(),
                  Padding(
                padding:  EdgeInsets.symmetric(vertical:2.0),
                child: TextButton(
                            onPressed: (){
                              NextPage().nextRoute(
                  context,
                  ExtraAction(
                    update: false,
                    online: false,
                  ));
                            },
                            child: Text(
                              'Click here to create more extras',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),),
              ),
              Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: ButtonWidget(
                                onPress: () => Navigator.pop(context),
                                width: 100.0,
                                 radius: 40.0,
                                height: 50.0,
                                fontSize: 18.0,
                                bgColor: Colors.grey[200],
                                txColor: Colors.redAccent,
                                text: 'Cancel',
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: ButtonWidget(
                                onPress: () => Navigator.pop(context),
                                width: 100.0,
                                radius: 40.0,
                                height: 50.0,
                                fontSize: 18.0,
                                bgColor: Colors.grey[200],
                                txColor: Color(PublicVar.primaryColor),
                                text: 'Save',
                              ),
                            ),
                          ],
                        )
                ])
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Add Extras',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 6.0),
                          child: Text(
                            'Select your extras for this dish or,',
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.black87),
                          ),
                        ),
                        
                        Container(
                            child: Wrap(
                          children: List.generate(
                            appBloc.extras.length,
                            (i) => Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 8),
                              child: FilterChip(
                                label: Text(appBloc.extras[i]['name']),
                                onSelected: (bool value) {
                                  updateExtras(state, i);
                                },
                                checkmarkColor: Colors.white,
                                selected:
                                    selectedExtras.contains(appBloc.extras[i]),
                                selectedColor: Color(PublicVar.primaryColor),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        )),
                        
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  showAddCategorySheet() {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
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
              bottomNavigationBar: Container(height: 100,child: Column(children:[
                Divider(),
                Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: ButtonWidget(
                                onPress: () => Navigator.pop(context),
                                width: 100.0,
                                 radius: 40.0,
                                height: 50.0,
                                fontSize: 18.0,
                                bgColor: Colors.grey[200],
                                txColor: Colors.redAccent,
                                text: 'Cancel',
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: ButtonWidget(
                                onPress: () => Navigator.pop(context),
                                width: 100.0,
                                radius: 40.0,
                                height: 50.0,
                                fontSize: 18.0,
                                bgColor: Colors.grey[200],
                                txColor: Color(PublicVar.primaryColor),
                                
                                text: 'Save',
                              ),
                            ),
                          ],
                        )
              ]),),
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Choose a category',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20),
                          child: Text(
                            'Select a category for your dish from your category list',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.black87),
                          ),
                        ),
                        Container(
                            child: Wrap(
                          children: List.generate(
                            categoryList.length,
                            (i) => Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 8),
                              child: FilterChip(
                                label: Text(categoryList[i]['name']),
                                onSelected: (bool value) {
                                  updateCategory(state, i);
                                },
                                checkmarkColor: Colors.white,
                                selected:
                                    selectedCategory.contains(categoryList[i]),
                                selectedColor: Color(PublicVar.primaryColor),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                        )),
                        
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  showAddPeriodSheet() {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
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
                        Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Choose preparation period',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20),
                          child: Text(
                            'Time to prepare this dish.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.black87),
                          ),
                        ),
                        Container(
                            child: Column(
                          children: List.generate(
                              durationsList.length,
                              (i) => Column(
                                    children: <Widget>[
                                      ListTile(
                                        onTap: () {
                                          durationController.text =
                                              durationsList[i]['value'];
                                          Navigator.pop(context);
                                          FocusScope.of(context).unfocus();
                                        },
                                        title: Text(
                                          '${durationsList[i]['name']}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        trailing: Icon(
                                          Icons.timer,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  )),
                        )),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<Null> updateExtras(StateSetter updateState, i) async {
    if (selectedExtras.contains(appBloc.extras[i])) {
      selectedExtras.remove(appBloc.extras[i]);
    } else {
      selectedExtras.add(appBloc.extras[i]);
    }
    setState(() {});
    updateState(() {
      selectedExtras = selectedExtras;
    });
  }

  Future<Null> updateCategory(StateSetter updateState, i) async {
    if (selectedCategory.length > 0) {
      selectedCategory.clear();
      selectedCategory.add(categoryList[i]);
    } else {
      selectedCategory.add(categoryList[i]);
    }
    setState(() {});
    updateState(() {
      selectedCategory = selectedCategory;
    });
    Navigator.pop(context);
  }

  validate() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      isLoading();
      if (await AppActions().checkInternetConnection()) {
        update ? saveDish() : checkCategoryAndMeals();
      } else {
        isLoading();
        AppActions().showErrorToast(text: PublicVar.checkInternet,context: context,);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  checkCategoryAndMeals() {
    if (selectedCategory.length == 0) {
      isLoading();
      AppActions().showAppDialog(context,
          title: 'Add dish category',
          descp: 'Please select a category for your dish before saving',
          okText: "Ok",
          singlAction: true, okAction: () async {
        Navigator.pop(context);
        showAddCategorySheet();
      });
    } else if (appBloc.selectedMeals.length == 0) {
      isLoading();
      AppActions().showAppDialog(context,
          title: 'Include cuisines!',
          descp: 'Please include cuisines to your dish before saving',
          okText: "Ok",
          singlAction: true, okAction: () async {
        Navigator.pop(context);
        goToMealPage();
      });
    } else if (selectedExtras.length == 0) {
      isLoading();
      AppActions().showAppDialog(context,
          title: 'Include Extras?',
          descp:
              'Do you want to ${update ? "Update" : "Create"} this dish without extras?',
          okText: "${update ? "Update" : "Save"} Dish",
          danger: false,
          cancleText: "Add Extras", okAction: () async {
        Navigator.pop(context);
        isLoading();
        saveDish();
      }, cancleAction: () async {
        Navigator.pop(context);
        checkExtras();
      });
    } else {
      saveDish();
    }
  }

  saveDish() async {
    List extras = [];
    for (var i = 0; i < selectedExtras.length; i++) {
      extras.add(selectedExtras[i]['id']);
    }
    List meals = [];
    for (var i = 0; i < appBloc.selectedMeals.length; i++) {
      meals.add(appBloc.selectedMeals[i]['id']);
    }
    Map data = {
      'name': nameController.text??"",
      "category": 1,
      'kitchen_id': PublicVar.kitchenID,
      'menu': selectedCategory[0]['id'],
      'group':{
        'type':'PER_PLATE',
      },
      'meal': meals,
      'descp': desController.text??"",
      'package': double.parse(packageField).toStringAsFixed(2),
      'price': double.parse(priceField).toStringAsFixed(2),
      "duration": int.parse(durationField.toString()),
      'extra': extras,
    };
//    print('IDjs id ${data}');
//    print('IDjs id ${dishId}');
//    isLoading();
    if (update
        ? await Server().putAction(
            bloc: appBloc, data: data, url: Urls.dishActions + dishId)
        : await Server()
            .postAction(bloc: appBloc, data: data, url: Urls.createDish)) {
     if(!PublicVar.onProduction) print(appBloc.mapSuccess);

     var id = update ? dishId : appBloc.mapSuccess['id'];

        if(!update){
          await Server().putAction(bloc: appBloc,url: '${Urls.dishActions}$id/instock',
          data: {"available":true,"kitchen_id":PublicVar.kitchenID});
        }

      if (imageFile != null) {
        updateDishImage(dishId: id);
      } else {
        finishAction();
      }
    } else {
      isLoading();
      AppActions().showErrorToast(text: appBloc.errorMsg,context: context,);
    }
  }

  updateDishImage({String dishId}) async {
    var imgFile = await CompressImage().compressAndGetFile(
        file: imageFile, name: "upload_image", extention: ".jpg");
    var data = {'img': imgFile};
    if (await Server().uploadImg(
        appBloc: appBloc,
        url:
            '${Urls.dishActions}$dishId/${PublicVar.kitchenID}/resources',
        data: data)) {
      finishAction();
    } else {
      isLoading();
      AppActions().showErrorToast(text: appBloc.errorMsg,context: context,);
    }
  }

  finishAction() async {
    bool showDialog=false;
    if (!PublicVar.hasDish) {
      setState(() {
        SharedStore().setData(type: 'bool', key: 'firstDish', data: true);
        PublicVar.hasDish = true;
      });
      showDialog=true;
    }
    await Server().getDishes(appBloc: appBloc, data: PublicVar.queryKitchen);
    isLoading();
    if (update) {
      appBloc.dish[cix]['dishes'][dix]['name'] = nameController.text;
      appBloc.dish[cix]['dishes'][dix]['descp'] = desController.text;
      appBloc.dish[cix]['dishes'][dix]['price'] =
          double.parse(priceController.text).toStringAsFixed(2);
      appBloc.dish[cix]['dishes'][dix]['duration'] =
          int.parse(durationField.toString());
      appBloc.dish[cix]['dishes'][dix]['package_cost'] =
          double.parse(packageField).toStringAsFixed(2);
      appBloc.dish = appBloc.dish;

    }
    AppActions().showSuccessToast(context: context,text: update ? 'Dish updated' : 'Dish added');
    if(showDialog){
      AppActions().showAppDialog(context,
          title: 'Congratulations 🎉🎉🎉\n you have created your first dish.',
          descp:'Now that you have created your first dish, you can now activate and open your kitchen, so you can start accepting orders.\n Go to setting and tap on ACTIVATE KITCHEN, then Tap on OPEN KITCHEN',
          okText: "OK",
          singlAction: true, okAction: () async {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }else{

      if(update){
        Navigator.pop(context);
      }else{
        Navigator.pop(context);
        Navigator.pop(context);
      }
      
    }
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
      AppActions().showErrorToast(text: '${e.toString()}',context: context,);
    }
  }

  checkMeals() async {
    if (appBloc.meals.length == 0) {
      await Server().getMeals(appBloc: appBloc);
    }
   await Future.delayed(Duration(milliseconds: 0), () async {
      if (update) {
        if(appBloc.selectedMeals.length==0){
          for (var meal in onlineMeals) {
            for(var aMeal in appBloc.meals){
              if(meal['id']==aMeal['id']){
                if(!PublicVar.onProduction)print('HAS ONLINE IS $meal and OFFLINE IS $aMeal');
                appBloc.selectedMeals.add(aMeal);
              }
            }
        }
        }
        
        for (var mExtra in appBloc.extras) {
          for (var fExtra in onlineExtras) {
            if(mExtra['id']==fExtra['id']){
              selectedExtras.add(mExtra);
            }
          }
        }
        setState(() {});
      }
    });
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

  goToMealPage() {
   if(appBloc.meals.length == 0 && appBloc.selectedMeals.length==0){
      checkMeals();
   }
    NextPage().nextRoute(context, Meals());
  }

  @override
  void dispose()async {
  await  Future.delayed(Duration(milliseconds: 0), () async {
      appBloc.selectedMeals = [];
    });

    super.dispose();
  }
}
