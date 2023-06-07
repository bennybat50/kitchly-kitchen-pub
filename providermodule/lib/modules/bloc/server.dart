import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:providermodule/modules/models/PublicVar.dart';
import 'package:providermodule/modules/models/error.dart';
import 'package:providermodule/modules/models/urls.dart';
import 'package:reworkutils/rework_utils.dart';

import 'app_bloc.dart';

class Server {
  PubRequest _request = PubRequest();

  Future getMeals({
    AppBloc appBloc,
  }) async {
    if (await getAction(appBloc: appBloc, url: Urls.getMeals)) {
      appBloc.meals = appBloc.mapSuccess['meals'];
      appBloc.meals.sort((a, b) {
        return a['name']
            .toString()
            .toLowerCase()
            .compareTo(b['name'].toString().toLowerCase());
      });
      return 'true';
    } else {
      if (!PublicVar.onProduction) print('get Meals');
      return 'false';
    }
  }

  Future getDurations({
    AppBloc appBloc,
  }) async {
    if (await getAction(appBloc: appBloc, url: Urls.getDishDuration)) {
      appBloc.dishDuration = appBloc.mapSuccess;
    } else {
      if (!PublicVar.onProduction) print('get Meals');
    }
  }

  Future<String> getOptions({AppBloc appBloc, var data}) async {
    String gotResponse;
    if (await postAction(bloc: appBloc, url: Urls.getOptions, data: data)) {
      appBloc.options = appBloc.mapSuccess['options'];
      gotResponse = 'true';
    } else {
      gotResponse = 'false';
    }
    return gotResponse;
  }

  Future<bool> getKitchen({AppBloc appBloc, var data}) async {
    bool gotResponse;
    if (await postAction(bloc: appBloc, url: Urls.kitchenDetails, data: data)) {
      appBloc.kitchenDetails = appBloc.mapSuccess;
      gotResponse = true;
    } else {
      gotResponse = false;
    }
    return gotResponse;
  }

  Future<String> getExtras({AppBloc appBloc, var data}) async {
    String gotResponse;
    if (await postAction(bloc: appBloc, url: Urls.getExtras, data: data)) {
      if (!PublicVar.onProduction)
        print('Extrasr map success =====${appBloc.mapSuccess}');
      appBloc.extras = appBloc.mapSuccess;
      if (appBloc.extras.length > 0) {
        if (!PublicVar.hasExtra) {
          PublicVar.hasExtra = true;
          await SharedStore()
              .setData(type: 'bool', key: 'firstExtra', data: true);
        }
        appBloc.hasExtras = true;
        gotResponse = 'true';
      } else {
        appBloc.hasExtras = true;
        gotResponse = 'empty';
      }
      await getOptions(appBloc: appBloc, data: data['query']);
    } else {
      gotResponse = 'false';
    }
    return gotResponse;
  }

  Future<String> getDishes({AppBloc appBloc, var data}) async {
    String gotResponse;
    if (await postAction(bloc: appBloc, url: Urls.getDishes, data: data)) {
      var res = appBloc.mapSuccess;
      if (res['dishes'].length > 0) {
        setDishData(appBloc: appBloc, data: res);
        gotResponse = 'true';
      } else {
        appBloc.hasDish = false;
        gotResponse = 'empty';
      }
    } else {
      appBloc.hasDish = false;
      gotResponse = 'false';
    }
    return gotResponse;
  }

  Future<String> getPackages({AppBloc appBloc, var data}) async {
    String gotResponse;
    if (await postAction(bloc: appBloc, url: Urls.getPackages, data: data)) {
      var res = appBloc.mapSuccess;
      if (res['dishes'].length > 0) {
        setPackageData(appBloc: appBloc, data: res);
        gotResponse = 'true';
      } else {
        appBloc.hasPackages = false;
        gotResponse = 'empty';
      }
    } else {
      appBloc.hasPackages = false;
      gotResponse = 'false';
    }
    return gotResponse;
  }

