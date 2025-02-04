import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  // e.g: 2025 / 01 / 22
  return DateFormat('yyyy / MM / dd').format(date);
}
