import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kitchly_chef/ui/main_pages/settings/kitchen/kitchen_setup.dart';
import 'package:kitchly_chef/ui/main_pages/view_hours.dart';
import 'package:ordermodule/ordermodule.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';
import '../pulse_icon.dart';
import 'base.dart';
import 'settings/kitchen/kitchen_time.dart';

class Home extends StatefulWidget {
  const Home({Key key, this.scaffoldKey}) : super(key: key);

  final scaffoldKey;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin<Home> {
 List tabs = [
    {"name": "New", "value": 0},   
    {"name": "Preparing", "value": 0},
    {"name": "Ready", "value": 0},
    {"name": "In Transit", "value": 0},
  ];
  AppBloc appBloc;
  var code = TextEditingController();
  int currentPage = 0, currentIndex = 0;
  double deviceHeight, deviceWidth, deviceFont;
  String elapsedTime = '';
  bool isSwitched = true, showOrder = true, firstTime = false, online = true;
  List pageActivities = [], actions = [];
  final PageController pageController = PageController(initialPage: 0, viewportFraction: 0.9);
  Map pageTime;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  bool startStop = true;
  List summaryList;

  Timer timer;
  Stopwatch watch = new Stopwatch();

  AnimationController _animeController;
  TabController _tabController;

  @override
  void dispose() {
    pageController.dispose();
    _animeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, initialIndex: 0, length: tabs.length);
    _tabController.addListener(handleTabs);
    _animeController = new AnimationController(vsync: this,);
    // Timer.periodic(Duration(seconds: 1), (timer){
    //     pageTime=timer.tick;
    //     print("Ticking $pageTime");
    //   });
    //startOrStop();
    _startAnimation();
    Timer.periodic(new Duration(seconds: 1), (_) async {
      if (await AppActions().checkInternetConnection()) {
        online = true;
      } else {
        online = false;
      }
      if (mounted) setState(() {});
    });
    super.initState();
  }

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        startStop = false;
        PublicVar.pageTime = transformMilliSeconds(watch.elapsedMilliseconds);
        //print("Page Time ${PublicVar.pageTime}");
      });
    }
  }

  startOrStop() {
    if (!PublicVar.onProduction) print("startstop=$startStop");
    if (startStop == true) {
      startWatch();
    } else {
      stopWatch();
    }
  }

  startWatch() {
    PublicVar.pageTime = {"h": 0, "m": 0, "s": 0};
    startStop = true;
    watch.start();
    timer = new Timer.periodic(new Duration(milliseconds: 1), updateTime);
  }

  stopWatch() {
    startStop = false;
    watch.stop();
    PublicVar.pageTime = {"h": 0, "m": 0, "s": 0};
    startStop = true;
    setState(() {});
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return {
      "h": int.parse(hoursStr),
      "m": int.parse(minutesStr),
      "s": int.parse(secondsStr)
    };
  }

  void _startAnimation() {
    _animeController.stop();
    _animeController.reset();
    _animeController.repeat(
      period: Duration(seconds: 1),
    );
  }

  handleTabs() {
    setState(() {
      currentIndex = _tabController.index;
    });
  }

  switchOrdersLengths() {
    switch (currentIndex) {
      case 0:
        return appBloc.pendingOrders.length;
      case 1:
        return appBloc.acceptedOrders.length;
      case 2:
        return appBloc.readyOrders.length;
      case 3:
        return appBloc.inTransitOrders.length;
      default:
    }
  }

  switchOrdersViews({buildIndex}) {
    switch (currentIndex) {
      case 0:
        return newOrderView(buildIndex);
      case 1:
        return acceptedOrderView(buildIndex);
      case 2:
        return readyOrderView(buildIndex);
      case 3:
        return intransitOrderView(buildIndex);
      default:
    }
  }

  checkOrderData() {
    if (!appBloc.hasPendingOrder) {
      return FutureBuilder(
        builder: (ctx, snap) {
          if (snap.hasData && snap.data['pending'] == "false") {
            return noOrder();
          }
          if (snap.connectionState == ConnectionState.active ||
              snap.connectionState == ConnectionState.waiting) {
            return Center(child: ShowPageLoading());
          }
          return orderBuilder();
        },
        future: getData(),
      );
    } else {
      return orderBuilder();
    }
  }

  getDay() {
    String day = '';
    if (appBloc.kitchenDetails['openings'] != null &&
        appBloc.kitchenDetails['openings'].length > 0) {
      var days = appBloc.kitchenDetails['openings'];
      DateTime date = new DateTime.now();
      switch (date.weekday) {
        case 1:
          if (days['monday'] != null) {
            day =
                "Monday\n${days['monday'][0]['time'] ?? "0:00"}${days['monday'][0]['period'] ?? ""} - ${days['monday'][1]['time'] ?? "0:00"}${days['monday'][1]['period'] ?? ""}";
          } else {
            return day = 'Monday\nClosed';
          }
          break;
        case 2:
          if (days['tuesday'] != null) {
            day =
                "Tuesday\n${days['tuesday'][0]['time'] ?? "0:00"}${days['tuesday'][0]['period'] ?? ""} - ${days['tuesday'][1]['time'] ?? "0:00"}${days['tuesday'][1]['period'] ?? ""}";
          } else {
            return day = 'Tuesday\nClosed';
          }
          break;
        case 3:
          if (days['wednesday'] != null) {
            day =
                "Wednesday\n${days['wednesday'][0]['time'] ?? "0:00"}${days['wednesday'][0]['period'] ?? ""} - ${days['wednesday'][1]['time'] ?? "0:00"}${days['wednesday'][1]['period'] ?? ""}";
          } else {
            return day = 'Wednesday\nClosed';
          }
          break;
        case 4:
          if (days['thursday'] != null) {
            day =
                "Thursday\n${days['thursday'][0]['time'] ?? "0:00"}${days['thursday'][0]['period'] ?? ""} - ${days['thursday'][1]['time'] ?? "0:00"}${days['thursday'][1]['period'] ?? ""}";
          } else {
            return day = 'Thursday\nClosed';
          }
          break;
        case 5:
          if (days['friday'] != null) {
            day =
                "Friday\n${days['friday'][0]['time'] ?? "0:00"}${days['friday'][0]['period'] ?? ""} - ${days['friday'][1]['time'] ?? "0:00"}${days['friday'][1]['period'] ?? ""}";
          } else {
            return day = 'Friday\nClosed';
          }
          break;
        case 6:
          if (days['saturday'] != null) {
            day =
                "Saturday\n${days['saturday'][0]['time'] ?? "0:00"}${days['saturday'][0]['period'] ?? ""} - ${days['saturday'][1]['time'] ?? "0:00"}${days['saturday'][1]['period'] ?? ""}";
          } else {
            return day = 'Saturday\nClosed';
          }
          break;
        case 7:
          if (days['sunday'] != null) {
            day =
                "Sunday\n${days['sunday'][0]['time'] ?? "0:00"}${days['sunday'][0]['period'] ?? ""} - ${days['sunday'][1]['time'] ?? "0:00"}${days['sunday'][1]['period'] ?? ""}";
          } else {
            return day = 'Sunday\nClosed';
          }
          break;
      }
    }
    return day;
  }

  orderBuilder() {
    if (switchOrdersLengths() == 0) {
      return noOrder();
    } else {
      return ListView.separated(
        separatorBuilder: (ctx, i) {
          return Divider();
        },
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: switchOrdersLengths(),
        itemBuilder: (ctx, i) {
          return switchOrdersViews(buildIndex: i);
        },
      );
    }
  }

  newOrderView(int i) {
    print(appBloc.pendingOrders[i]['orders']['countdown_date']);
    return Container(
      color: Colors.white,
      child: OrderDishTile(
        onLongPress: () => showOrderActionSelectorSheet(
            context: context, scaffoldKey: scaffoldKey),
        onTap: () {
          appBloc.orders = appBloc.pendingOrders;
          NextPage().nextRoute(
              context,
              ViewOrder(
                orderIndex: i,
                pageStatus: appBloc.pendingOrders[i]['orders']['status'],
              ));
        },
        onAccept: () async {
          if (await AppActions().checkInternetConnection() &&
              appBloc.kitchenDetails['opened_for_order']) {
            appBloc.orders = appBloc.pendingOrders;
            appBloc.pendingOrders[i]['orders']['status'] = "LOADING";
            appBloc.pendingOrders = appBloc.pendingOrders;
            if (await OrderActions().acreAction(
                appBloc: appBloc,
                status: "ACCEPTED",
                orderId: appBloc.pendingOrders[i]['orders']['order_id'],
                index: i)) {
              AppActions().showSuccessToast(
                text: 'Order Accepted',
                context: context,
              );
              appBloc.pendingOrders[i]['orders']['status'] = "ACCEPTED";
            } else {
              AppActions().showErrorToast(
                text: appBloc.errorMsg,
                context: context,
              );
            }
            await CheckStatus().checkStatus(
                pageStatus: "PENDING", bloc: appBloc, nextStatus: "ACCEPTED");
            setState(() {});
          } else {
            AppActions().showErrorToast(
                context: context,
                text: appBloc.kitchenDetails['opened_for_order']
                    ? PublicVar.checkInternet
                    : "Please open kitchen before accepting orders");
          }
        },
        onReject: () async {
          appBloc.orders = appBloc.pendingOrders;
          appBloc.pendingOrders[i]['orders']['status'] = "LOADING";
          appBloc.pendingOrders = appBloc.pendingOrders;
          if (await OrderActions().acreAction(
              appBloc: appBloc,
              status: "REJECTED",
              orderId: appBloc.pendingOrders[i]['orders']['order_id'],
              index: i)) {
            AppActions().showSuccessToast(
              text: 'Order Rejected',
              context: context,
            );
            appBloc.pendingOrders[i]['orders']['status'] = "REJECTED";
          } else {
            AppActions().showErrorToast(
              text: appBloc.errorMsg,
              context: context,
            );
          }
          await CheckStatus().checkStatus(
              pageStatus: "PENDING", bloc: appBloc, nextStatus: "REJECTED");
          setState(() {});
        },
        imgUrl: appBloc.pendingOrders[i]['orders']['dishes'][0]['img'],
        onlineImg: false,
        isDish: false,
        total:
            '${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'], number: appBloc.pendingOrders[i]['total'])} ',
        dishLength: appBloc.pendingOrders[i]['orders']['dishes'].length,
        status: appBloc.pendingOrders[i]['orders']['status'],
        name:
            '${appBloc.pendingOrders[i]['user']['first_name']} ${appBloc.pendingOrders[i]['user']['last_name']}',
        mealType:
            '${appBloc.pendingOrders[i]['orders']['dishes'][0]['meal_type']}',
        duration: GetTime().getCountDown(
            time: appBloc.pendingOrders[i]['orders']['countdown_date'],
            choice: TimeChoice.minutes),
        date: appBloc.pendingOrders[i]['orders']['order_sent_date'],
      ),
    );
  }

  acceptedOrderView(int i) {
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

  readyOrderView(int i) {
    return OrderDishTile(
      onTap: () {
        appBloc.orders = appBloc.readyOrders;
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
      total:
          '${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'], number: appBloc.readyOrders[i]['total'])}',
      dishLength: appBloc.readyOrders[i]['orders']['dishes'].length,
      status: appBloc.readyOrders[i]['orders']['status'],
      name:
          '${appBloc.readyOrders[i]['user']['first_name']} ${appBloc.readyOrders[i]['user']['last_name']}',
      mealType: '${appBloc.readyOrders[i]['orders']['dishes'][0]['meal_type']}',
      duration: GetTime().getCountDown(
          time: appBloc.readyOrders[i]['orders']['countdown_date'],
          choice: TimeChoice.minutes),
      date: appBloc.readyOrders[i]['orders']['order_sent_date'],
    );
  }

  intransitOrderView(int i) {
    return OrderDishTile(
      onTap: () {
        appBloc.orders = appBloc.inTransitOrders;
        NextPage().nextRoute(
            context,
            ViewOrder(
              orderIndex: i,
              pageStatus: appBloc.inTransitOrders[i]['orders']['status'],
            ));
      },
      onAccept: () async {
        AppActions().showAppDialog(context,
            title: "Delivery Confirmation",
            descp:
                "Please get the confirmation code from your customer, and enter it below",
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Container(
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
                    validator: Validation().text,
                    controller: code,
                    maxLength: 6,
                    decoration: FormDecorator(
                        labelText: 'Enter confirmation code',
                        helper: 'Please type only 6 digit code above',
                        hint: "- - - -")),
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
      total:
          '${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'] ?? '', number: appBloc.inTransitOrders[i]['total'])}',
      dishLength: appBloc.inTransitOrders[i]['orders']['dishes'].length,
      status: appBloc.inTransitOrders[i]['orders']['status'],
      name:
          '${appBloc.inTransitOrders[i]['user']['first_name']} ${appBloc.inTransitOrders[i]['user']['last_name']}',
      mealType:
          '${appBloc.inTransitOrders[i]['orders']['dishes'][0]['meal_type']}',
      duration: GetTime().getCountDown(
          time: appBloc.inTransitOrders[i]['orders']['countdown_date'],
          choice: TimeChoice.minutes),
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
      AppActions().showAppDialog(context,
          child: Column(
            children: [
              Image.asset(
                "assets/images/completed.png",
                height: 220,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "Order delivered successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          singlAction: true,
          okText: "Ok");
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

  pageView(index) {
    summaryList = [
      {
        "image": "assets/images/icons/order_icon2.png",
        "topic": "Orders Sumary",
        "value": "${appBloc.kitchenDetails['total_received'] ?? "0"}",
      },
      {
        "image": "assets/images/icons/money.png",
        "topic": "Total Earnings",
        "value":
            "${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'], number: appBloc.kitchenDetails['total_earning'])}",
      },
      {
        "image": "assets/images/icons/deliver_order.png",
        "topic": "Orders Delivered",
        "value": "${appBloc.kitchenDetails['total_delivered'] ?? "0"}",
      },
    ];
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          switch (index) {
            case 0:
              NextPage().nextRoute(context, OrderSummary());
              break;
            case 1:
              NextPage().nextRoute(
                  context,
                  EarningView(
                    single: true,
                  ));
              break;
            case 2:
              NextPage().nextRoute(
                  context,
                  DeliveredView(
                    single: true,
                  ));

              break;
          }
        },
        child: Material(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/placehold2.jpg'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: deviceHeight * 0.01,
                  horizontal: deviceWidth * 0.05),
              alignment: Alignment.center,
              height: deviceHeight * 0.20,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: getColor(index),
                  borderRadius: BorderRadius.circular(20)),
              child: Wrap(
                alignment: WrapAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        summaryList[index]['topic'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      Image.asset(
                        summaryList[index]['image'],
                        height: deviceHeight * 0.05,
                      ),
                    ],
                  ),
                  Text(
                    summaryList[index]['value'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MoneyConverter()
                            .getCount(n: summaryList[index]['value']),
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getColor(index) {
    switch (index) {
      case 0:
        return Colors.teal[800].withOpacity(0.9);
        break;
      case 1:
        return Colors.blue[800].withOpacity(0.9);
        break;
      case 2:
        return Colors.orange[800].withOpacity(0.9);
        break;
    }
  }

  onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  getData() async {
    return await OrderServer().getAllOrders(appBloc: appBloc);
  }

  noNetwork() {
    return DisplayMessage(
      onPress: () {
        appBloc.hasPendingOrder = false;
        setState(() {});
        getData();
      },
      asset: 'assets/images/icons/connection_icon.png',
      message: PublicVar.checkInternet,
      btnText: 'Reload',
      btnWidth: deviceWidth * 0.30,
    );
  }

  noOrder() {
    return DisplayMessage(
      onPress: () {
        appBloc.hasPendingOrder = false;
        setState(() {});
        getData();
      },
      asset: 'assets/images/icons/order_icon2.png',
      message: "No recent order yet!,\nReload to check if there is any",
      btnText: 'Reload',
      btnWidth: deviceWidth * 0.30,
    );
  }

  changeOrderStatus() async {
     if (PublicVar.hasDish) {
    var status = 0;
    appBloc.kitchenDetails['opened_for_order'] ? status = 0 : status = 1;

    AppActions().showLoadingToast(text: PublicVar.wait,context: context,);
    if (await Server().postAction(
        bloc: appBloc,
        url: Urls.changeKitchenOrderStatus,
        data: {"kitchen_id": PublicVar.kitchenID, "status": status})) {
          await Server().postAction(bloc: appBloc,url: Urls.activiteKitchen, data:  PublicVar.queryKitchenNoKey);

      appBloc.kitchenDetails['opened_for_order']
          ? appBloc.kitchenDetails['opened_for_order'] = false
          : appBloc.kitchenDetails['opened_for_order'] = true;
      AppActions().showSuccessToast(
        text: appBloc.kitchenDetails['opened_for_order']
            ? 'You can now accept orders'
            : 'You can no longer accept orders',
        context: context,
      );
      setState(() {});
    } else {
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
    } else {
        AppActions().showAppDialog(context,
        descp:"Please you have to create a menu for your before you can start accepting orders.",
        title: "Kitchen has no dish",
        singlAction: true, okAction: () { 
        NextPage().clearPages(context,Base(firstEntry: true,));}, okText: "Create menu");
      }
   
  }

  ordersTabs() {
    return Container(
      height: 40,
      width: double.infinity,
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            alignment: Alignment.center,
            child: PreferredSize(
                preferredSize: Size.fromHeight(30), // here the desired height
                child: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(PublicVar.primaryColor).withOpacity(0.4)),
                  unselectedLabelColor: Colors.black87,
                  unselectedLabelStyle: TextStyle(
                      fontSize: 2 * deviceFont, fontWeight: FontWeight.w700),
                  labelStyle: TextStyle(
                      fontSize: 2 * deviceFont, fontWeight: FontWeight.w600),
                  labelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: List.generate(tabs.length, (i) {
                    return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          child: Row(
                            children: [
                              Text(
                                '${tabs[i]['name']}',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              getLength(index: i)
                            ],
                          ),
                        ));
                  }),
                )),
          ),
        ),
      ),
    );
  }

  getLength({int index}) {
    if (tabs[index]['value'] > 0) {
      return Container(
        height: 18,
        width: 18,
        padding: EdgeInsets.all(1.0),
        child: CircleAvatar(
          backgroundColor: Colors.black,
          child: Text(
            "${tabs[index]['value']}",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    tabs[0]['value'] = appBloc.pendingOrders.length;
    tabs[1]['value'] = appBloc.acceptedOrders.length;
    tabs[2]['value'] = appBloc.readyOrders.length;
    tabs[3]['value'] = appBloc.inTransitOrders.length;
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    deviceFont = deviceHeight * 0.01;
    if (!firstTime) {
      firstTime = true;
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Feather.menu,
                size: 25,
              ),
              onPressed: () {
                widget.scaffoldKey.currentState.openDrawer();
              }),
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: Text(
                    appBloc.kitchenDetails['opened_for_order']
                        ? 'GO OFFLINE <<'
                        : 'GO ONLINE >>',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: appBloc.kitchenDetails['opened_for_order']
                            ? Colors.black
                            : Colors.black54),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                appBloc.kitchenDetails['opened_for_order']
                    ? CustomPaint(
                        painter: PulseIcon(_animeController),
                        child: SizedBox(
                          height: 15,
                          width: 15,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                            height: 10, width: 10, color: Colors.grey[500]))
              ],
            ),
          ),
          actions: <Widget>[
            Tooltip(
              message: "For opening and closing your kitchen",
              child: CupertinoSwitch(
                trackColor: Colors.grey[500],
                activeColor: Color(PublicVar.primaryColor),
                value: appBloc.kitchenDetails['opened_for_order'],
                onChanged: (value) async {
                  if (await AppActions().checkInternetConnection()) {
                    changeOrderStatus();
                   
                  } else {
                    AppActions().showErrorToast(
                      text: PublicVar.checkInternet,
                      context: context,
                    );
                  }
                },
              ),
            ),
          ],
          elevation: 0.0,
        ),
        body: PublicVar.accountApproved
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    online
                        ? SizedBox()
                        : InkWell(
                            onTap: () async {
                              AppActions().showLoadingToast(
                                text: PublicVar.wait,
                                context: context,
                              );
                              await Server().queryKitchen(appBloc: appBloc);
                            },
                            child: Container(
                              width: double.infinity,
                              color: Colors.orange[500],
                              child: Padding(
                                padding: EdgeInsets.all(deviceHeight * 0.01),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'Network is unavailable, Tap here to refresh',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      )),
                                      SizedBox(),
                                      Icon(
                                        Icons.error_rounded,
                                        color: Colors.white,
                                        size: 12,
                                      )
                                    ]),
                              ),
                            ),
                          ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth * 0.04,
                          vertical: deviceHeight * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                PageWatch().setCurrentScreen(
                                    user_id: PublicVar.userKitchlyID,
                                    kitchen_id: PublicVar.kitchenID,
                                    kitchenName: PublicVar.kitchenUserName,
                                    page: "Home Page",
                                    actions: ["Enter Page"],
                                    timeSpent: pageTime);
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.only(right: deviceWidth * 0.03),
                                child: Text(
                                  'Business Hours',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              AppActions().showAppDialog(context,
                                  title: "Business Hours",
                                  child: ViewHours(
                                    hours: appBloc.kitchenDetails['openings'],
                                  ),
                                  topClose: true,
                                  topEdit: true, editAction: () {
                                Navigator.pop(context);
                                NextPage().nextRoute(
                                    context,
                                    KitchenTime(
                                      onlineTime:
                                          appBloc.kitchenDetails['openings'],
                                    ));
                              }, singlAction: true, okText: "Close");
                            },
                            child: Text(
                              getDay(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: deviceHeight * 0.20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: PageView.builder(
                            key: widget.key,
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: onPageChanged,
                            itemCount: 3,
                            itemBuilder: (ctx, i) {
                              return pageView(i); //data[i]['duration']
                            },
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth * 0.05,
                          vertical: deviceHeight * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              appBloc.pendingOrders[1]['pos'] = 14;
                              appBloc.pendingOrders[1]['orders']['dishes'][0]
                                  ['duration'] = 14;
                            },
                            child: Text(
                              'Recent Orders',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w800),
                            ),
                          ),
                          // Tooltip(
                          //   message: "Switch to all orders in transit",
                          //   child: IconButton(
                          //       icon: Icon(
                          //         Ionicons.ios_arrow_round_forward,
                          //         size: 38,
                          //       ),
                          //       onPressed: () {
                          //         _tabController.animateTo(3);
                          //       }),
                          // )
                        ],
                      ),
                    ),
                    ordersTabs(),
                    SizedBox(
                      height: 20,
                    ),
                    checkOrderData(),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 80),
                child: KitchenSettings(),
              ));
  }
}
