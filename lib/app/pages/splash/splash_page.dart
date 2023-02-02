import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/ui/helpers/size_extension.dart';
import 'package:vakinha_burger/app/core/ui/widgets/delivery_button.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF140E0E),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: context.screenWidth,
              child: Image.asset(
                'assets/images/lanche.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: context.percentHeight(0.3),
                ),
                Image.asset(
                  "assets/images/logo.png",
                ),
                const SizedBox(
                  height: 80,
                ),
                DeliveryButton(
                  width: context.percentWidth(.6),
                  height: 46,
                  label: 'ACESSAR',
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed('/home');
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
