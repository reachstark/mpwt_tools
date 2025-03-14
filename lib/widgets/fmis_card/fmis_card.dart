import 'package:estimation_list_generator/models/fmis_code.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/copy_text.dart';
import 'package:estimation_list_generator/utils/format_riel_currency.dart';
import 'package:estimation_list_generator/utils/get_time_passed.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:estimation_list_generator/widgets/horizontal_data.dart';
import 'package:estimation_list_generator/widgets/scale_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class FmisCard extends StatefulWidget {
  final int index;
  final bool isLastItem;
  final FmisCode item;

  const FmisCard(
      {super.key,
      required this.index,
      required this.isLastItem,
      required this.item});

  @override
  State<FmisCard> createState() => _FmisCardState();
}

class _FmisCardState extends State<FmisCard> {
  bool isShown = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          margin: !widget.isLastItem ? const EdgeInsets.only(bottom: 8) : null,
          decoration: BoxDecoration(
            color: AppColors.backgroundLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Gap(8),
              SizedBox(
                width: 26,
                child: Text(
                  '${widget.index + 1}',
                  style: const TextStyle(
                    color: AppColors.primaryLight,
                    fontSize: 18,
                  ),
                ),
              ),
              const Gap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.projectId,
                    style: const TextStyle(
                      fontFamily: kantumruy,
                      color: AppColors.primaryLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formatRielCurrency(widget.item.projectBudget),
                    style: const TextStyle(
                      fontFamily: siemreap,
                      color: AppColors.midnightBlue,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Gap(8),
              ScaleButton(
                onTap: () {
                  setState(() {
                    isShown = !isShown;
                  });
                },
                child: Icon(
                  !isShown ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                  color: AppColors.primaryLight,
                ),
              ),
              const Gap(8),
            ],
          ),
        ),
        if (isShown) ...[
          if (widget.isLastItem) const Gap(8),
          Row(
            children: [
              Expanded(
                child: HorizontalData(
                  icon: FontAwesomeIcons.fileCode,
                  title: 'កូដ FMIS:',
                  data: widget.item.fmisCode,
                  dataSize: 18,
                ),
              ),
              const Gap(12),
              SizedBox(
                width: 150,
                child: ElevatedButton.icon(
                  onPressed: () => copyText(widget.item.fmisCode),
                  icon: const Icon(
                    FontAwesomeIcons.copy,
                    size: 16,
                    color: AppColors.white,
                  ),
                  label: Text('Copy'),
                ),
              ),
            ],
          ),
          const Gap(8),
          Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(
                widget.item.projectDetail.replaceAll('ម២', 'ម²'),
                style: const TextStyle(
                  fontFamily: siemreap,
                  fontFeatures: [FontFeature.superscripts()],
                ),
              ),
            ),
          ),
          const Gap(8),
          Row(
            children: [
              ScaleButton(
                tooltip: formatDateAndTime(widget.item.createdAt),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primaryLight,
                  size: 18,
                ),
              ),
              const Gap(4),
              Text(
                'បានបញ្ចូល ${getTimeHasPassed(widget.item.createdAt)}',
                style: TextStyle(
                  fontFamily: siemreap,
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
          const Gap(8),
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.circleUser,
                color: AppColors.primaryLight,
                size: 18,
              ),
              const Gap(4),
              Text(
                'ដោយ ${widget.item.createdBy}',
                style: TextStyle(
                  fontFamily: siemreap,
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
          const Gap(8),
        ],
      ],
    );
  }
}
