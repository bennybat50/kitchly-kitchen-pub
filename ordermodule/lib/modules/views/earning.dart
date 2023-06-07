import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ordermodule/modules/view_order.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';

import 'payment_view.dart';

class EarningView extends StatefulWidget {
  const EarningView({
    Key key,
    this.single,
  });

  final bool single;

  @override
  _EarningViewState createState() => _EarningViewState();
}

class _EarningViewState extends State<EarningView>
    with TickerProviderStateMixin<EarningView> {
  AppBloc appBloc;
  bool loading = false;
  List tabs = [
    "Today",
    "This Week",
    "This Month",
    "Past 3 Months",
    "This Year"
  ];

  TabController _tabController;

  @override
  void initState() {
    _tabController =
        TabController(vsync: this, initialIndex: 0, length: tabs.length);
    super.initState();
  }

  checkOrderData() {
    if (!appBloc.hasDeliveredOrder) {
      return FutureBuilder(
        builder: (ctx, snap) {
          if (snap.hasData && snap.data['delivered'] == "false") {
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
    if (appBloc.deliveredOrders.length == 0) {
      return Center(
        child: noOrder(),
      );
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Text(
                "Total Inflow",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w800),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
                child: Text(
                  "${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'], number: appBloc.kitchenDetails['total_earning'])}",
                  style: TextStyle(
                      color: Color(PublicVar.primaryColor),
                      fontSize: MoneyConverter().getCount(
                          n: '${appBloc.kitchenDetails['total_earning']}'),
                      fontWeight: FontWeight.w900),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Ionicons.ios_arrow_down,
                                size: 14, color: Color(PublicVar.primaryColor)),
                          ),
                          Text(
                            'Total Income',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 11,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          Text(
                            "${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'], number: appBloc.kitchenDetails['total_earning'])}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: ListTile(
                      onTap: () {
                        getPaymentLinks();
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Ionicons.ios_arrow_up,
                                size: 14, color: Colors.orange[800]),
                          ),
                          Text(
                            'Commission 10%',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 11,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          Text(
                            "${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'], number: getCommission(value: appBloc.kitchenDetails['amount_oweing']))}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  getPaymentLinks();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Pay Commission  >>',
                          style: TextStyle(
                              fontSize: 16, color: Colors.orange[700])),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                thickness: 1.2,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      "All Transactions",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              // Container(
              //   height: 40,
              //   width: double.infinity,
              //   alignment: Alignment.center,
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 15.0),
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(30),
              //       child: Container(
              //         alignment: Alignment.center,
              //         child: PreferredSize(
              //             preferredSize:
              //                 Size.fromHeight(30), // here the desired height
              //             child: TabBar(
              //               isScrollable: true,
              //               controller: _tabController,
              //               indicator: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(30),
              //                   color: Color(PublicVar.primaryColor)
              //                       .withOpacity(0.8)),
              //               unselectedLabelColor: Colors.black87,
              //               unselectedLabelStyle: TextStyle(
              //                   fontSize: 15, fontWeight: FontWeight.w700),
              //               labelStyle: TextStyle(
              //                   fontSize: 15, fontWeight: FontWeight.w600),
              //               labelColor: Colors.white,
              //               indicatorSize: TabBarIndicatorSize.tab,
              //               tabs: List.generate(tabs.length, (i) {
              //                 return Container(
              //                     decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(30),
              //                     ),
              //                     child: Padding(
              //                       padding: EdgeInsets.symmetric(
              //                           horizontal: 10.0, vertical: 5),
              //                       child: Row(
              //                         children: [
              //                           Text(
              //                             '${tabs[i]}',
              //                             style: TextStyle(fontSize: 14),
              //                           ),
              //                         ],
              //                       ),
              //                     ));
              //               }),
              //             )),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              ordersView(),
            ],
          ),
        ),
      );
    }
  }

  ordersView() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (ctx, i) {
        return Divider();
      },
      shrinkWrap: true,
      reverse: true,
      itemCount: appBloc.deliveredOrders.length,
      itemBuilder: (ctx, i) {
        return orderViews(i);
      },
    );
  }

  orderViewtest(int i) {
    return OrderDishTile(
      onTap: () {
        appBloc.orders = appBloc.deliveredOrders;
        NextPage().nextRoute(
            context,
            ViewOrder(
              orderIndex: i,
              pageStatus: appBloc.deliveredOrders[i]['orders']['status'],
            ));
      },
      imgUrl: appBloc.deliveredOrders[i]['orders']['dishes'][0]['img'],
      onlineImg: false,
      isDish: false,
      total:
          "${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'], number: appBloc.deliveredOrders[i]['total'])}",
      dishLength: appBloc.deliveredOrders[i]['orders']['dishes'].length,
      name:
          '${appBloc.deliveredOrders[i]['user']['first_name']} ${appBloc.deliveredOrders[i]['user']['last_name']}',
      mealType:
          '${appBloc.deliveredOrders[i]['orders']['dishes'][0]['meal_type']}',
      duration: appBloc.deliveredOrders[i]['orders']['total_duration'],
      date: appBloc.deliveredOrders[i]['orders']['order_sent_date'],
    );
  }

  orderViews(int i) {
    return ListTile(
      contentPadding: EdgeInsets.all(1),
      leading: Container(
        height: 20,
        child: CircleAvatar(
          backgroundColor: Color(PublicVar.primaryColor),
          child: Text(
            '${convertDate(appBloc.deliveredOrders[i]['orders']['order_sent_date'], 'day')}',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              '${appBloc.deliveredOrders[i]['user']['first_name']} ${appBloc.deliveredOrders[i]['user']['last_name']}',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Text(
            '${convertDate(appBloc.deliveredOrders[i]['orders']['order_sent_date'], 'date')}',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
      subtitle: Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.vertical,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.vertical,
                children: [
                  Text(
                    'Income',
                    style: TextStyle(fontSize: 9),
                  ),
                  Text(
                    "${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'], number: appBloc.deliveredOrders[i]['total'])}",
                    maxLines: 3,
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                width: 20,
              ),
              SizedBox(
                  width: 30,
                  child: Divider(
                    color: Colors.blueGrey,
                  )),
              SizedBox(
                width: 20,
              ),
              Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.vertical,
                children: [
                  Text(
                    'Commision 10%',
                    style: TextStyle(fontSize: 9),
                  ),
                  Text(
                    "${MoneyConverter().convertN(symbol: PublicVar.kitchenCountry['symbol'], number: getCommission(value: appBloc.deliveredOrders[i]['total']))}",
                    maxLines: 3,
                    style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  containerView({child, color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: color ?? Colors.white,
          child: child,
        ),
      ),
    );
  }

  getPaymentLinks() async {
    Map data = {
      "kitchen_id": PublicVar.kitchenID,
      "longitude": 12.4543,
      "latitude": 34.6543
    };
    showLoading();
    if (await Server()
        .postAction(bloc: appBloc, data: data, url: Urls.payments)) {
      var res = appBloc.mapSuccess;
      NextPage().nextRoute(
          context,
          PaymentView(
            url: res['data']['link'],
          ));
    } else {
      AppActions().showErrorToast(text: appBloc.errorMsg, context: context);
    }
    showLoading();
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
      asset: 'assets/images/icons/money.png',
      message:
          "No earnings yet!,\nReload or switch to pending tab to start accepting orders.",
      btnText: 'Reload',
      btnWidth: 100,
    );
  }

  getData() async {
    return await OrderServer().getAllOrders(appBloc: appBloc);
  }

  reload() {
    appBloc.hasDeliveredOrder = false;
    getData();
    setState(() {});
  }

  convertDate(timestamp, get) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var day = date.day,
        year = date.year,
        month = date.month,
        hour = date.hour,
        min = date.minute;
    switch (get) {
      case 'time':
        return '$hour:$min';
      case 'day':
        return '$day';
      case 'date':
        return '$day-${getMonth(month)}-$year';
      case 'both':
        return '$hour:$min / $day-${getMonth(month)}-$year';
    }
  }

  getCommission({int value}) {
    var res;
    try {
      res = value * 0.1;
    } catch (e) {
      res = 0.0;
    }
    return res;
  }

  getMonth(data) {
    switch (data) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
    }
  }

  showLoading() {
    if (loading) {
      loading = false;
    } else {
      loading = true;
    }
    setState(() {});
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
                'Kitchen Earnings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: loading ? ShowFloatingLoader() : null,
    );
  }
}
