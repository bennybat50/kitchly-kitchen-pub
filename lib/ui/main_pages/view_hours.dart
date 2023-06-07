import 'package:flutter/material.dart';
class ViewHours extends StatelessWidget {
  Map hours;
   ViewHours({Key key, this.hours}) : super(key: key);
final dayStyle = TextStyle(
          color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
      titleStyle = TextStyle(color: Colors.grey, fontSize: 14),
      timeStyle = TextStyle(color: Colors.black, fontSize: 15);
  var days = [{"day":"Monday","value":"monday"},{"day":"Tuesday","value":"tuesday"},{"day":"Wednesday","value":"wednesday"},{"day":"Thursday","value":"thursday"},
  {"day":"Friday","value":"friday"},{"day":"Saturday","value":"saturday"},{"day":"Sunday","value":"sunday"}];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(child: Column(children: [
        Text('Show when you are open or\nclosed for business',textAlign: TextAlign.center,),
        ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: days.length,itemBuilder: (cxt,i){
          return ListTile(title: Text("${days[i]['day']}",style: dayStyle,), subtitle: checkHours(day:days[i]['value'],times: hours[days[i]['value']]),);
        })
      ],)),
    );
  }

  checkHours({day, times}){
    if(hours.containsKey(day)){
      return getDaySubTitle(getOnlineTime(times:times));
    }else{
    return Text('We Are Closed',style: TextStyle(color:Colors.redAccent, fontSize:16),);
    }
  }


  getOnlineTime({List times}){
  var data=[];
  data.add({
            'period1': times[0]['period']??"",
            'from': times[0]['time']??"",
            'to': times[1]['time']??"",
            'period2': times[1]['period']??"",
            'first': true
          });
    if(times.length>2){
       data.add({
            'period1': times[2]['period']??"",
            'from': times[2]['time']??"",
            'to': times[3]['time']??"",
            'period2': times[3]['period']??"",
            'first': false
          });
    }
  return data;
}

  getDaySubTitle(List data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: List.generate(data.length, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: <Widget>[
                timingLisTile(fromData:'${data[i]['from']} ${data[i]['period1']}',toData:'${data[i]['to']} ${data[i]['period2']}',),
                SizedBox(
                  height: 2,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  timingLisTile({fromData, toData,}) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Expanded(
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
        width: 5,
      ),
      Expanded(
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

}