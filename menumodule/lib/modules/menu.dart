import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:highlighter_coachmark/highlighter_coachmark.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

import 'category/category.dart';
import 'dish/dishes.dart';
import 'extras/extras.dart';
import 'special-packages/special-packages.dart';

class Menu extends StatefulWidget {
  final scaffoldKey;
  const Menu({Key key, this.scaffoldKey}) : super(key: key);
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin<Menu> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(),
      _sheetScaffoldKey = new GlobalKey();
      
  TabController _tabController;
  var currentIndex = 0;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController();
  bool _autoValidate = false, firstMenu = PublicVar.hasMenu;
  String categoryField;
  double deviceHeight;

  AppBloc appBloc = AppBloc();
  List tabs = PublicVar.hasDish
      ? ['Dishes', 'Categories', 'Extras']
      : ['Categories', 'Extras', 'Dishes'];
  List<Widget> tabBody = PublicVar.hasDish
      ? [
          Dishes(),
          Category(),
          Extras(),
        ]
      : [
          Category(),
          Extras(),
          Dishes(),
        ];

  @override
  void initState() {

    if(PublicVar.showSpecialPackages){
      tabs.add("Packages");
      tabBody.add(SpecialPackages());
    }
    _tabController = TabController(vsync: this, initialIndex: 0, length: tabs.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    deviceHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PublicVar.accountApproved
          ? AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  icon: Icon(
                    Feather.menu,
                    size: 25,
                  ),
                  onPressed: () {
                    widget.scaffoldKey.currentState.openDrawer();
                  }),
              centerTitle: true,
              title: Text(   
                  'Menu',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize:  22),
                ),
              bottom: firstMenu
                  ? TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      indicatorColor: Colors.black,
                      unselectedLabelColor: Colors.grey[400],
                      unselectedLabelStyle: TextStyle(
                          fontSize:  14, fontWeight: FontWeight.w600),
                      labelStyle: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w900),
                      labelColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: List.generate(tabs.length, (i) {
                        return Tab(text: '${tabs[i]}');
                      }))
                  : null,
              actions: <Widget>[
                IconButton(
                  onPressed: () async {
                    await Server().getDishes(
                        appBloc: appBloc, data: PublicVar.queryKitchen);
                        await Server().getPackages(
                        appBloc: appBloc, data: PublicVar.queryKitchen);
                  },
                  icon: Icon(
                    Ionicons.ios_refresh,
                    size: 22,
                    color: Colors.black,
                  ),
                ),
              ],
              elevation: 0.8,
              titleSpacing: 0.0,
            )
          : null,
      body: PublicVar.accountApproved
          ? Center(
              child: firstMenu
                  ? TabBarView(
                      controller: _tabController,
                      children: List.generate(tabBody.length, (i) {
                        return tabBody[i];
                      }))
                  : firstMenuWidget(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 80),
              child: Text(
                  'Your account has not yet been approved, please setup your kitchen'),
            ),
    );
  }

  checkDish() {
    if (appBloc.dish != null) {
      setState(() {});
    }
  }

  firstMenuWidget() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal:18.0),
      child: DisplayMessage(
        onPress: () {
          setState(() {
            SharedStore().setData(type: 'bool', key: 'firstMenu', data: true);
            PublicVar.hasMenu = true;
            firstMenu = true;
          });
        },
        asset: 'assets/images/icons/menu_icon.png',
        title:"Create kitchen menu",
        message: 'Start your cooking business by creating menu so that your customers can see what you have to offer.',
        btnText: 'Create Menu',
        btnWidth: 120,
        
      ),
    );
  }



}
