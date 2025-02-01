import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showMessage(String message) {
  Get.snackbar(
    "Success",
    message,
    showProgressIndicator: true,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(20),
  );
}
