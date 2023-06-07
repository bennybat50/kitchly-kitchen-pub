import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'dish_action.dart';
import 'dish_choice.dart';
import 'view_dish.dart';

class Dishes extends StatefulWidget {
  final scaffoldKey;
  const Dishes({Key key, this.scaffoldKey}) : super(key: key);
  @override
  _DishesState createState() => _DishesState();
}

class _DishesState extends State<Dishes> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  String menuField;
  AppBloc appBloc = AppBloc();
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0),
          child: PublicVar.hasDish ? checkDishData() : firstDishWidget(),
        ),
      ),
      floatingActionButton:
          PublicVar.hasDish ? btnCreateDish(text: "Create Dish") : null,
    );
  }

  checkDishData() {
    if (!appBloc.hasDish) {
      return FutureBuilder(
        initialData: appBloc.dish,
        builder: (ctx, snap) {
          if (snap.data == "false") {
            return noNetwork();
          }
          if (snap.data == "empty") {
            return firstDishWidget();
          }
          if (snap.connectionState == ConnectionState.waiting ||
              snap.connectionState == ConnectionState.active) {
            return ShowPageLoading();
          }
          return dishBuilder();
        },
        future: getDishes(),
      );
    } else {
      return dishBuilder();
    }
  }

  dishBuilder() {
    if (appBloc.dish.length == 0) {
      return noData();
    } else {
      return ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: FilterChip(
                    label: Text(appBloc.dish[i]['name'] ?? ''),
                    
                    onSelected: (bool value) {
                      appBloc.selectedCategoryIndex = i;
                      appBloc.selectedCategory = appBloc.dish[i]['dishes'];
                      appBloc.selectedCategoryId = '${appBloc.dish[i]['id']}';
                    },
                    
                    showCheckmark: false,
                    tooltip: 'Select from list of categories',
                    selected: appBloc.selectedCategoryId
                        .contains('${appBloc.dish[i]['id']}'),
                    selectedColor: Color(PublicVar.primaryColor).withOpacity(0.4),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                    backgroundColor: Colors.white,
                  ),
                );
              },
              itemCount: appBloc.dish.length,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: ListView.separated(
                separatorBuilder: (ctx, i) {
                  return Divider();
                },
                itemCount: appBloc.selectedCategory.length,
                reverse: true,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 4),
                      onTap: () {
                       if(!PublicVar.onProduction) print(appBloc.selectedCategoryIndex);
                        NextPage().nextRoute(
                            context,
                            ViewDish(
                              categoryIndex: appBloc.selectedCategoryIndex,
                              dishIndex: i,
                            ));
                      },
                      onLongPress: () => askDeleteDish(
                          cix: appBloc.selectedCategoryIndex, dix: i),
                      leading: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        color: Colors.black.withOpacity(0.6),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          splashColor: Colors.grey.withOpacity(0.6),
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 120,
                              width: 60,
                              child: GetImageProvider(
                                placeHolder: PublicVar.defaultKitchenImage,
                                url: appBloc.selectedCategory[i]['image'],
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        appBloc.selectedCategory[i]['name'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      subtitle: Text(
                        '${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.selectedCategory[i]['price']) }',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: (){
                          if(appBloc.selectedCategory[i]['instock']){
                            AppActions().showAppDialog(
                                context,
                                title: 'Out of stock?',
                                descp:
                                    'Your customers will not be able to order this dish, are you sure you want to remove it from your stock?',
                                okText: "Confirm",
                                cancleText: "Cancel",
                                danger:true,
                                cancleAction: () => Navigator.pop(context),
                                okAction: () async {
                                  changeStockStatus(cix: appBloc.selectedCategoryIndex, dix: i,hasStock: false,dishId:appBloc.selectedCategory[i]['id']);
                                  Navigator.pop(context);
                                });
                            
                          }else{
                                changeStockStatus(cix: appBloc.selectedCategoryIndex, dix: i,hasStock: true,dishId: appBloc.selectedCategory[i]['id']);
                          }
                        },
                        icon:Icon(appBloc.selectedCategory[i]['instock']?Feather.eye:Feather.eye_off, size: 24,
                       color:appBloc.selectedCategory[i]['instock']?Colors.black:Colors.grey,),),
                    ),
                  );
                }),
          )
        ,SizedBox(height: 100,)
        ],
      );
    }
  }

  askDeleteDish({
    cix,
    dix,
  }) async {
    AppActions().showAppDialog(
        context,
        title: 'Delete Dish?',
        descp:
            'Are you sure you want to delete ${appBloc.dish[cix]['dishes'][dix]['name']} from your menu?',
        okText: "Delete",
        cancleText: "Cancel",
        danger:true,
        cancleAction: () => Navigator.pop(context),
        okAction: () async {
          Navigator.pop(context);
          if (await Server().deleteAction(
              bloc: appBloc,
              url: Urls.dishActions,
              data: {"dish_id": appBloc.dish[cix]['dishes'][dix]['id']})) {
            appBloc.dish[cix]['dishes'].removeAt(dix);
            appBloc.dish = appBloc.dish;
            AppActions().showSuccessToast(text: 'Dish delete',context: context,);
          } else {
            AppActions().showErrorToast(text: '${appBloc.errorMsg}',context: context,);
          }
        });
  }

  changeStockStatus({cix,dix,dishId,bool hasStock})async {
    if(await Server().putAction(bloc: appBloc,url: '${Urls.dishActions}$dishId/instock',
     data: {"available":hasStock,"kitchen_id":PublicVar.kitchenID})){
      appBloc.dish[cix]['dishes'][dix]['instock']=hasStock;
      appBloc.dish = appBloc.dish;
      AppActions().showSuccessToast(text: hasStock?'Dish is available':'Dish is out of stock',context: context,);
    }else{
      AppActions().showErrorToast(text: '${appBloc.errorMsg}',context: context,);
    }
  }

  firstDishWidget() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal:8.0),
      child: DisplayMessage(
        onPress: () => openCreateDish(),
        asset: 'assets/images/icons/dish_icon.png',
        title: 'Create Dish',
        message:'Create a dish under any of the category you created and you can include the extras too.',
        btnText: 'Create Dish',
      ),
    );
  }

  noNetwork() {
    return DisplayMessage(
      onPress: () => reload(),
      asset: 'assets/images/icons/connection_icon.png',
      message: PublicVar.checkInternet,
      btnText: 'Reload',
    );
  }

  btnCreateDish({String text}) {
    return FloatingTextButton(
      text: "Add Dish",
      icon: Icons.add,
      onTap: () => openCreateDish(),
    );
  }

  noData() {
    return DisplayMessage(
      onPress: () => reload(),
      asset: 'assets/images/icons/dataError_icon.png',
      message: PublicVar.requestErrorString,
      btnText: 'Reload',
      btnWidth: 100,
    );
  }

  openCreateDish() {
    if (PublicVar.hasCategory && appBloc.dish.length > 0) {
      appBloc.selectedMeals = [];
      NextPage().nextRoute(context,DishChoice(
        
      ));
    } else {
      AppActions().showErrorToast(
          text: 'Please you have to create a menu category before creating a dish',context: context,);
    }
  }

  getDishes() async {
    return await Server()
        .getDishes(appBloc: appBloc, data: PublicVar.queryKitchen);
  }

  reload() {
    appBloc.hasDish = false;
    setState(() {});
  }
}
