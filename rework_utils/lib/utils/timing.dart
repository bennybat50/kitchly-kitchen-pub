class Timing{

  String getTime(int time_span){

    int index = 0;
    int time_value = 0;

    String metric = "";
    String metric_value = "";

    final List<int> epoch = [0,60,3600,86400,604800,2419200,29030400];
    final List<String> unit = [' s',' min',' hr',' d',' wk',' mon',' yr'];

    for(int time in epoch){

      if( time_span >= epoch[epoch.length - 1]){
        time_value = time_span ~/ epoch[epoch.length - 1];
        metric = unit[epoch.length - 1];
        metric_value =  "$time_value$metric";
        return metric_value;
      }

      if( time_span >= time && time_span <= ( epoch[index + 1] - 1 ) ){
        time_value = index == 0 ? time_span : time_span ~/ time;
        metric = unit[index];
        metric_value =  "$time_value$metric";
        return metric_value;
      }
      index++;
    }
    return null;
  }

  String duration(int date_time){
   if(date_time!=null){
     int now = new DateTime.now().millisecondsSinceEpoch;
     int moment = now - date_time;
     int micro_second = int.parse((moment ~/ 1000).toString());
     return this.getTime(micro_second);
   }else{
     return null;
   }
  }

}