import 'dart:async';
import 'dart:convert';
import 'package:providermodule/modules/models/PublicVar.dart';
import 'package:reworkutils/rework_utils.dart';

class PageWatch {
  Timer timer;
  setCurrentScreen(
      {String user_id,
      kitchen_id,
      kitchenName,
      name,
      email,
      page,
     Map timeSpent,
      List actions,
       }) async {
    try {
      Map data = {
        "user_id": user_id,
        "name": name,
        "email": email,
        "kitchen_id": kitchen_id,
        "kitchenName": kitchenName,
        "page": page,
        "actions": actions,
        "page_time": timeSpent
      };
      PublicVar.appWatch['kitchen_data'].add(data);
      print("PAGE WATCH: ${PublicVar.appWatch}");
      await SharedStore().setData(
          type: 'string', key: 'appWatch', data: PublicVar.appWatch.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map> getPageWatch() async {
    try {
      String data = await SharedStore().getData(
        type: 'string',
        key: 'appWatch',
      );
      return jsonDecode(data.trim());
    } catch (e) {
      print(e.toString());
      return {"error": e.toString()};
    }
  }
}
