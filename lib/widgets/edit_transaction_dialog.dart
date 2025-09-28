import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'amount_field.dart';
import 'note_field.dart';

class EditTransactionDialog extends StatefulWidget {
  final TransactionModel transaction;
  final void Function(TransactionModel) onSave;

  const EditTransactionDialog({
    super.key,
    required this.transaction,
    required this.onSave,
  });

  @override
  State<EditTransactionDialog> createState() => _EditTransactionDialogState();
}

class _EditTransactionDialogState extends State<EditTransactionDialog> {
  late TextEditingController amountController;
  late TextEditingController categoryController;
  late TextEditingController noteController;
  late String type;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(
      text: widget.transaction.amount.toString(),
    );
    categoryController = TextEditingController(
      text: widget.transaction.categoryId.toString(),
    );
    noteController = TextEditingController(text: widget.transaction.note);
    type = widget.transaction.type;
  }

  @override
  void dispose() {
    amountController.dispose();
    categoryController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Edit Transaction",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            AmountField(controller: amountController),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),
            NoteField(controller: noteController),
            DropdownButtonFormField(
              initialValue: type,
              items: const [
                DropdownMenuItem(value: "income", child: Text("Income")),
                DropdownMenuItem(value: "expense", child: Text("Expense")),
              ],
              onChanged: (value) => setState(() => type = value!),
              decoration: const InputDecoration(labelText: "Type"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedTx = TransactionModel(
              id: widget.transaction.id,
              amount: double.tryParse(amountController.text) ?? 0,
              categoryId: widget.transaction.categoryId,
              note: noteController.text,
              type: type,
              date: widget.transaction.date,
            );
            widget.onSave(updatedTx);
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
