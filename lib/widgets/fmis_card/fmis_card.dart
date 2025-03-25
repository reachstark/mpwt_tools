import 'package:estimation_list_generator/controllers/db_controller.dart';
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
import 'package:get/get.dart';

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
                width: 100,
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
              const Gap(12),
              IconButton(
                tooltip: 'លុបគម្រោង',
                onPressed: () =>
                    Get.dialog(DeleteFmisDialog(item: widget.item)),
                icon: Icon(
                  FontAwesomeIcons.trashCan,
                  size: 18,
                  color: AppColors.cosmicRed,
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

class DeleteFmisDialog extends StatelessWidget {
  final FmisCode item;
  const DeleteFmisDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final dbX = Get.find<DbController>();
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.trash,
              color: Colors.red,
              size: 50,
            ),
            const Gap(12),
            Text(
              'លុបព្រឹត្តការណ៍រង្វាន់?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Gap(8),
            Text(
              'តើអ្នកប្រាកដថាចង់លុប ${item.projectId} ទេ?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: kantumruy,
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const Gap(8),
            Text(
                'ទិន្នន័យទាំងអស់នឹងត្រូវបានលុបជាអចិន្ត្រៃយ៍ ហើយមិនអាចត្រឡប់វិញបានទេ',
                style: TextStyle(
                  fontFamily: kantumruy,
                  fontSize: 14,
                )),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ScaleButton(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'បោះបង់',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: ScaleButton(
                    onTap: () => dbX
                        .deleteFmisCode(item.id)
                        .whenComplete(() => Get.back()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'យល់ព្រម',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
