// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'package:vakinha_burger/app/pages/home/home_state.dart';
import 'package:vakinha_burger/app/repositories/products/products_repository.dart';

class HomeController extends Cubit<HomeState> {
  final ProductsRepository _productsRepository;

  HomeController(
    this._productsRepository,
  ) : super(const HomeState.initial());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: HomeStateStatus.loading));

    try {
      final products = await _productsRepository.findAllProducts();

      emit(
        state.copyWith(
          status: HomeStateStatus.loaded,
          products: products,
        ),
      );
    } catch (err, st) {
      log('Erro ao buscar produto', error: err, stackTrace: st);
      emit(state.copyWith(status: HomeStateStatus.error, errorMessage: 'Erro ao buscar produtos'));
    }
  }
}
