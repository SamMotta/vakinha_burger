// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

import 'package:vakinha_burger/app/dto/order_product_dto.dart';
import 'package:vakinha_burger/app/models/payment_type_model.dart';

part 'order_state.g.dart';

@match
enum OrderStatus {
  inital,
  loading,
  loaded,
  updateOrder,
  confirmRemoveProduct,
  error,
}

class OrderState extends Equatable {
  final OrderStatus status;
  final List<OrderProductDto> products;
  final List<PaymentTypeModel> paymentTypes;
  final String? errorMessage;

  const OrderState({
    required this.status,
    required this.products,
    required this.paymentTypes,
    this.errorMessage,
  });

  const OrderState.initial()
      : status = OrderStatus.inital,
        paymentTypes = const [],
        products = const [],
        errorMessage = null;

  double get totalOrder =>
      products.fold(0.0, (previousValue, current) => previousValue + current.totalPrice);

  @override
  List<Object?> get props => [status, products, paymentTypes, errorMessage];

  OrderState copyWith({
    OrderStatus? status,
    List<OrderProductDto>? products,
    List<PaymentTypeModel>? paymentTypes,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      products: products ?? this.products,
      paymentTypes: paymentTypes ?? this.paymentTypes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class OrderConfirmDeleteProductState extends OrderState {
  final OrderProductDto orderProduct;
  final int index;

  const OrderConfirmDeleteProductState({
    required this.orderProduct,
    required this.index,
    required super.status,
    required super.products,
    required super.paymentTypes,
    super.errorMessage,
  });
}
