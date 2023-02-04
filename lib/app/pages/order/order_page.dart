import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_burger/app/core/extensions/formatter_extension.dart';
import 'package:vakinha_burger/app/core/ui/base_state/base_state.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_button.dart';
import 'package:vakinha_burger/app/dto/order_product_dto.dart';
import 'package:vakinha_burger/app/models/payment_type_model.dart';
import 'package:vakinha_burger/app/models/product_model.dart';
import 'package:vakinha_burger/app/pages/order/order_controller.dart';
import 'package:vakinha_burger/app/pages/order/order_state.dart';
import 'package:vakinha_burger/app/pages/order/widget/order_field.dart';
import 'package:vakinha_burger/app/pages/order/widget/payment_types_field.dart';
import 'package:vakinha_burger/app/pages/order/widget/order_product_title.dart';
import 'package:validatorless/validatorless.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  final _orderFormKey = GlobalKey<FormState>();
  final _addressEC = TextEditingController();
  final _cpfEC = TextEditingController();
  final paymentTypeValid = ValueNotifier<bool>(true);
  int? paymentTypeId;

  @override
  void onReady() {
    final products = ModalRoute.of(context)!.settings.arguments as List<OrderProductDto>;

    controller.load(products);
  }

  @override
  void dispose() {
    _cpfEC.dispose();
    _addressEC.dispose();

    super.dispose();
  }

  void _showConfirmProductDialog(OrderConfirmDeleteProductState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title:
              Text("Tem certeza que deseja remover o produto ${state.orderProduct.product.name}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.cancelDeleteProcess();
              },
              child: Text(
                "Cancelar",
                style: context.textStyles.textBold.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.decrementProduct(state.index);
              },
              child: Text(
                "Confirmar",
                style: context.textStyles.textBold,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderController, OrderState>(
      listener: (context, state) {
        state.status.matchAny(
            any: () => hideLoader,
            loading: () => showLoader,
            loaded: () => hideLoader,
            error: () {
              hideLoader();
              showError('Erro');
            },
            confirmRemoveProduct: () {
              hideLoader();

              if (state is OrderConfirmDeleteProductState) {
                //! Importante: Autopromoção de tipos
                _showConfirmProductDialog(state);
              }
            });
      },
      child: WillPopScope(
        onWillPop: () async {
          // Estado atualizado
          Navigator.of(context).pop(controller.state.products);
          return false;
        },
        child: Scaffold(
          appBar: DeliveryAppbar(),
          body: Form(
            key: _orderFormKey,
            child: CustomScrollView(
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
                BlocSelector<OrderController, OrderState, List<OrderProductDto>>(
                  selector: (state) => state.products,
                  builder: (context, orders) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: orders.length,
                        (context, index) {
                          final orderProduct = orders[index];
                          final product = orders[index].product;

                          return Column(
                            children: [
                              ProductOrderTitle(
                                index: index,
                                orderProduct: OrderProductDto(
                                  amount: orderProduct.amount,
                                  product: ProductModel(
                                    id: product.id,
                                    name: product.name,
                                    description: product.description,
                                    image: product.image,
                                    price: product.price,
                                  ),
                                ),
                              ),
                              const Divider(color: Colors.grey),
                            ],
                          );
                        },
                      ),
                    );
                  },
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
                            BlocSelector<OrderController, OrderState, double>(
                              selector: (state) => state.totalOrder,
                              builder: (context, totalOrder) {
                                return Text(
                                  totalOrder.currencyBR,
                                  style: context.textStyles.textExtraBold.copyWith(
                                    fontSize: 20,
                                  ),
                                );
                              },
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
                        validator: Validatorless.required('Endereço obrigatório'),
                        controller: _addressEC,
                      ),
                      const SizedBox(height: 10),
                      OrderField(
                        title: 'CPF',
                        hintText: 'Digite o CPF',
                        validator: Validatorless.required('CPF obrigatório'),
                        controller: _cpfEC,
                      ),
                      const SizedBox(height: 10),
                      BlocSelector<OrderController, OrderState, List<PaymentTypeModel>>(
                        selector: (state) => state.paymentTypes,
                        builder: (context, payment) {
                          return ValueListenableBuilder(
                            valueListenable: paymentTypeValid,
                            builder: (_, paymentTypeValidValue, child) {
                              return PaymentTypesField(
                                valid: paymentTypeValidValue,
                                paymentTypes: payment,
                                valueSelected: paymentTypeId.toString(),
                                valueChanged: (value) {
                                  paymentTypeId = value;
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: DeliveryButton(
                          label: 'FINALIZAR',
                          onPressed: () {
                            final valid = _orderFormKey.currentState?.validate() ?? false;
                            final paymentTypeSelected = paymentTypeId != null;
                            paymentTypeValid.value = paymentTypeSelected;

                            if (valid) {}
                          },
                          width: double.infinity,
                          height: 48,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
