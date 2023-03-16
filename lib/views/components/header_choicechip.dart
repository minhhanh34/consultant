
import 'package:flutter/material.dart';

class HeaderChoiceChip extends StatefulWidget {
  const HeaderChoiceChip({
    super.key,
    required this.label,
    this.selected = false,
  });
  final String label;
  final bool selected;
  @override
  State<HeaderChoiceChip> createState() => _HeaderChoiceChipState();
}

class _HeaderChoiceChipState extends State<HeaderChoiceChip> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChoiceChip(
        onSelected: (bool value) {
          setState(() {
            selected = !selected;
          });
        },
        elevation: 0,
        selectedColor: Colors.indigo.shade100,
        disabledColor: Colors.white,
        label: Text(widget.label),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: Colors.black,
        ),
        selected: selected,
      ),
    );
  }
}
