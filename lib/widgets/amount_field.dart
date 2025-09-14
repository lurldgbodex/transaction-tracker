import 'package:flutter/material.dart';

class AmountField extends StatelessWidget {
  final TextEditingController controller;

  const AmountField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Amount',
        prefixIcon: Icon(Icons.attach_money),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter an amount";
        }
        if (double.tryParse(value) == null) {
          return "Enter a valid number";
        }
        return null;
      },
    );
  }
}
