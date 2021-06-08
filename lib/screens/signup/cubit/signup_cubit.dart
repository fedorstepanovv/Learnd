import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnd/models/models.dart';
import 'package:learnd/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  SignupCubit(
      {@required AuthRepository authRepository, UserRepository userRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());
  void userNameChanged(String value) {
    emit(state.copyWith(username: value, status: SignupStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(status: SignupStatus.initial, password: value));
  }

  Future<void> signupWithCredentials() async {
    //check if the form is valid, if not stop our func
    if (!state.isFormValid || state.status == SignupStatus.submitting) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      await _authRepository.signUpWithEmailAndPassword(
          username: state.username,
          email: state.email,
          password: state.password);
      emit(state.copyWith(status: SignupStatus.success));
    } on Failure catch (e) {
      emit(state.copyWith(failure: e, status: SignupStatus.error));
    }
  }
}
