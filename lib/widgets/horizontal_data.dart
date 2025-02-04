import 'dart:ui';

import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HorizontalData extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String data;
  const HorizontalData({
    super.key,
    this.icon,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: AppColors.primaryLight,
                size: 18,
              ),
              const Gap(8),
            ],
            Text(
              title,
              style: TextStyle(
                color: AppColors.primaryLight,
              ),
            ),
          ],
        ),
        Flexible(
          child: SizedBox(
            width: clampDouble(width * 0.25, 120, 200),
            child: Text(
              data,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: AppColors.primaryLight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
