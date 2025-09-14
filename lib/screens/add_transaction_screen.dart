import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../utils/date_utils.dart';
import '../widgets/amount_field.dart';
import '../widgets/type_selector.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/note_field.dart';
import '../widgets/date_selector.dart';
import '../widgets/submit_button.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _type = "expense";
  String _category = "Food";
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = [
    "Food",
    "Transport",
    "Bills",
    "Shopping",
    "Salary",
    "Others",
  ];

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final tx = TransactionModel(
        amount: double.parse(_amountController.text),
        type: _type,
        category: _category,
        note: _noteController.text,
        date: _selectedDate,
      );

      await ref.read(transactionProvider.notifier).addTransaction(tx);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePickerDialog(
      context: context,
      initialDate: _selectedDate,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AmountField(controller: _amountController),
              const SizedBox(height: 16),
              TypeSelector(
                selectedType: _type,
                onTypeChanged: (type) {
                  setState(() {
                    _type = type;
                  });
                },
              ),
              const SizedBox(height: 16),
              CategoryDropDown(
                selectedCategory: _category,
                categories: _categories,
                onCategoryChanged: (category) {
                  setState(() {
                    _category = category;
                  });
                },
              ),
              const SizedBox(height: 16),
              NoteField(controller: _noteController),
              const SizedBox(height: 16),
              DateSelector(
                selectedDate: _selectedDate,
                onDatePressed: _pickDate,
              ),
              const SizedBox(height: 16),
              SubmitButton(onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
