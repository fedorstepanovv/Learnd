import 'package:learnd/models/models.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({String userId});
  Future<void> updateUser({User user});
  Future<void> incrementCoins({String userId});
  Future<void> decrementCoins({String userId});
  Future<int> getBalance({String userId});

}
