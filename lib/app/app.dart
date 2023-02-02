import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/provider/application_binding.dart';
import 'package:vakinha_burger/app/core/ui/themes/theme_config.dart';
import 'package:vakinha_burger/app/pages/splash/splash_page.dart';
import 'package:vakinha_burger/app/pages/home/home_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ApplicationBinding(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vakinha Burger',
        theme: ThemeConfig.theme,
        routes: {
          '/': (context) => const SplashPage(),
          '/home': (context) => HomeRouter.page,
        },
      ),
    );
  }
}
