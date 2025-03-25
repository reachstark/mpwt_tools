import 'dart:ui';

import 'package:choice/choice.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/models/event_prize.dart';
import 'package:estimation_list_generator/models/lottery_event.dart';
import 'package:estimation_list_generator/models/winning_ticket.dart';
import 'package:estimation_list_generator/screens/winner/winner_ticket_detail.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_images.dart';
import 'package:estimation_list_generator/utils/app_lottie.dart';
import 'package:estimation_list_generator/utils/show_loading.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:estimation_list_generator/widgets/dotted_line.dart';
import 'package:estimation_list_generator/widgets/scale_button.dart';
import 'package:estimation_list_generator/widgets/winner_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

void navigateToWinnerListAdmin({
  LotteryEvent? setEvent,
}) {
  Get.to(
    () => WinnerListAdmin(
      setEvent: setEvent,
    ),
    transition: Transition.cupertino,
  );
}

class WinnerListAdmin extends StatefulWidget {
  final LotteryEvent? setEvent;
  const WinnerListAdmin({super.key, this.setEvent});

  @override
  State<WinnerListAdmin> createState() => _WinnerListAdminState();
}

class _WinnerListAdminState extends State<WinnerListAdmin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final dbX = Get.find<DbController>();
  List<DropdownMenuItem<LotteryEvent>> eventLists = [];
  LotteryEvent? selectedEvent;
  EventPrize? selectedPrize;
  List<EventPrize> prizes = [];
  final lotteryNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<LotteryWinner> winners = [];
  bool isLoadingWinners = false;
  bool showFilterMenu = false;
  final searchController = TextEditingController();
  LotteryWinner foundWinner = LotteryWinner(
    eventId: -1,
    ticketNumber: '',
    lotteryPrize: '',
  );
  bool isSearching = false;

  @override
  void initState() {
    eventLists = dbX.lotteryEvents
        .map((e) => DropdownMenuItem(value: e, child: Text(e.eventTitle)))
        .toList();
    if (dbX.selectedLotteryEvent.value == widget.setEvent) {
      selectedEvent = dbX.selectedLotteryEvent.value;
    }
    if (widget.setEvent != null) {
      selectedEvent = widget.setEvent;
    }
    getLotteryPrizesList();
    super.initState();
  }

  void getLotteryPrizesList() {
    setState(() {
      prizes = selectedEvent?.eventPrizes ?? [];
    });
  }

  void setSelectedEvent(LotteryEvent event) {
    setState(() {
      dbX.selectedLotteryEvent.value = event;
    });
  }

  void setSelectedLotteryWinner(LotteryWinner winner) {
    dbX.selectedWinner.value = winner;
  }

  void submitWinner() async {
    if (formKey.currentState!.validate()) {
      if (selectedPrize == null) {
        // Handle existing snackbars
        Get.closeAllSnackbars();
        Get.snackbar(
          'Error',
          'សូមជ្រើសរើសប្រភេទរង្វាន់',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(20),
        );
        return;
      }

      showLoading();

      final isCreated = await dbX.createLotteryWinner(
        LotteryWinner(
          eventId: selectedEvent!.id,
          ticketNumber: lotteryNumberController.text.trim(),
          lotteryPrize: selectedPrize!.prizeTitle,
        ),
      );

      if (isCreated) {
        Get.back();
        setState(() {
          winners.add(
            LotteryWinner(
              eventId: selectedEvent!.id,
              ticketNumber: lotteryNumberController.text.trim(),
              lotteryPrize: selectedPrize!.prizeTitle,
            ),
          );
        });
      } else {
        stopLoading();
      }
      lotteryNumberController.clear();
    }
  }

  void searchWinner() async {
    if (searchController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      isSearching = true;
    });

    foundWinner = await dbX.findWinnerByTicketNumber(
      searchController.text.trim(),
    );

    setState(() {
      isSearching = false;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    Widget buildFilterSheet() {
      Widget buildContent() {
        switch (isSearching) {
          case true:
            return Center(
              child: Lottie.asset(AppLottie.loading, height: height * 0.15),
            );
          case false:
            if (foundWinner.id != -1 && foundWinner.eventId != -1) {
              return Column(
                children: [
                  DottedLine(width: width),
                  Gap(32),
                  Text(
                    'លេខ ${foundWinner.ticketNumber} បានឈ្នះរង្វាន់',
                    style: TextStyle(
                      fontFamily: siemreap,
                      color: AppColors.primaryLight,
                      fontSize: 18,
                    ),
                  ),
                  Gap(8),
                  Text(
                    foundWinner.lotteryPrize,
                    style: TextStyle(
                      fontFamily: siemreap,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Gap(12),
                  Text(
                    foundWinner.isClaimed
                        ? 'បានបើកជូនរួចរាល់'
                        : 'មិនទាន់បានបើកជូនទេ',
                    style: TextStyle(
                      fontFamily: siemreap,
                      color: foundWinner.isClaimed
                          ? Colors.green
                          : AppColors.mpwtRed,
                      fontSize: 18,
                    ),
                  ),
                  Gap(32),
                ],
              );
            } else {
              return Center(
                child: Icon(
                  FontAwesomeIcons.fileCircleExclamation,
                  color: Colors.grey,
                  size: 128,
                ),
              );
            }
        }
      }

      return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastEaseInToSlowEaseOut,
        bottom: showFilterMenu ? 0 : -240,
        right: 32,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: width * 0.35,
          height: showFilterMenu ? height * 0.5 : 320,
          padding: EdgeInsets.all(clampDouble(height * 0.02, 16, 32)),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 4,
                offset: Offset(5, 5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  tooltip: !showFilterMenu ? 'បង្ហាញ Menu' : 'បិទ Menu',
                  onPressed: () {
                    setState(() {
                      if (showFilterMenu) {
                        showFilterMenu = false;
                      } else {
                        showFilterMenu = true;
                      }
                    });
                  },
                  icon: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        child: Icon(
                          showFilterMenu
                              ? FontAwesomeIcons.caretDown
                              : FontAwesomeIcons.magnifyingGlass,
                          size: 16,
                        ),
                      ),
                      const Gap(12),
                      Text(
                        'ស្វែងរកលេខរង្វាន់',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(height * 0.024),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'លេខរង្វាន់',
                        ),
                        onFieldSubmitted: (value) => searchWinner(),
                      ),
                    ),
                    const Gap(12),
                    ScaleButton(
                      onTap: () => searchWinner(),
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'ស្វែងរក',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                Text(
                  'លទ្ធផល',
                  style: TextStyle(
                    color: AppColors.primaryLight,
                    fontSize: 18,
                  ),
                ),
                const Gap(16),
                buildContent(),
              ],
            ),
          ),
        ),
      );
    }

    Widget buildWinnerChips() {
      if (isLoadingWinners) {
        return CircularProgressIndicator(
          year2023: false,
        );
      }

      return Row(
        children: [
          Expanded(
            child: Choice.inline(
              itemCount: winners.length,
              itemBuilder: (state, i) {
                return ScaleButton(
                  onTap: () {
                    _key.currentState!.openEndDrawer();
                    setSelectedLotteryWinner(winners[i]);
                  },
                  child: WinnerNumber(
                    i: i,
                    ticketNumber: winners[i].ticketNumber,
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    Widget buildAppBar() {
      return Container(
        padding: EdgeInsets.all(clampDouble(height * 0.07, 6, 8)),
        height: clampDouble(height * 0.07, 50, 100),
        width: width,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.1,
              ),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(16),
            ScaleButton(
              tooltip: 'ត្រលប់ទៅក្រោយ',
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.caretLeft,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const Gap(16),
            Animate(
              onPlay: (controller) => controller.repeat(),
              effects: const [
                ShimmerEffect(
                  color: AppColors.mpwtYellow,
                  delay: Duration(seconds: 4),
                  duration: Duration(milliseconds: 1800),
                ),
              ],
              child: EasyRichText(
                'បញ្ជីអ្នកទទួលរង្វាន់ MPWT',
                patternList: [
                  EasyRichTextPattern(
                    targetString: 'បញ្ជីអ្នកទទួលរង្វាន់',
                    style: TextStyle(
                      fontSize: clampDouble(height * 0.04, 18, 22),
                      color: AppColors.primaryLight,
                    ),
                  ),
                  EasyRichTextPattern(
                    targetString: 'MPWT',
                    style: TextStyle(
                      fontSize: clampDouble(height * 0.04, 18, 22),
                      fontWeight: FontWeight.bold,
                      fontFamily: moulLight,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'ADMIN',
                style: TextStyle(
                  color: AppColors.white,
                  fontFamily: siemreap,
                  fontSize: 10,
                ),
              ),
            ),
            const Spacer(),
            ScaleButton(
              tooltip: 'ទាញយកទិន្ន័យចុងក្រោយ',
              onTap: () => dbX.readLotteryEvents(loading: true),
              child: Icon(
                FontAwesomeIcons.arrowsRotate,
                color: AppColors.primaryLight,
              ),
            ),
            const Gap(16),
          ],
        ),
      );
    }

    Widget buildLeftPane() {
      return Expanded(
        child: Container(
          height: height,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: AppColors.primaryLight,
                width: 2,
              ),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(height * 0.1),
                  Text(
                    'ព្រឹត្តការណ៍រង្វាន់',
                    style: TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: clampDouble(height * 0.04, 14, 16),
                    ),
                  ),
                  const Gap(8),
                  DropdownButtonFormField(
                    value: selectedEvent,
                    menuMaxHeight: height * 0.4,
                    items: eventLists,
                    onChanged: (value) {
                      setState(() {
                        selectedEvent = value;
                        getLotteryPrizesList();
                        setSelectedEvent(value!);
                        selectedPrize = null;
                      });
                    },
                    selectedItemBuilder: (context) {
                      return eventLists
                          .map(
                            (e) => SizedBox(
                              width: width * 0.26,
                              child: Text(
                                e.value!.eventTitle,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: siemreap,
                                  fontSize: clampDouble(height * 0.04, 14, 16),
                                  color: AppColors.primaryLight,
                                ),
                              ),
                            ),
                          )
                          .toList();
                    },
                  ),
                  const Gap(16),
                  DottedLine(width: width),
                  const Gap(16),
                  Text(
                    'ប្រភេទរង្វាន់',
                    style: TextStyle(
                      color: AppColors.primaryLight,
                      fontSize: clampDouble(height * 0.04, 14, 16),
                    ),
                  ),
                  const Gap(8),
                  Choice.inline(
                    itemCount: prizes.length,
                    itemBuilder: (state, i) {
                      bool isSelected = selectedPrize == prizes[i];

                      return ChoiceChip(
                        showCheckmark: false,
                        color: WidgetStatePropertyAll(
                          isSelected ? AppColors.primaryLight : null,
                        ),
                        selected: isSelected,
                        onSelected: (selected) async {
                          if (isSelected) return;
                          setState(() {
                            isLoadingWinners = true;
                            selectedPrize = prizes[i];
                          });

                          winners = await dbX
                              .getLotteryPrizeWinners(
                                eventId: selectedEvent!.id,
                                prizeName: prizes[i].prizeTitle,
                              )
                              .whenComplete(
                                () => setState(() {
                                  isLoadingWinners = false;
                                }),
                              );

                          setState(() {});
                        },
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              prizes[i].prizeTitle,
                              style: TextStyle(
                                color: isSelected ? Colors.white : null,
                              ),
                            ),
                            if (prizes[i].isTopPrize) ...[
                              const Gap(4),
                              Image.asset(
                                AppImages.iconCrown,
                                height: 14,
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  const Gap(16),
                  DottedLine(width: width),
                  const Gap(16),
                  Row(
                    children: [
                      Text(
                        'បញ្ជូលទិន្ន័យអ្នកឈ្នះរង្វាន់',
                        style: TextStyle(
                          fontSize: clampDouble(height * 0.04, 14, 16),
                          color: AppColors.primaryLight,
                        ),
                      ),
                      const Gap(12),
                      ScaleButton(
                        tooltip:
                            'អ្នកអាចចុច Enter Key ឬប៊ូតុង Submit ដើម្បីបញ្ជូលទិន្ន័យអ្នកឈ្នះរង្វាន់',
                        child: Icon(
                          FontAwesomeIcons.circleQuestion,
                          color: AppColors.primaryLight,
                          size: clampDouble(height * 0.04, 14, 16),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  TextFormField(
                    controller: lotteryNumberController,
                    style: TextStyle(
                      fontFamily: siemreap,
                      fontSize: clampDouble(height * 0.04, 14, 16),
                    ),
                    decoration: InputDecoration(
                      hintText: 'លេខរបស់អ្នកឈ្នះរង្វាន់',
                      prefixIcon: Icon(
                        FontAwesomeIcons.hashtag,
                        color: AppColors.primaryLight,
                        size: clampDouble(height * 0.04, 14, 16),
                      ),
                    ),
                    onFieldSubmitted: (value) => submitWinner(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'សូមបញ្ជូលលេខរបស់អ្នកឈ្នះរង្វាន់';
                      }
                      return null;
                    },
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      Expanded(
                        child: ScaleButton(
                          onTap: () => submitWinner(),
                          child: Container(
                            alignment: Alignment.center,
                            height: 45,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'SUBMIT',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget buildRightPane() {
      return Expanded(
        flex: 2,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            SizedBox(
              height: height,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(height * 0.1),
                    Text(
                      'លេខសំណាងដែលបានឈ្នះរង្វាន់',
                      style: TextStyle(
                        fontSize: clampDouble(height * 0.04, 14, 16),
                        color: AppColors.primaryLight,
                      ),
                    ),
                    const Gap(8),
                    Row(
                      children: [
                        Text(
                          selectedPrize?.prizeTitle ?? 'សូមជ្រើសរើសរង្វាន់',
                          style: TextStyle(
                            fontSize: clampDouble(height * 0.04, 14, 16),
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    DottedLine(width: width),
                    const Gap(16),
                    buildWinnerChips(),
                  ],
                ),
              ),
            ),
            buildFilterSheet(),
          ],
        ),
      );
    }

    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      endDrawer: WinnerTicketDetail(),
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: Row(
              children: [
                buildLeftPane(),
                buildRightPane(),
              ],
            ),
          ),
          buildAppBar(),
        ],
      ),
    );
  }
}
