import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ordermodule/modules/view_order.dart';
import 'package:ordermodule/ordermodule.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
class ReadyView extends StatefulWidget {

  final bool single;
  const ReadyView({Key key, this.single,  });
  @override
  _ReadyViewState createState() => _ReadyViewState();
}

class _ReadyViewState extends State<ReadyView> {
  AppBloc appBloc;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
   // scrollController.addListener(() {checkScrollExtent();});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      appBar:widget.single? AppBar(
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
          'Ready Orders',
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
      body: checkOrderData(),
      floatingActionButton:widget.single? null:FloatingActionButton(onPressed: ()=>reload(),child: Icon(Icons.refresh,color: Colors.white,))
    );
  }

 
  checkOrderData() {
    if (!appBloc.hasReadyOrder) {
      return FutureBuilder(
        builder: (ctx, snap) {
          if (snap.hasData && snap.data['ready'] == "false") {
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
    if (appBloc.readyOrders.length == 0) {
      return Center(
        child: noOrder(),
      );
    } else {
      return SingleChildScrollView(
        controller: scrollController,
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 5),child:ordersView() ,),
      );
    }
  }

  ordersView() {
    return containerView(
      child: CupertinoScrollbar(
              child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (ctx, i) {
            return Divider();
          },
          shrinkWrap: true,
          itemCount: appBloc.readyOrders.length,
          itemBuilder: (ctx, i) {
            return orderView(i);
          },
        ),
      ),
    );
  }


   orderView(int i) {
    return OrderDishTile(
      onTap: () {
        appBloc.orders=appBloc.readyOrders;
        NextPage().nextRoute(
            context,
            ViewOrder(
              orderIndex: i,
              pageStatus: appBloc.readyOrders[i]['orders']['status'],
            ));
      },
      onAccept: () async {
        appBloc.orders = appBloc.readyOrders;
        appBloc.readyOrders[i]['orders']['status'] = "LOADING";
        appBloc.readyOrders = appBloc.readyOrders;
        if (await OrderActions().deliveryAction(
            appBloc: appBloc,
            status: "IN_TRANSIT",
            orderId: appBloc.readyOrders[i]['orders']['order_id'],
            index: i)) {
          AppActions().showSuccessToast(
            text: 'Order is on its way',
            context: context,
          );
          appBloc.readyOrders[i]['orders']['status'] = "IN_TRANSIT";
        } else {
          AppActions().showErrorToast(
            text: appBloc.errorMsg,
            context: context,
          );
        }
        await CheckStatus().checkStatus(
            pageStatus: "READY", bloc: appBloc, nextStatus: "IN_TRANSIT");
        setState(() {});
      },
          imgUrl: appBloc.readyOrders[i]['orders']['dishes'][0]['img'],
          onlineImg: false,
          isDish: false,
          total: '${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.readyOrders[i]['total'])}',
          dishLength: appBloc.readyOrders[i]['orders']['dishes'].length,
          status: appBloc.readyOrders[i]['orders']['status'],
          name:
              '${appBloc.readyOrders[i]['user']['first_name']} ${appBloc.readyOrders[i]['user']['last_name']}',
          mealType: '${appBloc.readyOrders[i]['orders']['dishes'][0]['meal_type']}',
          duration: GetTime().getCountDown(time:appBloc.readyOrders[i]['orders']['countdown_date'], choice: TimeChoice.minutes),
          date: appBloc.readyOrders[i]['orders']['order_sent_date'],
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
      asset: 'assets/images/icons/category_icon.png',
      message: "No order ready for delivery yet!,\nReload or switch to new tab to start accepting orders.",
      btnText: 'Reload',
      btnWidth: 100,
    );
  }


  getData() async {
    return await OrderServer().getAllOrders(appBloc: appBloc);
  }

  reload() {
    appBloc.hasReadyOrder = false;
    getData();
    setState(() {});
  }

   checkScrollExtent() async{
    if(scrollController.position.atEdge){
      print('Enter here');
      if(scrollController.position.pixels > 0){
        Map data = {
      "query": {"kitchen_id": PublicVar.kitchenID, "status": "READY"},
      "page": 1,
      "limit": 100,
      "token": PublicVar.getToken
    };
        if (await Server().postAction(
          bloc: appBloc, url: Urls.getKitchenOrders, data: data)) {
          appBloc.readyOrders.addAll(appBloc.mapSuccess['data']);
          appBloc.readyOrders=appBloc.readyOrders;
       
      }
      }
    }
  }
}
