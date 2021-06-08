import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:meta/meta.dart';

abstract class BaseAuthRepository {
  Stream<auth.User> get user;
  Future<auth.User> signUpWithEmailAndPassword(
      {@required String username,@required String email,@required String password});
  Future<auth.User> loginWithEmailAndPasword({@required String email, @required String password});
  Future<void> logOut();
}
