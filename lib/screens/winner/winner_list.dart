import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_lottie.dart';
import 'package:estimation_list_generator/utils/launch_confetti.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/db_controller.dart';

class WinnerList extends StatefulWidget {
  const WinnerList({
    super.key,
  });

  @override
  State<WinnerList> createState() => _WinnerListState();
}

class _WinnerListState extends State<WinnerList> {
  final scrollController = ScrollController();
  final dbX = Get.find<DbController>();

  @override
  void initState() {
    // Auto-scroll when a new winner is added
    ever(dbX.lotteryWinners, (_) {
      launchConfetti(context);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent + 200,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastEaseInToSlowEaseOut,
          );
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    Widget leftPaneList() {
      return Expanded(
        child: Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.trophy,
                      color: AppColors.primaryLight,
                      size: clampDouble(width * 0.02, 16, 28),
                    ),
                    const Gap(12),
                    Text(
                      'បញ្ជីរអ្នកទទួលរង្វាន់',
                      style: TextStyle(
                        fontSize: clampDouble(width * 0.02, 16, 28),
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: scrollController,
                        itemCount: dbX.lotteryWinners.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool isLastItem =
                              index == dbX.lotteryWinners.length - 1;

                          return Container(
                            margin: isLastItem
                                ? const EdgeInsets.only(bottom: 16)
                                : null,
                            child: ListTile(
                              tileColor: Colors.transparent,
                              leading: Text(
                                '${index + 1}.',
                                style: TextStyle(
                                  color: AppColors.primaryLight,
                                  fontSize: 14,
                                  fontFamily: moulLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              title: Text(
                                dbX.lotteryWinners[index].lotteryPrize,
                                style: TextStyle(
                                  fontSize: width * 0.014,
                                  color: AppColors.primaryLight,
                                ),
                              ),
                              trailing: Text(
                                dbX.lotteryWinners[index].ticketNumber,
                                style: TextStyle(
                                  color: AppColors.primaryLight,
                                  fontSize: width * 0.02,
                                  fontFamily: moulLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Top fade effect
                      Align(
                        alignment: Alignment.topCenter,
                        child: IgnorePointer(
                          child: Container(
                            height: 30,
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.white.withValues(alpha: 0.8),
                                  AppColors.white.withValues(alpha: 0.02),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Bottom fade effect
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: IgnorePointer(
                          child: Container(
                            height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.white.withValues(alpha: 0.02),
                                  AppColors.white.withValues(alpha: 0.8),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget rightPane() {
      return Obx(
        () {
          if (dbX.lotteryWinners.isEmpty) {
            return SizedBox();
          }

          String lastTicketNumber = dbX.lotteryWinners.last.ticketNumber;

          return Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'អ្នកឈ្នះចុងក្រោយបំផុត',
                  style: TextStyle(
                    fontSize: width * 0.02,
                    color: AppColors.primaryLight,
                  ),
                ),
                Gap(height * 0.02),
                Container(
                  width: clampDouble(width * 0.45, 420, 620),
                  height: clampDouble(height * 0.4, 370, 570),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset(
                        AppLottie.winnerBackground,
                        width: width,
                      ),
                      Animate(
                        key: ValueKey(lastTicketNumber),
                        effects: [
                          FadeEffect(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.easeInOut,
                          ),
                          ScaleEffect(
                            duration: Duration(milliseconds: 1500),
                            curve: Curves.fastEaseInToSlowEaseOut,
                          ),
                          SlideEffect(
                            begin: Offset(0, -6),
                            end: Offset.zero,
                            duration: Duration(milliseconds: 1200),
                            curve: Curves.easeOutBack,
                          ),
                          ShimmerEffect(
                            duration: Duration(seconds: 2),
                          ),
                        ],
                        child: Text(
                          lastTicketNumber,
                          style: TextStyle(
                            fontSize: width * 0.13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            letterSpacing: 10,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black.withValues(alpha: 0.5),
                                offset: Offset(3, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 36,
                        child: Icon(
                          FontAwesomeIcons.award,
                          color: AppColors.primaryLight,
                          size: clampDouble(width * 0.02, 28, 42),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    leftPaneList(),
                    rightPane(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Row(
              children: [
                buildInternetStatus(),
                Gap(22),
                buildSubscribeStatus(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildInternetStatus() {
  final appX = Get.find<AppController>();

  return Obx(
    () {
      String switchStatus() {
        switch (appX.hasNetwork.value) {
          case true:
            return 'អ៊ីនធឺណិតត្រូវបានភ្ជាប់';
          case false:
            return 'អ៊ីនធឺណិត​ត្រូវ​បាន​ផ្ដាច់';
        }
      }

      Color switchStatusColor() {
        switch (appX.hasNetwork.value) {
          case true:
            return Colors.green;
          case false:
            return Colors.red;
        }
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: switchStatusColor(),
          border: Border.all(color: switchStatusColor()),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: switchStatusColor().withValues(alpha: 0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.wifi,
              color: Colors.white,
              size: 18,
            ),
            const Gap(8),
            Text(
              switchStatus(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget buildSubscribeStatus() {
  final dbX = Get.find<DbController>();

  return Obx(
    () {
      String switchStatus() {
        switch (dbX.subscribeStatus.value) {
          case 'active':
            return 'ប្រព័ន្ធកំពុងដំណើរការ';
          case 'disconnected':
            return 'ការតភ្ជាប់បានបរាជ័យ';
          case 'none':
            return 'ប្រព័ន្ធត្រូវការតភ្ជាប់';
          default:
            return 'ប្រព័ន្ធមិនដំណើរការ';
        }
      }

      Color switchStatusColor() {
        switch (dbX.subscribeStatus.value) {
          case 'active':
            return Colors.green;
          case 'disconnected':
            return Colors.red;
          case 'none':
            return AppColors.vibrantOrange;
          default:
            return AppColors.vibrantOrange;
        }
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: switchStatusColor(),
          border: Border.all(color: switchStatusColor()),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: switchStatusColor().withValues(alpha: 0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.wifi,
              color: Colors.white,
              size: 18,
            ),
            const Gap(8),
            Text(
              switchStatus(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    },
  );
}
