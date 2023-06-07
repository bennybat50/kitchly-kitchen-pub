import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:menumodule/menumodule.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'dish_action.dart';
import 'dish_bowl.dart';

class ViewDish extends StatefulWidget {
  final categoryIndex, dishIndex;
  const ViewDish({
    Key key,
    this.categoryIndex,
    this.dishIndex,
  }) : super(key: key);
  @override
  _ViewDishState createState() => _ViewDishState();
}

class _ViewDishState extends State<ViewDish> {
  AppBloc appBloc;
  bool titleDark = false, firstEnter = true, loading = false;
  ScrollController _scrollController;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  var catIndex, dishIndex;
  @override
  void initState() {
    catIndex = widget.categoryIndex;
    dishIndex = widget.dishIndex;
    _scrollController = ScrollController();
    _scrollController.addListener(listenToScrollChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    Future.delayed(Duration(milliseconds: 1), () {
      if (appBloc.dish[catIndex]['dishes'][dishIndex]['extras'] != null &&
          appBloc.dish[catIndex]['dishes'][dishIndex]['extras'].length > 0) {
        if (firstEnter) {
          appBloc.selectedExtra = appBloc.dish[catIndex]['dishes'][dishIndex]
              ['extras'][0]['options'];
          appBloc.selectedExtraId =
              '${appBloc.dish[catIndex]['dishes'][dishIndex]['extras'][0]['id']}';
          firstEnter = false;
        }
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: dishView(),
      bottomNavigationBar: ButtonWidget( 
      onPress: (){
      if(appBloc.dish[catIndex]['dishes'][dishIndex]['instock']){
       AppActions().showAppDialog(
       context,
      title: 'Out of stock?',
      descp:'Your customers will not be able to order this dish, are you sure you want to remove it from your stock?',
      okText: "Confirm",
      cancleText: "Cancel",
      danger:true,
      cancleAction: () => Navigator.pop(context),
      okAction: () async {
        changeStockStatus(cix: catIndex, dix: dishIndex,hasStock: false,dishId:appBloc.dish[catIndex]['dishes'][dishIndex]['id']);
        Navigator.pop(context);
      });
      }else{
      changeStockStatus(cix: catIndex, dix: dishIndex,hasStock: true,dishId:appBloc.dish[catIndex]['dishes'][dishIndex]['id']);
      }
      },
      width: double.infinity,
      textIcon: appBloc.dish[catIndex]['dishes'][dishIndex]['instock']?Feather.eye_off: Feather.eye,
      height: 50.0,
      iconSize: 13.0,
      radius: 0.0,
      fontSize: 20.0,
      txColor: Colors.white,
      bgColor:appBloc.dish[catIndex]['dishes'][dishIndex]['instock']?Colors.grey[600]: Color(PublicVar.primaryColor),
      text: appBloc.dish[catIndex]['dishes'][dishIndex]['instock']?'Set out of stock':'Set Avaliable',),
    );
  }

  dishView() {
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
                  child: Text(
                      '${appBloc.dish[catIndex]['dishes'][dishIndex]['name'] ?? ''} ',
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
                  IconButton(
                    onPressed: () => editDish(),
                    icon: Icon(
                      Icons.edit_rounded,
                      size: 20,
                      color: titleDark ? Colors.black : Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => askDeleteDish(),
                    icon: Icon(
                      Ionicons.ios_trash,
                      size: 20,
                      color: titleDark ? Colors.black : Colors.white,
                    ),
                  ),
                ],
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      GetImageProvider(
                        url: appBloc.dish[catIndex]['dishes'][dishIndex]
                            ['image'],
                        placeHolder: PublicVar.defaultKitchenImage,
                      ),
                      Container(
                        height: double.infinity,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.0, vertical: 15.0),
                    child: SingleChildScrollView(
                      child: Stack(
                        children: <Widget>[
                          ListView(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 5),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "${appBloc.dish[catIndex]['dishes'][dishIndex]['name'] ?? ""}",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.dish[catIndex]['dishes'][dishIndex]['price'])}',
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Color(PublicVar.primaryColor),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: InkWell(
                                          onTap: () => NextPage().nextRoute(
                                              context,
                                              ViewCategory(
                                                categoryIndex:
                                                    widget.categoryIndex,
                                              )),
                                          child: Container(
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 4.0),
                                                  child: Row(children: [
                                                    Icon(
                                                      Icons.menu_book,
                                                      size: 14,
                                                      color: Colors.black54,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                      "${appBloc.dish[widget.categoryIndex]['name'] ?? ""}",
                                                      
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                  ),
                                                    )
                                                  ],),
                                                )),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Wrap(
                                          alignment: WrapAlignment.spaceBetween,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6.0,
                                                    vertical: 2.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.timer,
                                                      size: 13,
                                                      color: Colors.black54,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "${appBloc.dish[catIndex]['dishes'][dishIndex]['duration'] ?? ""}min",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6.0,
                                                    vertical: 2.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Feather.shopping_bag,
                                                      size: 12,
                                                      color: Colors.black54,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.dish[catIndex]['dishes'][dishIndex]['package_cost'])}",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ],
                                  )),
                              Divider(),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      "Description:",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    subtitle: Text(
                                      appBloc.dish[catIndex]['dishes']
                                              [dishIndex]['descp'] ??
                                          "",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 2),
                                child: Divider(),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      "Dish Type:- (${sortDishTypeText(appBloc.dish[catIndex]['dishes'][dishIndex]['group']['type'])})",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    subtitle: sortDishTypeView(appBloc.dish[catIndex]['dishes'][dishIndex]['group']['type']),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 2),
                                child: Divider(),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 25),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Cuisine Types:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 5),
                                child: appBloc.dish[catIndex]['dishes']
                                            [dishIndex]['meal_types'] ==
                                        null
                                    ? SizedBox()
                                    : Container(
                                        child: Wrap(
                                          children: List.generate(
                                              appBloc
                                                  .dish[catIndex]['dishes']
                                                      [dishIndex]['meal_types']
                                                  .length, (i) {
                                            return Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black87
                                                            .withOpacity(0.7)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Text(
                                                  '${appBloc.dish[catIndex]['dishes'][dishIndex]['meal_types'][i]['name']} ',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black87
                                                          .withOpacity(0.7)),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 2),
                                child: Divider(),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Extras:',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 18.0,
                                ),
                                child: appBloc.dish[catIndex]['dishes']
                                            [dishIndex]['extras'] ==
                                        null
                                    ? SizedBox()
                                    : extrasView(appBloc.dish[catIndex]
                                        ['dishes'][dishIndex]),
                              ),
                              optionsView(),
//          Padding(
//            padding:  EdgeInsets.symmetric(horizontal:18.0),
//            child: Divider(),
//          ),
//          Padding(
//            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
//            child: Text(
//              'Reviews:',
//              style: TextStyle(
//                  fontSize: 16,
//                  color: Colors.black87,
//                  fontWeight: FontWeight.bold),
//            ),
//          ),
//          ListView(
//            shrinkWrap: true,
//            physics: AlwaysScrollableScrollPhysics(),
//            children: <Widget>[
//              Padding(
//                padding:  EdgeInsets.symmetric(horizontal:8.0,vertical: 5),
//                child: ListTile(
//                  leading: Column(
//                    children: <Widget>[
//                      Container(
//                        height: 35,
//                        width: 35,
//                        decoration: BoxDecoration(
//                            image: DecorationImage(
//                                image: AssetImage('assets/images/userHolder.jpg'),
//                                fit: BoxFit.cover),
//                            borderRadius: BorderRadius.circular(60)),
//                      )
//                    ],
//                  ),
//                  title: Text('Jane Barak',style: TextStyle(fontSize: 16),),
//                  subtitle: Text(
//                      'Very good but you need to reduce the sugar in the tea a little',style: TextStyle(fontSize: 12),),
//                ),
//              ),
//              Padding(
//                padding:  EdgeInsets.symmetric(horizontal:8.0,vertical: 5),
//                child: ListTile(
//                  leading: Column(
//                    children: <Widget>[
//                      Container(
//                        height: 35,
//                        width: 35,
//                        decoration: BoxDecoration(
//                            image: DecorationImage(
//                                image: AssetImage('assets/images/kitchen.jpg'),
//                                fit: BoxFit.cover),
//                            borderRadius: BorderRadius.circular(60)),
//                      )
//                    ],
//                  ),
//                  title: Text('Mary Orban',style: TextStyle(fontSize: 16),),
//                  subtitle: Text(
//                      'Yeeeaaiiii i love this tea, it gets me fired up at the work place, ',style: TextStyle(fontSize: 12),),
//                ),
//              ),
//            ],
//          )
                            ],
                          ),
                          loading
                              ? Align(
                                  alignment: Alignment.center,
                                  child: ShowPageLoading())
                              : SizedBox()
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

  extrasView(data) {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (ctx, i) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: FilterChip(
              label: Text(data['extras'][i]['name']),
              onSelected: (bool value) {
                appBloc.selectedExtra = data['extras'][i]['options'];
                appBloc.selectedExtraId = '${data['extras'][i]['id']}';
              },
              showCheckmark: false,
              selected: appBloc.selectedExtraId
                  .contains('${data['extras'][i]['id']}'),
              selectedColor: Color(PublicVar.primaryColor).withOpacity(0.4),
              labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              backgroundColor: Colors.black54,
            ),
          );
        },
        itemCount: data['extras'].length,
      ),
    );
  }

  optionsView() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 3),
      child: ListView.separated(
          physics: ScrollPhysics(),
          separatorBuilder: (ctx, i) {
            return Divider();
          },
          shrinkWrap: true,
          itemCount: appBloc.selectedExtra.length,
          itemBuilder: (ctx, i) {
            return ListTile(
              leading: Text("*",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              title: Text('${appBloc.selectedExtra[i]['name'] ?? ''}',style: TextStyle(fontWeight: FontWeight.w600,
                                            fontSize: 18),),
              trailing: Text(
                '${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.selectedExtra[i]['price'])}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            );
          }),
    );
  }

  editDish() {
    switch(appBloc.dish[widget.categoryIndex]['dishes'][widget.dishIndex]['group']['type']){
      
      case "PER_PLATE":
      NextPage().nextRoute(
        context,
        DishAction(
          catIndex: widget.categoryIndex,
          update: true,
          category: appBloc.dish[widget.categoryIndex],
          dishIndex: widget.dishIndex,
        ));
        break;
        case "SMALL_CHOPS":
        NextPage().nextRoute(
          context,
          DishBowl(
            catIndex: widget.categoryIndex,
            update: true,
            large: false,
            category: appBloc.dish[widget.categoryIndex],
            dishIndex: widget.dishIndex,
          ));
        break;
        case "LARGE_SERVING":
        NextPage().nextRoute(
          context,
          DishBowl(
            catIndex: widget.categoryIndex,
            update: true,
            large: true,
            category: appBloc.dish[widget.categoryIndex],
            dishIndex: widget.dishIndex,
          ));
          break;
          default:NextPage().nextRoute(
        context,
        DishAction(
          catIndex: widget.categoryIndex,
          update: true,
          category: appBloc.dish[widget.categoryIndex],
          dishIndex: widget.dishIndex,
        ));

    }
    
  }

  listenToScrollChange() {
    setState(() {
      if (_scrollController.offset >= 130.0) {
        titleDark = true;
      } else {
        titleDark = false;
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

  askDeleteDish() {
    AppActions().showAppDialog(context,
        title: 'Delete Dish?',
        descp: 'Are you sure you want to delete this dish?',
        okText: "Delete",
        cancleText: "Cancel",
        danger: true,
        cancleAction: () => Navigator.pop(context),
        okAction: () {
          Navigator.pop(context);
          deleteDish();
        });
  }

  deleteDish() async {
    isLoading();
    Map query = {
      "nokey": {"dish_id": appBloc.dish[catIndex]['dishes'][dishIndex]['id']},
      'token': PublicVar.getToken,
    };
    AppActions().showLoadingToast(text: PublicVar.wait,context: context,);
    if (await Server().deleteAction(
        bloc: appBloc, data: query, url: Urls.dishActions)) {
      appBloc.dish[catIndex]['dishes'].removeAt(dishIndex);
      appBloc.dish = appBloc.dish;
      AppActions().showSuccessToast(
          text:
              '${appBloc.dish[catIndex]['dishes'][dishIndex]['name']} deleted successfully',context: context,);
      await Server().getDishes(appBloc: appBloc, data: PublicVar.queryKitchen);

      Navigator.pop(context);
    } else {
      AppActions().showErrorToast(text: appBloc.errorMsg,context: context,);
    }
  }

  sortDishTypeView(data){
    var typeStyle=TextStyle(color: Colors.black, fontSize:14.0, fontWeight:FontWeight.bold);
    var smallStyle=TextStyle(color: Colors.black, fontSize:14.0);
    var view;
    switch(data){
      case "PER_PLATE" :
      view = Text("Serve's just one person"); 
       break;
      case "LARGE_SERVING" :
       view = ListTile(title: Text("Bowl Size:",style: typeStyle,),subtitle: Text("${appBloc.dish[catIndex]['dishes'][dishIndex]['group']['bowl_size'] ??"" }",style: smallStyle,),);
       break;
      case "SMALL_CHOPS" :
       view = Column(
         children:[
           SizedBox(height:10.0),
           Row(children: [Text("Minimum Count: ",style: typeStyle,), Text("${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.dish[catIndex]['dishes'][dishIndex]['group']['min_order_count'])}",style: smallStyle,)],),
           SizedBox(height:10.0),
           Row(children: [Text("Cost Per Item: ",style: typeStyle,), Text("${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.dish[catIndex]['dishes'][dishIndex]['group']['cost_per_item'])}",style: smallStyle,)],),
           
       ]);
       break;
    }
    return view;
  }

  sortDishTypeText(data){
    var text="";
    switch(data){
      case "PER_PLATE" :
      text ="Per Plate"; 
       break;
      case "LARGE_SERVING" :
      text ="Large Serving"; 
       break;
      case "SMALL_CHOPS" :
      text ="Small Chops"; 
       break;
    }
    return text;
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

  @override
  void dispose() {
    appBloc.selectedExtra = [];
    appBloc.selectedExtraId = '';
    super.dispose();
  }
}
