import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/models/event_prize.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_images.dart';
import 'package:estimation_list_generator/utils/generate_id.dart';
import 'package:estimation_list_generator/widgets/scale_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

void showAddLotteryPrizeItemDialog({
  required bool isUpdating,
  EventPrize? selectedPrize,
}) {
  Get.dialog(AddLotteryPrizeItem(
    isUpdating: isUpdating,
    selectedPrize: selectedPrize,
  ));
}

class AddLotteryPrizeItem extends StatefulWidget {
  final bool isUpdating;
  final EventPrize? selectedPrize;
  const AddLotteryPrizeItem({
    super.key,
    required this.isUpdating,
    this.selectedPrize,
  });

  @override
  State<AddLotteryPrizeItem> createState() => _AddLotteryPrizeItemState();
}

class _AddLotteryPrizeItemState extends State<AddLotteryPrizeItem> {
  final titleController = TextEditingController();
  final quantityController = TextEditingController();
  final appX = Get.find<AppController>();
  final dbX = Get.find<DbController>();

  int quantity = 10;
  bool isTopPrize = false;

  @override
  void initState() {
    if (!widget.isUpdating) {
      quantityController.text = quantity.toString(); // defaults to 10
    } else {
      titleController.text = widget.selectedPrize!.prizeTitle;
      quantityController.text = widget.selectedPrize!.quantity.toString();
      isTopPrize = widget.selectedPrize!.isTopPrize;
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  Future<void> updatePrizeItem() async {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a prize title",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
      );
      return;
    }
    await dbX
        .updateLotteryPrize(
          dbX.selectedLotteryEvent.value.id,
          EventPrize(
            id: widget.selectedPrize!.id,
            prizeTitle: titleController.text.trim(),
            isTopPrize: isTopPrize,
            quantity: quantity,
          ),
        )
        .whenComplete(
          () => Get.back(),
        );
  }

  Future<void> addPrizeItem() async {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a prize title",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
      );
      return;
    }
    await dbX
        .addLotteryPrize(
          dbX.selectedLotteryEvent.value.id,
          EventPrize(
            id: generateID(),
            prizeTitle: titleController.text.trim(),
            isTopPrize: isTopPrize,
            quantity: quantity,
          ),
        )
        .whenComplete(
          () => Get.back(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: appX.isDarkMode.value
                ? AppColors.primaryLight
                : AppColors.white,
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
                    widget.isUpdating ? 'កែប្រែរង្វាន់' : 'បន្ថែមរង្វាន់ថ្មី',
                    style: TextStyle(
                      fontSize: 18,
                      color: appX.isDarkMode.value
                          ? Colors.white
                          : AppColors.primaryLight,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.xmark,
                      color:
                          appX.isDarkMode.value ? Colors.white : Colors.black54,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Gap(16),

              /// **Title Input Field**
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'ឈ្មោះរង្វាន់',
                      ),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => quantity = int.parse(value),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'បរិមាណ',
                        suffix: Visibility(
                          visible: !widget.isUpdating,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ScaleButton(
                                onTap: () {
                                  setState(() {
                                    quantity--;
                                    if (quantity < 1) quantity = 1;
                                    quantityController.text =
                                        quantity.toString();
                                  });
                                },
                                tooltip: 'ដក -1',
                                child: const Icon(
                                  FontAwesomeIcons.circleMinus,
                                  size: 18,
                                ),
                              ),
                              const Gap(8),
                              ScaleButton(
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                    quantityController.text =
                                        quantity.toString();
                                  });
                                },
                                tooltip: 'បន្ថែម +1',
                                child: Icon(
                                  FontAwesomeIcons.circlePlus,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: appX.isDarkMode.value
                      ? AppColors.secondaryLight
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      value: isTopPrize,
                      onChanged: (value) {
                        setState(
                          () => isTopPrize = !isTopPrize,
                        );
                      },
                    ),
                    const Gap(8),
                    Text(
                      'ជារង្វាន់ធំ',
                      style: TextStyle(
                        color: appX.isDarkMode.value
                            ? Colors.white
                            : AppColors.primaryLight,
                      ),
                    ),
                    const Gap(8),
                    Image.asset(AppImages.iconCrown, height: 24),
                  ],
                ),
              ),
              const Gap(16),

              /// **Action Buttons**
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "បោះបង់",
                      style: TextStyle(
                        color: appX.isDarkMode.value
                            ? Colors.white
                            : Colors.black54,
                      ),
                    ),
                  ),
                  const Gap(12),
                  ElevatedButton.icon(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (widget.isUpdating) {
                        updatePrizeItem();
                      } else {
                        addPrizeItem();
                      }
                    },
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
      ),
    );
  }
}
