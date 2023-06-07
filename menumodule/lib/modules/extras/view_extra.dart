import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';

import 'extra_action.dart';

class ViewExtra extends StatefulWidget {
  final extraIndex;
  const ViewExtra({Key key, this.extraIndex}) : super(key: key);
  @override
  _ViewExtraState createState() => _ViewExtraState();
}

class _ViewExtraState extends State<ViewExtra> {
  ScrollController _scrollController;
  AppBloc appBloc = AppBloc();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  var index;
  bool titleDark = false, loading = false, gotOptions = false;
  var selectedOptions = [];

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(listenToScrollChange);
    getSelectedOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    index = widget.extraIndex;
    return Scaffold(backgroundColor: Colors.white, body: extraView());
  }

  extraView() {
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
                  child: Text('${appBloc.extras[index]['name'] ?? ''} ',
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
                      onPressed: () => gotoExtraAction(itemOnly: false),
                      child: Text(
                        "Edit",
                        style: TextStyle(color: Colors.blue),
                      )),
                  TextButton(
                      onPressed: () => askDeleteExtra(),
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
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      appBloc.extras[index]['name'] ?? '',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      ' "${appBloc.extras[index]['descp'] ?? ''}" ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black54),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: RichText(
                                          text: TextSpan(
                                              text: 'Max: ',
                                              style: TextStyle(
                                                  color: Color(
                                                      PublicVar.primaryColor),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                              children: [
                                            TextSpan(
                                                text:
                                                    '${appBloc.extras[index]['max'] ?? ""}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: '       Min: ',
                                                style: TextStyle(
                                                    color: Color(
                                                        PublicVar.primaryColor),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text:
                                                    '${appBloc.extras[index]['min'] ?? ""}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ])),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: Divider(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 18.0, top: 3.0, bottom: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: Text(
                                        'Items List (${selectedOptions.length})',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
                                    ),
                                   selectedOptions.length==0?SizedBox(): TextButton(
                                        onPressed: () => gotoExtraAction(itemOnly: true),
                                        child: Text(
                                          "Update items",
                                          style: TextStyle(color: Colors.blue),
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: ListView.separated(
                                    separatorBuilder: (ctx, i) {
                                      return Divider();
                                    },
                                    itemCount: selectedOptions.length,
                                    physics: ScrollPhysics(),
                                    reverse: true,
                                    shrinkWrap: true,
                                    itemBuilder: (ctx, i) {
                                      return ListTile(
                                        leading: Text(
                                          "*",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        title: Text(
                                          selectedOptions[i]['name'] ?? '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        ),
                                        trailing: Text(
                                          "${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'], number: selectedOptions[i]['price'])}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            ],
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

  gotoExtraAction({bool  itemOnly}) {
    appBloc.optionItems = selectedOptions;
    NextPage().nextRoute(
        context,
        ExtraAction(
          update: true,
          extraIndex: index,
          itemOnly: itemOnly,
          online: true,
        ));
  }

  getSelectedOptions() async {
    await Future.delayed(Duration(milliseconds: 1), () {
      for (var i = 0; i < appBloc.options.length; i++) {
        if (appBloc.extras[index]['option'] == appBloc.options[i]['option']) {
          selectedOptions.add(appBloc.options[i]);
        }
      }
    });
    setState(() {});
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

  askDeleteExtra() {
    AppActions().showAppDialog(context,
        title: 'Delete Extra?',
        descp:
            'Are you sure you want to delete ${appBloc.extras[index]['name']} ?',
        okText: "Delete",
        cancleText: "Cancel",
        danger: true,
        cancleAction: () => Navigator.pop(context),
        okAction: () {
          Navigator.pop(context);
          deleteExtra();
        });
  }

  deleteExtra() async {
    Map query = {
      "nokey": {"extra_id": appBloc.extras[index]['id']},
      'token': PublicVar.getToken,
    };
    AppActions().showLoadingToast(
      text: PublicVar.wait,
      context: context,
    );
    if (await Server()
        .deleteAction(bloc: appBloc, data: query, url: Urls.extrasAction)) {
      AppActions().showSuccessToast(
        text: '${appBloc.extras[index]['name']} deleted successfully',
        context: context,
      );
      Navigator.pop(context);
      appBloc.extras.remove(index);
      appBloc.extras = appBloc.extras;
    } else {
      AppActions().showErrorToast(
        text: 'An error occured  please try again',
        context: context,
      );
    }
  }
}
