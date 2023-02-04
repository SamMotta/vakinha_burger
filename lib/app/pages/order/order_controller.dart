import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:vakinha_burger/app/dto/order_dto.dart';
import 'package:vakinha_burger/app/dto/order_product_dto.dart';
import 'package:vakinha_burger/app/pages/order/order_state.dart';
import 'package:vakinha_burger/app/repositories/orders/order_repository.dart';

class OrderController extends Cubit<OrderState> {
  final OrderRepository _orderRepo;

  OrderController(this._orderRepo) : super(const OrderState.initial());

  void incrementProduct(int index) {
    final orders = [...state.products];
    final order = orders[index];

    // Copiando o pedido e sobrescrevendo o item na lista com um novo valor
    orders[index] = order.copyWith(amount: order.amount + 1);

    emit(state.copyWith(products: orders, status: OrderStatus.updateOrder));
  }

  void decrementProduct(int index) {
    final orders = [...state.products];
    final order = orders[index];
    final amount = order.amount;

    if (amount == 1) {
      if (state.status != OrderStatus.confirmRemoveProduct) {
        emit(OrderConfirmDeleteProductState(
          orderProduct: order,
          index: index,
          status: OrderStatus.confirmRemoveProduct,
          products: state.products,
          paymentTypes: state.paymentTypes,
          errorMessage: state.errorMessage,
        ));
        return;
      } else {
        orders.removeAt(index);
      }
    } else {
      orders[index] = order.copyWith(amount: order.amount - 1);
    }

    if (orders.isEmpty) {
      emit(state.copyWith(status: OrderStatus.emptyBag));

      return;
    }

    emit(state.copyWith(products: orders, status: OrderStatus.updateOrder));
  }

  Future<void> load(List<OrderProductDto> products) async {
    try {
      emit(state.copyWith(status: OrderStatus.loading));

      final paymentTypes = await _orderRepo.getAllPayments();

      emit(state.copyWith(
        status: OrderStatus.loaded,
        products: products,
        paymentTypes: paymentTypes,
      ));
    } on DioError catch (e, s) {
      log('Erro ao carregar página de pedido', error: e, stackTrace: s);
      emit(state.copyWith(status: OrderStatus.error, errorMessage: 'Erro ao carregar página'));
    }
  }

  void cancelDeleteProcess() {
    emit(state.copyWith(status: OrderStatus.loaded));
  }

  void emptyBag() {
    emit(state.copyWith(status: OrderStatus.emptyBag));
  }

  void saveOrder({
    required String address,
    required String cpf,
    required int paymentMethodID,
  }) async {
    emit(state.copyWith(status: OrderStatus.loading));
    await _orderRepo.saveOrder(OrderDto(
      products: state.products,
      address: address,
      cpf: cpf,
      paymentMethodID: paymentMethodID,
    ));
    emit(state.copyWith(status: OrderStatus.success));
  }
}
