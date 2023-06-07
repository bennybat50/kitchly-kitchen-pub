
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

import 'options_actions.dart';

class ExtraAction extends StatefulWidget {
  final bool update, online,itemOnly;
  final extraIndex;
  const ExtraAction({Key key, this.update, this.extraIndex, this.online, this.itemOnly})
      : super(key: key);
  @override
  _ExtraActionState createState() => _ExtraActionState();
}

class _ExtraActionState extends State<ExtraAction> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(),
      _sheetScaffoldKey = new GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(),
      sheetFormKey = GlobalKey<FormState>();
  var extraId;
  bool edit = false,
      loading = false,
      necessary = false,
      update,
      online,
      nameFocus = false;
  String itemNameField, itemPriceField;
  int index = 0, extraIndex;
  ScrollController scrollController = ScrollController();
  TextEditingController nameController = TextEditingController(),
      desController = TextEditingController(),
      minController = TextEditingController(),
      itemNameController = TextEditingController(),
      itemPriceController = TextEditingController(),
      maxController = TextEditingController();
  final formPadding = EdgeInsets.symmetric(vertical: 10.0);

  AppBloc appBloc;
  String nameField,
      selectedDifficulty,
      durationField,
      descField,
      minField,
      maxField;
  @override
  initState() {
    extraIndex = widget.extraIndex;
    update = widget.update;
    checkIfUpdate();
     if(widget.itemOnly){
       Future.delayed(Duration(milliseconds: 2),(){
       scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.ease);
     });
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
          update ? 'Update Extra (${nameController.text})' : 'Add Extra',
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: Icon(
            Ionicons.ios_close,
            size: 45,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          controller:  scrollController,
                  child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 14.0),
                  child: Text(
                    'Describe details about extra by using the form below',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.0, color: Colors.black87),
                  ),
                ),
                Padding(
                  padding: formPadding,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    },
                    textCapitalization: TextCapitalization.sentences,
                    controller: nameController,
                    validator: Validation().text,
                    onSaved: (String val) {
                      nameField = val;
                    },
                    decoration:
                        FormDecorator(helper: 'e.g Drinks', hint: "Enter Name "),
                  ),
                ),
                Padding(
                  padding: formPadding,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: desController,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    },
                    textCapitalization: TextCapitalization.sentences,
                    validator: Validation().text,
                    maxLines: null,
                    onSaved: (String val) {
                      descField = val;
                    },
                    decoration: FormDecorator(
                        helper: 'e.g select your protein of choice',
                        hint: 'Describe Extra'),
                  ),
                ),
                ListTile(
                  title: Text(
                    necessary ? 'Necessary' : 'Not Necessary',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      'Check necessary if your customers must choose this extra'),
                  trailing: CupertinoSwitch(
                    value: necessary,
                    onChanged: (value) {
                      changeRequiredStatus();
                    },
                    activeColor: Color(PublicVar.primaryColor),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 15.0,
                  ),
                  child: Row(children: [
                    Text(
                    'Quantity to select ',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w800),
                  )
                  ],),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: minController,
                        validator: Validation().oneNumber,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        onSaved: (String val) {
                          minField = val;
                        },
                        decoration:
                            FormDecorator(hint: 'Min', helper: '2 pieces'),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: maxController,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                        validator: Validation().oneNumber,
                        onSaved: (String val) {
                          maxField = val;
                        },
                        decoration:FormDecorator(hint: 'Max', helper: '10 pieces'),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Add Items",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                      IconButton(
                        color: Color(PublicVar.primaryColor),
                        iconSize: 30,
                        icon: Icon(Icons.add_circle_rounded),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          optionsActionDialog();
                          
                        },
                      )
                    ],
                  ),
                ),
                ListView.separated(
                    separatorBuilder: (context, i) {
                      return Divider();
                    },
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: appBloc.optionItems.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: Text("*",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                        title: Text(
                          " ${CapitalizeText().capitalize(appBloc.optionItems[i]['name'])}",
                          style: TextStyle(fontSize: 17.0, color: Colors.black,fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'], number: appBloc.optionItems[i]['price'])}',
                          style: TextStyle(fontSize: 15.0, color: Colors.black),
                        ),
                        trailing: Wrap(
                          children: [
                            IconButton(
                              color: Colors.black54,
                              icon: Icon(
                                Icons.edit_rounded,
                                size: 18,
                              ),
                              onPressed: () {
                                editItem(i);
                              },
                            ),
                            IconButton(
                              color: Colors.red[300],
                              icon: Icon(
                                Ionicons.ios_close_circle,
                                size: 18,
                              ),
                              onPressed: () {
                                askDeleteExtra(i);
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:8.0,vertical: 60),
                      child: ButtonWidget(
        onPress: () => validate(),
        height: 50.0,
        fontSize: 20.0,
        loading: loading,
        txColor: Colors.white,
        bgColor: Color(PublicVar.primaryColor),
        text: update ? 'Update Extra' : "Save Extra",
      ),
                    ),
                SizedBox(
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  validate() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (appBloc.optionItems.length == 0) {
        openEmptyExtraDialog();
      } else {
        isLoading();
        if (await AppActions().checkInternetConnection()) {
          if (update) {
            updateExtra();
          } else {
            if (appBloc.optionItems.length > 0) {
              saveOptions();
            } else {
              openEmptyExtraDialog();
            }
          }
        } else {
          isLoading();
          AppActions().showErrorToast(
            text: PublicVar.checkInternet,
            context: context,
          );
        }
      }
    }
  }

  openEmptyExtraDialog() {
    AppActions().showAppDialog(context,
        title: 'Empty Items',
        descp: 'Please add items to extra before saving',
        okText: "Ok",
        singlAction: true, okAction: () async {
      Navigator.pop(context);
      NextPage().nextRoute(
          context,
          OptionAction(
            update: false,
            online: widget.online,
          ));
    });
  }

  optionsActionDialog() {
    AppActions().showAppDialog(context,
        title: "Add Item",
        descp: "Populate your extra with items e.g \nName: Coke; Price: 200.00",
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
          child: Container(
            child: Form(
              key: sheetFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 5.0,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextFormField(
                          autofocus: nameFocus,
                          keyboardType: TextInputType.text,
                          controller: itemNameController,
                          textCapitalization: TextCapitalization.sentences,
                          validator: Validation().text,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            validateItemsSheet();
                          },
                          onSaved: (String val) {
                            itemNameField = val;
                          },
                          decoration: FormDecorator(
                              hint: 'Name', helper: 'e.g Fresh Fish'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextFormField(
                          autofocus: false,
                          keyboardType:
                              TextInputType.number,
                          controller: itemPriceController,
                          validator: Validation().oneNumber,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            validateItemsSheet();
                          },
                          onSaved: (String val) {
                            itemPriceField = val;
                          },
                          decoration:
                              FormDecorator(hint: 'Price', helper: 'e.g 550'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        okAction: () =>validateItemsSheet(),
        okText: edit?"Update Item":"Add Item",
        cancleText: "Close");
  }

  validateItemsSheet() {
    FocusScope.of(context).unfocus();
    if (sheetFormKey.currentState.validate()) {
       sheetFormKey.currentState.save();
      if (edit) {
        updateItem();
      } else {
        addItem();
      }
    } 
  }

  addItem() async {
    FocusScope.of(context).unfocus();
    Map data = {
      "nokey": {
        "kitchen_id": PublicVar.kitchenID,
        "options": [
          {
            'name': itemNameField,
            'price': double.parse(itemPriceField),
          }
        ]
      },
      'token': PublicVar.getToken
    };
    if (widget.online) {
     if(!PublicVar.onProduction) print(
          "${Urls.optionsAction}/${appBloc.extras[extraIndex]['option']}/add");
      if (await Server().putAction(
          bloc: appBloc,
          data: data,
          url:
              "${Urls.optionsAction}/${appBloc.extras[extraIndex]['option']}/add")) {
       if(!PublicVar.onProduction) print(appBloc.mapSuccess);
        AppActions().showSuccessToast(text: "Item added",context: context,);
      } else {
        AppActions().showErrorToast(text: appBloc.errorMsg,context: context,);
      }
    }
    setState(() {
      appBloc.optionItems.add(data['nokey']['options'][0]);
      nameFocus = true;
    });
    itemNameController.clear();
    itemPriceController.clear();
  }

  editItem(i) async {
    setState(() {
      itemNameController.text = appBloc.optionItems[i]['name'];
      itemPriceController.text = "${appBloc.optionItems[i]['price']}";
      index = i;
      edit = true;
      nameFocus = true;
      optionsActionDialog();
    });
  }

  updateItem() async {
    FocusScope.of(context).unfocus();
    if (index != null && appBloc.optionItems.length > 0) {
      setState(() {
        appBloc.optionItems[index]['name'] = itemNameField;
        appBloc.optionItems[index]['price'] = double.parse(itemPriceField);
        edit = false;
        nameFocus = false;
      });
      itemNameController.clear();
      itemPriceController.clear();
      if (widget.online) {
        var data = {
          "name": appBloc.optionItems[index]['name'],
          "price": double.parse(appBloc.optionItems[index]['price'].toString())
        };
        if (await Server().putAction(
            bloc: appBloc,
            data: data,
            url: "${Urls.optionsAction}/${appBloc.optionItems[index]['id']}")) {
          AppActions().showSuccessToast(text: "Item updated",context: context,);
        } else {
          AppActions().showErrorToast(text: appBloc.errorMsg,context: context,);
        }
      }
    } else {
      addItem();
    }
    Navigator.pop(context);
  }

   askDeleteExtra(i) {
    AppActions().showAppDialog(
         context,
        title: 'Remove item',
        descp: 'Are you sure you want to remove this item from the list ?',
        okText: "Delete",
        cancleText: "Cancel",
        danger:true,
        cancleAction: () => Navigator.pop(context),
        okAction: () {
          Navigator.pop(context);
          removeItem(i);
        });
  }

  removeItem(i) async {
    
    if (widget.online) {
      var data = {
        "option_id": appBloc.optionItems[i]['id'],
      };
     if(!PublicVar.onProduction) print(appBloc.optionItems[i]['id']);
      if (await Server().deleteAction(
          bloc: appBloc, data: data, url: "${Urls.optionsAction}")) {
        AppActions().showSuccessToast(text: "Item Deleted",context: context,);
      } else {
        AppActions().showErrorToast(text: appBloc.errorMsg,context: context,);
      }
    }
    setState(() {
      appBloc.optionItems.removeAt(i);
    });
  }

  checkIfUpdate() async {
    await Future.delayed(Duration(milliseconds: 1), () {
      if (update) {
        update = widget.update;
        extraId = appBloc.extras[extraIndex]['id'];
        nameController.text = appBloc.extras[extraIndex]['name'];
        desController.text = appBloc.extras[extraIndex]['descp'];
        maxController.text = "${appBloc.extras[extraIndex]['max']}";
        minController.text = "${appBloc.extras[extraIndex]['min']}";
        necessary = appBloc.extras[extraIndex]['required'];
      }
    });
    setState(() {});
  }

  changeRequiredStatus() {
    if (necessary) {
      necessary = false;
    } else {
      necessary = true;
    }
    setState(() {});
  }

  saveOptions() async {
    Map optionData = {
      'kitchen_id': PublicVar.kitchenID,
      'options': appBloc.optionItems
    };
    Map data = {"token": PublicVar.getToken, 'nokey': optionData};
    if (await Server()
        .postAction(url: Urls.optionsAction, data: data, bloc: appBloc)) {
      appBloc.optionId = appBloc.mapSuccess['option_id'];
      saveExtras();
    } else {
      isLoading();
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
  }

  saveExtras() async {
    var max = int.parse(double.parse(maxField).round().toString()),
        min = int.parse(double.parse(minField).round().toString());
    Map extraData = {
      "extra": {
        "type": 1,
        "name": nameField,
        "caption": descField,
        "descp": descField,
        "max": max,
        "min": min,
        "required": necessary,
      },
      "option": appBloc.optionId,
      "kitchen_id": PublicVar.kitchenID
    };
    Map data = {
      "token": PublicVar.getToken,
      'nokey': extraData,
    };
    if (!PublicVar.onProduction) print(data);
    if (await Server()
        .postAction(url: Urls.extrasAction, data: data, bloc: appBloc)) {
      if (!PublicVar.hasExtra) {
        setState(() {
          SharedStore().setData(type: 'bool', key: 'firstExtra', data: true);
          PublicVar.hasExtra = true;
        });
      }
      appBloc.extras.add(extraData);
      await Server().getExtras(appBloc: appBloc, data: PublicVar.queryKitchen);
      isLoading();

      AppActions().showSuccessToast(
        text: 'Extra added',
        context: context,
      );
      Navigator.pop(context);
    } else {
      isLoading();
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
  }

  updateExtra() async {
    var max = int.parse(double.parse(maxField).round().toString()),
        min = int.parse(double.parse(minField).round().toString());
    Map extraData = {
      "caption": "",
      "descp": descField,
      "option": appBloc.extras[extraIndex]['option'],
      "required": necessary,
      "max": max,
      "min": min,
      "type": 1,
      "name": nameField
    };
    Map data = {
      "token": PublicVar.getToken,
      "nokey": extraData,
    };
    if (await Server().putAction(
        url: '${Urls.extrasAction}/$extraId', data: data, bloc: appBloc)) {
      await Server().getExtras(appBloc: appBloc, data: PublicVar.queryKitchen);
      appBloc.extras[extraIndex]['name'] = nameField;
      appBloc.extras[extraIndex]['descp'] = descField;
      appBloc.extras[extraIndex]['max'] = max;
      appBloc.extras[extraIndex]['min'] = min;
      appBloc.extras = appBloc.extras;
      await Server().getDishes(appBloc: appBloc, data: PublicVar.queryKitchen);
      isLoading();
      AppActions().showSuccessToast(
        text: 'Extra Updated',
        context: context,
      );
      Navigator.pop(context);
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
      if (loading) {
        loading = false;
      } else {
        loading = true;
      }
    });
  }
}
