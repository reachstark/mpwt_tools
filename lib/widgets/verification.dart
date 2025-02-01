import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/screens/lottery/lottery_list.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

void launchVerificationDialog() {
  Get.dialog(
    Verification(),
  );
}

class Verification extends StatefulWidget {
  const Verification({
    super.key,
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
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: AppColors.primaryLight,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(16),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.darkerRed),
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

    return Dialog(
      backgroundColor: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              pinController.text == dbX.masterKey.value
                  ? Icons.check_circle_rounded
                  : Icons.lock_rounded,
              color: AppColors.primaryLight,
              size: height / 6,
            ),
            const Gap(16),
            Text(
              'បញ្ចូលលេខកូដដើម្បីបន្ត',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primaryLight,
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
              errorTextStyle: const TextStyle(
                color: AppColors.darkerRed,
              ),
              onCompleted: (value) => setState(() {}),
              onChanged: (value) async {
                if (value == dbX.masterKey.value) {
                  Future.delayed(
                    const Duration(milliseconds: 300),
                    () => Get.back(),
                  ).whenComplete(
                    () => Get.to(
                      () => const LotteryList(),
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
            const Gap(16),
          ],
        ),
      ),
    );
  }
}

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(16),
        SvgPicture.asset(
          svgSpecialEvent,
          height: height / 2,
        ),
        const Gap(16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryLight),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.circleInfo,
                color: AppColors.primaryLight,
              ),
              const Gap(8),
              Flexible(
                child: Text(
                  'មុខងារនេះមានទិន្នន័យសម្ងាត់ សូមផ្ទៀងផ្ទាត់មុនពេលប្រើប្រាស់។',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(16),
        ElevatedButton(
          onPressed: () => launchVerificationDialog(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_open_rounded, color: Colors.white),
              const Gap(8),
              Text('Verify'),
            ],
          ),
        ),
      ],
    );
  }
}
