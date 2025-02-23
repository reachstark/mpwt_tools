import 'dart:ui';

import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/screens/winner/winner_list.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_lottie.dart';
import 'package:estimation_list_generator/utils/launch_confetti.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:estimation_list_generator/widgets/gradient_icon_button.dart';
import 'package:estimation_list_generator/widgets/winner_view_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

void launchWinnerListView() {
  Get.to(
    () => const WinnerListView(),
    transition: Transition.cupertino,
  );
}

class WinnerListView extends StatefulWidget {
  const WinnerListView({super.key});

  @override
  State<WinnerListView> createState() => _WinnerListViewState();
}

class _WinnerListViewState extends State<WinnerListView> {
  final dbX = Get.find<DbController>();
  bool showDrawer = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    dbX.stopListeningToWinnerChanges();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    double appBarHeight = clampDouble(height / 8, 80, 110);

    Widget buildWinnerList() {
      if (dbX.selectedLotteryEvent.value.id != 0) {
        return const WinnerList();
      } else {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                AppLottie.notFound,
                height: height / 2,
              ),
            ],
          ),
        );
      }
    }

    return KeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          setState(() {
            showDrawer = false;
          });
        }

        if (event.logicalKey == LogicalKeyboardKey.backspace) {
          launchConfetti(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(
          () => Stack(
            children: [
              Positioned(
                right: -22,
                bottom: -52,
                child: Icon(
                  FontAwesomeIcons.trophy,
                  color: AppColors.primaryLight.withValues(
                    alpha: 0.1,
                  ),
                  size: clampDouble(width / 5, 150, 320),
                ),
              ),
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: width,
                        padding: EdgeInsets.symmetric(horizontal: width / 20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                        ),
                        height: appBarHeight,
                        child: Center(
                          child: Animate(
                            onPlay: (controller) => controller.repeat(),
                            effects: const [
                              ShimmerEffect(
                                color: AppColors.mpwtYellow,
                                delay: Duration(seconds: 4),
                                duration: Duration(milliseconds: 1800),
                              ),
                            ],
                            child: Text(
                              dbX.selectedLotteryEvent.value.id == 0
                                  ? 'សូមជ្រើសរើសព្រឹត្តិការណ៍ដើម្បីបង្ហាញទិន្នន័យ'
                                  : dbX.selectedLotteryEvent.value.eventTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryLight,
                                fontSize: clampDouble(height * 0.03, 18, 26),
                                fontFamily: moulLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 32,
                        child: GradientIconButton(
                          tooltip: 'Show menu',
                          icon: FontAwesomeIcons.bars,
                          onClick: () {
                            setState(() {
                              showDrawer = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  buildWinnerList(),
                ],
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastEaseInToSlowEaseOut,
                left: showDrawer ? 0 : -width / 3,
                child: WinnerListViewDrawer(
                  onTapBack: () {
                    setState(() => showDrawer = false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
