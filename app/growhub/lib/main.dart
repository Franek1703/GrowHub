import 'package:flutter/material.dart';
import 'package:growhub/config/routing.dart';

import 'package:growhub/views/main_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GHRouter().router,
    );
  }
}
