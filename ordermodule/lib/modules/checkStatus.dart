
import 'package:providermodule/providermodule.dart';

class CheckStatus{
    checkStatus({pageStatus,nextStatus,AppBloc bloc})async{
    switch(pageStatus){
      case "PENDING":
      await relaodStatus(status: pageStatus,bloc: bloc);
      await relaodStatus(status: nextStatus,bloc: bloc);
     if(!PublicVar.onProduction) print('PEND___ORDERS==${bloc.orders}');
      //bloc.pendingOrders=bloc.orders;
      break;
      case "ACCEPTED":
      await relaodStatus(status: pageStatus,bloc: bloc);
      await relaodStatus(status: nextStatus,bloc: bloc);
     if(!PublicVar.onProduction) print('ACCEP___ORDERS==${bloc.orders}');
      //bloc.acceptedOrders=bloc.orders;
      break;
      case "READY":
      await relaodStatus(status: pageStatus,bloc: bloc);
      await relaodStatus(status: nextStatus,bloc: bloc);
      //bloc.readyOrders=bloc.orders;
      break;
      case "IN_TRANSIT":
      await relaodStatus(status: pageStatus,bloc: bloc);
      await relaodStatus(status: nextStatus,bloc: bloc);
      //bloc.inTransitOrders=bloc.orders;
      break;
      case "DELIVERED":
      await relaodStatus(status: pageStatus,bloc: bloc);
      await relaodStatus(status: nextStatus,bloc: bloc);
      //bloc.deliveredOrders=bloc.orders;
      break;
      case "CONFIRMED":
      await relaodStatus(status: pageStatus,bloc: bloc);
      await relaodStatus(status: nextStatus,bloc: bloc);
      //bloc.deliveredOrders=bloc.orders;
      break;
      case "REJECTED":
      await relaodStatus(status: pageStatus,bloc: bloc);
      await relaodStatus(status: nextStatus,bloc: bloc);
      //bloc.rejectedOrders=bloc.orders;
      break;
    }
  }

  relaodStatus({String status,AppBloc bloc})async{
  switch(status){
      case "PENDING":
       PublicVar.getOrderData['query']['status']="PENDING";
      await OrderServer()
          .getPendingOrders(appBloc: bloc, data: PublicVar.getOrderData);
          bloc.pendingOrders=bloc.pendingOrders;
        if(!PublicVar.onProduction)  print('PENDING Orders = ${bloc.pendingOrders}');
      break;
      case "ACCEPTED":
      PublicVar.getOrderData['query']['status']="ACCEPTED";
      await OrderServer()
          .getAcceptedOrders(appBloc: bloc, data: PublicVar.getOrderData);
          bloc.acceptedOrders=bloc.acceptedOrders;
         if(!PublicVar.onProduction)  print('ACCEPTED Orders = ${bloc.acceptedOrders}');
          break;
      case "READY":
      PublicVar.getOrderData['query']['status']="READY";
      await OrderServer()
          .getReadyOrders(appBloc: bloc, data: PublicVar.getOrderData);
           bloc.readyOrders=bloc.readyOrders;
          break;
      case "IN_TRANSIT":
       PublicVar.getOrderData['query']['status']="IN_TRANSIT";
      await OrderServer()
          .getIntransitOrders(appBloc: bloc, data: PublicVar.getOrderData);
           bloc.inTransitOrders=bloc.inTransitOrders;
      break;
      case "DELIVERED":
      PublicVar.getOrderData['query']['status']="DELIVERED";
      await OrderServer()
          .getDeliveredOrders(appBloc: bloc, data: PublicVar.getOrderData);
           bloc.deliveredOrders=bloc.deliveredOrders;
      break;
      case "CONFIRMED":
      PublicVar.getOrderData['query']['status']="CONFIRMED";
      await OrderServer()
          .getDeliveredOrders(appBloc: bloc, data: PublicVar.getOrderData);
           bloc.deliveredOrders=bloc.deliveredOrders;
      break;
      case "REJECTED":
      await OrderServer()
          .getRejectedOrders(appBloc: bloc, data: PublicVar.getOrderData);
           bloc.rejectedOrders=bloc.rejectedOrders;
      break;
    }
    await Server().queryKitchen(appBloc:bloc);
    
}

}