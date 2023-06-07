
import 'package:kitchlykitchendb/database/dbModel/user.dart';
import 'package:kitchlykitchendb/database/doa/userDoa.dart';
import 'package:kitchlykitchendb/database/providers/dbProvider.dart';
import 'package:kitchlykitchendb/database/repository/UserRepository.dart';

class UsersDb implements UserRepository {
  final dao = UserDoa();

  @override
  DatabaseProvider databaseProvider;

  UsersDb({this.databaseProvider});

  @override
  Future<User> insert(User user) async {
    final db = await databaseProvider.db();
    user.id = await db.insert(dao.tableName, dao.toMap(user));
    return user;
  }

  @override
  Future<User> deleteData(User user) async {
    final db = await databaseProvider.db();
    await db.delete(dao.tableName,
        where: dao.columnId + " = ?", whereArgs: [user.id]);
    return user;
  }

  @override
  Future<User> update(User user) async {
    final db = await databaseProvider.db();
    await db.update(dao.tableName, dao.toMap(user),
        where: dao.columnId + " = ?", whereArgs: [user.id]);
    return user;
  }



  @override
  Future<List<User>> getAll() async {
    final db = await databaseProvider.db();
    List<Map> maps = await db.query(dao.tableName);
    return dao.fromList(maps);
  }

  @override
  Future<User> getData(int id) async {
    var dbClient = await  databaseProvider.db();
    var result = await dbClient
        .rawQuery("SELECT * FROM ${dao.tableName} WHERE ${dao.columnId} = $id");
    if (result.length == 0) return null;
    return new UserDoa().fromMap(result.first);
  }

  @override
  Future deleteAll()async {
    final db = await databaseProvider.db();
    return await db.delete(dao.tableName);
  }






}