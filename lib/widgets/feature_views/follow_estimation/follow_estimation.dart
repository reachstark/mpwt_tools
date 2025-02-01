import 'dart:ui';

import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FollowEstimation extends StatelessWidget {
  const FollowEstimation({super.key});

  @override
  Widget build(BuildContext context) {
    final appX = Get.find<AppController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(16),
        Row(
          children: [
            Icon(
              Icons.description_rounded,
              color: AppColors.primaryLight,
            ),
            const Gap(8),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primaryLight,
              ),
            ),
          ],
        ),
        const Gap(16),
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Text(
            'ចុចប៊ូតុងខាងក្រោមដើម្បីបើកកម្មវិធី Web Browser ភ្ជាប់ទៅកាន់ប្រព័ន្ធ Google Sheets',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        const Gap(16),
        AspectRatio(
          aspectRatio: 2.3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: AppColors.secondaryLight, width: 2.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // The underlying image
                  Image.asset(
                    AppImages.estimationListTable,
                    fit: BoxFit.cover,
                  ),
                  // Apply the blur effect
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Container(
                      color: const Color.fromARGB(31, 129, 129, 129),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Gap(16),
        Center(
          child: ElevatedButton.icon(
            onPressed: () => appX.launchEstimationList(),
            icon: const Icon(
              Icons.open_in_new_rounded,
              color: Colors.white,
            ),
            label: const Text('បើកកម្មវិធី'),
          ),
        ),
        const Gap(16),
      ],
    );
  }
}
