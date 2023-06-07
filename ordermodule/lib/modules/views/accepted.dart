import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ordermodule/modules/view_order.dart';
import 'package:ordermodule/ordermodule.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';

class AcceptedView extends StatefulWidget {
  const AcceptedView({
    Key key,
    this.single,
  });

  final bool single;

  @override
  _AcceptedViewState createState() => _AcceptedViewState();
}

class _AcceptedViewState extends State<AcceptedView> {
  AppBloc appBloc;
  ScrollController scrollController = ScrollController();
  int scrollPage = 1;

  @override
  void initState() {
    scrollController.addListener(() {
      checkScrollExtent();
    });
    super.initState();
  }

  checkOrderData() {
    if (!appBloc.hasAcceptedOrder) {
      return FutureBuilder(
        builder: (ctx, snap) {
          if (snap.hasData && snap.data['accepted'] == "false") {
            return Center(
              child: noNetwork(),
            );
          }
          if (snap.connectionState == ConnectionState.active ||
              snap.connectionState == ConnectionState.waiting) {
            return ShowPageLoading();
          }
          return orderBuilder();
        },
        future: getData(),
      );
    } else {
      return orderBuilder();
    }
  }

  orderBuilder() {
    if (appBloc.acceptedOrders.length == 0) {
      return Center(
        child: noOrder(),
      );
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: ordersView(),
        ),
      );
    }
  }

  ordersView() {
    return containerView(
      child: ListView.separated(
        controller: scrollController,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (ctx, i) {
          return Divider();
        },
        shrinkWrap: true,
        itemCount: appBloc.acceptedOrders.length,
        itemBuilder: (ctx, i) {
          return orderView(i);
        },
      ),
    );
  }

  orderView(int i) {
    return OrderDishTile(
      onTap: () {
        appBloc.orders = appBloc.acceptedOrders;
        NextPage().nextRoute(
            context,
            ViewOrder(
              orderIndex: i,
              pageStatus: appBloc.acceptedOrders[i]['orders']['status'],
            ));
      },
      onAccept: () async {
        appBloc.orders = appBloc.acceptedOrders;
        NextPage().nextRoute(
            context,
            ViewOrder(
              orderIndex: i,
              pageStatus: appBloc.acceptedOrders[i]['orders']['status'],
            ));
      },
      imgUrl: appBloc.acceptedOrders[i]['orders']['dishes'][0]['img'],
      onlineImg: false,
      isDish: false,
      total:
          '${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'], number: appBloc.acceptedOrders[i]['total'])}',
      dishLength: appBloc.acceptedOrders[i]['orders']['dishes'].length,
      status: appBloc.acceptedOrders[i]['orders']['status'],
      name:
          '${appBloc.acceptedOrders[i]['user']['first_name']} ${appBloc.acceptedOrders[i]['user']['last_name']}',
      mealType:
          '${appBloc.acceptedOrders[i]['orders']['dishes'][0]['meal_type']}',
      duration: GetTime().getCountDown(
          time: appBloc.acceptedOrders[i]['orders']['countdown_date'],
          choice: TimeChoice.minutes),
      date: appBloc.acceptedOrders[i]['orders']['order_sent_date'],
    );
  }

  containerView({child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Colors.white,
          child: child,
        ),
      ),
    );
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

  noOrder() {
    return DisplayMessage(
      onPress: () => reload(),
      asset: 'assets/images/icons/accept_order.png',
      message:
          "No accepted order yet!,\nReload or switch to new tab to start accepting orders.",
      btnText: 'Reload',
      btnWidth: 100,
    );
  }

  getData() async {
    return await OrderServer().getAllOrders(appBloc: appBloc);
  }

  reload() {
    appBloc.hasAcceptedOrder = false;
    getData();
    setState(() {});
  }

  checkScrollExtent() {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels > 0) {
        AppActions().showSuccessToast(
            context: context, text: "Has reached scroll extent");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
        appBar: widget.single
            ? AppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Feather.arrow_left,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
                title: Text(
                  'Accepted Orders',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      reload();
                    },
                    icon: Icon(
                      Ionicons.ios_refresh,
                      size: 22,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            : null,
        backgroundColor: Colors.white,
        body: checkOrderData(),
        floatingActionButton: widget.single
            ? null
            : FloatingActionButton(
                onPressed: () => reload(),
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                )));
  }
}
