import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/currency_provider.dart';
import '../utils/currency_utils.dart';

class CurrencySettings extends ConsumerWidget {
  final String? selectedCurrency;

  const CurrencySettings({super.key, this.selectedCurrency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Preferred Currency",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DropdownButton(
          value: currency ?? "auto",
          items: [
            DropdownMenuItem(value: "auto", child: Text("auto")),
            ...CurrencyUtils.currencies.map(
              (code) => DropdownMenuItem(value: code, child: Text(code)),
            ),
          ],
          onChanged: (value) {
            ref
                .read(currencyProvider.notifier)
                .setCurrency(value == "auto" ? null : value);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Currency preference updated')),
            );
          },
        ),
      ],
    );
  }
}
