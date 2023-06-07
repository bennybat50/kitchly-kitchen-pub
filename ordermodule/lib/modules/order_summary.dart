import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:providermodule/providermodule.dart';
import 'package:provider/provider.dart';
import 'package:ordermodule/ordermodule.dart';

class OrderSummary extends StatefulWidget {
  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  AppBloc appBloc;
  double deviceHeight,deviceWidth,deviceFont;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    final topLeft = BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(5),
        bottomRight: Radius.circular(5),
        topRight: Radius.circular(5));
    final topright = BorderRadius.only(
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(5),
        bottomRight: Radius.circular(5),
        topLeft: Radius.circular(5));
    final bottomright = BorderRadius.only(
        bottomRight: Radius.circular(20),
        bottomLeft: Radius.circular(5),
        topRight: Radius.circular(5),
        topLeft: Radius.circular(5));
    final bottomLeft = BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(5),
        topRight: Radius.circular(5),
        topLeft: Radius.circular(5));
    final allRadius = BorderRadius.circular(5);
    final all20Radius = BorderRadius.circular(20);
    final sumPadding = EdgeInsets.all(8.0);
    deviceHeight=MediaQuery.of(context).size.height;
    deviceWidth=MediaQuery.of(context).size.width;
    deviceFont=deviceHeight *0.01;
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
        actions: <Widget>[
          // IconButton(icon: Icon(Feather.map_pin), onPressed: () {})
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        'Order Summary ',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.dashboard,
                      size: 25,
                      color: Color(PublicVar.primaryColor),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 5),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: InkWell(
                          onTap: (){
                            NextPage().nextRoute(
                                      context,
                                      EarningView(
                                        single: true,
                                      ));
                          },
                                                  child: Material(
                            elevation: 5,
                            shadowColor: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/placehold2.jpg'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 25),
                                alignment: Alignment.center,
                                height: deviceHeight*0.18,
                                width: deviceWidth*0.9,
                                decoration: BoxDecoration(
                                    color: Colors.blue[600].withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Total Earned',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Image.asset(
                                          'assets/images/icons/money.png',
                                          height: 35,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.kitchenDetails['total_earning'])}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MoneyConverter().getCount(n:'${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.kitchenDetails['total_earning'])}'),
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: sumPadding,
                            child: GetSumContainer(
                                image: 'assets/images/icons/order_icon2.png',
                                ontap: () {
                                  NextPage().nextRoute(
                                      context,
                                      PendingView(
                                        single: true,
                                      ));
                                },
                                bgColor: Colors.green,
                                radius: topLeft,
                                titleText: 'Pending',
                                amountText: '${appBloc.pendingOrders.length}',
                                textColor: Colors.white),
                          ),
                          Padding(
                            padding: sumPadding,
                            child: GetSumContainer(
                                image: 'assets/images/icons/accept_order.png',
                                ontap: () {
                                  NextPage().nextRoute(
                                      context,
                                      AcceptedView(
                                        single: true,
                                      ));
                                },
                                bgColor: Colors.teal,
                              
                                radius: topright,
                                titleText: 'Accepted',
                                amountText: '${appBloc.acceptedOrders.length}',
                                textColor: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: sumPadding,
                            child: GetSumContainer(
                                image: 'assets/images/icons/category_icon.png',
                                ontap: () {
                                  NextPage().nextRoute(
                                      context,
                                      ReadyView(
                                        single: true,
                                      ));
                                },
                                bgColor: Colors.lightBlueAccent,
                                radius: allRadius,
                                titleText: 'Ready',
                                amountText: '${appBloc.readyOrders.length}',
                                textColor: Colors.white),
                          ),
                          Padding(
                            padding: sumPadding,
                            child: GetSumContainer(
                                image: 'assets/images/icons/delivery_icon.png',
                                ontap: () {
                                  NextPage().nextRoute(
                                      context,
                                      InTransitView(
                                        single: true,
                                      ));
                                },
                                bgColor: Colors.cyan,
                                radius: allRadius,
                                titleText: 'In Transit',
                                amountText: '${appBloc.inTransitOrders.length}',
                                textColor: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: sumPadding,
                            child: GetSumContainer(
                                image: 'assets/images/icons/deliver_order.png',
                                ontap: () {
                                  NextPage().nextRoute(
                                      context,
                                      DeliveredView(
                                        single: true,
                                      ));
                                },
                                bgColor: Colors.orange[600],
                                radius: bottomLeft,
                                titleText: 'Delivered',
                                amountText: '${appBloc.deliveredOrders.length}',
                                textColor: Colors.white),
                          ),
                          Padding(
                            padding: sumPadding,
                            child: GetSumContainer(
                                image: 'assets/images/icons/cancel.png',
                                ontap: () {
                                  NextPage().nextRoute(
                                      context,
                                      RejectedView(
                                        single: true,
                                      ));
                                },
                                bgColor: Colors.red,
                                radius: bottomright,
                                titleText: 'Rejected',
                                amountText: '${appBloc.rejectedOrders.length}',
                                textColor: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class GetSumContainer extends StatelessWidget {
   GetSumContainer(
      {Key key,
      this.radius,
      this.bgColor,
      this.textColor,
      this.titleText,
      this.amountText,
      this.image,
      this.ontap,
      this.height,
      this.width,
      this.amountFont})
      : super(key: key);

double deviceHeight,deviceWidth,deviceFont;
  final radius,
      bgColor,
      textColor,
      titleText,
      amountText,
      image,
      ontap,
      height,
      width,
      amountFont;

  @override
  Widget build(BuildContext context) {
    deviceHeight=MediaQuery.of(context).size.height;
    deviceWidth=MediaQuery.of(context).size.width;
    deviceFont=deviceHeight *0.01;
    return InkWell(
      onTap: ontap,
      borderRadius: radius,
      splashColor: Colors.grey,
      child: ClipRRect(
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/placehold1.jpg",
                  ),
                  fit: BoxFit.cover)),
          child: Container(
            height: height ?? deviceWidth*0.48,
            width: width ?? deviceWidth*0.4,
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.9),
              borderRadius: radius,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                direction: Axis.vertical,
                children: <Widget>[
                  Image.asset(
                    image,
                    height: 35,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    titleText,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: textColor),
                  ),
                  Text(
                    amountText,
                    style: TextStyle(
                        fontSize: amountFont ?? 18,
                        fontWeight: FontWeight.w800,
                        color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
