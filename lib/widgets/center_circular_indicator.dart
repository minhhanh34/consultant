import 'package:flutter/material.dart';

class CenterCircularIndicator extends StatelessWidget {
  const CenterCircularIndicator({
    super.key,
    this.color,
  });
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: color),
    );
  }
}
