import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakinha_burger/app/core/extensions/formatter_extension.dart';
import 'package:vakinha_burger/app/core/ui/helpers/size_extension.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/dto/order_product_dto.dart';

class ShoppingBagWidget extends StatelessWidget {
  final List<OrderProductDto> bag;
  const ShoppingBagWidget({
    super.key,
    required this.bag,
  });

  @override
  Widget build(BuildContext context) {
    var totalBag = bag.fold(0.0, (total, element) => total += element.totalPrice).currencyBR;

    Future<void> goOrder(BuildContext context) async {
      final navigator = Navigator.of(context);
      final SharedPreferences sp = await SharedPreferences.getInstance();

      if (!sp.containsKey('access_token')) {
        // Envio para o login
        final loginResult = await navigator.pushNamed('/auth/login');

        if (loginResult == null || loginResult == false) {
          return;
        }
      }

      // Envio para o pedido
      await navigator.pushNamed('/order', arguments: bag);
    }

    return Container(
      width: context.screenWidth,
      height: 90,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          goOrder(context);
        },
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.shopping_cart,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Ver sacola',
                style: context.textStyles.textExtraBold.copyWith(fontSize: 14),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                totalBag,
                style: context.textStyles.textExtraBold.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
