import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

class OptionAction extends StatefulWidget {
  final bool update, online;
  final extraIndex;
  const OptionAction({Key key, this.update, this.extraIndex, this.online})
      : super(key: key);
  @override
  _OptionActionState createState() => _OptionActionState();
}

class _OptionActionState extends State<OptionAction> {
  AppBloc appBloc = AppBloc();
  GlobalKey<FormState> _sheetFormKey = GlobalKey<FormState>();
  var itemNameController = TextEditingController(),
      itemPriceController = TextEditingController();
  bool _autoValidateSheet = false,
      edit = false,
      loading = false,
      update,
      online,
      nameFocus = false;
  String itemNameField, itemPriceField;
  int index = 0, extraIndex;
  @override
  void initState() {
    update = widget.update;
    online = widget.online;
    extraIndex = widget.extraIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          update ? "Update Items" : "Add Items",
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
        actions: <Widget>[],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10.0),
                  child: Text(
                    'Populate your extra with items e.g \nName: Coke; Price: 200.00',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0, color: Colors.black87),
                  ),
                ),
                Form(
                  key: _sheetFormKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 5.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              autofocus: nameFocus,
                              keyboardType: TextInputType.text,
                              controller: itemNameController,
                              textCapitalization: TextCapitalization.sentences,
                              validator: Validation().text,
                              onEditingComplete: () {
                    FocusScope.of(context).unfocus();
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
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              autofocus: false,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              controller: itemPriceController,
                              validator: Validation().text,
                              onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                              
                              onSaved: (String val) {
                                itemPriceField = val;
                              },
                              decoration: FormDecorator(
                                  hint: 'Price', helper: 'e.g N550'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: ButtonWidget(
                    onPress: () => validateItemsSheet(),
                    width: 100.0,
                    height: 35.0,
                    textIcon: Ionicons.ios_add,
                    radius: 20.0,
                    fontSize: 15.0,
                    txColor: Colors.white,
                    bgColor: edit ? Colors.orange : Colors.black54,
                    text: edit ? 'Update' : 'Add',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: ListView.separated(
                      separatorBuilder: (context, i) {
                        return Divider();
                      },
                      shrinkWrap: true,
                      reverse: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: appBloc.optionItems.length,
                      itemBuilder: (context, i) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                CapitalizeText()
                                    .capitalize(appBloc.optionItems[i]['name']),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black87),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    ' ${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.optionItems[i]['price'] )}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black87),
                                  ),
                                ),
                                IconButton(
                                  color: Colors.black54,
                                  icon: Icon(
                                    Feather.edit_2,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    editItem(i);
                                  },
                                ),
                                IconButton(
                                  color: Colors.red[300],
                                  icon: Icon(Ionicons.ios_close_circle),
                                  onPressed: () {
                                    askDeleteExtra(i);
                                  },
                                ),
                              ],
                            )
                          ],
                        );
                      }),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: ButtonWidget(
          onPress: () {
            if (appBloc.optionItems.length > 0) {
              appBloc.optionItems = appBloc.optionItems;
              Navigator.pop(context);
            } else {
              AppActions()
                  .showErrorToast(text: 'Please add an item to your extra',context: context,);
            }
          },
          radius: 0.0,
          fontSize: 20.0,
          height: 50.0,
          loading: loading,
          txColor: Colors.white,
          bgColor: Color(PublicVar.primaryColor),
          text: update ? "Update Items" : 'Save Items'),
    );
  }

  validateItemsSheet() {
    if (_sheetFormKey.currentState.validate()) {
      _sheetFormKey.currentState.save();
      if (edit) {
        updateItem();
      } else {
        addItem();
      }
    } else {
      setState(() => _autoValidateSheet = true);
    }
  }

  addItem() async {
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
    });
  }

  updateItem() async {
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

  saveOptions() async {
    Map optionData = {
      'kitchen_id': PublicVar.kitchenID,
      "option": update ? 1 : null,
      'options': appBloc.optionItems
    };
    Map data = {"token": PublicVar.getToken, 'nokey': optionData};
    if (await Server()
        .postAction(url: Urls.optionsAction, data: data, bloc: appBloc)) {
    } else {
      isLoading();
      AppActions().showErrorToast(text: appBloc.errorMsg,context: context,);
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
