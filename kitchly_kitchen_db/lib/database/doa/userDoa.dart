import 'package:kitchlykitchendb/database/dbModel/user.dart';
import '../doa.dart';

class UserDoa implements Dao<User> {

  final tableName = 'users',
      columnId = 'id',
      _columnFname = 'firstName',
      _columnLName = 'lastName',
      _columnToken = 'token',
      _columnKitchlyID = 'userKitchlyID',
      _columnEmail = 'email',
      _columnPhone = 'phone',
      _columnKitchenId = 'kitchenId',
      _columnPassword = 'password';
  @override
  // TODO: implement createTableQuery
  String get createTableQuery =>  "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY,"
      " $_columnFname TEXT,$_columnLName TEXT,$_columnToken TEXT,$_columnKitchlyID TEXT,$_columnEmail TEXT,$_columnPhone TEXT,$_columnKitchenId TEXT,"
      " $_columnPassword TEXT)";

  @override
  List<User> fromList(List<Map<String, dynamic>> query) {
    List<User> users = List<User>();
    for (Map map in query) {
      users.add(fromMap(map));
    }
    return users;
  }


  @override
  User fromMap(Map<String, dynamic> query) {
    User user = User();
    user.id = query[columnId];
    user.firstName = query[_columnFname];
    user.lastName = query[_columnLName];
    user.token = query[_columnToken];
    user.email = query[_columnEmail];
    user.phone = query[_columnPhone];
    user.password = query[_columnPassword];
    user.kitchenId = query[_columnKitchenId];
    user.userKitchlyID = query[_columnKitchlyID];
    return user;
  }

  @override
  Map<String, dynamic> toMap(User object) {
    return <String, dynamic>{
      _columnFname: object.firstName,
      _columnLName: object.lastName,
      _columnToken: object.token,
      _columnEmail: object.email,
      _columnPhone: object.phone,
      _columnPassword: object.password,
      _columnKitchenId:object.kitchenId,
      _columnKitchlyID: object.userKitchlyID
    };
  }
}