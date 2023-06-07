import 'package:providermodule/modules/utils/gettime.dart';

class SortOrder{
   sortDataDecending(data){
    for (var i = data.length - 1; i >= 0; i--) {
    for (var j = i; j >= 0; j--) {
      if (data[i]['orders']['countdown_date'] < data[j]['orders']['countdown_date']) {
        var t = data[i];
        data[i] = data[j];
        data[j] = t;
      }
    }
  }
  return data;
  }

  sortDate(data){
  for (var i = 0; i < data.length; i++) {
    var date = data[i]['orders']['order_sent_date'];

    data[i]['orders']['countdown_date'] = date;
    data[i]['orders']['total_duration'] = getTotalDuration(data[i]['orders']['dishes']);
    // if(GetTime().getCountDown(time:newDate, choice:TimeChoice.distance) < 0){
    //   data[i]['orders']['countdown_date'] = 10;
    // }else{
    // }
  }
  return data;
}

getTotalDuration(data){
  int amount = 0;
    for (var j = 0; j < data.length; j++) {
      amount = int.parse(data[j]['duration'].toString()) + amount;
    }
    return amount;
}
}