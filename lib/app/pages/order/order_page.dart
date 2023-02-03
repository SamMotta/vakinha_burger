import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_burger/app/dto/order_product_dto.dart';
import 'package:vakinha_burger/app/models/product_model.dart';
import 'package:vakinha_burger/app/pages/order/widget/order_field.dart';
import 'package:vakinha_burger/app/pages/order/widget/product_order_title.dart';
import 'package:validatorless/validatorless.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppbar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Text(
                    "Carrinho",
                    style: context.textStyles.textTitle,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/images/trashRegular.png',
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 2,
              (context, index) {
                return Column(
                  children: [
                    ProductOrderTitle(
                      index: index,
                      orderProduct: OrderProductDto(
                        amount: 10,
                        product: ProductModel(
                          id: 4,
                          name: "X-Egg",
                          description:
                              "Lanche acompanha pão, hamburguer, queijo, ovo, maionese, alface e tomate",
                          image: 'https://sachefmio.blob.core.windows.net/fotos/x-egg-73519.jpg',
                          price: 15.0,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.grey),
                  ],
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total do pedido",
                        style: context.textStyles.textExtraBold.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        r"R$ 150,00",
                        style: context.textStyles.textExtraBold.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                OrderField(
                  title: 'Endereço de entrega',
                  hintText: 'Digite um endereço',
                  formFieldValidator: Validatorless.required('TO DO: IIIAAHUUUL'),
                  textEditingController: TextEditingController(),
                ),
                const SizedBox(height: 10),
                OrderField(
                  title: 'CPF',
                  hintText: 'Digite o CPF',
                  formFieldValidator: Validatorless.required('TO DO: IIIAAHUUUL'),
                  textEditingController: TextEditingController(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
