import 'package:flutter/material.dart';
import 'package:project_tracker/widgets/theme_mode_settings.dart';

import '../widgets/currency_settings.dart';
import 'category_screen.dart';

class SettingsScreen extends StatelessWidget {
  final String? selectedCurrency;

  const SettingsScreen({super.key, this.selectedCurrency});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ThemeModeSettings(),
            CurrencySettings(selectedCurrency: selectedCurrency),
            const SizedBox(height: 16),
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Manage Categories",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CategoryScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
