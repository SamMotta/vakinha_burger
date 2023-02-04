// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:vakinha_burger/app/dto/order_product_dto.dart';

class OrderDto {
  final List<OrderProductDto> products;
  final String address;
  final String cpf;
  final int paymentMethodID;
  
  OrderDto({
    required this.products,
    required this.address,
    required this.cpf,
    required this.paymentMethodID,
  });

}
