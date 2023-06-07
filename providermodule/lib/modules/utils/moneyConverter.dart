import 'package:intl/intl.dart';

class MoneyConverter {
 
final oCcy = NumberFormat("#,##0.00", "en_US");
  convertN({number,symbol}) {
    if (number != null && number != '') {
      number = double.parse(number.toString());
      var data = NumberFormat.currency(customPattern: "#,##0.00", symbol: '',  ).format(number);
      if(symbol=="₦"){
        data="N$data";
      }
     return data;
    } else {
      return "0.00";
    }
  }

    convertNumber({number}) {
    if (number != null && number != '') {
      number = double.parse(number.toString());
      var data = NumberFormat.currency(customPattern: "#,##0.00", symbol: '',  ).format(number);
     return data;
    } else {
      return "0";
    }
  }


   getCount({n}){
    if(n.toString().length <=6){
      return 35.0;
    }
    if(n.toString().length <=9){
      return 30.0;
    }
    if(n.toString().length <=12){
      return 25.0;
    }
    if(n.toString().length <=15){
      return 20.0;
    }
    if(n.toString().length <=18){
      return 18.0;
    }
    if(n.toString().length <=21){
      return 16.0;
    }
    if(n.toString().length > 24){
      return 12.0;
    }
  }
}
