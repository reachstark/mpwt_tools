import 'dart:ui';

import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_lottie.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

void showLoading() {
  Get.dialog(
    const ShowLoading(),
    barrierDismissible: false,
  );
}

void stopLoading() => Get.back();

class ShowLoading extends StatelessWidget {
  const ShowLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              AppLottie.loading,
              height: height / 4,
            ),
            const Gap(16),
            Text(
              'កំពុងដំណើរការ...',
              style: TextStyle(
                color: AppColors.primaryLight,
                fontSize: clampDouble(
                  height * 0.04,
                  18,
                  22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
