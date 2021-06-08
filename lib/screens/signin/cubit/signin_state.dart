part of 'signin_cubit.dart';

enum SigninStatus { initial, submitting, success, error }

class SigninState extends Equatable {
  final String email;
  final String password;
  final SigninStatus status;
  final Failure failure;
  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  const SigninState({
    @required this.email,
    @required this.password,
    @required this.status,
    @required this.failure,
  });
  factory SigninState.initial() {
    return SigninState(
      email: '',
      password: '',
      status: SigninStatus.initial,
      failure: Failure()
    );
  }


  @override
  List<Object> get props => [email,password,status,failure];

  SigninState copyWith({
    String email,
    String password,
    SigninStatus status,
    Failure failure,
  }) {
    return SigninState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
