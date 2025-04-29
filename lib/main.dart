import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_creator/app_module.dart';

void main() {
  runApp(ModularApp(module: AppModule(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Platzi Store',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      routerConfig: Modular.routerConfig,
    );
  }
}
