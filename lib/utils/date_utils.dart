import 'package:flutter/material.dart';

String formatDate(DateTime date) {
  return date.toLocal().toString().split(' ')[0];
}

Future<DateTime?> showDatePickerDialog({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate ?? DateTime(2010),
    lastDate: lastDate ?? DateTime(2100),
  );
}
