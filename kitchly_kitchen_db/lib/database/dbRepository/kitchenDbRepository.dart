import 'package:kitchlykitchendb/database/dbModel/kitchen.dart';
import 'package:kitchlykitchendb/database/doa/kitchenDoa.dart';
import 'package:kitchlykitchendb/database/providers/dbProvider.dart';
import 'package:kitchlykitchendb/database/repository/KitchenRepository.dart';

class KitchenDb implements KitchenRepository{
  final dao = KitchenDoa();
  @override
  DatabaseProvider databaseProvider;
  KitchenDb({this.databaseProvider});

  @override
  Future deleteAll() async{
    final db = await databaseProvider.db();
    return await db.delete(dao.tableName);
  }

  @override
  Future<Kitchen> deleteData(Kitchen kitchen) async{
    final db = await databaseProvider.db();
    await db.delete(dao.tableName,
        where: dao.columnId + " = ?", whereArgs: [kitchen.id]);
    return kitchen;
  }

  @override
  Future<List<Kitchen>> getAll() async{
    final db = await databaseProvider.db();
    List<Map> maps = await db.query(dao.tableName);
    return dao.fromList(maps);
  }

  @override
  Future<Kitchen> getData(int id)async {
    var dbClient = await  databaseProvider.db();
    var result = await dbClient
        .rawQuery("SELECT * FROM ${dao.tableName} WHERE ${dao.columnId} = $id");
    if (result.length == 0) return null;
    return new KitchenDoa().fromMap(result.first);
  }

  @override
  Future<Kitchen> insert(Kitchen kitchen)async {
    final db = await databaseProvider.db();
    kitchen.id = await db.insert(dao.tableName, dao.toMap(kitchen));
    return kitchen;
  }

  @override
  Future<Kitchen> update(Kitchen kitchen) async{
    final db = await databaseProvider.db();
    await db.update(dao.tableName, dao.toMap(kitchen),
        where: dao.columnId + " = ?", whereArgs: [kitchen.id]);
    return kitchen;
  }

}