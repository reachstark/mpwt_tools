import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/models/event_prize.dart';
import 'package:estimation_list_generator/widgets/scale_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

void showDeleteLotteryPrizeDialog(EventPrize prize) {
  Get.dialog(DeleteLotteryPrize(prize: prize));
}

class DeleteLotteryPrize extends StatelessWidget {
  final EventPrize prize;
  const DeleteLotteryPrize({super.key, required this.prize});

  @override
  Widget build(BuildContext context) {
    final dbX = Get.find<DbController>();

    void deletePrize() async {
      await dbX
          .deleteLotteryPrize(dbX.selectedLotteryEvent.value.id, prize.id)
          .whenComplete(() => Get.back());
    }

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
            // Icon
            Icon(
              FontAwesomeIcons.trash,
              color: Colors.red,
              size: 50,
            ),
            const Gap(12),

            // Title
            Text(
              'លុបរង្វាន់?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Gap(8),

            // Prize Info
            Text(
              'តើអ្នកប្រាកដថាចង់លុប "${prize.prizeTitle}" ទេ?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const Gap(8),
            Text('បរិមាណរង្វាន់ ${prize.quantity} នឹងត្រូវបានដកចេញ',
                style: TextStyle(fontSize: 14)),
            const Gap(20),

            // Buttons
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
                    onTap: () => deletePrize(),
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
