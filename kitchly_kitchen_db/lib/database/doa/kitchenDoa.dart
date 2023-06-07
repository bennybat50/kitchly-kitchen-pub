import 'package:kitchlykitchendb/database/dbModel/kitchen.dart';
import '../doa.dart';

class KitchenDoa implements Dao<Kitchen>{
  final tableName = 'kitchen',
      columnId = 'id',
      _columnKitchenName= 'kitchenName',
      _columnKitchenId = 'kitchenId',
      _columnUsername = 'username',
      _columnCaption = 'caption',
      _columnTime = 'time',
      _columnCountry = 'country',
      _columnCity = 'city',
      _columnDistrict = 'district',
      _columnLandmark = 'landmark',
      _columnAddress = 'address',
      _columnOnlineTourLink = 'onlineTourLink',
      _columnOfflineTourPath = 'offlineTourPath',
      _columnProfileImgLink = 'profileImgLink',
      _columnProfileImgPath = 'profileImgPath';


  @override
  // TODO: implement createTableQuery
  String get createTableQuery => "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY,$_columnKitchenId TEXT,"
      " $_columnKitchenName TEXT,$_columnUsername TEXT,$_columnCaption TEXT,$_columnTime TEXT,$_columnCountry TEXT,$_columnCity TEXT, $_columnDistrict TEXT,$_columnLandmark TEXT,$_columnAddress TEXT,"
      " $_columnOnlineTourLink TEXT,$_columnOfflineTourPath TEXT,$_columnProfileImgLink TEXT,$_columnProfileImgPath TEXT)";

  @override
  List<Kitchen> fromList(List<Map<String,dynamic >> query) {
    List<Kitchen> kitchen = List<Kitchen>();
    for (Map map in query) {
      kitchen.add(fromMap(map));
    }
    return kitchen;
  }

  @override
  Kitchen fromMap(Map<String,dynamic > query) {
    Kitchen kitchen = Kitchen();
    kitchen.id = query[columnId];
    kitchen.kitchenId = query[_columnKitchenId];
    kitchen.kitchenName = query[_columnKitchenName];
    kitchen.username = query[_columnUsername];
    kitchen.caption = query[_columnCaption];
    kitchen.time = query[_columnTime];
    kitchen.country = query[_columnCountry];
    kitchen.city = query[_columnCity];
    kitchen.district = query[_columnDistrict];
    kitchen.landmark = query[_columnLandmark];
    kitchen.address = query[_columnAddress];
    kitchen.onlineTourLink = query[_columnOnlineTourLink];
    kitchen.offlineTourPath = query[_columnOfflineTourPath];
    kitchen.profileImgLink = query[_columnProfileImgLink];
    kitchen.profileImgPath = query[_columnProfileImgPath];
    return kitchen;
  }

  @override
  Map<String,dynamic > toMap(Kitchen object) {
    return  <String, dynamic>{
      _columnKitchenId: object.kitchenId,
      _columnKitchenName: object.kitchenName,
      _columnUsername: object.username,
      _columnCaption: object.caption,
      _columnTime:object.time,
      _columnCountry: object.country,
      _columnCity: object.city,
      _columnDistrict:object.district,
      _columnLandmark: object.landmark,
      _columnAddress:object.address,
      _columnOnlineTourLink:object.onlineTourLink,
      _columnOfflineTourPath:object.offlineTourPath,
      _columnProfileImgLink:object.profileImgLink,
      _columnProfileImgPath:object.profileImgPath
    };
  }

}