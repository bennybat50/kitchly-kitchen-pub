import 'package:kitchlykitchendb/database/dbModel/kitchen.dart';
import 'package:kitchlykitchendb/database/providers/dbProvider.dart';

abstract class KitchenRepository {
  DatabaseProvider databaseProvider;

  Future<Kitchen> insert(Kitchen kitchen);

  Future<Kitchen> update(Kitchen kitchen);

  Future<Kitchen> deleteData(Kitchen kitchen);

  Future deleteAll();

  Future<Kitchen> getData(int id);

  Future<List<Kitchen>> getAll();
}