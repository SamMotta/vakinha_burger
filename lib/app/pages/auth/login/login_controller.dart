import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakinha_burger/app/core/exceptions/unathorized_exception.dart';
import 'package:vakinha_burger/app/pages/auth/login/login_state.dart';
import 'package:vakinha_burger/app/repositories/auth/auth_repository.dart';

class LoginController extends Cubit<LoginState> {
  final AuthRepository _authRepo;

  LoginController(this._authRepo) : super(const LoginState.initial());

  Future<void> login(String email, String password) async {
    try {
      emit(state.copyWith(status: LoginStatus.login));

      final authModel = await _authRepo.login(email, password);
      final sp = await SharedPreferences.getInstance();

      await sp.setString('access_token', authModel.accessToken);
      await sp.setString('refresh_token', authModel.refreshToken);

      emit(state.copyWith(status: LoginStatus.success));
    } on UnathorizedException catch (e, s) {
      log('Email ou senha inválidos', error: e, stackTrace: s);
      emit(
        state.copyWith(status: LoginStatus.loginError, errorMessage: 'Email ou senha inválidos'),
      );
    } catch (e, s) {
      log('Não foi possível realizar o login', error: e, stackTrace: s);
      emit(
        state.copyWith(
          status: LoginStatus.loginError,
          errorMessage: 'Não foi possível realizar o login',
        ),
      );
    }
  }
}
