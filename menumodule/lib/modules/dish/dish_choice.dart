import 'package:flutter/material.dart';
import 'package:providermodule/providermodule.dart';
import 'package:menumodule/menumodule.dart';
import 'package:provider/provider.dart';

class DishChoice extends StatefulWidget {
  final catIndex;
  DishChoice({Key key, this.catIndex}) : super(key: key);
  @override
  _DishChoiceState createState() => _DishChoiceState();
}

class _DishChoiceState extends State<DishChoice> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  AppBloc appBloc = AppBloc();
  var catIndex;

  @override
  void initState() {
    if(widget.catIndex!=null){
      catIndex=widget.catIndex;
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
          'Choose Dish Type',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap:(){
                appBloc.selectedMeals = [];
                NextPage().nextRoute(
                    context,
                    DishAction(
                      update: false,
                      catIndex: catIndex,
                    ));
              },child: getChoiceView(title:"Per Plate serving",subtitle: "Create Dish for just one person in mind.",assetUrl: "assets/images/per-plate.jpg")),
              InkWell(
                onTap:(){
                NextPage().nextRoute(context,PackagesAction(update:false));
              },child: getChoiceView(title:"Special Package (Combo's)",subtitle: "Create simple Combo meals for you customers.",assetUrl: "assets/images/food-combo.jpg")),
              InkWell(
              onTap:(){
                appBloc.selectedMeals = [];
                NextPage().nextRoute(
                    context,
                    DishBowl(
                      update: false,
                      large: true,
                      catIndex: catIndex,
                    ));
              },
                child: getChoiceView(title:"Larger Serving (Bowl or Tray)",subtitle: "Create Dish for more persons including party and other ocasions in mind.",assetUrl: "assets/images/buffet.jpg")),
              InkWell(
                onTap:(){
                appBloc.selectedMeals = [];
                NextPage().nextRoute(
                    context,
                    DishBowl(
                      update: false,
                      large: false,
                      catIndex: catIndex,
                    ));
              },
                child: getChoiceView(title:"Small Chops Serving",subtitle: "Create dish like small-chops, spring-rolls and other similar meals .",assetUrl: "assets/images/chops.jpg")),
            ],
          ),
        ),
      ),
    );
  }

  getLeadingWidget({String text}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        height: 30,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget getChoiceView({String title, subtitle, assetUrl}){
    return Padding(
    padding:  EdgeInsets.symmetric(vertical:15.0, horizontal: 8.0),
      child: Material(
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(assetUrl),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8),
                alignment: Alignment.center,
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 25,),
                    ListTile(title: Text(title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900),
                        ), subtitle: Text(
                      subtitle,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ), trailing: Icon(Icons.chevron_right_rounded,color: Colors.white, size: 30,),),
                  
                    
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
