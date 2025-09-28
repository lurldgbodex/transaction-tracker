import 'package:flutter/material.dart';

import '../utils/date_utils.dart';

class DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Future<void> Function() onDatePressed;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Date: ${formatDate(selectedDate)}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Spacer(),
        TextButton(onPressed: onDatePressed, child: const Text('change')),
      ],
    );
  }
}
