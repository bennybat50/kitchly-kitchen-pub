import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ordermodule/ordermodule.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

class Delivery extends StatefulWidget {
  final orIndex, pageStatus;
  const Delivery({Key key, this.orIndex, this.pageStatus}) : super(key: key);
  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var code = TextEditingController();
  String currentText;
  String confirmCode;
  bool checkConfirm = false, _autoValidate = false;
  final titleStyle =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16);
  var orIndex, pageStatus;
  AppBloc appBloc;
  @override
  void initState() {
    orIndex = widget.orIndex;
    code.addListener(getCodeCount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        titleSpacing: 0,
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
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          CircleImage(
            size: 25,
            url: PublicVar.kitchenImageUrl,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                '${appBloc.orders[orIndex]['user']['first_name']} ${appBloc.orders[orIndex]['user']['last_name']}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ]),
        actions: <Widget>[
          appBloc.orders[orIndex]['orders']['status'] == "IN_TRANSIT"
              ? TextButton(
                  child: Text(
                    'Confirm Delivery',
                    style: TextStyle(color: Color(PublicVar.primaryColor)),
                  ),
                  onPressed: () async {
                    pageStatus = appBloc.orders[orIndex]['orders']['status'];
                    appBloc.orders[orIndex]['orders']['status'] = "LOADING";
                    appBloc.orders = appBloc.orders;
                    if (await OrderActions().deliveryAction(
                      appBloc: appBloc,
                      status: "CONFIRMED",
                      orderId: appBloc.orders[orIndex]['orders']['order_id'],
                      index: orIndex,
                    )) {
                      AppActions().showSuccessToast(
                        text: 'Order delivered successfully!',
                        context: context,
                      );
                      appBloc.orders[orIndex]['orders']['status'] = "DELIVERED";
                    } else {
                      AppActions().showErrorToast(
                        text: appBloc.errorMsg,
                        context: context,
                      );
                    }
                    await CheckStatus().checkStatus(
                        pageStatus: pageStatus,
                        bloc: appBloc,
                        nextStatus: "DELIVERED");
                    appBloc.orders = appBloc.orders;
                  },
                )
              : SizedBox(),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Center(
                  child: Text(
                    'Delivery Status ',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              getStatus(status: appBloc.orders[orIndex]['orders']['status'])
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          getBottom(status: appBloc.orders[orIndex]['orders']['status']),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        child: Material(
          borderRadius: BorderRadius.circular(100),
          color: Colors.black,
          elevation: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: 40,
              width: 160,
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Ionicons.ios_arrow_back,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 1,
                      ),
                      Text(
                        'Back to orders',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getBottom({status}) {
    switch (status) {
      // case "DELIVERED":
      //   return Container(
      //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: <Widget>[
      //         ButtonWidget(
      //           onPress: () {},
      //           width: 120.0,
      //           height: 40.0,
      //           txColor: Colors.white,
      //           textIcon: Icons.receipt,
      //           bgColor: Color(PublicVar.primaryColor),
      //           text: 'Invoice',
      //         ),
      //         SizedBox(
      //           width: 20,
      //         ),
      //         ButtonWidget(
      //           onPress: () {},
      //           width: 120.0,
      //           height: 40.0,
      //           txColor: Colors.white,
      //           textIcon: Icons.star,
      //           bgColor: Color(PublicVar.primaryColor),
      //           text: 'Reviews',
      //         )
      //       ],
      //     ),
      //   );
      default:
        return SizedBox();
    }
  }

  getStatus({status}) {
    switch (status) {
      case "IN_TRANSIT":
        return getView(
            color1: Colors.green,
            color2: Colors.grey,
            color3: Colors.grey,
            onTap: () => confirm(),
            step1: true,
            step2: false,
            step3: false);
      case "DELIVERED":
        return getView(
            color1: Colors.green,
            color2: Colors.green,
            color3: Colors.green,
            onTap: () => deliver(),
            step1: true,
            step2: true,
            step3: true);
      default:
        return getView(
            color1: Colors.grey,
            color2: Colors.grey,
            color3: Colors.grey,
            onTap: () => inTransit(),
            step1: false,
            step2: false,
            step3: false);
    }
  }

  getView({color1, color2, color3, onTap, bool step1, step2, step3}) {
    return Column(
      children: <Widget>[
        ListTile(
            onTap: onTap,
            leading: Icon(
              Ionicons.ios_bicycle,
              size: 30,
              color: color1,
            ),
            title: Text(
              'On the way..',
              style: titleStyle,
            ),
            trailing: IconButton(
                icon: Icon(
                  step1 ? Feather.check_circle : Feather.circle,
                  color: color1,
                  size: 18,
                ),
                onPressed: onTap),
            subtitle: Wrap(
              children: <Widget>[
                Icon(
                  Feather.clock,
                  size: 14,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '09:10 AM, 10 April 2020',
                  style: TextStyle(fontSize: 12),
                )
              ],
            )),
        Container(
            height: 60,
            width: 4,
            child: VerticalDivider(
              color: color1,
            )),
        checkConfirm
            ? InkWell(
                onTap: onTap,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Ionicons.ios_home,
                      color: color2,
                    ),
                    Expanded(
                      child: Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Confirm Delivery',
                                style: titleStyle,
                              ),
                              Container(
                                width: 230,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 5.0),
                                  child: Text(
                                    'Ask your customer for order confirmation code and enter it here',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black87),
                                  ),
                                ),
                              ),
                              Container(
                                width: 150,
                                child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    autofocus: false,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w900),
                                    validator: Validation().text,
                                    controller: code,
                                    maxLength: 6,
                                    onSaved: (String val) {
                                      confirmCode = val;
                                    },
                                    decoration: FormDecorator(
                                        labelText: 'Enter verification code',
                                        helper: 'Enter verification code',
                                        hint: "- - - -")),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          step2 ? Feather.check_circle : Feather.circle,
                          color: color2,
                          size: 18,
                        ),
                        onPressed: onTap)
                  ],
                ),
              )
            : ListTile(
                onTap: onTap,
                leading: Icon(
                  Feather.check,
                  color: color2,
                ),
                title: Text(
                  'Confirm Delivery',
                  style: titleStyle,
                ),
                trailing: IconButton(
                    icon: Icon(
                      step2 ? Feather.check_circle : Feather.circle,
                      color: color2,
                      size: 18,
                    ),
                    onPressed: onTap),
                subtitle: Wrap(
                  children: <Widget>[
                    Icon(
                      Feather.clock,
                      size: 14,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '09:20 AM, 10 April 2020',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                )),
        Container(
            height: 60,
            width: 4,
            child: VerticalDivider(
              color: color2,
            )),
        ListTile(
            leading: Icon(
              Feather.shopping_bag,
              color: color3,
            ),
            title: Text(
              'Delivered',
              style: titleStyle,
            ),
            trailing: IconButton(
                icon: Icon(
                  step3 ? Feather.check_circle : Feather.circle,
                  color: color3,
                  size: 18,
                ),
                onPressed: onTap),
            subtitle: Wrap(
              children: <Widget>[
                Icon(
                  Feather.clock,
                  size: 14,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '09:30 AM, 10 April 2020',
                  style: TextStyle(fontSize: 12),
                )
              ],
            )),
      ],
    );
  }

  inTransit() async {
    pageStatus = appBloc.orders[orIndex]['orders']['status'];
    appBloc.orders[orIndex]['orders']['status'] = "LOADING";
    appBloc.orders = appBloc.orders;
    if (await OrderActions().deliveryAction(
        appBloc: appBloc,
        status: "IN_TRANSIT",
        orderId: appBloc.orders[orIndex]['orders']['order_id'],
        index: orIndex)) {
      AppActions().showSuccessToast(
        text: 'Order is on its way',
        context: context,
      );
      appBloc.orders[orIndex]['orders']['status'] = "IN_TRANSIT";
    } else {
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
    await CheckStatus().checkStatus(
        pageStatus: pageStatus, bloc: appBloc, nextStatus: "IN_TRANSIT");
    appBloc.orders = appBloc.orders;
    setState(() {});
  }

  confirm() {
    setState(() => checkConfirm = true);
  }

  getCodeCount() {
    setState(() {
      if (code.text.length == 6) {
        deliver(code: int.parse(code.text));
      }
    });
  }

  deliver({int code}) async {
    pageStatus = appBloc.orders[orIndex]['orders']['status'];
    appBloc.orders[orIndex]['orders']['status'] = "LOADING";
    appBloc.orders = appBloc.orders;
    if (await OrderActions().deliveryAction(
        appBloc: appBloc,
        status: "DELIVERED",
        orderId: appBloc.orders[orIndex]['orders']['order_id'],
        index: orIndex,
        confirmCode: code)) {
      await Server().queryKitchen(appBloc: appBloc);
      AppActions().showSuccessToast(
        text: 'Order delivered successfully!',
        context: context,
      );
      appBloc.orders[orIndex]['orders']['status'] = "DELIVERED";
    } else {
      AppActions().showErrorToast(
        text: appBloc.errorMsg,
        context: context,
      );
    }
    await CheckStatus().checkStatus(
        pageStatus: pageStatus, bloc: appBloc, nextStatus: "DELIVERED");
    appBloc.orders = appBloc.orders;
    setState(() {});
  }
}
