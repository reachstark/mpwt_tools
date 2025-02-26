import 'dart:math';

import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/models/lottery_event.dart';
import 'package:estimation_list_generator/screens/lottery/widgets/lottery_event_card.dart';
import 'package:estimation_list_generator/screens/lottery/widgets/lottery_prize_item_card.dart';
import 'package:estimation_list_generator/screens/winner/winner_list_admin.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_lottie.dart';
import 'package:estimation_list_generator/utils/custom_card.dart';
import 'package:estimation_list_generator/utils/format_date.dart';
import 'package:estimation_list_generator/utils/get_prizes_count.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:estimation_list_generator/widgets/dialogs/add_lottery_event.dart';
import 'package:estimation_list_generator/widgets/dialogs/add_lottery_prize_item.dart';
import 'package:estimation_list_generator/widgets/dialogs/delete_lottery_event.dart';
import 'package:estimation_list_generator/widgets/horizontal_data.dart';
import 'package:estimation_list_generator/widgets/scale_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LotteryList extends StatefulWidget {
  const LotteryList({super.key});

  @override
  State<LotteryList> createState() => _LotteryListState();
}

class _LotteryListState extends State<LotteryList> {
  final dbX = Get.find<DbController>();
  List<LotteryEvent> filteredEvents = [];

  @override
  void initState() {
    filteredEvents = dbX.lotteryEvents;
    dbX.searchController.addListener(_filterPlans);
    super.initState();
  }

  // Function to filter plans based on search query
  void _filterPlans() {
    String query = dbX.searchController.text.toLowerCase();

    setState(() {
      filteredEvents = dbX.lotteryEvents
          .where((event) => filterCases(event, query))
          .toList();
    });
  }

