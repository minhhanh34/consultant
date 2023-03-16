import 'package:flutter/material.dart';

class CenterCircularIndicator extends StatelessWidget {
  const CenterCircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
