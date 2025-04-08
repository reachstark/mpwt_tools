import 'package:choice/choice.dart';
import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_theme.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final appX = Get.find<AppController>();

    return Obx(
      () {
        List<Widget> settingItems = [
          SettingCard(
            title: 'Modern UI',
            description: 'Use modern and sleek User Interface',
            initialValue: !appX.useClassicTheme.value,
            onChanged: (value) => appX.toggleTheme(true),
          ),
          SettingCard(
            title: 'Tinted Blue',
            description: appX.useTintedBlue.value
                ? 'Using tinted blue as background color'
                : 'Apply tinted blue color scheme instead of white',
            initialValue: appX.useTintedBlue.value,
            onChanged: (value) => appX.toggleTintedBlue(value),
          ),
        ];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                settings,
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontSize: 32,
                ),
              ),
              const Gap(16),
              Text(
                'These settings only apply to the Modern UI.',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontSize: 16,
                ),
              ),
              const Gap(32),
              Choice.inline(
                itemCount: settingItems.length,
                itemBuilder: (state, i) => settingItems[i],
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingCard extends StatefulWidget {
  final String title;
  final String description;
  final bool initialValue; // Add initial value for the switch
  final ValueChanged<bool>? onChanged; // Add onChanged callback

  const SettingCard({
    super.key,
    required this.title,
    required this.description,
    this.initialValue = false,
    this.onChanged,
  });

  @override
  State<SettingCard> createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  bool isHovered = false;
  bool _switchValue = false; // Internal switch value

  @override
  void initState() {
    super.initState();
    _switchValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => isHovered = true),
      onExit: (event) => setState(() => isHovered = false),
      child: AnimatedContainer(
        constraints: const BoxConstraints(maxWidth: 400),
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastEaseInToSlowEaseOut,
        padding: EdgeInsets.all(isHovered ? 16 : 8),
        decoration: BoxDecoration(
          color: isHovered ? AppColors.primaryLight : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: blurShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color:
                          isHovered ? AppColors.white : AppColors.primaryLight,
                      fontSize: 22,
                      fontFamily: roboto,
                    ),
                  ),
                ),
                Switch(
                  value: _switchValue,
                  onChanged: (bool value) {
                    setState(() {
                      _switchValue = value;
                    });
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  },
                ),
              ],
            ),
            Text(
              widget.description,
              style: TextStyle(
                color: isHovered ? AppColors.white : AppColors.primaryLight,
                fontSize: 16,
                fontFamily: roboto,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
