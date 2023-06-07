import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:providermodule/providermodule.dart';
import 'package:reworkutils/rework_utils.dart';

class KitchenTime extends StatefulWidget {
  final  onlineTime;
  KitchenTime({Key key, this.onlineTime}) : super(key: key);
  @override
  _KitchenTimeState createState() => _KitchenTimeState();
}

class _KitchenTimeState extends State<KitchenTime>
    with SingleTickerProviderStateMixin<KitchenTime> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey(),
      _sheetScaffoldKey = new GlobalKey();
  TabController _tabController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false, showPassword = true, loading = false;

  AppBloc appBloc;
  String day, pm, am;
  final formPadding = EdgeInsets.symmetric(vertical: 7.0, horizontal: 10);
  File imageFile;
  final dayStyle = TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      titleStyle = TextStyle(color: Colors.grey, fontSize: 16),
      timeStyle = TextStyle(color: Colors.black, fontSize: 18);
  final border = Radius.circular(15);
  var dayMap={},days = ["monday","tuesday","wednesday","thursday","friday","saturday","sunday"];
  int index = 0;
  @override
  void initState() {
    dayMap= {
      "monday": {
        "checked": false,
        "data": [
          {
            'period1': 'am',
            'from': 00.00,
            'to': 00.00,
            'period2': 'am',
            'first': true
          },
        ]
      },
      "tuesday": {
        "checked": false,
        "data": [
          {
            'period1': 'am',
            'from': 00.00,
            'to': 00.00,
            'period2': 'am',
            'first': true
          },
        ]
      },
      "wednesday": {
        "checked": false,
        "data": [
          {
            'period1': 'am',
            'from': 00.00,
            'to': 00.00,
            'period2': 'am',
            'first': true
          },
        ]
      },
      "thursday": {
        "checked": false,
        "data": [
          {
            'period1': 'am',
            'from': 00.00,
            'to': 00.00,
            'period2': 'am',
            'first': true
          },
        ]
      },
      "friday": {
        "checked": false,
        "data": [
          {
            'period1': 'am',
            'from': 00.00,
            'to': 00.00,
            'period2': 'am',
            'first': true
          },
        ]
      },
      "saturday": {
        "checked": false,
        "data": [
          {
            'period1': 'am',
            'from': 00.00,
            'to': 00.00,
            'period2': 'am',
            'first': true
          },
        ]
      },
      "sunday": {
        "checked": false,
        "data": [
          {
            'period1': 'am',
            'from': 00.00,
            'to': 00.00,
            'period2': 'am',
            'first': true
          },
        ]
      },
    };
    if(!PublicVar.onProduction) print(widget.onlineTime);
    if(!PublicVar.onProduction) print("HOURS LENGTH>>>>>${widget.onlineTime}");

    if(PublicVar.accountApproved && widget.onlineTime.length>0){
      for(var day in dayMap.keys){
        if(!PublicVar.onProduction) print('We have the Key ${widget.onlineTime.containsKey(day)}');
        if(widget.onlineTime.containsKey(day)){
            //dayMap["$day"]["checked"]=true;
            dayMap["$day"]["data"]=getOnlineTime(times:widget.onlineTime[day]);
            dayMap["$day"]["checked"]=getOnlineTime(times:widget.onlineTime[day]).length>0?true:false;
           if(!PublicVar.onProduction)  print('Day checked is ${dayMap["$day"]}');
          }
      }
    }
    super.initState();
  }

