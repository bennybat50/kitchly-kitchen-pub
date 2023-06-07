import 'dart:io';
import 'dart:async';
import 'dart:convert' show json,utf8;
import 'package:http/http.dart' as http;

class PubRequest{

  HttpClient httpClient;
  
  PubRequest(){
    httpClient = HttpClient();
  }

   getDataType(data) {
    var has = false;
    if (data.runtimeType.toString() ==
        "_InternalLinkedHashMap<String, dynamic>") {
      has = true;
    }
    return has;
  }

  get({ String url,Map headers, Function callback}){
    http.get(Uri.parse(url),headers:headers)
    .then((_){
      callback(json.decode(_.body));
    }).catchError((_){
      callback(_);
    });
  }

  deleteUrl({ String url,Map headers, Function callback}){
    http.delete(Uri.parse(url),headers:headers)
        .then((_){
      callback(json.decode(_.body));
    }).catchError((_){
      callback(_);
    });
  }

  Future getRoute(String url,{Map headers}) async{
    var result = await http.get(Uri.parse(url),headers: headers,);
    return json.decode(result.body);
  }

  Future deleteRoute(String url,{Map headers}) async{
    var result = await http.delete(Uri.parse(url),headers: headers,);
    return json.decode(result.body);
  }

  post(String url,Map map,Function callback) async{
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    var reply,token;
    if(map['token']!=null){
      token = map['token'];
      map.remove('token');
      reply = await operation(request:request,map:map,token:token);
    }else{
       reply = await operation(request:request,map:map);
    }
    callback(reply);
  }
  
  put(String url,Map map,Function callback) async{
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(url));
    var reply ,token;
    if(map['token']!=null){
      token =map['token'];
      map.remove('token');
      reply = await operation(request:request,map:map,token:token);
    }else{
      reply = await operation(request:request,map:map);
    }
    callback(reply);
  }

  delete(String url,Map map,Function callback) async{
    HttpClientRequest request = await httpClient.deleteUrl(Uri.parse(url));
    var reply ,token;
    if(map['token']!=null){
      token =map['token'];
      map.remove('token');
      reply = await operation(request:request,map:map,token:token);
    }else{
      reply = await operation(request:request,map:map);
    }
    callback(reply);
  }

  operation({HttpClientRequest request,Map map, String token}) async{
    try{
        var data;
        if(map['nokey']!=null){
          data= utf8.encode(json.encode(map['nokey']));
        }else{
          data= utf8.encode(json.encode(map));
        }
        
        request.headers.set("content-type", 'application/json');
        if(token!=null){
          request.headers.set("Authorization",'token ' +token);
        }
        request.add(data);
        HttpClientResponse response;
        response = await request.close().timeout(Duration(seconds: 30));
        
        String reply = await response.transform(utf8.decoder).join();
        return json.decode(reply);
    }catch(e){
      print('Operation error=> ${e.toString()}');
      Map error={"error":"${e.toString()}"};
      return error;
    }
  }
}