import 'dart:developer';

import 'package:vakinha_burger/app/core/exceptions/repository_exceptions.dart';
import 'package:vakinha_burger/app/core/rest_client/custom_dio.dart';
import 'package:vakinha_burger/app/models/product_model.dart';

import 'package:dio/dio.dart';
import './products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final CustomDio dio;

  ProductsRepositoryImpl({
    required this.dio,
  });

  @override
  Future<List<ProductModel>> findAllProducts() async {
    try {
      final result = await dio.unauth().get('/products');

      return result.data
          .map<ProductModel>(
            (p) => ProductModel.fromMap(p),
          )
          .toList();
    } on DioError catch (e, s) {
      log("Error ao buscar produtos:", error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao buscar produtos.');
    }
  }
}
