import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:menumodule/menumodule.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

class ViewCategory extends StatefulWidget {
  final categoryIndex;
  const ViewCategory({
    Key key,
    this.categoryIndex,
  }) : super(key: key);
  @override
  _ViewCategoryState createState() => _ViewCategoryState();
}

class _ViewCategoryState extends State<ViewCategory> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(),
      _sheetScaffoldKey = new GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool autoValidate = false,
      _btnEnabled = true,
      isNetwork = true,
      titleDark = false,
      loading = false;
  TextEditingController categoryController = TextEditingController();
  String categoryField;
  AppBloc appBloc = AppBloc();
  int categortIndex;
  ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(listenToScrollChange);
    categortIndex = widget.categoryIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: categoryView(),
        floatingActionButton: appBloc.dish[categortIndex]['dishes'].length == 0
            ? null
            : FloatingTextButton(
                text: "Add Dish",
                icon: Icons.add,
                onTap: () {
                  NextPage().nextRoute(
                      context,
                      DishChoice(
                        catIndex: categortIndex,
                      ));
                },
              ));
  }

  categoryView() {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 170,
                pinned: true,
                titleSpacing: 2.0,
                title: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: titleDark ? 1.0 : 0.0,
                  curve: Curves.ease,
                  child: Text('${appBloc.dish[categortIndex]['name'] ?? ''} ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                leading: BackBtn(
                    onTap: () => Navigator.pop(context),
                    icon: Feather.arrow_left,
                    titleDark: titleDark),
                elevation: 1.0,
                forceElevated: true,
                actions: <Widget>[
                  TextButton(
                      onPressed: () => showAddCategorySheet(),
                      child: Text(
                        "Edit",
                        style: TextStyle(color: Colors.blue),
                      )),
                  TextButton(
                      onPressed: () => askDeleteCategory(),
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.redAccent),
                      )),
                ],
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage(
                            'assets/images/menuimg.jpg',
                          ),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 25.0),
                                  child: Text(
                                    '${appBloc.dish[categortIndex]['name'] ?? ''}',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Divider(),
                          ),
                          appBloc.dish[categortIndex]['dishes'].length == 0
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.only(
                                      left: 18.0, top: 3.0, bottom: 4),
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(
                                          'List of all dishes under this category',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0, bottom: 4),
                            child: appBloc
                                        .dish[categortIndex]['dishes'].length ==
                                    0
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 28.0),
                                    child: Center(child: firstDishWidget()),
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: ListView.separated(
                                        separatorBuilder: (ctx, i) {
                                          return Divider();
                                        },
                                        itemCount: appBloc
                                            .dish[categortIndex]['dishes']
                                            .length,
                                        physics: ScrollPhysics(),
                                        reverse: true,
                                        shrinkWrap: true,
                                        itemBuilder: (ctx, i) {
                                          return ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 6.0,
                                                    horizontal: 20),
                                            onTap: () {
                                              NextPage().nextRoute(
                                                  context,
                                                  ViewDish(
                                                    categoryIndex:
                                                        categortIndex,
                                                    dishIndex: i,
                                                  ));
                                            },
                                            onLongPress: () =>
                                                askDeleteDish(index: i),
                                            leading: Material(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              elevation: 5,
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                splashColor: Colors.grey
                                                    .withOpacity(0.6),
                                                onTap: () {},
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    height: 120,
                                                    width: 60,
                                                    child: GetImageProvider(
                                                      placeHolder: PublicVar
                                                          .defaultKitchenImage,
                                                      url: appBloc.dish[
                                                                  categortIndex]
                                                              ['dishes'][i]
                                                          ['image'],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              appBloc.dish[categortIndex]
                                                      ['dishes'][i]['name'] ??
                                                  '',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            subtitle: Text(
                                              '${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'], number: appBloc.dish[categortIndex]['dishes'][i]['price'])}',
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
                                                      changeStockStatus(cix: categortIndex, dix: i,hasStock: false,dishId:appBloc.dish[categortIndex]['dishes'][i]['id']);
                                                      Navigator.pop(context);
                                                    });
                                                
                                              }else{
                                                    changeStockStatus(cix:categortIndex, dix: i,hasStock: true,dishId: appBloc.dish[categortIndex]['dishes'][i]['id']);
                                              }
                                            },
                                            icon:Icon(appBloc.dish[categortIndex]['dishes'][i]['instock']?Feather.eye:Feather.eye_off, size: 24,
                                          color:appBloc.dish[categortIndex]['dishes'][i]['instock']?Color(PublicVar.primaryColor):Colors.grey,),),
                                          );
                                        }),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  showAddCategorySheet() {
    categoryController.text = appBloc.dish[categortIndex]['name'];
    AppActions().showAppDialog(context,
            title: "Update Category",
            descp: "Change the name of your menu category",
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
                              onEditingComplete: () => validate(),
                              validator: Validation().text,
                              onSaved: (String val) {
                                categoryField = val;
                              },
                              decoration: FormDecorator(
                                  hint: 'Enter your category ',
                                  helper: 'e.g Soup'),
                            ),
                          ),
                        ),
              ),
            ), okAction: () => validate(), okText: "Update", cancleText: "Cancel");
   }

  validate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FocusScope.of(context).unfocus();
      AppActions().showLoadingToast(
        text: PublicVar.wait,
        context: context,
      );
      updateCategory();
    } else {
      setState(() => autoValidate = true);
    }
  }

  updateCategory() async {
    Map data = {"title": categoryField};
    var id = appBloc.dish[categortIndex]['id'];
    categoryController.clear();
    Navigator.pop(context);
    if (await Server()
        .putAction(bloc: appBloc, data: data, url: Urls.createMenu + '/$id')) {
      await Server().getDishes(appBloc: appBloc, data: PublicVar.queryKitchen);
      appBloc.dish[categortIndex]['name'] = categoryField;
      AppActions().showSuccessToast(
        text: 'Category Updated',
        context: context,
      );
    } else {
      AppActions().showErrorToast(
        text: 'An error occurred: ${appBloc.errorMsg}',
        context: context,
      );
    }
  }

  listenToScrollChange() {
    setState(() {
      if (_scrollController.offset >= 100.0) {
        titleDark = true;
      } else {
        titleDark = false;
      }
    });
  }

  firstDishWidget() {
    return DisplayMessage(
      onPress: () {
        appBloc.selectedMeals = [];
        NextPage().nextRoute(
            context,
            DishChoice(
              catIndex: categortIndex,
             
            ));
      },
      message: 'Create a dish under this category',
      btnText: 'Create Dish',
    );
  }

  askDeleteCategory() {
    AppActions().showAppDialog(context,
        title: 'Delete Menu?',
        descp:
            'Are you sure you want to delete ${appBloc.dish[categortIndex]['name']} from your menu?',
        okText: "Delete",
        cancleText: "Cancel",
        danger: true,
        cancleAction: () => Navigator.pop(context),
        okAction: () {
          Navigator.pop(context);
          if(appBloc.dish[categortIndex]['dishes'].length>0){
            AppActions().showAppDialog(context, title: 'Menu is not empty!',
            descp:'You cannot delete a menu that still has dishes, remove all the dishes before deleting this menu',
            singlAction: true,
            okText: "Ok",);
          }else{
            deleteCategory();
          }
        });
  }

  askDeleteDish({index}) {
    AppActions().showAppDialog(context,
        title: 'Delete Dish?',
        descp: 'Are you sure you want to delete this dish?',
        okText: "Delete",
        cancleText: "Cancel",
        danger: true,
        cancleAction: () => Navigator.pop(context),
        okAction: () {
          Navigator.pop(context);
          deleteDish(index);
        });
  }

  deleteCategory() async {
    Map query = {
      "nokey": {"menu_id": appBloc.dish[categortIndex]['id']},
      'token': PublicVar.getToken,
    };
    if (await Server()
        .deleteAction(bloc: appBloc, data: query, url: Urls.deleteMenu)) {
      isLoading();
      Navigator.pop(context);
       AppActions().showSuccessToast(
        text: '${appBloc.dish[categortIndex]['name']} deleted successfully',
        context: context,
      );
      appBloc.dish.removeAt(categortIndex);
      appBloc.dish = appBloc.dish;
     
    } else {
      isLoading();
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
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

  deleteDish(index) async {
    AppActions().showLoadingToast(
      text: PublicVar.wait,
      context: context,
    );
    isLoading();
    Map query = {
      "nokey": {"dish_id": appBloc.dish[categortIndex]['dishes'][index]['id']},
      'token': PublicVar.getToken,
    };

    if (await Server().deleteAction(
        bloc: appBloc, data: query, url: Urls.dishActions)) {
      AppActions().showSuccessToast(
        text:
            '${appBloc.dish[categortIndex]['dishes'][index]['name']} deleted successfully',
        context: context,
      );
      appBloc.dish[categortIndex]['dishes'].removeAt(index);
      await Server().getDishes(appBloc: appBloc, data: PublicVar.queryKitchen);
      appBloc.dish = appBloc.dish;
      isLoading();
    } else {
      isLoading();
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
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
