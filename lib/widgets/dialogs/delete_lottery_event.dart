import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/models/lottery_event.dart';
import 'package:estimation_list_generator/widgets/scale_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

void showDeleteLotteryEventDialog(LotteryEvent event) {
  Get.dialog(DeleteLotteryEvent(event: event));
}

class DeleteLotteryEvent extends StatelessWidget {
  final LotteryEvent event;
  const DeleteLotteryEvent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final dbX = Get.find<DbController>();

    void deleteEvent() async {
      await dbX.deleteLotteryEvent(event.id).whenComplete(() => Get.back());
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
              'លុបព្រឹត្តការណ៍រង្វាន់?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Gap(8),

            // Prize Info
            Text(
              'តើអ្នកប្រាកដថាចង់លុប <<${event.eventTitle}>> ទេ?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const Gap(8),
            Text(
                'ទិន្នន័យទាំងអស់នឹងត្រូវបានលុបជាអចិន្ត្រៃយ៍ ហើយមិនអាចត្រឡប់វិញបានទេ',
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
                    onTap: () => deleteEvent(),
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
