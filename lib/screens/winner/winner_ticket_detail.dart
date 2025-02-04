import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/launch_confetti.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class WinnerTicketDetail extends StatelessWidget {
  const WinnerTicketDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dbX = Get.find<DbController>();

    return Drawer(
      width: width * 0.3,
      child: Obx(
        () {
          bool isClaimed = dbX.selectedWinner.value.isClaimed;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                Text(
                  'លេខសំណាង',
                  style: const TextStyle(
                    fontSize: 24,
                    color: AppColors.primaryLight,
                  ),
                ),
                const Gap(16),
                Text(
                  dbX.selectedWinner.value.ticketNumber,
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    fontFamily: siemreap,
                    color: AppColors.primaryLight,
                  ),
                ),
                const Gap(16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isClaimed ? Colors.green : AppColors.mpwtYellow,
                    ),
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isClaimed ? Icons.check : Icons.warning_amber_rounded,
                        color: isClaimed ? Colors.green : AppColors.mpwtYellow,
                      ),
                      const Gap(8),
                      Text(
                        isClaimed
                            ? 'លេខរង្វាន់នេះបានបើកជូនរួចហើយ'
                            : 'លេខរង្វាន់នេះមិនទាន់បានបើកជូនទេ',
                        style: TextStyle(
                          fontSize: 18,
                          color:
                              isClaimed ? Colors.green : AppColors.mpwtYellow,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                SwitchListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: isClaimed ? Colors.green : AppColors.mpwtYellow,
                  title: Text('បើកជូន', style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    'ចុចដើម្បីផ្លាស់ប្តូរ Status',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: siemreap,
                      color: AppColors.white,
                    ),
                  ),
                  value: dbX.selectedWinner.value.isClaimed,
                  onChanged: (value) {
                    dbX.switchTicketClaimStatus(
                        dbX.selectedWinner.value.id, value);
                    launchConfetti(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
