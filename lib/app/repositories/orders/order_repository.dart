
import 'package:vakinha_burger/app/models/payment_type_model.dart';

abstract class OrderRepository {
  Future<List<PaymentTypeModel>> getAllPayments();
}
