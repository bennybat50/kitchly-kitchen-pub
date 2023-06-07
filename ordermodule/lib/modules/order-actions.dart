import 'package:providermodule/providermodule.dart';

class OrderActions {
  Future acreAction({
    AppBloc appBloc,
    String status,
    orderId,
    index,
  }) async {
    Map data = {
      "nokey": {"order_id": orderId,},
      'token': PublicVar.getToken,
    };
    switch (status) {
      case 'ACCEPTED':
        for (var j = 0;j < appBloc.orders[index]['orders']['dishes'].length;j++) {
          Map dishData = {
            "nokey": { "dish_order_id": appBloc.orders[index]['orders']['dishes'][j]['dish_order_id'],"status": "IN_PROGRESS"},
            'token': PublicVar.getToken,
          };
          await Server().postAction(data: dishData, bloc: appBloc, url: Urls.dishStatus);
          appBloc.orders[index]['orders']['dishes'][j]['status'] = "IN_PROGRESS";
        }
        //return true;
        return Server() .postAction(data: data, bloc: appBloc, url: Urls.acceptOrders);

      case 'REJECTED':
        //return true;
        return Server() .postAction(data: data, bloc: appBloc, url: Urls.rejectOrders);
    }
  }

  Future deliveryAction(
      {AppBloc appBloc, String status, orderId, index, int confirmCode}) async {
        
    Map deliveryData = {
      "nokey": status == "DELIVERED"
          ? { "order_id": orderId,"code": confirmCode,}
          : {"order_id": orderId,},
      'token': PublicVar.getToken,
    };
   if(!PublicVar.onProduction) print(deliveryData);
    switch (status) {
      case 'READY':
        //return true;
        return Server().postAction( data: deliveryData, bloc: appBloc, url: Urls.orderReady);
      case 'IN_TRANSIT':
        //return true;
        return Server().postAction( data: deliveryData, bloc: appBloc, url: Urls.orderIntransit);
      case 'CONFIRMED':
        //return true;
        return Server().postAction(data: deliveryData, bloc: appBloc, url: Urls.orderConfirmed);
      case 'DELIVERED':
        //return true;
        return Server().postAction( data: deliveryData, bloc: appBloc, url: Urls.orderDelivery);
    }
  }
}
