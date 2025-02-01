import 'package:cached_network_image/cached_network_image.dart';
import 'package:estimation_list_generator/models/lottery_event.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_images.dart';
import 'package:estimation_list_generator/utils/app_theme.dart';
import 'package:estimation_list_generator/widgets/dialogs/add_lottery_prize_item.dart';
import 'package:estimation_list_generator/widgets/dialogs/delete_lottery_prize.dart';
import 'package:estimation_list_generator/widgets/scale_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class LotteryPrizeItemCard extends StatelessWidget {
  final String index;
  final EventPrize prize;
  const LotteryPrizeItemCard({
    super.key,
    required this.index,
    required this.prize,
  });

  @override
  Widget build(BuildContext context) {
    final prizeName = prize.prizeTitle;
    final quantity = prize.quantity.toString();
    Widget buildQuantity() {
      return ScaleButton(
        tooltip: 'មានចំនួន $quantity រង្វាន់',
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primaryLight,
            ),
            borderRadius: BorderRadius.circular(
              100,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FontAwesomeIcons.box,
                color: AppColors.primaryLight,
              ),
              const Gap(8),
              Text(
                quantity,
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        Container(
          width: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              index,
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ),
        const Gap(8),
        Expanded(
          child: Card.outlined(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    height: 50,
                    width: 50,
                    imageUrl:
                        'https://images.sigma.world/lottery-numbers-1336x751.jpg',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        boxShadow: fadeShadow,
                      ),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      prizeName,
                                      style: TextStyle(
                                        color: AppColors.primaryLight,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  if (prize.isTopPrize) ...[
                                    const Gap(8),
                                    ScaleButton(
                                      tooltip: 'ជារង្វាន់ធំ',
                                      child: Image.asset(
                                        AppImages.iconCrown,
                                        height: 26,
                                        width: 26,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(8),
                        Row(
                          children: [
                            buildQuantity(),
                            const Spacer(),
                            ScaleButton(
                              onTap: () => showAddLotteryPrizeItemDialog(
                                isUpdating: true,
                                selectedPrize: prize,
                              ),
                              tooltip: 'ធ្វើកំណែ',
                              child: Icon(
                                FontAwesomeIcons.pencil,
                                color: AppColors.primaryLight,
                                size: 18,
                              ),
                            ),
                            const Gap(8),
                            ScaleButton(
                              onTap: () => showDeleteLotteryPrizeDialog(prize),
                              tooltip: 'លុបចេញ',
                              child: Icon(
                                FontAwesomeIcons.trash,
                                color: AppColors.mpwtRed,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
