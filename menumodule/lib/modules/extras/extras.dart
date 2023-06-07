import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:highlighter_coachmark/highlighter_coachmark.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';

import 'extra_action.dart';
import 'view_extra.dart';

class Extras extends StatefulWidget {
  final scaffoldKey;
  const Extras({Key key, this.scaffoldKey}) : super(key: key);
  @override
  _ExtrasState createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(),
      _sheetScaffoldKey = new GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController menuController = TextEditingController();
  bool _autoValidate = false,
      _btnEnabled = true,
      isNetwork = true,
      _btnSend = false;
  String menuField;
  AppBloc appBloc = AppBloc();

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
          child: PublicVar.hasExtra ? checkExtraData() : firstExtraWidget(),
        ),
      ),
      floatingActionButton: PublicVar.hasExtra ? btnCreateExtra() : null,
    );
  }

  checkExtraData() {
    if (!appBloc.hasExtras) {
      return FutureBuilder(
        initialData: appBloc.extras,
        builder: (ctx, snap) {
          if (snap.data == "false") {
            return noNetwork();
          }
          if (snap.data == "empty") {
            return firstExtraWidget();
          }

          if (snap.connectionState == ConnectionState.waiting ||
              snap.connectionState == ConnectionState.active) {
            return ShowPageLoading();
          }
          return extraBuilder();
        },
        future: getExtras(),
      );
    } else {
      return extraBuilder();
    }
  }

  extraBuilder() {
    if (appBloc.extras.length == 0) {
      return firstExtraWidget();
    } else {
      return ListView.separated(
          separatorBuilder: (ctx, i) {
            return Divider();
          },
          itemCount: appBloc.extras.length,
          itemBuilder: (ctx, i) {
            return ListTile(
              onTap: () {
                NextPage().nextRoute(
                    context,
                    ViewExtra(
                      extraIndex: i,
                    ));
              },
              onLongPress: () => askDeleteExtra(i),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: Colors.black,
                  padding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                  height: 30,
                  child: Text(
                    appBloc.extras[i]['name'].toString()[0],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              title: Text(
                "${appBloc.extras[i]['name'] ?? ""}",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              subtitle: Text(
                '${appBloc.extras[i]['descp'] ?? ""} ',
                style: TextStyle(fontSize: 15),
              ),
              trailing: Text(
                '${appBloc.extras[i]['min'] ?? ""} - ${appBloc.extras[i]['max'] ?? ""}',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            );
          });
    }
  }

  getExtras() async {
    return await Server()
        .getExtras(appBloc: appBloc, data: PublicVar.queryKitchen);
  }

  firstExtraWidget() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal:8.0),
      child: DisplayMessage(
        onPress: () => NextPage().nextRoute(
            context,
            ExtraAction(
              update: false,
              online: false,
              itemOnly: false,
            )),
        asset: 'assets/images/icons/extra_icon.png',
        title: "Create extras",
        message:'categorize extra items well so user can pick what they want. e.g\nDrinks:- Bottle water,Fanta, Coke.',
        btnText: 'Create Extra',
      ),
    );
  }

  btnCreateExtra() {
    return FloatingTextButton(
      icon: Icons.add,
      text: 'Add Extra',
      onTap: () {
        appBloc.optionItems = [];
        NextPage().nextRoute(
            context,
            ExtraAction(
              update: false,
              itemOnly: false,
              online: false,
            ));
      },
      
    );
  }

  askDeleteExtra(i) {
    AppActions().showAppDialog(context,
        title: 'Delete Extra?',
        descp: 'Are you sure you want to delete ${appBloc.extras[i]['name']} ?',
        okText: "Delete",
        cancleText: "Cancel",
        danger: true,
        cancleAction: () => Navigator.pop(context),
        okAction: () {
          Navigator.pop(context);
          deleteExtra(
            index: i,
          );
        });
  }

  deleteExtra({index}) async {
    var data = {
      "nokey": {"extra_id": appBloc.extras[index]['id']},
      "token": PublicVar.getToken,
    };

    AppActions().showLoadingToast(
      text: PublicVar.wait,
      context: context,
    );
    if (await Server()
        .deleteAction(bloc: appBloc, data: data, url: Urls.extrasAction)) {
      await Server().getExtras(appBloc: appBloc, data: PublicVar.queryKitchen);
      appBloc.extras.remove(index);
      appBloc.extras = appBloc.extras;
      setState(() {});
      AppActions().showSuccessToast(
        text: "Extra Deleted!",
        context: context,
      );
    } else {
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
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

  noData() {
    return DisplayMessage(
      onPress: () => reload(),
      asset: 'assets/images/icons/dataError_icon.png',
      message: PublicVar.requestErrorString,
      btnText: 'Reload',
      btnWidth: 100,
    );
  }

  reload() {
    appBloc.hasExtras = false;
    setState(() {});
  }
}
