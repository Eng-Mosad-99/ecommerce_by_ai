import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/auth_repo.dart';
import '../../../../core/utils/secure_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo;

  AuthBloc(this._authRepo) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<VerifyCodeEvent>(_onVerifyCode);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepo.login(event.email, event.password);
    await result.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (response) async {
        if (response.token != null) {
          await SecureStorage.saveToken(response.token!);
        }
        emit(AuthSuccess(user: response.user));
      },
    );
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepo.register(
      name: event.name,
      email: event.email,
      password: event.password,
      phone: event.phone,
    );
    await result.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (response) async {
        if (response.token != null) {
          await SecureStorage.saveToken(response.token!);
        }
        emit(AuthSuccess(user: response.user));
      },
    );
  }

  Future<void> _onForgotPassword(ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepo.forgotPassword(event.email);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(PasswordResetCodeSent()),
    );
  }

  Future<void> _onVerifyCode(VerifyCodeEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepo.verifyCode(event.code);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(PasswordResetCodeVerified()),
    );
  }

  Future<void> _onResetPassword(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepo.resetPassword(event.email, event.newPassword);
    await result.fold(
      (failure) async => emit(AuthFailure(failure.message)),
      (token) async {
        await SecureStorage.saveToken(token);
        emit(PasswordResetSuccess());
      },
    );
  }
}
