import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:vakinha_burger/app/pages/auth/register/register_state.dart';

import 'package:vakinha_burger/app/repositories/auth/auth_repository.dart';

class RegisterController extends Cubit<RegisterState> {
  final AuthRepository _authRepo;

  RegisterController(this._authRepo) : super(const RegisterState.initial());

  Future<void> register(String name, String email, String password) async {
    try {
      emit(state.copyWith(status: RegisterStatus.register));
      await _authRepo.register(name, email, password);
      emit(state.copyWith(status: RegisterStatus.sucess));
    } catch (e, s) {
      log('Erro ao registrar usuário', error: e, stackTrace: s);
      emit(state.copyWith(status: RegisterStatus.error));
    }
  }
}
