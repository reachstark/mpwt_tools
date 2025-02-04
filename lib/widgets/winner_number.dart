import 'dart:ui';

import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class WinnerNumber extends StatefulWidget {
  final int i;
  final String ticketNumber;
  const WinnerNumber({
    super.key,
    required this.i,
    required this.ticketNumber,
  });

  @override
  State<WinnerNumber> createState() => _WinnerNumberState();
}

class _WinnerNumberState extends State<WinnerNumber> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isHovered ? AppColors.primaryLight : AppColors.backgroundLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.1,
              ),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isHovered
                    ? AppColors.primaryLight
                    : AppColors.backgroundLight,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                (widget.i + 1).toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: siemreap,
                  color: AppColors.white,
                  fontSize: clampDouble(height * 0.02, 18, 22),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:
                    isHovered ? AppColors.mpwtYellow : AppColors.primaryLight,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FontAwesomeIcons.hashtag,
                    color: AppColors.white,
                    size: clampDouble(height * 0.02, 16, 18),
                  ),
                  const Gap(8),
                  Text(
                    widget.ticketNumber,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: siemreap,
                      color: AppColors.white,
                      fontSize: clampDouble(height * 0.02, 22, 26),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
