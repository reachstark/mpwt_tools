import 'package:estimation_list_generator/models/lottery_event.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/format_date.dart';
import 'package:estimation_list_generator/widgets/dialogs/delete_lottery_event.dart';
import 'package:estimation_list_generator/widgets/scale_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class LotteryEventCard extends StatelessWidget {
  final LotteryEvent event;
  final bool isSelected;
  final bool isLastItem;
  final VoidCallback onTap;
  const LotteryEventCard({
    super.key,
    this.isLastItem = false,
    required this.isSelected,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ScaleButton(
        onTap: onTap,
        onLongPress: () => showDeleteLotteryEventDialog(event),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondaryLight : AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primaryLight,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      event.eventTitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.primaryLight,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.calendar,
                    color: isSelected ? Colors.white : AppColors.primaryLight,
                    size: 16,
                  ),
                  const Gap(8),
                  Text(
                    formatDate(event.eventDate),
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
