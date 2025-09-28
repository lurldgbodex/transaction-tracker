import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/currency_utils.dart';

class CurrencyNotifier extends Notifier<String?> {
  @override
  String? build() {
    _load();

    return null;
  }

  Future<void> _load() async {
    final pref = await CurrencyUtils.getPreferredCurrency();
    if (pref == null || pref.isEmpty) {
      state = null;
    } else {
      state = pref;
    }
  }

  Future<void> setCurrency(String? code) async {
    await CurrencyUtils.setPreferredCurrency(code ?? "");
    state = code?.isEmpty == true ? null : code;
  }
}

final currencyProvider = NotifierProvider<CurrencyNotifier, String?>(
  CurrencyNotifier.new,
);
