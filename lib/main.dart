import 'package:flutter/material.dart';

import 'package:vakinha_burger/app/app.dart';
import 'package:vakinha_burger/app/core/config/env.dart';

void main() async {
  await Env.instance.load();
  runApp(const App());
}
