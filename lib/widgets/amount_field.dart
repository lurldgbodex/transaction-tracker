import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/currency_provider.dart';

class AmountField extends ConsumerWidget {
  final TextEditingController controller;

  const AmountField({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyCode = ref.watch(currencyProvider);
    final currencySymbol = NumberFormat.simpleCurrency(
      name: currencyCode,
    ).currencySymbol;

    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Amount',
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            currencySymbol,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
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
      onChanged: (value) {},
    );
  }
}
