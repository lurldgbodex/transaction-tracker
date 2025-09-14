import 'package:flutter/material.dart';

class NoteField extends StatelessWidget {
  final TextEditingController controller;

  const NoteField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: "Note (optional)",
        prefixIcon: Icon(Icons.note),
      ),
    );
  }
}
