import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/screens/lottery/lottery_list.dart';
import 'package:estimation_list_generator/screens/winner/winner_list_admin.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/custom_card.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

enum VerificationType {
  lotteryEvent,
  winnerAdmin,
}

void launchVerificationDialog(VerificationType type) {
  Get.dialog(Verification(type: type));
}

class Verification extends StatefulWidget {
  final VerificationType type;
  const Verification({
    super.key,
    required this.type,
  });

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final focusNode = FocusNode();
  final pinController = TextEditingController();
  final appX = Get.find<AppController>();
  final dbX = Get.find<DbController>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: appX.isDarkMode.value ? AppColors.white : AppColors.primaryLight,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
            color: appX.isDarkMode.value
                ? AppColors.white
                : AppColors.primaryLight),
        borderRadius: BorderRadius.circular(16),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
          color: appX.isDarkMode.value
              ? AppColors.cosmicRed
              : AppColors.darkerRed),
    );

    Widget switchButton() {
      if (pinController.text == dbX.masterKey.value) {
        return CircularProgressIndicator();
      }

      return ElevatedButton(
        onPressed: () {
          setState(() {
            pinController.clear();
          });
          focusNode.requestFocus();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_rounded, color: Colors.white),
            const Gap(8),
            Text('លុបលេខកូដ'),
          ],
        ),
      );
    }

    return Obx(
      () => Dialog(
        backgroundColor:
            appX.isDarkMode.value ? AppColors.primaryLight : AppColors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (dbX.masterKey.value.isEmpty) ...[],
              if (dbX.masterKey.value.isNotEmpty) ...[
                Icon(
                  pinController.text == dbX.masterKey.value
                      ? Icons.check_circle_rounded
                      : Icons.lock_rounded,
                  color: appX.isDarkMode.value
                      ? AppColors.white
                      : AppColors.primaryLight,
                  size: height / 6,
                ),
                const Gap(16),
                Text(
                  'បញ្ចូលលេខកូដដើម្បីបន្ត',
                  style: TextStyle(
                    fontSize: 18,
                    color: appX.isDarkMode.value
                        ? AppColors.white
                        : AppColors.primaryLight,
                  ),
                ),
                const Gap(16),
                Pinput(
                  controller: pinController,
                  focusNode: focusNode,
                  length: int.parse(dbX.masterKey.value).toString().length,
                  autofocus: true,
                  obscureText: true,
                  obscuringCharacter: '*',
                  defaultPinTheme: defaultPinTheme,
                  errorPinTheme: errorPinTheme,
                  errorTextStyle: TextStyle(
                    color: appX.isDarkMode.value
                        ? AppColors.cosmicRed
                        : AppColors.darkerRed,
                  ),
                  onCompleted: (value) => setState(() {}),
                  onChanged: (value) async {
                    if (value == dbX.masterKey.value) {
                      Future.delayed(
                        const Duration(milliseconds: 300),
                        () => Get.back(),
                      ).whenComplete(
                        () => Get.to(
                          () => widget.type == VerificationType.lotteryEvent
                              ? const LotteryList()
                              : const WinnerListAdmin(),
                          transition: Transition.cupertino,
                          duration: const Duration(milliseconds: 300),
                        ),
                      );
                    }
                  },
                  validator: (value) {
                    if (value != dbX.masterKey.value) {
                      return 'លេខកូដមិនត្រឹមត្រូវ';
                    }
                    return null;
                  },
                ),
                const Gap(16),
                switchButton(),
              ],
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Gap(height / 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              svgSpecialEvent,
              height: width / 4,
            ),
            CustomCard(
              heading: 'Verification',
              description:
                  'មុខងារនេះមានទិន្នន័យសម្ងាត់ សូមផ្ទៀងផ្ទាត់មុនពេលប្រើប្រាស់។',
              onTap: () =>
                  launchVerificationDialog(VerificationType.lotteryEvent),
            ),
          ],
        ),
      ],
    );
  }
}