  setDishData({AppBloc appBloc, data}) async {
    appBloc.dish = data['dishes'];
    appBloc.country = data['currency'];
    PublicVar.kitchenCountry = data['currency'];
    appBloc.categories = data['dishes'];
    PublicVar.hasMenu = true;
    await SharedStore().setData(type: 'bool', key: 'firstMenu', data: true);
    PublicVar.hasCategory = true;
    await SharedStore().setData(type: 'bool', key: 'firstCategory', data: true);
    appBloc.hasCategory = true;
    appBloc.selectedCategoryId = '${appBloc.dish[0]['id']}';
    appBloc.selectedCategory = appBloc.dish[0]['dishes'];
    appBloc.selectedCategoryIndex = 0;
    appBloc.hasDish = true;
    PublicVar.hasDish = true;
    await SharedStore().setData(type: 'bool', key: 'firstDish', data: true);
  }

  setPackageData({AppBloc appBloc, data}) async {
    appBloc.packages = data['dishes'];
    appBloc.hasPackages = true;
    PublicVar.hasPackages = true;
    await SharedStore().setData(type: 'bool', key: 'firstPackage', data: true);
  }

  uploadImg<bool>({AppBloc appBloc, url, Map data}) async {
    try {
      List fields = data.keys.toList();
      List files = data.values.toList();
      var request = http.MultipartRequest("PUT", Uri.parse(url));
      for (var i = 0; i < fields.length; i++) {
        var pic = await http.MultipartFile.fromPath(
          fields[i],
          files[i].path,
        );
        request.files.add(pic);
      }
      var response = await request.send();
      var responseData =
          await response.stream.toBytes().timeout(Duration(seconds: 30));
      var responseString = String.fromCharCodes(responseData);
      if (!PublicVar.onProduction) print(responseString);
      return true;
    } catch (e) {
      appBloc.errorMsg = e.toString();
      if (!PublicVar.onProduction) print('Upload error ${e.toString()}');
      return false;
    }
  }

  Future<bool> postAction({AppBloc bloc, String url, var data}) async {
    bool sent;
    try {
      await _request.post(url, data, (res) {
        if (getDataType(res) &&
            Error().getStatus(status: res["type"]) == true) {
          bloc.errorMsg = res["msg"];
          sent = false;
        } else {
          bloc.mapSuccess = res;
          sent = true;
        }
      }).timeout(Duration(seconds: 15));
    } catch (e) {
      if (!PublicVar.onProduction)
        print('===========>>Post error ${e.toString()} url$url');
      bloc.errorMsg = PublicVar.serverError;
      sent = false;
    }
    return sent;
  }

  Future multiPostAction({String url, var data}) async {
    var response;
    try {
      await _request.post(url, data, (res) {
        response = res;
      });
    } catch (e) {
      if (!PublicVar.onProduction) print('Post error ${e.toString()} url:');
      response = {"error": "${e.toString()}"};
    }
    return response;
  }

  Future<bool> putAction({AppBloc bloc, String url, var data}) async {
    bool sent = false;
    try {
      await _request.put(url, data, (res) {
        // if(!PublicVar.onProduction) print(res);
        if (getDataType(res) && Error().getStatus(status: res["type"])) {
          sent = false;
          bloc.errorMsg = res["msg"];
        } else {
          sent = true;
        }
      }).timeout(Duration(seconds: 15));
    } catch (e) {
      if (!PublicVar.onProduction)
        print('=========>>Put error ${e.toString()}');
      bloc.errorMsg = PublicVar.serverError;
      sent = false;
    }

    return sent;
  }

  Future<bool> deleteAction({AppBloc bloc, String url, var data}) async {
    bool sent = false;
    try {
      await _request.delete(url, data, (res) {
        if (getDataType(res) && Error().getStatus(status: res["type"])) {
          sent = false;
          bloc.errorMsg = res["msg"];
        } else {
          if (!PublicVar.onProduction) print('=========>>delete Success $res');
          sent = true;
        }
      }).timeout(Duration(seconds: 15));
    } catch (e) {
      if (!PublicVar.onProduction)
        print('=========>>delete error ${e.toString()}');
      bloc.errorMsg = PublicVar.serverError;
      sent = false;
    }
    return sent;
  }

  getDataType(data) {
    var has = false;
    if (data.runtimeType.toString() ==
        "_InternalLinkedHashMap<String, dynamic>") {
      has = true;
    }
    return has;
  }

