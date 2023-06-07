import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

class Meals extends StatefulWidget {
  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  AppBloc appBloc;
  bool loading = false, searching = false;
  TextEditingController searchController = TextEditingController();
  var items = List(), duplicateItems = List();
  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Feather.arrow_left,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[],
      ),
      bottomNavigationBar: ButtonWidget(
        radius: 0.0,
        fontSize: 20.0,
        height: 50.0,
        txColor: Colors.white,
        onPress: () {
          Navigator.pop(context);
        },
        bgColor: Color(PublicVar.primaryColor),
        text: 'Save Cuisines',
      ),
      body: Center(
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Add Cuisines',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Include 1 or more cusine(s) to your dish',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          checkCountries()
        ]),
      ),
    );
  }

  void filterSearchResults(String query) {
    List dummySearchList = List();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List dummyListData = List();
      dummySearchList.forEach((item) {
        if (item['name'].contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
        searching = true;
      });
      return;
    } else {
     if(!PublicVar.onProduction) print('Enter Duplicate');
      setState(() {
        searching = false;
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  checkCountries() {
    if (appBloc.meals.length == 0) {
      return FutureBuilder(
        builder: (ctx, snap) {
          if (snap.data == 'false') {
            return Text("No Cuisines available");
          }
          if (snap.connectionState == ConnectionState.waiting ||
              snap.connectionState == ConnectionState.active) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                ShowPageLoading()
              ],
            ));
          }

          return mealBuilder(
              data: searching
                  ? items.length == 0 ? appBloc.meals : items
                  : appBloc.meals);
        },
        future: getData(),
      );
    } else {
      return mealBuilder(
          data: searching
              ? items.length == 0 ? appBloc.meals : items
              : appBloc.meals);
    }
  }

  mealBuilder({List data}) {
    return Container(
        child: Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal:18.0,vertical: 10),
            child: TextField(
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                filterSearchResults(value);
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  searching = false;
                });
              },
              onTap: () {
                setState(() {
                  searching = true;
                  duplicateItems = appBloc.meals;
                  items.addAll(duplicateItems);
                });
              },
              controller: searchController,
              decoration: InputDecoration(
                  labelText: "Search meal types",
                  hintText: "Search ",
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(65.0)))),
            ),
          ),
        Wrap(
          children: List.generate(
            data.length,
            (i) => Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
              child: ListTile(
                title:
                    Text(CapitalizeText().capitalize(data[i]['name'])),
                trailing: Checkbox(
                  onChanged: (bool value) {
                    updateMeal(i);
                  },
                  value: appBloc.selectedMeals.contains(data[i]),
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }

  getData() async {
   if(!PublicVar.onProduction) print('enter here');
    return await Server().getMeals(appBloc: appBloc);
  }

  Future<Null> updateMeal(i) async {
    if (appBloc.selectedMeals.contains(appBloc.meals[i])) {
      appBloc.selectedMeals.remove(appBloc.meals[i]);
    } else {
      appBloc.selectedMeals.add(appBloc.meals[i]);
    }
    appBloc.selectedMeals = appBloc.selectedMeals;
  }

  noNetwork() {
    return DisplayMessage(
      onPress: () {
        setState(() {});
      },
      asset: 'assets/images/icons/connection_icon.png',
      message: PublicVar.checkInternet,
      btnText: 'Reload',
      btnWidth: 100,
    );
  }
}
