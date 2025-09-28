import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';

class ThemeModeSettings extends ConsumerWidget {
  const ThemeModeSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Theme",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DropdownButton(
          value: themeMode,
          items: const [
            DropdownMenuItem(value: ThemeMode.light, child: Text("Light")),
            DropdownMenuItem(value: ThemeMode.dark, child: Text("Dark")),
          ],
          onChanged: (mode) {
            if (mode != null) {
              ref.read(themeProvider.notifier).setTheme(mode);
            }
          },
        ),
      ],
    );
  }
}