  Future<bool> getAction({AppBloc appBloc, String url}) async {
    bool sent = false;
    try {
      var data = await _request.getRoute(url).timeout(Duration(seconds: 15));
      if (data != null) {
        appBloc.mapSuccess = data;
        sent = true;
      } else {
        sent = false;
      }
    } catch (e) {
      if (!PublicVar.onProduction) print('get error ${e.toString()}');
      appBloc.errorMsg = PublicVar.serverError;
      sent = false;
    }
    return sent;
  }

  queryKitchen({AppBloc appBloc}) async {
    bool hasKitchen = false;
    Map map = {
      "id": PublicVar.kitchenID,
      'token': PublicVar.getToken,
    };
    if (await Server().getKitchen(appBloc: appBloc, data: map)) {
      await SharedStore().setData(
          type: 'string',
          key: 'cachedKitchen',
          data: jsonEncode(appBloc.mapSuccess));
      setKitchenData(appBloc: appBloc, res: appBloc.mapSuccess);
      hasKitchen = true;
    } else if (await SharedStore()
            .getData(type: 'string', key: 'cachedKitchen') !=
        null) {
      setKitchenData(
          appBloc: appBloc,
          res: json.decode(await SharedStore()
              .getData(type: 'string', key: 'cachedKitchen')));
    }
    if (await Server().postAction(
        bloc: appBloc,
        url: Urls.getKitchensSummary,
        data: PublicVar.queryKitchenNoKey)) {
      if (appBloc.mapSuccess.toString().contains('total_received')) {
        var response = {
          "total_received": appBloc.mapSuccess['total_received'],
          "total_delivered": appBloc.mapSuccess['total_delivered'],
          "total_earning": appBloc.mapSuccess['total_earning'],
          "amount_oweing": appBloc.mapSuccess['amount_oweing'],
          "currency": appBloc.mapSuccess['currency']
        };
        setKitchenSummary(appBloc: appBloc, res: response);
        await SharedStore().setData(
            type: 'string', key: 'cachedSummary', data: jsonEncode(response));
      }
    } else if (await SharedStore()
            .getData(type: 'string', key: 'cachedSummary') !=
        null) {
      setKitchenSummary(
          appBloc: appBloc,
          res: json.decode(await SharedStore()
              .getData(type: 'string', key: 'cachedSummary')));
    }
    appBloc.kitchenDetails = appBloc.kitchenDetails;
    return hasKitchen;
  }

  setKitchenSummary({AppBloc appBloc, res}) {
    appBloc.kitchenDetails['total_received'] = res['total_received'];
    appBloc.kitchenDetails['total_delivered'] = res['total_delivered'];
    appBloc.kitchenDetails['total_earning'] = res['total_earning'];
    appBloc.kitchenDetails['amount_oweing'] = res['amount_oweing'];
    appBloc.kitchenDetails['currency'] = res['currency'];
  }

  setKitchenData({AppBloc appBloc, res}) {
    appBloc.kitchenDetails['username'] = res['username'];
    appBloc.kitchenDetails['caption'] = res['caption'];
    appBloc.kitchenDetails['email'] = res['email'];
    appBloc.kitchenDetails['phone'] = res['phone'];
    appBloc.kitchenDetails['profile'] = res['profile'];
    PublicVar.kitchenVideoUrl = appBloc.kitchenDetails['kitchen_video'];
    appBloc.kitchenDetails['addr'] = res['addr'];
    appBloc.kitchenDetails['opened_for_order'] = res['opened_for_order'];
    appBloc.kitchenDetails['openings'] = res['openings'];
    var data = [];
    if (appBloc.kitchenDetails['views'].isNotEmpty) {
      if (!PublicVar.onProduction) print('Inserting views');
      if (!PublicVar.onProduction) print(appBloc.kitchenDetails['views']);
      data.add(appBloc.kitchenDetails['views']['1']);
      data.add(appBloc.kitchenDetails['views']['2']);
      data.add(appBloc.kitchenDetails['views']['3']);
      data.add(appBloc.kitchenDetails['views']['4']);
    }
    PublicVar.kitchenViews = data;
  }
}
