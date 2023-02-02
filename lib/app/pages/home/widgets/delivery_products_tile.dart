import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/extensions/formatter_extension.dart';
import 'package:vakinha_burger/app/core/ui/styles/colors_style.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';
import 'package:vakinha_burger/app/models/product_model.dart';

class DeliveryProductsTile extends StatelessWidget {
  final ProductModel product;
  const DeliveryProductsTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    product.name,
                    style: context.textStyles.textExtraBold.copyWith(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    product.description,
                    style: context.textStyles.textRegular.copyWith(fontSize: 12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    product.price.currencyBR,
                    style: context.textStyles.textMedium.copyWith(
                      fontSize: 12,
                      color: context.colors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          FadeInImage.assetNetwork(
            placeholder: 'assets/images/loading.gif',
            image: product.image,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }
}
