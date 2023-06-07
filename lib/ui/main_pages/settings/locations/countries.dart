import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

class Countries extends StatefulWidget {
  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  AppBloc appBloc;
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
              'Countries',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Select the your country',
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

  checkCountries() {
    if (appBloc.countries.length == 0) {
      return FutureBuilder(
        builder: (ctx, snap) {
          if (snap.data == false) {
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
          if (!snap.hasData) {
            return SizedBox();
          }
          return countryBuilder();
        },
        future: getData(),
      );
    } else {
      return countryBuilder();
    }
  }

  countryBuilder() {
    return ListView.separated(
      itemBuilder: (ctx, i) {
        return ListTile(
          leading: CircleAvatar(
            child: Text(
              CapitalizeText().capitalize(appBloc.countries[i]['code']),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            backgroundColor: Colors.black.withOpacity(0.6),
          ),
          onTap: () {
            appBloc.country = appBloc.countries[i];
            Navigator.pop(context);
          },
          title: Text(
            appBloc.countries[i]['name'],
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      },
      separatorBuilder: (ctx, i) {
        return Divider();
      },
      itemCount: appBloc.countries.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
    );
  }

  getData() async {
    Map data = {
      "query": {"country": "all"}
    };
    var received = await Server()
        .postAction(bloc: appBloc, url: Urls.getCountries, data: data);
    if (received) {
      appBloc.countries = appBloc.mapSuccess;
    }
    return received;
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
