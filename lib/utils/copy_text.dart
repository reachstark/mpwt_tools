import 'package:estimation_list_generator/widgets/snackbar/snackbars.dart';
import 'package:flutter/services.dart';

void copyText(String text) {
  Clipboard.setData(ClipboardData(text: text));
  showSuccessSnackbar(message: 'Copied to clipboard');
}
