part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final auth.User user;
  final AuthStatus status;
  const AuthState({this.user,this.status});
  factory AuthState.unknown() => const AuthState();
  factory AuthState.authenticated({@required auth.User user}) {
    return AuthState(user: user,status: AuthStatus.authenticated);
  }
  factory AuthState.unauthenticated({auth.User user}) {
    return AuthState(status: AuthStatus.unauthenticated);
  }
  @override
  List<Object> get props => [user, status];
}

