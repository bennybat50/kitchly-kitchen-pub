import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ordermodule/ordermodule.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
class PendingView extends StatefulWidget {
final bool single;
  const PendingView({Key key, this.single,  })
      : super(key: key);
  @override
  _PendingViewState createState() => _PendingViewState();
}

class _PendingViewState extends State<PendingView> {
  AppBloc appBloc;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      appBar: widget.single?AppBar(
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
          'New Orders',
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
      ):null,
      backgroundColor: Colors.white,
      body:checkOrderData(),
      floatingActionButton:widget.single? null:FloatingActionButton(onPressed: ()=>reload(),child: Icon(Icons.refresh,color: Colors.white,))
    );
  }

  checkOrderData() {
    if (!appBloc.hasPendingOrder) {
      return FutureBuilder(
        builder: (ctx, snap) {
          if (snap.hasData && snap.data['pending'] == "false") {
            return Center(
              child: noOrder(),
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
    if (appBloc.pendingOrders.length == 0) {
      return Center(
        child: noOrder(),
      );
    } else {
      return SingleChildScrollView(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 5),child:ordersView() ,),
      );
    }
  }

  ordersView() {
    return containerView(
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (ctx, i) {
          return Divider();
        },
        shrinkWrap: true,
        itemCount: appBloc.pendingOrders.length,
        itemBuilder: (ctx, i) {
         return orderView(i);
        },
      ),
    );
  }

  orderView(int i) {
    return OrderDishTile(
      onTap: () {
        appBloc.orders= appBloc.pendingOrders;
        NextPage().nextRoute(
            context,
            ViewOrder(
              orderIndex: i,
              pageStatus: appBloc.pendingOrders[i]['orders']['status'],
            ));
      },  onAccept: () async {
        appBloc.orders= appBloc.pendingOrders;
            appBloc.pendingOrders[i]['orders']['status'] = "LOADING";
            appBloc.pendingOrders = appBloc.pendingOrders;
            if (await OrderActions().acreAction(
                appBloc: appBloc,
                status: "ACCEPTED",
                orderId: appBloc.pendingOrders[i]['orders']['order_id'],
                index: i)) {
              AppActions().showSuccessToast(text: 'Order Accepted');
              appBloc.pendingOrders[i]['orders']['status'] = "ACCEPTED";
            } else {
              AppActions().showErrorToast(text: appBloc.errorMsg,context: context,);
            }
           await CheckStatus().checkStatus(
                pageStatus: "PENDING", bloc: appBloc, nextStatus: "ACCEPTED");
                setState(() {});
          },
          onReject: () async {
            appBloc.orders= appBloc.pendingOrders;
            appBloc.pendingOrders[i]['orders']['status'] = "LOADING";
            appBloc.pendingOrders = appBloc.pendingOrders;
            if (await OrderActions().acreAction(
                appBloc: appBloc,
                status: "REJECTED",
                orderId: appBloc.pendingOrders[i]['orders']['order_id'],
                index: i)) {
              AppActions().showSuccessToast(text: 'Order Rejected');
              appBloc.pendingOrders[i]['orders']['status'] = "REJECTED";
            } else {
              AppActions().showErrorToast(text: appBloc.errorMsg,context: context,);
            }
           await CheckStatus().checkStatus(
                pageStatus: "PENDING", bloc: appBloc, nextStatus: "REJECTED");
                setState(() {});
          },
          
          imgUrl: appBloc.pendingOrders[i]['orders']['dishes'][0]['img'],
          onlineImg: false,
          isDish: false,
          total: '${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.pendingOrders[i]['total'])}',
          dishLength: appBloc.pendingOrders[i]['orders']['dishes'].length,
          status: appBloc.pendingOrders[i]['orders']['status'],
          name:
              '${appBloc.pendingOrders[i]['user']['first_name']} ${appBloc.pendingOrders[i]['user']['last_name']}',
          mealType: '${appBloc.pendingOrders[i]['orders']['dishes'][0]['meal_type']}',
          duration: GetTime().getCountDown(time:appBloc.pendingOrders[i]['orders']['countdown_date'], choice: TimeChoice.minutes),
          date: appBloc.pendingOrders[i]['orders']['order_sent_date'],
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
      asset: 'assets/images/icons/order_icon2.png',
      message: "No new order yet!,\nReload to check if there is any.",
      btnText: 'Reload',
      btnWidth: 100,
    );
  }

  getData() async {
    return await OrderServer().getAllOrders(appBloc: appBloc);
  }

  reload() {
    appBloc.hasPendingOrder = false;
    getData();
    setState(() {});
  }



}
