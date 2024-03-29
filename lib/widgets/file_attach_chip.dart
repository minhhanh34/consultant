import 'package:flutter/material.dart';

class FileAttachChip extends StatelessWidget {
  const FileAttachChip({
    super.key,
    required this.name,
    required this.onRemove,
    this.enable = true,
  });
  final String name;
  final VoidCallback onRemove;
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          Chip(
            padding: const EdgeInsets.all(12),
            label: Text(name),
          ),
          Visibility(
            visible: enable,
            child: Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: onRemove, // filePickerResult?.files.removeAt(i);
                child: const CircleAvatar(
                  radius: 12,
                  child: Icon(Icons.close),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
