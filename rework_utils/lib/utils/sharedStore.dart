import 'package:shared_preferences/shared_preferences.dart';
class SharedStore{

  getData({type,key})async{
    var data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch(type){
      case 'bool':data= prefs.getBool(key);break;
      case 'string':data= prefs.getString(key);break;
      case 'int':data= prefs.getInt(key);break;
      case 'double':data= prefs.getDouble(key);break;
    }
    return data;

  }

  setData({type,key,data})async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch(type){
      case 'bool':prefs.setBool(key,data);break;
      case 'string': prefs.setString(key,data);break;
      case 'int':prefs.setInt(key,data);break;
      case 'double':prefs.setDouble(key,data);break;
    }
  }

  removeData({key})async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}