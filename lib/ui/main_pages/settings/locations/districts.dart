import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

class Districts extends StatefulWidget {
  @override
  _DistrictsState createState() => _DistrictsState();
}

class _DistrictsState extends State<Districts> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  AppBloc appBloc;
   bool loading = false, searching = false;
  TextEditingController searchController = TextEditingController();
  var items = [], duplicateItems = [];
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
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[],
      ),
      body: Center(
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'All Districts under ${CapitalizeText().capitalize(appBloc.state['id'])}',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Please select the District where your kitchen is located in ${CapitalizeText().capitalize(appBloc.state['id'])}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          checkStates()
        ]),
      ),
    );
  }

   void filterSearchResults(String query) {
    List dummySearchList = [];
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List dummyListData = [];
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

  checkStates() {
    if (appBloc.districts.length == 0) {
      return FutureBuilder(
        builder: (ctx, snap) {
          if (snap.data == 'false') {
            return noNetwork();
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

          return stateBuilder(data: searching
              ? items.length == 0 ? appBloc.districts : items
              : appBloc.districts);
        },
        future: getData(),
      );
    } else {
      return stateBuilder(data: searching
              ? items.length == 0 ? appBloc.districts : items
              : appBloc.districts);
    }
  }

  stateBuilder({List data}) {
    return Column(children: [
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
                  duplicateItems = appBloc.districts;
                  items.addAll(duplicateItems);
                });
              },
              controller: searchController,
              decoration: InputDecoration(
                  labelText: "Search locations in ${appBloc.state['id']}",
                  hintText: "Search ",
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(65.0)))),
            ),
          ),
      ListView.separated(
      itemBuilder: (ctx, i) {
        return ListTile(
          leading: CircleAvatar(
            child: Text(
              data[i]['name'].toString()[0] +
                 data[i]['name'].toString()[1],
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            backgroundColor: Color(PublicVar.primaryColor).withOpacity(0.8),
          ),
          onTap: () {
            appBloc.district = data[i];
            Navigator.pop(context);
          },
          title: Text(
            data[i]['name'],
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      },
      separatorBuilder: (ctx, i) {
        return Divider();
      },
      itemCount: data.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
    )
    ]);
  }

  getData() async {
    var response = 'false';
    Map data = {
      "query": {"state_id": appBloc.state['id']}
    };
    if (await Server()
        .postAction(bloc: appBloc, url: Urls.getDistricts, data: data)) {
      appBloc.districts = appBloc.mapSuccess;
       appBloc.districts.sort((a,b){
       return a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase());
      });
      response = 'true';
    }
    return response;
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
