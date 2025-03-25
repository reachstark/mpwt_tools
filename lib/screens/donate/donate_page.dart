import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_lottie.dart';
import 'package:estimation_list_generator/utils/app_theme.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:estimation_list_generator/widgets/horizontal_data.dart';
import 'package:estimation_list_generator/widgets/scale_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  String bankSelected = 'ABA';

  @override
  Widget build(BuildContext context) {
    String donateInfo =
        'ប្រព័ន្ធនេះគឺឥតគិតថ្លៃទាំងស្រុងក្នុងការប្រើប្រាស់។ អ្នកមិនតម្រូវឱ្យបង់ប្រាក់ជាសាច់ប្រាក់ដើម្បីបន្តប្រើប្រាស់ប្រព័ន្ធនេះទេ។ ទោះជាយ៉ាងណាក៏ដោយ អ្នកអាចបរិច្ចាគមួយចំនួនដើម្បីរក្សាអ្នកអភិវឌ្ឍន៍នេះឱ្យសប្បាយចិត្ត និងរក្សាប្រព័ន្ធនេះឱ្យទាន់សម័យក្នុងរយៈពេលវែង។';
    Color switchSelectBankColor() {
      switch (bankSelected) {
        case 'ABA':
          return Color(0xFF004973);
        case 'Wing':
          return Color(0xFFa9cf38);
        default:
          return AppColors.primaryLight;
      }
    }

    return Column(
      children: [
        const Gap(32),
        Stack(
          alignment: Alignment.center,
          children: [
            Lottie.asset(
              AppLottie.blockyBackground,
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: blurShadow,
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage(
                      devProfilePic,
                    ),
                  ),
                ),
                const Gap(32),
                Container(
                  width: 580,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: AppColors.white,
                    boxShadow: blurShadow,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(FontAwesomeIcons.circleInfo),
                      const Gap(12),
                      Expanded(
                        child: Text(
                          donateInfo,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 13,
                            fontFamily: kantumruy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(32),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.0),
                    color: Colors.white30,
                    boxShadow: blurShadow,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 207,
                        width: 207,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: AppColors.white,
                          border: Border.all(
                            width: 4,
                            color: switchSelectBankColor(),
                          ),
                          boxShadow: blurShadow,
                        ),
                        child: Image.asset(
                          bankSelected == 'ABA' ? devABAQR : devWingQR,
                        ),
                      ),
                      const Gap(16),
                      Container(
                        width: 350,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: AppColors.white,
                          boxShadow: blurShadow,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: buildBankButton(
                                    bankName: 'ABA',
                                    buttonColor: Color(0xFF004973),
                                    onTap: () {
                                      setState(() {
                                        bankSelected = 'ABA';
                                      });
                                    },
                                  ),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: buildBankButton(
                                      bankName: 'Wing Bank',
                                      buttonColor: Color(0xFFa9cf38),
                                      onTap: () {
                                        setState(() {
                                          bankSelected = 'Wing';
                                        });
                                      }),
                                ),
                              ],
                            ),
                            const Gap(16),
                            HorizontalData(
                              icon: FontAwesomeIcons.buildingColumns,
                              title: 'Bank Name:',
                              data: bankSelected == 'ABA'
                                  ? 'ABA Bank'
                                  : 'Wing Bank',
                            ),
                            const Gap(16),
                            HorizontalData(
                              icon: FontAwesomeIcons.buildingColumns,
                              title: 'Account Number:',
                              data: bankSelected == 'ABA'
                                  ? '003 320 620'
                                  : '100 940 369',
                            ),
                            const Gap(16),
                            HorizontalData(
                              icon: FontAwesomeIcons.circleUser,
                              title: 'Account Holder Name:',
                              data: 'LE BORITHEAREACH',
                            ),
                            const Gap(16),
                            HorizontalData(
                              icon: FontAwesomeIcons.moneyBill,
                              title: 'Account Currency:',
                              data: bankSelected == 'ABA' ? 'USD' : 'KHR',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBankButton({
    required String bankName,
    required Color buttonColor,
    VoidCallback? onTap,
  }) {
    return ScaleButton(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: buttonColor,
        ),
        child: Text(
          bankName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: moulLight,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
