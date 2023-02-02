import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vakinha_burger/app/pages/home/home_controller.dart';
import 'package:vakinha_burger/app/pages/home/home_page.dart';
import 'package:vakinha_burger/app/repositories/products/products_repository.dart';
import 'package:vakinha_burger/app/repositories/products/products_repository_impl.dart';

class HomeRouter {
  HomeRouter._();

  static Widget get page => MultiProvider(
        providers: [
          Provider<ProductsRepository>(
            create: (context) => ProductsRepositoryImpl(dio: context.read()),
          ),
          Provider(
            create: (context) => HomeController(context.read()),
          ),
        ],
        child: const HomePage(),
      );
}
