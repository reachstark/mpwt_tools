import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

void showSuccessSnackbar({
  String title = 'Hooray!',
  required String message,
}) {
  final snackBar = SnackBar(
    elevation: 0,
    backgroundColor: Colors.green,
    content: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(16),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontFamily: kantumruy,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
  );

  ScaffoldMessenger.of(Get.context!)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showErrorSnackbar({
  String title = 'Oops!',
  required String message,
  Widget? action,
}) {
  final snackBar = SnackBar(
    elevation: 0,
    backgroundColor: Colors.red,
    content: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(16),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontFamily: kantumruy,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        if (action != null) ...[
          const Gap(16),
          action,
        ],
      ],
    ),
  );

  ScaffoldMessenger.of(Get.context!)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showWarningSnackbar({
  String title = 'Warning!',
  required String message,
}) {
  final snackBar = SnackBar(
    elevation: 0,
    backgroundColor: AppColors.vibrantOrange,
    content: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(16),
        Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontFamily: kantumruy,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );

  ScaffoldMessenger.of(Get.context!)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
