import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:ordermodule/ordermodule.dart';
import 'package:reworkutils/rework_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewOrder extends StatefulWidget {
  final orderIndex, pageStatus;
  final bool isDelivery;
  const ViewOrder({Key key, this.orderIndex, this.pageStatus, this.isDelivery})
      : super(key: key);
  @override
  _ViewOrderState createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder>
    with SingleTickerProviderStateMixin<ViewOrder> {
  AppBloc appBloc;
  var index, pageStatus,deliveryData;
  double deviceHeight, deviceWidth, deviceFont;
  int currentIndex = 0;
  bool checkConfirm = false, buildTabs=false, hasCompanyData=false;
  TabController _tabController;
  List tabs ;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var codeField = TextEditingController();
 String confirmCode;
  @override
  void initState() {
    index = widget.orderIndex;
    Timer.periodic(new Duration(seconds: 30), (_) async {
      if(mounted)setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    if(!buildTabs){
      buildTabs=true;
      if(appBloc.orders[index]['delivery_type']=="SHIPPING_DELIVERY"){
         tabs = ['Orders',"Delivery",'Customer',];
        _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
      }else{
         tabs = ['Orders', 'Customer'];
       _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
      }
     
      _tabController.addListener(handleTabs);
    }
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    deviceFont = deviceHeight * 0.01;
   if(!PublicVar.onProduction) print(appBloc.orders[index]);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        titleSpacing: 0.0,
        title: Text('Order Details'),
        centerTitle: true,
        actions: [IconButton(
            onPressed: () async{
               var url = "tel:${appBloc.orders[index]['user']['phone']}";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
            },
            icon: Icon(
              Icons.phone,
              size: 22,
              color: Colors.black,
            ),
          ),],
        bottom: PreferredSize(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                getLabelStatus(appBloc.orders[index]['orders']['status']),
                getTextStatus(appBloc.orders[index]['orders']['status'])
              ],),
            ),
            preferredSize: Size.fromHeight(25.0)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15,),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child:  Column(
                    children: <Widget>[
                      orderSummaryTile(
                          title1: "#ID: ",
                          sec1Bold: true,
                          descp1:"${appBloc.orders[index]['orders']['order_id']}",
                          title2: '',
                          descp2:'${getDeliveryStatus(data:appBloc.orders[index]['delivery_type']??"")}'),
                      Divider(),
                      orderSummaryTile(
                          title1: 'Dishes: ',
                          descp1:
                              '${appBloc.orders[index]['orders']['dishes'].length}',
                          title2: 'Price: ',
                          descp2:
                              '${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.orders[index]['total'])}'),
                      Divider(),
                      orderSummaryTile(
                        title1: 'Date: ',
                        descp1:
                            '${convertDate(appBloc.orders[index]['orders']['order_sent_date'], 'date')}',
                        title2: 'Due in: ',
                        descp2: '15-30 min',
                        color2: getTimingColor(value: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                    ],
                  )),
            Padding(
               padding:  EdgeInsets.symmetric(horizontal:15.0),
              child: Container(
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                 border:Border.all(width:1, color: Color(PublicVar.primaryColor)),
                  color: Colors.white),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        alignment: Alignment.center,
                        child: PreferredSize(
                            preferredSize:Size.fromHeight(20), // here the desired height
                            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(PublicVar.primaryColor)),
              unselectedLabelColor: Colors.black,
              unselectedLabelStyle: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600),
              labelStyle: TextStyle(
                   fontSize: 16, fontWeight: FontWeight.w600),
              labelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: List.generate(tabs.length, (i) {
                return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.0),
                      child: Tab(text: '${tabs[i]}'),
                    );
              }),
                            )),
                      ),
                    ),
                  ),
                ),
            ),
           appBloc.orders[index]['delivery_type']=="SHIPPING_DELIVERY"? tabBarView2() : tabBarView1()
          ],
        ),
      ),
      bottomNavigationBar:getActionStatus(appBloc.orders[index]['orders']['status']),
    );
  }

  getDeliveryStatus({data}){
    switch(data){
      case"SHIPPING_DELIVERY":return "DELIVERY";
      case"EAT_IN":return "EAT IN";
      case"SELF_PICKUP":return "PICKUP";
      default: return  "";
    }
  }

  handleTabs() {
    setState(() {
      currentIndex = _tabController.index;
    });
  }

  tabBarView1() {
    if (currentIndex == 0) {
      return orderDetailsView();
    } else {
      return customerView();
    }
  }

  tabBarView2() {
    if (currentIndex == 0) {
      return orderDetailsView();
    } if (currentIndex == 1) {
      return checkDeliveryCompanyData();
    }else {
      return customerView();
    }
  }
 

   deliverOrder({int code}) async {
    pageStatus = appBloc.orders[index]['orders']['status'];
            appBloc.orders[index]['orders']['status'] = "LOADING";
            appBloc.orders = appBloc.orders;
            if (await OrderActions().deliveryAction(
                appBloc: appBloc,
                status: "DELIVERED",
                confirmCode: code,
                orderId: appBloc.orders[index]['orders']['order_id'],
                index: index)) {
              AppActions().showSuccessToast(
                text: 'Order delivered successfully!',
                context: context,
              );
              appBloc.orders[index]['orders']['status'] = "DELIVERED";
            } else {
              AppActions().showErrorToast(
                text: appBloc.errorMsg,
                context: context,
              );
            }
            await CheckStatus().checkStatus(
                pageStatus: pageStatus, bloc: appBloc, nextStatus: "DELIVERED");
            appBloc.orders = appBloc.orders;
  }

  orderDetailsView() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
          child: Text(
                      'Order Info:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
          child: getContainer(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (ctx, i) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                      child: Divider(
                        thickness: 2,
                      ),
                    );
                  },
                  shrinkWrap: true,
                  itemCount: appBloc.orders[index]['orders']['dishes'].length,
                  itemBuilder: (ctx, i) {
                    return orderView(i);
                  },
                ),
              )),
        ),
      ],
    );
  }

  customerView() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: getContainer(
            child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 25,
          ),
          child: Column(
            children: <Widget>[
              Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
          child: Text(
                      'Customer Info:',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
        ),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                CircleImage(
                  size: 14,
                  url: PublicVar.kitchenImageUrl,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      '${appBloc.orders[index]['user']['first_name']} ${appBloc.orders[index]['user']['last_name']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(
                  Ionicons.ios_mail,
                  size: 14,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      '${appBloc.orders[index]['user']['email']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 6),
              InkWell(
                onTap: () async {
                  var url = "tel:${appBloc.orders[index]['user']['phone']}";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Icon(
                    Icons.phone,
                    size: 14,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        '${appBloc.orders[index]['user']['phone']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(
                  Ionicons.ios_pin,
                  size: 14,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      '${appBloc.orders[index]['user']['addr'] ?? ""}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ])
            ],
          ),
        )));
  }

    checkDeliveryCompanyData() {
    if (hasCompanyData) {
      return deliveryInfoView();
    } else {
      return FutureBuilder(
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting ||
                snap.connectionState == ConnectionState.active) {
              return Center(child: ShowPageLoading());
            }
            return deliveryInfoView();
          },
          future:
              getDeliveryCompanyInfo(appBloc.orders[index]['delivery']['company']['id']));
    }
  }

  deliveryInfoView() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: getContainer(
            child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 25,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Delivery Info:',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 20,
                    width: 20,
                    child: Icon(Icons.delivery_dining_rounded),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      '${appBloc.orders[index]['delivery']['company']['name']}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 6),
              InkWell(
                onTap: () async {
                  var url = "tel:${appBloc.orders[index]['delivery']['phones'][0]}";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Icon(
                    Icons.phone,
                    size: 14,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        '${appBloc.orders[index]['delivery']['phones'][0]}',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(height: 6),
              InkWell(
                onTap: () async {
                  var url = "tel:${appBloc.orders[index]['delivery']['phones'][1]}";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Icon(
                    Icons.phone,
                    size: 14,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        '${appBloc.orders[index]['delivery']['phones'][1]}',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(height: 6),
              Column(children: [
                ListTile(title: Text(
                'PICKUP:>>>',
                textAlign: TextAlign.left,
                style: TextStyle(
                fontSize: 14,
                  color: Colors.black54,
                ),
              ), subtitle: Text(" ${appBloc.orders[index]['delivery']['route']['from'] ?? ""}", style: TextStyle(
                fontSize: 16,
                  color: Colors.black,
                ),),),
              ListTile(title: Text(
                'DROP-OFF:>>>',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ), subtitle: Text("${appBloc.orders[index]['delivery']['route']['to']}", style: TextStyle(
                fontSize: 16,
                  color: Colors.black,
                ),),)
              ],),
              SizedBox(height: 16),
            ],
          ),
        )));
  }

  orderView(int i) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 40,
                        width: 40,
                        child: GetImageProvider(
                            url: appBloc.orders[index]['orders']['dishes'][i]
                                ['img'],
                            placeHolder: PublicVar.defaultKitchenImage),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${appBloc.orders[index]['orders']['dishes'][i]['name']} ',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.black87.withOpacity(0.8),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                '${appBloc.orders[index]['orders']['dishes'][i]['quantity']}',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          getDishStatus(status:appBloc.orders[index]['orders']['dishes'][i]['status'] ),
                          Text(
                              '${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.orders[index]['orders']['dishes'][i]['unit_price'])}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                          // getOrderDishStatus(
                          //     status: appBloc.orders[index]['orders']['dishes']
                          //         [i]['status'],
                          //     isDish: true)
                        ],
                      ),
                    ]),
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(children: [
              
              Divider(),
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Extras:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (ctx, opi) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                                  '${appBloc.orders[index]['orders']['dishes'][i]['extras'][opi]['value']}')),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '(x${appBloc.orders[index]['orders']['dishes'][i]['extras'][opi]['quantity']})',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          Text(
                            '${MoneyConverter().convertN(symbol:PublicVar.kitchenCountry['symbol'],number:appBloc.orders[index]['orders']['dishes'][i]['extras'][opi]['unit_price'])}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ]);
                  },
                  separatorBuilder: (ctxb, b) {
                    return Divider();
                  },
                  itemCount: appBloc
                      .orders[index]['orders']['dishes'][i]['extras'].length),
              appBloc.orders[index]['orders']['dishes'][i]['comment'] == ''
                  ? SizedBox()
                  : Column(
                      children: <Widget>[
                        Divider(),
                        Row(
                          children: <Widget>[
                            Text(
                              'Customer Note:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.grey[100],
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Text(
                                    '${appBloc.orders[index]['orders']['dishes'][i]['comment']}',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ]),
          ),
          SizedBox(height:10),
          getDishActionButton(status: appBloc.orders[index]['orders']['dishes'][i]['status'], dishIndex: i)
        ],
      ),
    );
  }

  getActionStatus(String status) {
    switch (status) {
      case "PENDING":
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ButtonWidget(
              onPress: () async {
                pageStatus = appBloc.orders[index]['orders']['status'];
                appBloc.orders[index]['orders']['status'] = "LOADING";
                appBloc.orders = appBloc.orders;
                if (await OrderActions().acreAction(
                    appBloc: appBloc,
                    status: "REJECTED",
                    orderId: appBloc.orders[index]['orders']['order_id'],
                    index: index)) {
                  AppActions().showSuccessToast(
                    text: 'Order Rejected',
                    context: context,
                  );
                  appBloc.orders[index]['orders']['status'] = "REJECTED";
                } else {
                  AppActions().showErrorToast(
                    text: appBloc.errorMsg,
                    context: context,
                  );
                }
                await CheckStatus().checkStatus(
                    pageStatus: pageStatus,
                    bloc: appBloc,
                    nextStatus: "REJECTED");
                appBloc.orders = appBloc.orders;
              },
              width: 120.0,
              textIcon: Ionicons.ios_close,
              height: 45.0,
              radius: 50.0,
              fontSize: 15.0,
              txColor: Colors.white,
              bgColor: Colors.black45,
              text: 'Reject',
            ),
            ButtonWidget(
              onPress: () async {
                pageStatus = appBloc.orders[index]['orders']['status'];
                appBloc.orders[index]['orders']['status'] = "LOADING";
                appBloc.orders = appBloc.orders;
                if (await OrderActions().acreAction(
                    appBloc: appBloc,
                    status: "ACCEPTED",
                    orderId: appBloc.orders[index]['orders']['order_id'],
                    index: index)) {
                  AppActions().showSuccessToast(
                    text: 'Order Accepted',
                    context: context,
                  );
                  appBloc.orders[index]['orders']['status'] = "ACCEPTED";
                } else {
                  AppActions().showErrorToast(
                    text: appBloc.errorMsg,
                    context: context,
                  );
                }
                await CheckStatus().checkStatus(
                    pageStatus: pageStatus,
                    bloc: appBloc,
                    nextStatus: "ACCEPTED");
                appBloc.orders = appBloc.orders;
              },
              width: 120.0,
              height: 45.0,
              radius: 50.0,
              textIcon: Ionicons.ios_checkmark,
              fontSize: 15.0,
              txColor: Colors.white,
              bgColor: Colors.orange[300],
              text: 'Accept',
            ),
          ]),
        );
      case "ACCEPTED":
        return SizedBox();
        // ButtonWidget(
        //   onPress: () async {
        //     pageStatus = appBloc.orders[index]['orders']['status'];
        //     appBloc.orders[index]['orders']['status'] = "LOADING";
        //     appBloc.orders = appBloc.orders;
        //     if (await OrderActions().deliveryAction(
        //         appBloc: appBloc,
        //         status: "READY",
        //         orderId: appBloc.orders[index]['orders']['order_id'],
        //         index: index)) {
        //       AppActions().showSuccessToast(
        //         text: 'Order Ready for delivery',
        //         context: context,
        //       );
        //       appBloc.orders[index]['orders']['status'] = "READY";
        //     } else {
        //       AppActions().showErrorToast(
        //         text: appBloc.errorMsg,
        //         context: context,
        //       );
        //     }
        //     await CheckStatus().checkStatus(
        //         pageStatus: pageStatus, bloc: appBloc, nextStatus: "READY");
        //     appBloc.orders = appBloc.orders;
        //     // NextPage().nextRoute(
        //     //     context,
        //     //     Delivery(
        //     //       orIndex: index,
        //     //       pageStatus: appBloc.orders[index]['orders']['status'],
        //     //     ));
        //   },
        //   radius: 0.0,
        //   fontSize: 22.0,
        //   height: 50.0,
        //   txColor: Colors.white,
        //   bgColor: Color(PublicVar.primaryColor),
        //   text: 'Ready for delivery',
        // );
      case "REJECTED":
        return SizedBox();
      case "LOADING":
        return ButtonWidget(
          onPress: () {},
          radius: 0.0,
          height: 50.0,
          fontSize: 22.0,
          loading: true,
          txColor: Colors.white,
          bgColor: Color(PublicVar.primaryColor),
        );
      case "READY":
        return ButtonWidget(
          onPress: () async {
            pageStatus = appBloc.orders[index]['orders']['status'];
            appBloc.orders[index]['orders']['status'] = "LOADING";
            appBloc.orders = appBloc.orders;
            if (await OrderActions().deliveryAction(
                appBloc: appBloc,
                status: "IN_TRANSIT",
                orderId: appBloc.orders[index]['orders']['order_id'],
                index: index)) {
              AppActions().showSuccessToast(
                text: 'Order is on its way',
                context: context,
              );
              appBloc.orders[index]['orders']['status'] = "IN_TRANSIT";
            } else {
              AppActions().showErrorToast(
                text: appBloc.errorMsg,
                context: context,
              );
            }
            await CheckStatus().checkStatus(
                pageStatus: pageStatus, bloc: appBloc, nextStatus: "IN_TRANSIT");
            appBloc.orders = appBloc.orders;
          },
          radius: 0.0,
          fontSize: 22.0,
          height: 50.0,
          txColor: Colors.white,
          bgColor: Color(PublicVar.primaryColor),
          text: getTransitText(appBloc.orders[index]['delivery_type']),
        );
     case "IN_TRANSIT":
        return ButtonWidget(
          onPress: () async {
            AppActions().showAppDialog(context,
            title: getPopupTitle(appBloc.orders[index]['delivery_type']),
            descp: "Please get the confirmation code from your customer, and enter it below",
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal:8.0,vertical: 8.0),
              child: Container(
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    autofocus: false,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
                    validator: Validation().text,
                    controller: codeField,
                    maxLength: 6,
                    decoration: FormDecorator(
                         labelText:'Enter confirmation code' , helper: 'Please type only 6 digit code above', hint: "- - - -")),
              ),
            ), okAction: () {
          if (codeField.text.length == 6) {
            Navigator.pop(context);
            deliverOrder(code: int.parse(codeField.text),);
          } else {
            AppActions().showErrorToast(
                text: "Enter six digits only to confirm order",
                context: context);
          }
        }, okText: "Confirm", cancleText: "Cancel");
          },
          radius: 0.0,
          fontSize: 22.0,
          height: 50.0,
          txColor: Colors.white,
          bgColor: Color(PublicVar.primaryColor),
          text:getConfirmText(appBloc.orders[index]['delivery_type']),
        );
     case "CONFIRMED":
     case "DELIVERED":
     default:
      return ButtonWidget(
          radius: 0.0,
          height: 50.0,
          fontSize: 22.0,
          txColor:Colors.white,
          bgColor:Color(PublicVar.primaryColor),
          text: 'View Feedback',
        );
    }
  }

  getConfirmText(data){
    switch(data){
      case "SHIPPING_DELIVERY": return "Confirm Delivery";
      case "EAT_IN": return "Confirm Served";
      case "SELF_PICKUP": return "Confirm Pick Up";
    }
  }

  getPopupTitle(data){
    switch(data){
      case "SHIPPING_DELIVERY": return "Delivery Comfirmation";
      case "EAT_IN": return "Confirm Order Served";
      case "SELF_PICKUP": return "Pick Up Confirmation";
    }
  }

 getTransitText(data){
    switch(data){
      case "SHIPPING_DELIVERY": return "Start Delivery >>>";
      case "EAT_IN": return "Server Order";
      case "SELF_PICKUP": return "Set for Pick Up";
    }
  }

  getOrderStatus({bool p, a, r, i}) {
    return Row(
      children: [
        Expanded(
          child: statusContainer(status: p),
        ),
        Expanded(
          child: statusContainer(status: a),
        ),
        Expanded(
          child: statusContainer(status: r),
        ),
        Expanded(
          child: statusContainer(status: i),
        ),
      ],
    );
  }

  statusContainer({bool status}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            height: 5,
            width: 120,
            color: status ? Color(PublicVar.primaryColor) : Colors.black54),
      ),
    );
  }

  getLabelStatus(String status) {
    switch (status) {
      case "LOADING":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Loading...',style: TextStyle(color: Color(PublicVar.primaryColor)),)],);
      case "PENDING":
        return getOrderStatus(p: false, a: false, r: false, i: false);
      case "REJECTED":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Order Rejected ',style: TextStyle(color: Colors.red),),
           SizedBox(width: 10,),Icon(Ionicons.ios_close_circle,color: Colors.red,)],);
      case "ACCEPTED":
        return getOrderStatus(p: true, a: false, r: false, i: false);
      case "IN_PROGRESS":
        return getOrderStatus(p: true, a: false, r: false, i: false);
      case "READY":
        return getOrderStatus(p: true, a: true, r: false, i: false);
      case "IN_TRANSIT":
        return getOrderStatus(p: true, a: true, r: true, i: false);
      case "CONFIRMED":
        return  getOrderStatus(p: true, a: true, r: true, i: true);
      case "DELIVERED":
        return   getOrderStatus(p: true, a: true, r: true, i: true);
          default:return SizedBox();
    }
  }
 
  getTextStatus(String status) {
    switch (status) {
     
      case "PENDING":
        return textStatus(icon: Ionicons.ios_sync,text: "Waiting to accept order...");
      case "ACCEPTED":
        return  textStatus(icon: Ionicons.ios_hourglass,text: "Preparing Order...");
      case "IN_PROGRESS":
        return textStatus(icon: Ionicons.ios_hourglass,text: "Preparing Order...");
      case "READY":
        return textStatus(icon: Feather.shopping_bag,text: "Order is ready");
      case "IN_TRANSIT":
         if(appBloc.orders[index]['delivery_type']=="SHIPPING_DELIVERY"){
            return textStatus(icon: Ionicons.ios_bicycle,text: "Order is on its way");
          }else if(appBloc.orders[index]['delivery_type']=="EAT_IN"){
            return textStatus(icon: Icons.dinner_dining_rounded,text: "Order is ready");
          }else if(appBloc.orders[index]['delivery_type']=="SELF_PICKUP"){
            return textStatus(icon: Icons.shopping_bag_rounded,text: "Order is ready for Pick-Up");
          }
        break;
         case "CONFIRMED":
        if(appBloc.orders[index]['delivery_type']=="SHIPPING_DELIVERY"){
            return textStatus(icon: Ionicons.ios_bicycle,text: "Order has been delivered");
          }else if(appBloc.orders[index]['delivery_type']=="EAT_IN"){
            return textStatus(icon: Icons.dinner_dining_rounded,text: "Order is served");
          }else if(appBloc.orders[index]['delivery_type']=="SELF_PICKUP"){
            return textStatus(icon: Icons.shopping_bag_rounded,text: "Order has been picked up");
          }
        break;
         case "DELIVERED":
        if(appBloc.orders[index]['delivery_type']=="SHIPPING_DELIVERY"){
            return textStatus(icon: Ionicons.ios_checkmark_circle,text: "Order has been delivered");
          }else if(appBloc.orders[index]['delivery_type']=="EAT_IN"){
            return textStatus(icon: Icons.dinner_dining_rounded,text: "Order is served");
          }else if(appBloc.orders[index]['delivery_type']=="SELF_PICKUP"){
            return textStatus(icon: Icons.shopping_bag_rounded,text: "Order has been picked up");
          }
        break;
          default:return SizedBox();
    }
  }
 
  textStatus({text,icon}){
    return Padding(
          padding:  EdgeInsets.symmetric(horizontal:8.0),
          child: Row(
          children: [
            Text(text,
              style: TextStyle(
                  fontSize: 16,
              ),
            ),
            SizedBox(width: 10),
            Icon(icon,size: 16,)
          ],
        ),
                );
  }

  getContainer({child}) {
    return Material(
      elevation: 5.0,
      shadowColor: Color(PublicVar.primaryColor).withOpacity(0.1),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: child,
      ),
    );
  }

  orderSummaryTile(
      {title1, descp1, color1, title2, descp2, color2, bool hasSec1, hasSec2, sec1Bold}) {
    if (hasSec1 == null) hasSec1 = true;
    if (hasSec2 == null) hasSec2 = true;
    if (sec1Bold == null) sec1Bold = false;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          hasSec1
              ? Expanded(
                  child: Row(
                    children: [
                      Text(
                        title1 ?? "",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          descp1 ?? "",
                          style: TextStyle(
                              fontSize:sec1Bold?2.8 * deviceFont: 2.0 * deviceFont,
                              fontWeight: sec1Bold?FontWeight.w800:FontWeight.w600,
                              color: color1 ?? Colors.black),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          hasSec2
              ? Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        title2 ?? "",
                        style: TextStyle(fontSize: 13),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          descp2 ?? "",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: color2 ?? Colors.black),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }



getDishActionButton({status,dishIndex}){
  switch (status) {
    case "IN_PROGRESS": return ButtonWidget(
              onPress: () async {
                appBloc.orders[index]['orders']['dishes'][dishIndex]['status'] = "LOADING";
                appBloc.orders = appBloc.orders;
                Map dishData = {
                  "nokey": {"dish_order_id": appBloc.orders[index]['orders']['dishes'][dishIndex]['dish_order_id'], "status": "FINISHED"},
                  'token': PublicVar.getToken,
                };
                await Server().postAction(data: dishData, bloc: appBloc, url: Urls.dishStatus);
                appBloc.orders[index]['orders']['dishes'][dishIndex]['status'] = "FINISHED";
                appBloc.orders = appBloc.orders;
                //Check if all dish status is finished
                var finishedDishes=0;
                for (var j = 0;j < appBloc.orders[index]['orders']['dishes'].length;j++) {
                  if(appBloc.orders[index]['orders']['dishes'][j]['status']=="FINISHED"){
                    finishedDishes++;
                  }
                }

                if(finishedDishes==appBloc.orders[index]['orders']['dishes'].length){
                    pageStatus = appBloc.orders[index]['orders']['status'];
                    appBloc.orders[index]['orders']['status'] = "LOADING";
                    appBloc.orders = appBloc.orders;
                    if (await OrderActions().deliveryAction(
                        appBloc: appBloc,
                        status: "READY",
                        orderId: appBloc.orders[index]['orders']['order_id'],
                        index: index)) {
                      AppActions().showSuccessToast(
                        text: 'Order Ready for delivery',
                        context: context,
                      );
                      appBloc.orders[index]['orders']['status'] = "READY";
                    } else {
                      AppActions().showErrorToast(
                        text: appBloc.errorMsg,
                        context: context,
                      );
                    }
                }
                await CheckStatus().checkStatus(
                pageStatus: pageStatus, bloc: appBloc, nextStatus: "READY");
                 appBloc.orders = appBloc.orders;
              },
              width: double.infinity,
              textIcon: Icons.check_circle_rounded,
              height: 40.0,
              radius: 10.0,
              loading: appBloc.orders[index]['orders']['dishes'][dishIndex]['status'] == "LOADING",
              fontSize: 16.0,
              txColor: Colors.white,
              bgColor: Color(PublicVar.primaryColor),
              text: 'Set food ready',
            );
    default:return SizedBox();
  }
}
  
  getDishStatus({status}) {
    switch (status) {
      case "PENDING":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pending?',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: 5,
            ),
             Icon(
              Ionicons.ios_sync,
              size: 16,
              color: Colors.black,
            ),
          ],
        );
      case "IN_PROGRESS":
        return Row(
           mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Preparing..',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Ionicons.ios_hourglass,
              size: 16,
              color: Colors.black,
            ),
          ],
        );
      case "FINISHED":
        return Row(
           mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Dish Ready',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Ionicons.ios_checkmark_circle,
              size: 16,
              color: Colors.blue,
            ),
            
          ],
        );
      default:
        return SizedBox();
    }
  }

    getDeliveryCompanyInfo(company_id) async {
    if (await Server().getAction(
        appBloc: appBloc, url: Urls.getDeliveryCompany + "/$company_id")) {
      appBloc.orders[index]['delivery']['phones'] = appBloc.mapSuccess['phone'];
      hasCompanyData = true;
    }
  }

}
