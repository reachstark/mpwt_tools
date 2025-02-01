import 'package:estimation_list_generator/widgets/dialogs/error_dialog.dart';
import 'package:get/get.dart';

void showErrorMessage(String message) {
  Get.dialog(
    ErrorDialog(message: message),
  );
}
