import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnd/config/paths.dart';
import 'package:learnd/exceptions/exceptions.dart';
import 'package:learnd/models/user.dart';
import 'package:learnd/repositories/user/base_user_repository.dart';
import 'package:meta/meta.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserWithId({@required String userId}) async {
    final doc =
        await _firebaseFirestore.collection(Paths.users).doc(userId).get();
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }

  @override
  Future<void> updateUser({@required User user}) async {
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(user.id)
        .update(user.toDocument());
  }

  @override
  Future<void> decrementCoins({@required String userId}) async {
    return _firebaseFirestore
        .collection(Paths.users)
        .doc(userId)
        .update({'coins': FieldValue.increment(-2)});
  }

  @override
  Future<void> incrementCoins({@required String userId}) {
    return _firebaseFirestore
        .collection(Paths.users)
        .doc(userId)
        .update({'coins': FieldValue.increment(2)});
  }

  @override
  Future<int> getBalance({String userId}) async {
    final userDoc =
        await _firebaseFirestore.collection(Paths.users).doc(userId).get();
    final balance = userDoc.data()['coins'];
    return balance;
  }
}
