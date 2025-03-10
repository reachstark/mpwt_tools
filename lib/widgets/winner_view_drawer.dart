import 'package:estimation_list_generator/main.dart';
import 'package:estimation_list_generator/models/lottery_event.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:estimation_list_generator/widgets/dotted_line.dart';
import 'package:estimation_list_generator/widgets/gradient_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controllers/db_controller.dart';

class WinnerListViewDrawer extends StatefulWidget {
  final VoidCallback? onTapBack;
  const WinnerListViewDrawer({
    super.key,
    this.onTapBack,
  });

  @override
  State<WinnerListViewDrawer> createState() => _WinnerListViewDrawerState();
}

class _WinnerListViewDrawerState extends State<WinnerListViewDrawer> {
  final dbX = Get.find<DbController>();
  List<DropdownMenuItem<LotteryEvent>> eventLists = [];
  LotteryEvent? selectedEvent;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    eventLists = dbX.lotteryEvents
        .map((e) => DropdownMenuItem(value: e, child: Text(e.eventTitle)))
        .toList();

    if (dbX.selectedLotteryEvent.value.id != 0) {
      selectedEvent = dbX.selectedLotteryEvent.value;
    } else {
      selectedEvent =
          dbX.lotteryEvents.isNotEmpty ? dbX.lotteryEvents.first : null;
    }
    super.initState();
  }

  void unfocus() => focusNode.unfocus();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width / 3,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Gap(height * 0.1),
                  SvgPicture.asset(
                    mpwtLogoSVG,
                    width: 100,
                  ),
                  const Gap(16),
                  Text(
                    'បញ្ជីរអ្នកទទួលរង្វាន់ MPWT',
                    style: TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: 18,
                    ),
                  ),
                  const Gap(16),
                  Container(
                    width: width,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.mpwtYellow),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_rounded,
                          color: AppColors.mpwtYellow,
                        ),
                        const Gap(8),
                        Flexible(
                          child: Text(
                            'ជ្រើសរើស​ព្រឹត្តិការណ៍​មួយ​ក្នុង​ចំណោម​ព្រឹត្តិការណ៍​ខាង​ក្រោម​បន្ទាប់​មក​ Subscribe ​ព្រឹត្តិការណ៍​នេះ​ដើម្បី​ទទួល​ទិន្នន័យ​ក្នុង​ពេល​ជាក់ស្ដែង។',
                            style: TextStyle(
                              color: AppColors.mpwtYellow,
                              fontFamily: kantumruy,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  DropdownButtonFormField(
                    autofocus: false,
                    focusNode: focusNode,
                    isExpanded: true,
                    items: eventLists,
                    value: selectedEvent,
                    onChanged: (value) {
                      if (value != null) {
                        selectedEvent = value;
                        dbX.selectedLotteryEvent.value = value;
                        dbX.getAllLotteryPrizeWinners(eventId: value.id);
                        unfocus();
                      }
                    },
                  ),
                  const Gap(16),
                  DottedLine(width: width),
                  const Gap(16),
                  Expanded(
                    child: Container(
                      width: width,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(16),
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.clipboardList,
                                color: AppColors.white,
                              ),
                              const Gap(8),
                              Text(
                                'Subscription Logs',
                                style: TextStyle(
                                  color: AppColors.white,
                                ),
                              ),
                              const Spacer(),
                              GradientIconButton(
                                icon: FontAwesomeIcons.trash,
                                tooltip: 'Clear logs',
                                onClick: () => dbX.clearLogs(),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              physics: const BouncingScrollPhysics(),
                              itemCount: dbX.dbLogs.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}. ',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontFamily: kantumruy,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Gap(12),
                                    Flexible(
                                      child: SelectableText(
                                        dbX.dbLogs[index],
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontFamily: kantumruy,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 32,
              left: 32,
              child: Row(
                children: [
                  GradientIconButton(
                    icon: FontAwesomeIcons.caretLeft,
                    onClick: widget.onTapBack,
                    tooltip: 'Hide menu',
                  ),
                  const Gap(16),
                  ElevatedButton(
                    onPressed: () {
                      Get.off(
                        () => const MyHomePage(),
                        transition: Transition.cupertino,
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                        ),
                        const Gap(8),
                        Text(
                          'Exit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 32,
              right: 32,
              child: ElevatedButton(
                onPressed: () {
                  if (dbX.isSubscribed.value) {
                    dbX.stopListeningToWinnerChanges();
                  } else {
                    dbX.listenToWinnerChanges(eventId: selectedEvent!.id);
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      dbX.isSubscribed.value
                          ? FontAwesomeIcons.bellSlash
                          : FontAwesomeIcons.bell,
                      color: Colors.white,
                    ),
                    const Gap(8),
                    Text(
                      dbX.isSubscribed.value ? 'UNSUBSCRIBE' : 'SUBSCRIBE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
