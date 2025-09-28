import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyUtils {
  static const _currencyKey = 'preferred_currency';

  static Future<void> setPreferredCurrency(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, code);
  }

  static Future<String?> getPreferredCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey);
  }

  static String formatAmount(
    double amount, {
    String? locale,
    String? currencyCode,
  }) {
    final format = NumberFormat.simpleCurrency(
      locale: locale,
      name: currencyCode,
    );
    return format.format(amount);
  }

  static final List<String> currencies = [
    "USD",
    "EUR",
    "GBP",
    "CNY",
    "JPY",
    "NGN",
    "INR",
    "ZAR",
  ];
}
