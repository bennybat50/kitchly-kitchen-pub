import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ordermodule/ordermodule.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';

class Order extends StatefulWidget {
  final scaffoldKey;
  const Order({Key key, this.scaffoldKey}) : super(key: key);
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order>
    with SingleTickerProviderStateMixin<Order> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  AppBloc appBloc;
  TabController _tabController;
  int currentIndex = 0;
  double deviceHeight;
  List tabs = [
    {"name": "New", "value": 0},
    {"name": "Preparing", "value": 0},
    {"name": "Ready", "value": 0},
    {"name": "In Transit", "value": 0},
    {"name": "Delivered", "value": 0},
    {"name": "Rejected", "value": 0},
  ];
  bool checked = true;
  @override
  void initState() {
    _tabController =
        TabController(vsync: this, initialIndex: 0, length: tabs.length);
    _tabController.addListener(handleTabs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    tabs[0]['value'] = appBloc.pendingOrders.length;
    tabs[1]['value'] = appBloc.acceptedOrders.length;
    tabs[2]['value'] = appBloc.readyOrders.length;
    tabs[3]['value'] = appBloc.inTransitOrders.length;
    tabs[4]['value'] = appBloc.deliveredOrders.length;
    tabs[5]['value'] = appBloc.rejectedOrders.length;
    deviceHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.8,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Feather.menu,
              size: 25,
            ),
            onPressed: () {
              widget.scaffoldKey.currentState.openDrawer();
            }),
        title: Text(
          'All Orders',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 35,
              child: TabBar(
                isScrollable: true,
                controller: _tabController,
                unselectedLabelColor: Colors.grey[500],
                unselectedLabelStyle: TextStyle(
                    fontSize: 2.0 * deviceHeight, fontWeight: FontWeight.w600),
                labelStyle: TextStyle(
                    fontSize: 2.0 * deviceHeight, fontWeight: FontWeight.w700),
                labelColor: Colors.black,
                labelPadding: EdgeInsets.symmetric(horizontal: 10),
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(PublicVar.primaryColor).withOpacity(0.4)),
                tabs: List.generate(tabs.length, (i) {
                  return Tab(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Text("${tabs[i]['name']}"),
                          SizedBox(
                            width: 5,
                          ),
                          getLength(index: i)
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.dashboard,
                size: 18,
              ),
              onPressed: () {
                NextPage().nextRoute(context, OrderSummary());
              }),
        ],
      ),
      body: Center(
        child: TabBarView(controller: _tabController, children: [
          PendingView(
            single: false,
          ),
          AcceptedView(
            single: false,
          ),
          ReadyView(
            single: false,
          ),
          InTransitView(
            single: false,
          ),
          DeliveredView(
            single: false,
          ),
          RejectedView(
            single: false,
          ),
        ]),
      ),
    );
  }

  handleTabs() {
    setState(() {
      currentIndex = _tabController.index;
    });
  }

  getLength({int index}) {
    if (tabs[index]['value'] > 0) {
      return Container(
        height: 14,
        width: 14,
        child: CircleAvatar(
          backgroundColor: Colors.black,
          child: Text(
            "${tabs[index]['value']}",
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
