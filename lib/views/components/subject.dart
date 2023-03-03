import 'package:flutter/material.dart';

class SubjectColumn extends StatelessWidget {
  const SubjectColumn({super.key, required this.icon, required this.label});

  final Widget icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56.0,
          height: 56.0,
          decoration: BoxDecoration(
            color: Colors.indigo.shade100,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(child: icon),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      ],
    );
  }
}
