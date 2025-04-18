import 'dart:ui';

import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controllers/app_controller.dart';

class HorizontalData extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String data;
  final double? dataSize;
  final Future<String>? futureData; // Added futureData

  const HorizontalData({
    super.key,
    this.icon,
    required this.title,
    required this.data,
    this.futureData,
    this.dataSize, // Added futureData
  });

  @override
  Widget build(BuildContext context) {
    final appX = Get.find<AppController>();
    final width = MediaQuery.of(context).size.width;

    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: appX.isDarkMode.value
                      ? AppColors.white
                      : AppColors.primaryLight,
                  size: 18,
                ),
                const Gap(8),
              ],
              Text(
                title,
                style: TextStyle(
                  color: appX.isDarkMode.value
                      ? AppColors.white
                      : AppColors.primaryLight,
                ),
              ),
            ],
          ),
          Flexible(
            child: SizedBox(
              width: clampDouble(width * 0.25, 120, 200),
              child: futureData != null
                  ? FutureBuilder<String>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LinearProgressIndicator(
                            year2023: false,
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error',
                            textAlign: TextAlign.end,
                            style: TextStyle(color: AppColors.mpwtRed),
                          );
                        } else {
                          return Text(
                            '${snapshot.data} / $data',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: appX.isDarkMode.value
                                  ? AppColors.white
                                  : AppColors.primaryLight,
                            ),
                          );
                        }
                      },
                    )
                  : Text(
                      data,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: dataSize,
                        color: appX.isDarkMode.value
                            ? AppColors.white
                            : AppColors.primaryLight,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
