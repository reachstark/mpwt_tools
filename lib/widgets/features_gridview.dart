import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_theme.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controllers/app_controller.dart';

class FeaturesGridView extends StatelessWidget {
  const FeaturesGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appX = Get.find<AppController>();
    final dbX = Get.find<DbController>();

    return Obx(
      () {
        List<FeatureItem> featureItems = [
          FeatureItem(
            icon: Icons.document_scanner_rounded,
            title: forReviewGenerator,
            selected: appX.featureIndex.value == 0,
            onTap: () => appX.setFeatureIndex(0),
          ),
          FeatureItem(
            icon: Icons.casino_rounded,
            title: mpwtLotteryList,
            selected: appX.featureIndex.value == 1,
            onTap: () => appX.setFeatureIndex(1),
          ),
          FeatureItem(
            icon: Icons.people_rounded,
            title: mpwtLotteryWinnerList,
            selected: appX.featureIndex.value == 2,
            onTap: () => appX.setFeatureIndex(2),
          ),
          FeatureItem(
            icon: Icons.follow_the_signs_rounded,
            title: followEstimationList,
            selected: appX.featureIndex.value == 3,
            onTap: () => appX.setFeatureIndex(3),
          ),
          FeatureItem(
            icon: FontAwesomeIcons.qrcode,
            title: qrCodeGenerator,
            selected: appX.featureIndex.value == 4,
            onTap: () => appX.setFeatureIndex(4),
          ),
          FeatureItem(
            icon: FontAwesomeIcons.circleDollarToSlot,
            title: donateDeveloper,
            selected: appX.featureIndex.value == 5,
            onTap: () => appX.setFeatureIndex(5),
          ),
          FeatureItem(
            icon: FontAwesomeIcons.fileCode,
            title: followFMIS,
            selected: appX.featureIndex.value == 6,
            onTap: () => appX.setFeatureIndex(6),
            badgeCount: dbX.fmisCodes.length,
          ),
        ];

        return Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.build_rounded,
                  color: AppColors.secondaryLight,
                ),
                const Gap(8),
                Text(
                  'Tools',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.secondaryLight,
                  ),
                ),
              ],
            ),
            const Gap(16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.15,
                ),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => featureItems[index],
                itemCount: featureItems.length,
              ),
            ),
          ],
        );
      },
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback? onTap;
  final int? badgeCount;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.selected,
    this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: selected ? AppColors.primaryLight : Colors.transparent,
                  width: clampDouble(width / 20, 2, 3),
                ),
                color: selected
                    ? AppColors.secondaryLight
                    : AppColors.backgroundLight,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    icon,
                    size: clampDouble(width / 20, 30, 35),
                    color: selected ? Colors.white : AppColors.primaryLight,
                  ),
                  if (badgeCount != null && badgeCount! > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.cosmicRed,
                          boxShadow: blurShadow,
                        ),
                        child: Text(
                          badgeCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Gap(16),
          SizedBox(
            width: clampDouble(width / 20, 120, 130),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.secondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