  bool filterCases(LotteryEvent event, String query) {
    return (event.eventTitle.toLowerCase().contains(query));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
                'បញ្ជីរង្វាន់ MPWT',
                patternList: [
                  EasyRichTextPattern(
                    targetString: 'បញ្ជីរង្វាន់',
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
            const Gap(32),
            SizedBox(
              width: width * 0.35,
              child: TextFormField(
                controller: dbX.searchController,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  hintText: 'Search...',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                        color: AppColors.primaryLight, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                ),
              ),
            ),
            const Gap(16),
            ScaleButton(
              tooltip: 'ទាញយកទិន្ន័យចុងក្រោយ',
              onTap: () async => dbX.readLotteryEvents(loading: true),
              child: Icon(
                FontAwesomeIcons.arrowsRotate,
                color: AppColors.primaryLight,
              ),
            ),
            const Spacer(),
            ScaleButton(
              tooltip: 'បង្កើតព្រឹត្តការណ៍រង្វាន់ថ្មី',
              child: ElevatedButton(
                onPressed: () => showAddLotteryEventDialog(isUpdating: false),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: AppColors.white,
                    ),
                    const Gap(8),
                    Text(
                      'បន្ថែមព្រឹត្តការណ៍',
                      style: TextStyle(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(16),
          ],
        ),
      );
    }

    Widget totalCount() {
      return Row(
        children: [
          Icon(
            FontAwesomeIcons.award,
            color: Colors.amber,
          ),
          const Gap(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('រង្វាន់សរុប​'),
              Obx(
                () => Text(
                  getPrizesCount(dbX.selectedLotteryEvent.value.eventPrizes),
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget buildDetails() {
      if (dbX.selectedLotteryEvent.value.eventPrizes.isEmpty) {
        return Container();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: max(width * 0.25, 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Obx(
                  () {
                    final selectedEvent = dbX.selectedLotteryEvent.value;
                    final prizesCount = selectedEvent.eventPrizes.length;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ព័ត៌មានលម្អិត',
                          style: TextStyle(
                            color: AppColors.primaryLight,
                            fontSize: clampDouble(
                              height * 0.04,
                              18,
                              22,
                            ),
                          ),
                        ),
                        const Gap(16),
                        HorizontalData(
                          icon: FontAwesomeIcons.calendarDay,
                          title: 'ថ្ងៃខែឆ្នាំ',
                          data: formatDate(selectedEvent.eventDate),
                        ),
                        const Gap(8),
                        HorizontalData(
                          icon: FontAwesomeIcons.hands,
                          title: 'បានបើកជូន',
                          data: getPrizesCount(selectedEvent.eventPrizes),
                          futureData:
                              dbX.getClaimedPrizesCount(selectedEvent.id),
                        ),
                        const Gap(8),
                        HorizontalData(
                          icon: FontAwesomeIcons.trophy,
                          title: 'ប្រភេទរង្វាន់',
                          data: '$prizesCount',
                        ),
                        const Gap(8),
                        HorizontalData(
                          icon: FontAwesomeIcons.crown,
                          title: 'រង្វាន់ធំ',
                          data: getBigPrizesCount(selectedEvent.eventPrizes),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: ScaleButton(
                  tooltip: 'កែសម្រួលព្រឹត្តការណ៍រង្វាន់',
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.pencil,
                      color: AppColors.primaryLight,
                    ),
                    onPressed: () => showAddLotteryEventDialog(
                      isUpdating: true,
                      lotteryEvent: dbX.selectedLotteryEvent.value,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ScaleButton(
                tooltip: 'Export to .csv file type',
                child: ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.fileExport,
                        size: 16,
                        color: AppColors.white,
                      ),
                      const Gap(8),
                      Text('Export'),
                    ],
                  ),
                ),
              ),
              const Gap(8),
              ScaleButton(
                tooltip: 'លុបព្រឹត្តការណ៍រង្វាន់នេះ',
                child: IconButton(
                  onPressed: () => showDeleteLotteryEventDialog(
                    dbX.selectedLotteryEvent.value,
                  ),
                  icon: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.trash,
                        size: 16,
                        color: AppColors.primaryLight,
                      ),
                      const Gap(8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          SizedBox(
            width: max(width * 0.25, 300),
            child: CustomCard(
              heading: 'បញ្ជីអ្នកទទួលរង្វាន់',
              description:
                  'បញ្ចូលទិន្នន័យអ្នកឈ្នះរង្វាន់ទៅក្នុងព្រឹត្តិការណ៍នេះ។',
              onTap: () => navigateToWinnerListAdmin(
                setEvent: dbX.selectedLotteryEvent.value,
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAppBar(),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: AppColors.primaryLight,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Obx(() {
                        final events = filteredEvents.isEmpty &&
                                dbX.searchController.text.isEmpty
                            ? dbX.lotteryEvents
                            : filteredEvents;

                        final selectedItem = dbX.selectedLotteryEvent.value;

                        Widget buildNoData() {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                svgNoData,
                                height: Get.height / 3,
                              ),
                              const Gap(16),
                              Text(
                                'មិនមានទិន្ន័យ',
                                style: TextStyle(
                                  color: AppColors.primaryLight,
                                  fontSize:
                                      clampDouble(Get.height * 0.04, 18, 22),
                                ),
                              ),
                              const Gap(16),
                              Text(
                                  'សូមបន្ថែមទិន្ន័យថ្មីដោយចុចប៊ូតុងបន្ថែមនៅខាងស្តាំ'),
                            ],
                          );
                        }

                        if (events.isEmpty) {
                          return buildNoData();
                        }

                        return ListView.builder(
                          itemCount: events.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (_, index) {
                            final event = events[index];

                            return LotteryEventCard(
                              onTap: () {
                                setState(() {
                                  dbX.selectedLotteryEvent.value = event;
                                });
                              },
                              isSelected: selectedItem.id == event.id,
                              event: event,
                              isLastItem: index == events.length - 1,
                            );
                          },
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 16,
                        right: 32,
                        left: 32,
                      ),
                      child: Obx(
                        () {
                          final selectedEvent = dbX.selectedLotteryEvent.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      selectedEvent.eventTitle,
                                      style: TextStyle(
                                        color: AppColors.primaryLight,
                                        fontSize: clampDouble(
                                          height * 0.04,
                                          18,
                                          22,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(8),
                                  Visibility(
                                    visible:
                                        dbX.selectedLotteryEvent.value.id != 0,
                                    child: Row(
                                      children: [
                                        totalCount(),
                                        const Gap(36),
                                        ScaleButton(
                                          onTap: () =>
                                              showAddLotteryPrizeItemDialog(
                                            isUpdating: false,
                                          ),
                                          tooltip: 'បន្ថែមរង្វាន់',
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.primaryLight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.circlePlus,
                                                  color: AppColors.primaryLight,
                                                ),
                                                const Gap(8),
                                                Text(
                                                  'បន្ថែមរង្វាន់',
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.primaryLight,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(16),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Obx(
                                        () {
                                          final eventPrizes = dbX
                                              .selectedLotteryEvent
                                              .value
                                              .eventPrizes;

                                          if (eventPrizes.isEmpty &&
                                              dbX.selectedLotteryEvent.value
                                                      .id ==
                                                  0) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Lottie.asset(
                                                  AppLottie.attentionArrow,
                                                  height: height / 2,
                                                ),
                                                const Gap(16),
                                                Text(
                                                  'មិនមានទិន្ន័យ',
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.primaryLight,
                                                    fontSize: clampDouble(
                                                      height * 0.04,
                                                      18,
                                                      22,
                                                    ),
                                                  ),
                                                ),
                                                const Gap(16),
                                                Text(
                                                  'សូមចុចលើធាតុណាមួយនៅខាងឆ្វេង ដើម្បីមើលទិន្នន័យ',
                                                ),
                                              ],
                                            );
                                          }

                                          if (eventPrizes.isEmpty) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  svgNoData,
                                                  height: height / 3,
                                                ),
                                                const Gap(16),
                                                Text(
                                                  'មិនមានរង្វាន់ទេ',
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.primaryLight,
                                                    fontSize: clampDouble(
                                                      height * 0.04,
                                                      18,
                                                      22,
                                                    ),
                                                  ),
                                                ),
                                                const Gap(16),
                                                Text(
                                                  'បន្ថែមរង្វាន់នៅខាងស្តាំ',
                                                ),
                                              ],
                                            );
                                          }

                                          return ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            padding: const EdgeInsets.only(
                                              right: 16,
                                              bottom: 16,
                                            ),
                                            itemCount: eventPrizes.length,
                                            itemBuilder: (_, index) {
                                              return LotteryPrizeItemCard(
                                                index: '${index + 1}',
                                                prize: eventPrizes[index],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    const Gap(16),
                                    buildDetails(),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
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
