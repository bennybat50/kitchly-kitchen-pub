import 'package:providermodule/modules/models/PublicVar.dart';
import 'package:providermodule/modules/models/data.dart';
import 'package:providermodule/modules/models/urls.dart';
import 'app_bloc.dart';
import 'server.dart';
import 'sort_order.dart';

class OrderServer {
  
//ORDERS SERVERS

Future<Map>  getAllOrders({AppBloc appBloc})async{
    Map gotResponse={"pending":"false","accepted":"false","ready":"false","in_transit":"false","delivered":"false","rejected":"false",};
     Map pending = {
      "query": {"kitchen_id": PublicVar.kitchenID, "status": "PENDING"},
      "page": 1,
      "limit": 100,
      "token": PublicVar.getToken
    };
    
    Map accepted = {
      "query": {"kitchen_id": PublicVar.kitchenID, "status": "ACCEPTED"},
      "page": 1,
      "limit": 100,
      "token": PublicVar.getToken
    };
    Map in_transit = {
      "query": {"kitchen_id": PublicVar.kitchenID, "status": "IN_TRANSIT"},
      "page": 1,
      "limit": 100,
      "token": PublicVar.getToken
    };
    Map ready = {
      "query": {"kitchen_id": PublicVar.kitchenID, "status": "READY"},
      "page": 1,
      "limit": 100,
      "token": PublicVar.getToken
    };
    Map rejected = {
      "query": {"kitchen_id": PublicVar.kitchenID, "status": "REJECTED"},
      "page": 1,
      "limit": 100,
      "token": PublicVar.getToken
    };
    Map delivered = {
      "query": {"kitchen_id": PublicVar.kitchenID, "status": "DELIVERED"},
      "page": 1,
      "limit": 100,
      "token": PublicVar.getToken
    };

     var responses = await Future.wait([
      Server().multiPostAction(data: pending,url:  Urls.getKitchenOrders,),
      Server().multiPostAction(data: accepted,url:  Urls.getKitchenOrders,),
      Server().multiPostAction(data: ready,url:  Urls.getKitchenOrders,),
      Server().multiPostAction(data: in_transit,url:  Urls.getKitchenOrders,),
      Server().multiPostAction(data: delivered,url:  Urls.getKitchenOrders,),
      Server().multiPostAction(data: rejected,url:  Urls.getKitchenOrders,),
    ]);

    for (var i = 0; i < responses.length; i++) {
      switch (i) {
        case 0:
        if(responses[i]['error']==null){
          appBloc.hasPendingOrder = true;
          appBloc.pendingOrders= SortOrder().sortDataDecending(SortOrder().sortDate(responses[i]['data']));
          gotResponse['pending']='true';
        }
          break;
        case 1:
         if(responses[i]['error']==null){
            appBloc.hasAcceptedOrder = true;
          appBloc.acceptedOrders=SortOrder().sortDataDecending(SortOrder().sortDate(responses[i]['data']));
          gotResponse['accepted']='true';
         }
          break;
        case 2:
        if(responses[i]['error']==null){
          appBloc.hasReadyOrder = true;
          appBloc.readyOrders=SortOrder().sortDataDecending(SortOrder().sortDate(responses[i]['data']));
          gotResponse['ready']='true';
        }
          break;
        case 3:
        if(responses[i]['error']==null){
          appBloc.hasIntransitOrders = true;
          appBloc.inTransitOrders=SortOrder().sortDataDecending(SortOrder().sortDate(responses[i]['data']));
          gotResponse['in_transit']='true';
        }
          break;
        case 4:
          if(responses[i]['error']==null){
            appBloc.hasDeliveredOrder = true;
          appBloc.deliveredOrders=SortOrder().sortDataDecending(SortOrder().sortDate(responses[i]['data']));
          gotResponse['delivered']='true';
          } 
          break;
        case 5:
          if(responses[i]['error']==null){
            appBloc.hasRejectedOrder = true;
          appBloc.rejectedOrders=SortOrder().sortDataDecending(SortOrder().sortDate(responses[i]['data']));
          gotResponse['rejected']='true';
          }
          break;
      }
    }
    if(!PublicVar.onProduction) print(gotResponse);
    return gotResponse;
  }

    Future getPendingOrders({AppBloc appBloc, data}) async {
    String gotResponse;
   if (await Server().postAction(
          bloc: appBloc, url: Urls.getKitchenOrders, data: data)) {
        appBloc.pendingOrders = SortOrder().sortDataDecending(SortOrder().sortDate(appBloc.mapSuccess['data'])); 
        gotResponse = 'true';
        appBloc.hasPendingOrder = true;
      } else {
        gotResponse = 'false';
        appBloc.hasPendingOrder = false;
      }
    return gotResponse;
  }
  Future getAcceptedOrders({AppBloc appBloc, data}) async {
    String gotResponse;
    if (await Server().postAction(
          bloc: appBloc, url: Urls.getKitchenOrders, data: data)) {
        appBloc.acceptedOrders = SortOrder().sortDataDecending(SortOrder().sortDate(appBloc.mapSuccess['data']));
        gotResponse = 'true';
        appBloc.hasAcceptedOrder = true;
      } else {
        gotResponse = 'false';
        appBloc.hasAcceptedOrder = false;
      }
    return gotResponse;
  }
  Future getRejectedOrders({AppBloc appBloc, data}) async {
    String gotResponse;
     if (await Server().postAction(
          bloc: appBloc, url: Urls.getKitchenOrders, data: data)) {
        appBloc.rejectedOrders = SortOrder().sortDataDecending(SortOrder().sortDate(appBloc.mapSuccess['data']));
        gotResponse = 'true';
        appBloc.hasRejectedOrder = true;
      } else {
        gotResponse = 'false';
        appBloc.hasRejectedOrder = false;
      }
    return gotResponse;
  }
  Future getReadyOrders({AppBloc appBloc, data}) async {
    String gotResponse;
    if (await Server().postAction(
          bloc: appBloc, url: Urls.getKitchenOrders, data: data)) {
        appBloc.readyOrders = SortOrder().sortDataDecending(SortOrder().sortDate(appBloc.mapSuccess['data']));
        gotResponse = 'true';
        appBloc.hasReadyOrder = true;
      } else {
        gotResponse = 'false';
        appBloc.hasReadyOrder = false;
      }
    return gotResponse;
  }

  Future getDeliveredOrders({AppBloc appBloc, data}) async {
    String gotResponse;
    if (await Server().postAction(
          bloc: appBloc, url: Urls.getKitchenOrders, data: data)) {
        appBloc.deliveredOrders = SortOrder().sortDataDecending(SortOrder().sortDate(appBloc.mapSuccess['data']));
        gotResponse = 'true';
        appBloc.hasDeliveredOrder = true;
      } else {
        gotResponse = 'false';
        appBloc.hasDeliveredOrder = false;
      }
    return gotResponse;
  }
   Future getIntransitOrders({AppBloc appBloc, data}) async {
    String gotResponse;
    if (await Server().postAction(
          bloc: appBloc, url: Urls.getKitchenOrders, data: data)) {
        appBloc.inTransitOrders = SortOrder().sortDataDecending(SortOrder().sortDate(appBloc.mapSuccess['data']));
        gotResponse = 'true';
        appBloc.hasIntransitOrders= true;
      } else {
        gotResponse = 'false';
        appBloc.hasIntransitOrders = false;
      }
    return gotResponse;
  }

 

  
//END ORDERS SERVER
}