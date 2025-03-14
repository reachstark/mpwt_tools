import 'package:intl/intl.dart';

String getTimeHasPassed(DateTime dateStart) {
  final Duration difference = DateTime.now().difference(dateStart);
  final int minutesPassed = difference.inMinutes;

  if (minutesPassed < 2) {
    return 'ថ្មីៗនេះ';
  }
  if (minutesPassed < 60) {
    return '$minutesPassed នាទីមុន';
  }
  if (minutesPassed < 60 * 24) {
    final int hoursPassed = minutesPassed ~/ 60;
    return '$hoursPassed ម៉ោងមុន';
  }
  if (minutesPassed < 60 * 24 * 3) {
    final int daysPassed = minutesPassed ~/ (60 * 24);
    return '$daysPassed ថ្ងៃមុន';
  }
  if (minutesPassed < 60 * 24 * 10) {
    return DateFormat('MM/dd').format(dateStart);
  }
  return DateFormat('dd/MMM/yyyy').format(dateStart);
}

String formatDateAndTime(DateTime date) {
  // e.g: 2025 / 01 / 22 0:00 AM
  return DateFormat('yyyy / MM / dd h:mm a').format(date);
}
