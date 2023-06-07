
import 'package:kitchlykitchendb/database/dbModel/user.dart';
import 'package:kitchlykitchendb/database/providers/dbProvider.dart';

abstract class UserRepository {
  DatabaseProvider databaseProvider;

  Future<User> insert(User user);

  Future<User> update(User user);

  Future<User> deleteData(User user);

  Future deleteAll();

  Future<User> getData(int id);

  Future<List<User>> getAll();
}