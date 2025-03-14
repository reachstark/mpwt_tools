import 'dart:ui';

import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/models/fmis_code.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_lottie.dart';
import 'package:estimation_list_generator/utils/app_theme.dart';
import 'package:estimation_list_generator/widgets/fmis_card/fmis_card.dart';
import 'package:estimation_list_generator/widgets/searchbar/appsearchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class FollowFmis extends StatefulWidget {
  const FollowFmis({super.key});

  @override
  State<FollowFmis> createState() => _FollowFmisState();
}

class _FollowFmisState extends State<FollowFmis> {
  List<FmisCode> filteredList = [];
  final dbX = Get.find<DbController>();
  final appX = Get.find<AppController>();
  final searchController = TextEditingController();
  final fmisCodeController = TextEditingController();
  final projectIdController = TextEditingController();
  final projectDetailController = TextEditingController();
  final projectBudgetController = TextEditingController();

  @override
  void initState() {
    filteredList = dbX.fmisCodes;
    ever(dbX.fmisCodes, (_) => filteredList = dbX.fmisCodes);
    searchController.addListener(_filterCodes);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterCodes() {
    String query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      filteredList = dbX.fmisCodes; // Show all if search is empty
    } else {
      filteredList = dbX.fmisCodes.where((code) {
        return code.projectId.toLowerCase().contains(query) ||
            code.fmisCode.toLowerCase().contains(query) ||
            (code.projectDetail.toLowerCase().contains(query)) ||
            code.projectBudget.toString().contains(query);
      }).toList();
    }

    setState(() {}); // Ensure UI updates
  }

  void addFmisCode() {
    if (fmisCodeController.text.isEmpty ||
        projectIdController.text.isEmpty ||
        projectBudgetController.text.isEmpty) {
      return;
    }
    dbX
        .addFmisCode(
      FmisCode(
        fmisCode: fmisCodeController.text,
        projectId: projectIdController.text,
        projectDetail: projectDetailController.text,
        projectBudget: int.parse(projectBudgetController.text),
        createdAt: DateTime.now(),
        createdBy: appX.username.value,
      ),
    )
        .whenComplete(() {
      // add to local list
      dbX.fmisCodes.add(
        FmisCode(
          fmisCode: fmisCodeController.text,
          projectId: projectIdController.text,
          projectDetail: projectDetailController.text,
          projectBudget: int.parse(projectBudgetController.text),
          createdAt: DateTime.now(),
          createdBy: appX.username.value,
        ),
      );
      fmisCodeController.clear();
      projectIdController.clear();
      projectDetailController.clear();
      projectBudgetController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget buildRightPane() {
      return SizedBox(
        width: clampDouble(width, 250, 350),
        child: Column(
          children: [
            buildTitle(FontAwesomeIcons.folderPlus, 'បញ្ចូលគម្រោង'),
            const Gap(16),
            TextFormField(
              controller: fmisCodeController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  FontAwesomeIcons.fileCode,
                  color: AppColors.primaryLight,
                ),
                hintText: 'លេខកូដ FMIS',
              ),
            ),
            const Gap(16),
            TextFormField(
              controller: projectIdController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  FontAwesomeIcons.hashtag,
                  color: AppColors.primaryLight,
                ),
                hintText: 'លេខគម្រោង',
              ),
            ),
            const Gap(16),
            TextFormField(
              controller: projectBudgetController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                prefixIcon: Icon(
                  FontAwesomeIcons.sackDollar,
                  color: AppColors.primaryLight,
                ),
                hintText: 'ទឹកប្រាក់គម្រោង (រៀល)',
              ),
            ),
            const Gap(16),
            TextFormField(
              controller: projectDetailController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'ខ្លឹមសារគម្រោង',
              ),
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => addFmisCode(),
                    child: const Text('បញ្ចូលគម្រោង'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        const Gap(16),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    buildTitle(FontAwesomeIcons.list, 'បញ្ជីគម្រោង'),
                    const Gap(16),
                    Appsearchbar(
                      controller: searchController,
                      suffixWidget: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          tooltip: 'ទាញយកទិន្នន័យជាថ្មី',
                          onPressed: () => dbX.getFmisCodes(loading: true),
                          icon: Icon(
                            FontAwesomeIcons.arrowRotateLeft,
                            color: AppColors.primaryLight,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: fadeShadow,
                        ),
                        child: Obx(
                          () {
                            if (filteredList.isEmpty) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Lottie.asset(
                                      AppLottie.notFound,
                                    ),
                                  ),
                                  const Gap(16),
                                  Text(
                                    'គ្មានទិន្នន័យទេ',
                                    style: TextStyle(
                                      color: AppColors.primaryLight,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.all(12),
                              physics: const BouncingScrollPhysics(),
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final fmisCode = filteredList[index];

                                return FmisCard(
                                  index: index,
                                  isLastItem: index == dbX.fmisCodes.length - 1,
                                  item: fmisCode,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              buildRightPane(),
            ],
          ),
        ),
        const Gap(16),
      ],
    );
  }

  Widget buildTitle(
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primaryLight,
        ),
        const Gap(8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.primaryLight,
          ),
        ),
      ],
    );
  }
}
