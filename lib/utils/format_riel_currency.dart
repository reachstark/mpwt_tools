import 'package:intl/intl.dart';

/// Format currency to Ex: 2,000,000,000
String formatRielCurrency(int number) {
  final formatter = NumberFormat('#,###');
  String formattedNumber = formatter.format(number);
  return '${formattedNumber.replaceAll(',', '.')}៛';
}