getOnlineTime({List times}){
  var data=[];
  
 

  data.add({
            'period1': times[0]['period']??"am",
            'from': times[0]['time'].toString().replaceAll(":", ".")??00.00,
            'to': times[1]['time'].toString().replaceAll(":", ".")??00.00,
            'period2': times[1]['period']??"pm",
            'first': true
          });
    if(times.length>2){
       data.add({
            'period1': times[2]['period']??"am",
            'from': times[2]['time'].toString().replaceAll(":", ".")??00.00,
            'to': times[3]['time'].toString().replaceAll(":", ".")??00.00,
            'period2': times[3]['period']??"pm",
            'first': false
          });
    }
  return data;
}


  @override
  Widget build(BuildContext context) {
    appBloc = Provider.of<AppBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Feather.arrow_left,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Kitchen Working hours",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Please specify when your kitchen will be open/closed to take orders.",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            FormUI(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:8.0,vertical: 50),
              child: ButtonWidget(
        onPress: ()async {
          showLoading();
          if(await AppActions().checkInternetConnection()){
              setTime();
          }else{
               showLoading();
              AppActions().showErrorToast(text:PublicVar.checkInternet ,context: context,);
          }
        },
        width: double.infinity,
        height: 50.0,
        fontSize: 20.0,
        loading: loading,
        txColor: Colors.white,
        bgColor: Color(PublicVar.primaryColor),
        text: PublicVar.accountApproved ? 'Update Hours' : 'Save Hours',
      ),
            ),
            SizedBox( height: 500,),
          ],
        ),
      ),
     
    );
  }

  Widget FormUI() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, bottom: 100),
      child: ListView.separated(
        separatorBuilder: (ctxs, i) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
            child: Divider(),
          );
        },
        itemCount: days.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (ctx, i) {
          return ListTile(
              title: Text(CapitalizeText().capitalize('${days[i]}'),
                  style: dayStyle),
              leading: Checkbox(
                onChanged: (val) {
                  dayMap['${days[i]}']['checked'] = val;
                  setState(() {});
                },
                value: dayMap['${days[i]}']['checked'],
              ),
              subtitle: getDaySubTitle("${days[i]}"));
        },
      ),
    );
  }



  showAppDialog({day, index, side}) {
    if (side == 'to' && dayMap[day]['data'][index]['from']==0.0){
        AppActions().showErrorToast(
        text: 'Please select opening time',context: context,);
        }
        else{
    var periodGroup = "", i=index,
        drop1,
        drop2,
        hr = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12',
    ],
        min = [
      '00',
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '25',
      '26',
      '27',
      '28',
      '29',
      '30',
      '31',
      '32',
      '33',
      '34',
      '35',
      '36',
      '37',
      '38',
      '39',
      '40',
      '41',
      '42',
      '43',
      '44',
      '45',
      '46',
      '47',
      '48',
      '49',
      '50',
      '51',
      '52',
      '53',
      '54',
      '55',
      '56',
      '57',
      '58',
      '59'
    ];
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 50,
                    height: MediaQuery.of(context).size.height * 0.70,
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 38.0),
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: SingleChildScrollView(
                                                  child: Column(children: [
                            Text('Choose Time',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 10),
                              child: Row(children: <Widget>[
                                Text(
                                  'Time:',
                                  style: titleStyle,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: DropdownButton<String>(
                                      hint: Text('hr'),
                                      value: drop1,
                                      style: timeStyle,
                                      items: hr.map((String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          drop1 = val;
                                        });
                                      }),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 2),
                                  child: Text(
                                    ':',
                                    style: titleStyle,
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButton<String>(
                                    hint: Text('min'),
                                    value: drop2,
                                    style: timeStyle,
                                    items: min.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        drop2 = val;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 15),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Period:',
                                    style: titleStyle,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'AM',
                                          style: timeStyle,
                                        ),
                                        Radio(
                                            value: "am",
                                            groupValue: periodGroup,
                                            onChanged: (val) {
                                              setState(() {
                                                periodGroup = val;
                                              });
                                            })
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Text('PM', style: timeStyle),
                                        Radio(
                                            value: "pm",
                                            groupValue: periodGroup,
                                            onChanged: (val) {
                                              setState(() {
                                                periodGroup = val;
                                              });
                                            })
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1.2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                     var result = '$drop1.$drop2';
                                    if (drop1 == null) {
                                      AppActions().showErrorToast(
                                          text: 'Please select hour',context: context,);
                                    } else if (drop2 == null) {
                                      AppActions().showErrorToast(
                                          text: 'Please select minute',context: context,);
                                    }else if (periodGroup == '') {
                                      AppActions().showErrorToast(
                                          text: 'Please select period (am or pm)',context: context,);
                                    } else if(side == 'to' && dayMap[day]['data'][i]['period1'] == periodGroup && double.parse(dayMap[day]['data'][i]['from']) > double.parse(result)){
                                        AppActions().showErrorToast(context:context,text:"Time error. Your opening time does not tally with you closing time");
                                    }else if(side == 'from' && dayMap[day]['data'][i]['period2'] == periodGroup && dayMap[day]['data'][i]['to']!= 0.0 && double.parse(dayMap[day]['data'][i]['to']) < double.parse(result)){
                                        AppActions().showErrorToast(context:context,text:"Time error. Your opening time does not tally with you closing time");
                                    }else {
                                      assignTime(
                                          i: i,
                                          result: double.parse(result).toStringAsFixed(2),
                                          side: side,
                                          day: day,
                                          periodGroup: periodGroup);
                                        }
                                  },
                                  child: Text(
                                    'Set Time',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          ]),
                        ),
                      ),
                    )),
                  ),
                ),
              );
            },
          );
        });
  }
  }

  assignTime({i, side, periodGroup, result, day}) {
    switch (i) {
      case 0:
        if (side == 'from') {
          dayMap[day]['data'][i]['from'] = result;
          dayMap[day]['data'][i]['period1'] = periodGroup;
        } else if (side == 'to') {
          dayMap[day]['data'][i]['to'] = result;
          dayMap[day]['data'][i]['period2'] = periodGroup;
        }
        break;
      case 1:
        if (side == 'from') {
          dayMap[day]['data'][i]['from'] = result;
          dayMap[day]['data'][i]['period1'] = periodGroup;
        } else if (side == 'to') {
          dayMap[day]['data'][i]['to'] = result;
          dayMap[day]['data'][i]['period2'] = periodGroup;
        }
        break;
    }
    Navigator.pop(context);
    if(dayMap[day]['data'][i]['from']!=0.0 && dayMap[day]['data'][i]['to']!=0.0){
      dayMap[day]['checked']=true;
      if(day=="monday"){
      AppActions().showAppDialog(
        context,
        title: 'Set all days of the week?',
        descp:'Do you want to use this time set through out the week',
        okText: "Yes",
        cancleText: "Cancel",
        danger:false,
        cancleAction: () => Navigator.pop(context),
        okAction: () async {
          dayMap= {
          "monday": {
            "checked": true,
            "data": [
              {
                'period1': dayMap[day]['data'][i]['period1'],
                'from': dayMap[day]['data'][i]['from'],
                'to': dayMap[day]['data'][i]['to'],
                'period2': dayMap[day]['data'][i]['period2'],
                'first': true
              },
            ]
          },
          "tuesday": {
            "checked": true,
            "data": [
              {
                'period1': dayMap[day]['data'][i]['period1'],
                'from': dayMap[day]['data'][i]['from'],
                'to': dayMap[day]['data'][i]['to'],
                'period2': dayMap[day]['data'][i]['period2'],
                'first': true
              },
            ]
          },
          "wednesday": {
            "checked": true,
            "data": [
              {
                'period1': dayMap[day]['data'][i]['period1'],
                'from': dayMap[day]['data'][i]['from'],
                'to': dayMap[day]['data'][i]['to'],
                'period2': dayMap[day]['data'][i]['period2'],
                'first': true
              },
            ]
          },
          "thursday": {
            "checked": true,
            "data": [
              {
                'period1': dayMap[day]['data'][i]['period1'],
                'from': dayMap[day]['data'][i]['from'],
                'to': dayMap[day]['data'][i]['to'],
                'period2': dayMap[day]['data'][i]['period2'],
                'first': true
              },
            ]
          },
          "friday": {
            "checked": true,
            "data": [
              {
                'period1': dayMap[day]['data'][i]['period1'],
                'from': dayMap[day]['data'][i]['from'],
                'to': dayMap[day]['data'][i]['to'],
                'period2': dayMap[day]['data'][i]['period2'],
                'first': true
              },
            ]
          },
          "saturday": {
            "checked": true,
            "data": [
              {
                'period1': dayMap[day]['data'][i]['period1'],
                'from': dayMap[day]['data'][i]['from'],
                'to': dayMap[day]['data'][i]['to'],
                'period2': dayMap[day]['data'][i]['period2'],
                'first': true
              },
            ]
          },
          "sunday": {
        "checked": true,
        "data": [
          {
            'period1': dayMap[day]['data'][i]['period1'],
            'from': dayMap[day]['data'][i]['from'],
            'to': dayMap[day]['data'][i]['to'],
            'period2': dayMap[day]['data'][i]['period2'],
            'first': true
          },
        ]
      },
    };
          setState(() {});
         Navigator.pop(context);
        });
    }
    }
    setState(() {});
  }
   
  getDaySubTitle(day) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: List.generate(dayMap[day]['data'].length, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: <Widget>[
                timingLisTile(
                    tapFrom: () =>showAppDialog(day: day, index: i, side: 'from'),
                    tapTo: () => showAppDialog(day: day, index: i, side: 'to'),
                    fromData:
                        '${dayMap[day]['data'][i]['from']} ${dayMap[day]['data'][i]['period1']}',
                    toData:
                        '${dayMap[day]['data'][i]['to']} ${dayMap[day]['data'][i]['period2']}',
                    first: dayMap[day]['data'][i]['first'],
                    remove: () {
                      dayMap[day]['data'].removeAt(i);
                      setState(() {});
                    }),
                SizedBox(
                  height: 10,
                ),
                dayMap[day]['data'].length > 1
                    ? SizedBox()
                    : InkWell(
                        onTap: () {
                          dayMap[day]['data'].add({
                            'period1': 'am',
                            'from': 00.00,
                            'to': 00.00,
                            'period2': 'pm',
                            'first': false
                          });
                          setState(() {});
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.add),
                            Text('Add additional hours')
                          ],
                        ),
                      )
              ],
            ),
          );
        }),
      ),
    );
  }

  timingLisTile({tapFrom, tapTo, fromData, toData, first, remove}) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      first
          ? SizedBox()
          : IconButton(icon: Icon(Icons.close), onPressed: remove),
      InkWell(
        onTap: tapFrom,
        child: Column(children: [
          Text(
            'Open',
            style: titleStyle,
          ),
          SizedBox(
            height: 5,
          ),
          Text(fromData, style: timeStyle)
        ]),
      ),
      SizedBox(
        width: 60,
      ),
      InkWell(
        onTap: tapTo,
        child: Column(children: [
          Text(
            'Close',
            style: titleStyle,
          ),
          SizedBox(
            height: 5,
          ),
          Text(toData, style: timeStyle)
        ]),
      )
    ]);
  }

  getDayData({List times, String day}) {
    var data = [];
    for (var i = 0; i < times.length; i++) {
      if (times[i]["from"] == 0.0) {
        AppActions()
            .showErrorToast(text: "Please specify your opening time on $day",context: context,);
      } else if (times[i]["to"] == 0.0) {
        AppActions()
            .showErrorToast(text: "Please specify your closing time on $day",context: context,);
      }
      if (times[i]["from"] != 0.0 && times[i]["to"] != 0.0) {
        data.add({"period": times[i]["period1"], "time": times[i]["from"]});
        data.add({"period": times[i]["period2"], "time": times[i]["to"]});
      }
    }
    return data;
  }

  setTime()async {
    var setDayTime = {},errorDey=[];
    for (var day in days) {
      
      if (dayMap[day]['checked'] &&
          getDayData(times: dayMap[day]['data'], day: day).length > 0) {
        setDayTime.addAll({day: getDayData(times: dayMap[day]['data'], day: day)});
      }else if(dayMap[day]['checked'] && getDayData(times: dayMap[day]['data'], day: day).length == 0){
        errorDey.add('e-dey');
      }
    }

    if(errorDey.isEmpty){
      var data={"nokey":setDayTime,"token":PublicVar.getToken};
      if(await Server().putAction(bloc:appBloc,data:data,url:'${Urls.getKitchens}${PublicVar.kitchenID}/openings')){
        finish();
      }else{
        AppActions().showErrorToast(text:appBloc.errorMsg,context: context,);
      }
    }
    if(setDayTime.isEmpty){
      AppActions().showErrorToast(text:"Please select a day to do business",context: context,);
    }
   if(!PublicVar.onProduction)  print('Enter ');
    showLoading();
  }

    finish() async {
    showLoading();
    await Server().queryKitchen(appBloc: appBloc);
    appBloc.kitchenDetails = appBloc.kitchenDetails;
    await SharedStore().setData(type: 'bool', data: true, key: 'kitchenHasHours');
    PublicVar.kitchenHasHours = true;
    AppActions().showSuccessToast(text: 'Business hours updated',context: context,);
    Navigator.pop(context);
  }

  showLoading() {
    if (loading) {
      loading = false;
    } else {
      loading = true;
    }
   if(mounted) setState(() {});
  }

 
}
