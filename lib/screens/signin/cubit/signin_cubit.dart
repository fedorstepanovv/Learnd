import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnd/models/models.dart';
import 'package:learnd/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepository _authRepository;
  SigninCubit({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SigninState.initial());
  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SigninStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SigninStatus.initial));
  }

  Future<void> signInWithCredentials() async {
    if (!state.isFormValid || state.status == SigninStatus.submitting) return;
    try {
      await _authRepository.loginWithEmailAndPasword(
          email: state.email, password: state.password);
      emit(state.copyWith(status: SigninStatus.success));
    } on Failure catch (e) {
      emit(state.copyWith(status: SigninStatus.error, failure: e));
    }
  }
}
