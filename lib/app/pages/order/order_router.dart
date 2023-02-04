import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vakinha_burger/app/pages/order/order_controller.dart';
import 'package:vakinha_burger/app/pages/order/order_page.dart';
import 'package:vakinha_burger/app/repositories/orders/order_repository.dart';
import 'package:vakinha_burger/app/repositories/orders/order_repository_impl.dart';

class OrderRouter {
  OrderRouter._();

  static Widget get page => MultiProvider(
        providers: [
          // Tipar toda implementação de interface no Provider!!!!!
          Provider<OrderRepository>(
            create: (context) => OrderRepositoryImpl(dio: context.read()),
          ),
          Provider(
            create: (context) => OrderController(context.read()),
          ),
        ],
        child: const OrderPage(),
      );
}
