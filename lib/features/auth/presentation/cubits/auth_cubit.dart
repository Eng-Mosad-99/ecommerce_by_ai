import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/auth_repo.dart';
import '../../../../core/utils/secure_storage.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await _authRepo.login(email, password);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (response) async {
        if (response.token != null) {
          await SecureStorage.saveToken(response.token!);
        }
        emit(AuthSuccess(user: response.user));
      },
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(AuthLoading());
    final result = await _authRepo.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (response) async {
        if (response.token != null) {
          await SecureStorage.saveToken(response.token!);
        }
        emit(AuthSuccess(user: response.user));
      },
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    final result = await _authRepo.forgotPassword(email);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(PasswordResetCodeSent()),
    );
  }

  Future<void> verifyCode(String code) async {
    emit(AuthLoading());
    final result = await _authRepo.verifyCode(code);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(PasswordResetCodeVerified()),
    );
  }

  Future<void> resetPassword(String email, String newPassword) async {
    emit(AuthLoading());
    final result = await _authRepo.resetPassword(email, newPassword);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (token) async {
        await SecureStorage.saveToken(token);
        emit(PasswordResetSuccess());
      },
    );
  }
}
