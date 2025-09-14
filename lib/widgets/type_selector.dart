import 'package:flutter/material.dart';

class TypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const TypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: [selectedType == "income", selectedType == "expense"],
      onPressed: (index) {
        onTypeChanged(index == 0 ? "income" : "expense");
      },
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Income'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Expense'),
        ),
      ],
    );
  }
}
