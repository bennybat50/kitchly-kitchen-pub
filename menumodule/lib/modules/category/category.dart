import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:menumodule/menumodule.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

import 'view_category.dart';

class Category extends StatefulWidget {
  final BuildContext appContext;
  final scaffoldKey;
  const Category({Key key, this.scaffoldKey, this.appContext})
      : super(key: key);
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(),
      _sheetScaffoldKey = new GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController();
  bool _autoValidate = false,
      _btnEnabled = true,
      isNetwork = true,
      _btnSend = false;
  Validation _validation = Validation();
  String categoryField;
  AppBloc appBloc = AppBloc();


  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0),
          child: PublicVar.hasCategory
              ? checkCategoryData() //categoryBuilder() SizedBox
              : firstCategoryWidget(),
        ),
      ),
      floatingActionButton: PublicVar.hasCategory ? btnCreateCategory() : null,
    );
  }

  checkCategoryData() {
    if (!appBloc.hasCategory) {
      return FutureBuilder(
        initialData: appBloc.dish,
        builder: (ctx, snap) {
          if (snap.data == "false") {
            return noNetwork();
          }
          if (snap.data == "empty") {
            return firstCategoryWidget();
          }
          if (snap.connectionState == ConnectionState.waiting ||
              snap.connectionState == ConnectionState.active) {
            return ShowPageLoading();
          }

          return categoryBuilder();
        },
        future: getCategories(),
      );
    } else {
      return categoryBuilder();
    }
  }

  categoryBuilder() {
    if (appBloc.dish.length == 0) {
      return firstCategoryWidget();
    } else {
      return ListView.separated(
          separatorBuilder: (ctx, iy) {
            return Divider();
          },
          itemCount: appBloc.dish.length,
          itemBuilder: (ctx, i) {
            return ListTile(
              onTap: () => NextPage().nextRoute(
                  context,
                  ViewCategory(
                    categoryIndex: i,
                  )),
              onLongPress: () => AppActions().showAppDialog(
                   context,
                  title: 'Delete menu',
                  descp:
                      'Are you sure you want to delete ${appBloc.dish[i]['name']} from your menu?',
                  okText: "Delete",
                  cancleText: "Cancel",
                  danger:true,
                  cancleAction: () => Navigator.pop(context),
                  okAction: () {
                    Navigator.pop(context);
                    if(appBloc.dish[i]['dishes'].length>0){
                      AppActions().showAppDialog(context, title: 'Menu is not empty!',
                      descp:'You cannot delete a menu that still has dishes, remove all the dishes before deleting this menu',
                      singlAction: true,
                      okText: "Ok",);
                    }else{
                      deleteMenu(index: i, id: appBloc.dish[i]['id']);
                    }
                    
                  }),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.black,
                  height: 30,
                  padding: EdgeInsets.symmetric(vertical:4.0,horizontal: 10.0),
                  child: Text(
                    appBloc.dish[i]['name'].toString()[0],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              title: Text(
                "${appBloc.dish[i]['name'] ?? ""}",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              subtitle: Text(
                '${appBloc.dish[i]['dishes'].length} dishes',
                style: TextStyle(fontSize: 14),
              ),
            );
          });
    }
  }

  firstCategoryWidget() {
    return DisplayMessage(
      onPress: () => showAddCategorySheet(),
      asset: 'assets/images/icons/category_icon.png',
      title: "Create Category",
      message: 'Create Menu category for your kitchen.',
      btnText: 'Create Category',
      btnWidth: 150,
    );
  }

  btnCreateCategory() {
    return FloatingTextButton(
     text: "Add Category",
      icon: Icons.add,
      width: 140.0,
      onTap: () => showAddCategorySheet(),
     
    );
  }

  

  showAddCategorySheet() {
    AppActions().showAppDialog(context,
            title: "Create menu category",
            descp: "Create a menu category, so you can categorize all your dish",
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:8.0,vertical: 8.0),
              child: Container(
                child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.always,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 5.0,
                            ),
                            child: TextFormField(
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              controller: categoryController,
                              validator: _validation.text,
                              onEditingComplete: () => validate(),
                              onSaved: (String val) {
                                categoryField = val;
                              },
                              decoration: FormDecorator(
                                  hint: 'Enter category Name',
                                  helper: 'e.g Soup'),
                            ),
                          ),
                        ),
              ),
            ), okAction: () => validate(), okText: "Create", cancleText: "Cancel");
  }

  validate() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FocusScope.of(context).unfocus();
      if (await AppActions().checkInternetConnection()) {
        AppActions().showLoadingToast(text: PublicVar.wait,context: context,);
        saveCategory();
      } else {
        AppActions().showErrorToast(text: PublicVar.checkInternet,context: context,);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  saveCategory() async {
    Map data = {
      "kitchen_id": PublicVar.kitchenID,
      "title": categoryController.text,
      "token": PublicVar.getToken
    };
    Navigator.pop(context);
    if (await Server()
        .postAction(bloc: appBloc, url: Urls.createMenu, data: data)) {
      
      if (appBloc.dish.length == 0) {
        await Server()
            .getDishes(appBloc: appBloc, data: PublicVar.queryKitchen);
      } else {
        Map data = {
          'id': appBloc.mapSuccess['id'],
          'name': appBloc.mapSuccess['title'],
          'dishes': [],
        };
        appBloc.dish.add(data);
        appBloc.dish = appBloc.dish;
      }

      AppActions().showSuccessToast(text: 'Category added',context: context,);
      if (!PublicVar.hasCategory || appBloc.dish.length == 1) {
        AppActions().showAppDialog(context,
            title: "Create a dish",
            descp: "Next step is to create a dish under ${categoryController.text.toUpperCase()}",
             okAction: () {
               categoryController.clear();
               setState(() {
                SharedStore().setData(type: 'bool', key: 'firstCategory', data: true);
                PublicVar.hasCategory = true;
              });
              Navigator.pop(context);
               NextPage().nextRoute(context, DishAction(update: false, catIndex: 0,category: appBloc.dish[0],));
             }, okText: "Create Dish", singlAction: true);
        
      }else{
        categoryController.clear();
      }
    } else {
      AppActions().showErrorToast(text: appBloc.errorMsg,context: context,);
    }
  }

  getCategories() async {
    return await Server()
        .getDishes(appBloc: appBloc, data: PublicVar.queryKitchen);
  }

  deleteMenu({id, index}) async {
    AppActions().showLoadingToast(text: PublicVar.wait,context: context,);
    var data = {
      "nokey": {"menu_id": id},
      "token": PublicVar.getToken,
    };
    if(!PublicVar.onProduction)print(data['nokey']);
    if (await Server()
        .deleteAction(bloc: appBloc, data: data, url: Urls.deleteMenu)) {
       appBloc.dish.removeAt(index);
      appBloc.dish = appBloc.dish;
      if(!PublicVar.onProduction)print('${appBloc.dish} and $index');
      if (mounted) setState(() {});
      AppActions().showSuccessToast(text: "Menu Deleted!",context: context,);
    } else {
      AppActions().showErrorToast(text: appBloc.errorMsg,context: context,);
    }
  }

  noNetwork() {
    return DisplayMessage(
      onPress: () => reload(),
      asset: 'assets/images/icons/connection_icon.png',
      message: PublicVar.checkInternet,
      btnText: 'Reload',
      btnWidth: 100,
    );
  }



  reload() {
    appBloc.hasCategory = false;
    setState(() {});
  }


}
