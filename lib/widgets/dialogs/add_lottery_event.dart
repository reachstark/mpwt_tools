import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/models/lottery_event.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

void showAddLotteryEventDialog({
  required bool isUpdating,
  LotteryEvent? lotteryEvent,
}) {
  Get.dialog(AddLotteryEventDialog(
    isUpdating: isUpdating,
    lotteryEvent: lotteryEvent,
  ));
}

class AddLotteryEventDialog extends StatefulWidget {
  final bool isUpdating;
  final LotteryEvent? lotteryEvent;
  const AddLotteryEventDialog({
    super.key,
    required this.isUpdating,
    this.lotteryEvent,
  });

  @override
  State<AddLotteryEventDialog> createState() => _AddLotteryEventDialogState();
}

class _AddLotteryEventDialogState extends State<AddLotteryEventDialog> {
  final dbX = Get.find<DbController>();

  DateTime eventDate = DateTime.now();
  final TextEditingController _titleController = TextEditingController();

  Future<void> _selectDate() async {
    final lastYear = DateTime.now().year - 1;
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: eventDate,
      firstDate: DateTime(lastYear),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        eventDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.isUpdating) {
      _titleController.text = widget.lotteryEvent!.eventTitle;
      eventDate = widget.lotteryEvent!.eventDate;
    }
    super.initState();
  }

  Future<void> _updateLotteryEvent() async {
    if (_titleController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter an event title",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
      );
      return;
    }

    await dbX
        .updateLotteryEvent(
          widget.lotteryEvent!.id,
          LotteryEvent(
            eventDate: eventDate,
            eventTitle: _titleController.text.trim(),
            createdAt: widget.lotteryEvent!.createdAt,
            eventPrizes: widget.lotteryEvent!.eventPrizes,
          ),
        )
        .whenComplete(
          () => Get.back(),
        );
  }

  Future<void> _addLotteryEvent() async {
    if (_titleController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter an event title",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
      );
      return;
    }

    final res = await dbX.createLotteryEvent(
      LotteryEvent(
        eventDate: eventDate,
        eventTitle: _titleController.text.trim(),
        createdAt: DateTime.now(),
        eventPrizes: [],
      ),
    );

    if (res['success']) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Title and Close Button**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isUpdating
                      ? 'កែប្រែព្រឹត្តិការណ៍រង្វាន់'
                      : 'បញ្ចូលព្រឹត្តិការណ៍រង្វាន់ថ្មី',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryLight,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.xmark,
                    color: Colors.black54,
                  ),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const Gap(16),

            /// **Event Title Field**
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'ឈ្មោះព្រឹត្តិការណ៍រង្វាន់',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.primaryLight,
                    width: 2,
                  ),
                ),
                hintText: 'ឈ្មោះព្រឹត្តិការណ៍រង្វាន់ថ្មី',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(FontAwesomeIcons.pen, size: 16),
              ),
            ),
            const Gap(12),

            /// **Date Picker**
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(FontAwesomeIcons.calendar, size: 16),
                    const SizedBox(width: 10),
                    Text(
                      "${eventDate.day}/${eventDate.month}/${eventDate.year}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    const Icon(FontAwesomeIcons.caretDown),
                  ],
                ),
              ),
            ),
            const Gap(24),

            /// **Action Buttons**
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    "បោះបង់",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
                const Gap(12),
                ElevatedButton.icon(
                  onPressed: () => widget.isUpdating
                      ? _updateLotteryEvent()
                      : _addLotteryEvent(),
                  icon: Icon(
                    FontAwesomeIcons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(widget.isUpdating ? "កែប្រែ" : "បញ្ចូល",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
