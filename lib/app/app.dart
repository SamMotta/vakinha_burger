import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/global/global_context.dart';
import 'package:vakinha_burger/app/core/provider/application_binding.dart';
import 'package:vakinha_burger/app/core/ui/themes/theme_config.dart';
import 'package:vakinha_burger/app/pages/auth/login/login_router.dart';
import 'package:vakinha_burger/app/pages/auth/register/register_router.dart';
import 'package:vakinha_burger/app/pages/order/order_completed_page.dart';
import 'package:vakinha_burger/app/pages/order/order_router.dart';
import 'package:vakinha_burger/app/pages/product_detail/product_detail_router.dart';
import 'package:vakinha_burger/app/pages/splash/splash_page.dart';
import 'package:vakinha_burger/app/pages/home/home_router.dart';

class App extends StatelessWidget {
  final _navKey = GlobalKey<NavigatorState>();

  App({super.key}) {
    GlobalContext.instance.navigatorKey =_navKey;
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationBinding(
      child: MaterialApp(
        navigatorKey: _navKey,
        debugShowCheckedModeBanner: false,
        title: 'Vakinha Burger',
        theme: ThemeConfig.theme,
        routes: {
          '/': (context) => const SplashPage(),
          '/home': (context) => HomeRouter.page,
          '/productDetail': (context) => ProductDetailRouter.page,
          '/auth/login': (context) => LoginRouter.page,
          '/auth/register': (context) => RegisterRouter.page,
          '/order': (context) => OrderRouter.page,
          '/order/completed': (context) => const OrderCompletedPage(),
        },
      ),
    );
  }
}
