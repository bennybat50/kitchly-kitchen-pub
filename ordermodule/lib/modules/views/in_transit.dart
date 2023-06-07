import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ordermodule/modules/view_order.dart';
import 'package:ordermodule/ordermodule.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';
class InTransitView extends StatefulWidget {
  final bool single;
  const InTransitView({Key key, this.single,});
  @override
  _InTransitViewState createState() => _InTransitViewState();
}

class _InTransitViewState extends State<InTransitView> {
  AppBloc appBloc;
  var code = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      appBar:  widget.single?AppBar(
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
        'Orders In Transit',
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
    if (!appBloc.hasIntransitOrders) {
      return FutureBuilder(
        builder: (ctx, snap) {
          if (snap.hasData && snap.data['in_transit'] == "false") {
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
    if (appBloc.inTransitOrders.length == 0) {
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
        itemCount: appBloc.inTransitOrders.length,
        itemBuilder: (ctx, i) {
          return intransitOrderView(i);
        },
      ),
    );
  }


  Widget intransitOrderView(int i) {
    return OrderDishTile(
      onTap: () {
        appBloc.orders=appBloc.inTransitOrders;
        NextPage().nextRoute(
            context,
            ViewOrder(
              orderIndex: i,
              pageStatus: appBloc.inTransitOrders[i]['orders']['status'],
            ));
      },
      onAccept: () async {
        AppActions().showAppDialog(context,
            title: "Delivery Comfirmation",
            descp: "Please get the confirmation code from your customer, and enter it below",
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:8.0,vertical: 8.0),
              child: Container(
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
                    validator: Validation().text,
                    controller: code,
                    maxLength: 6,
                    decoration: FormDecorator(
                         labelText:'Enter confirmation code' , helper: 'Please type only 6 digit code above', hint: "- - - -")),
              ),
            ), okAction: () {
          if (code.text.length == 6) {
            Navigator.pop(context);
            deliverOrder(code: int.parse(code.text), i: i);
          } else {
            AppActions().showErrorToast(
                text: "Enter six digits only to confirm order",
                context: context);
          }
        }, okText: "Confirm", cancleText: "Cancel");
      },
          imgUrl: appBloc.inTransitOrders[i]['orders']['dishes'][0]['img'],
          onlineImg: false,
          isDish: false,
          total: '${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.inTransitOrders[i]['total'])}',
          dishLength: appBloc.inTransitOrders[i]['orders']['dishes'].length,
          status: appBloc.inTransitOrders[i]['orders']['status'],
          name:
              '${appBloc.inTransitOrders[i]['user']['first_name']} ${appBloc.inTransitOrders[i]['user']['last_name']}',
          mealType: '${appBloc.inTransitOrders[i]['orders']['dishes'][0]['meal_type']}',
          duration: GetTime().getCountDown(time:appBloc.inTransitOrders[i]['orders']['countdown_date'], choice: TimeChoice.minutes), 
          date: appBloc.inTransitOrders[i]['orders']['order_sent_date'],
    );
  }

   deliverOrder({int code, i}) async {
    appBloc.orders = appBloc.inTransitOrders;
    appBloc.inTransitOrders[i]['orders']['status'] = "LOADING";
    appBloc.inTransitOrders = appBloc.inTransitOrders;
    if (await OrderActions().deliveryAction(
        appBloc: appBloc,
        status: "DELIVERED",
        orderId: appBloc.inTransitOrders[i]['orders']['order_id'],
        index: i,
        confirmCode: code)) {
      await Server().queryKitchen(appBloc: appBloc);
      
      AppActions().showAppDialog(
        context,
        child: Column(children: [
          Image.asset("assets/images/completed.png",
                          height: 80,
                          fit: BoxFit.contain,
                        ),
              SizedBox(height: 10
              ,),
              Text("Order Delivered Successfully! ",textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),)
        ],),
        singlAction: true,
        okText: "Ok"
      );
      appBloc.inTransitOrders[i]['orders']['status'] = "DELIVERED";

    } else {
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
    await CheckStatus().checkStatus(
        pageStatus: "IN_TRANSIT", bloc: appBloc, nextStatus: "DELIVERED");
    appBloc.inTransitOrders = appBloc.inTransitOrders;
    setState(() {});
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
      asset: 'assets/images/icons/delivery_icon.png',
      message: "No order in transit yet!,\nReload or switch to new tab to start accepting orders.",
      btnText: 'Reload',
      btnWidth: 100,
    );
  }


  getData() async {
    return await OrderServer().getAllOrders(appBloc: appBloc);
  }

  reload() {
    appBloc.hasIntransitOrders = false;
    getData();
    setState(() {});
  }
}
