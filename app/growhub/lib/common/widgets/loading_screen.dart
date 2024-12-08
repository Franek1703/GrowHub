import 'package:flutter/material.dart';
import 'package:growhub/common/widgets/progress_indicator.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: GHProgressIndicator(),
      ),
    );
  }
}
