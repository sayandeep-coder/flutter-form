import 'package:flutter/material.dart';

class RemarksInput extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;

  const RemarksInput({super.key, this.initialValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(labelText: 'Remarks (optional)'),
      onChanged: onChanged,
      controller: TextEditingController(text: initialValue),
    );
  }
} 