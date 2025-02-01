import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:estimation_list_generator/widgets/feature_views/estimation_generator/paper_layout.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PreviewLayout extends StatefulWidget {
  const PreviewLayout({
    super.key,
  });

  @override
  State<PreviewLayout> createState() => _PreviewLayoutState();
}

class _PreviewLayoutState extends State<PreviewLayout> {
  final appX = Get.find<AppController>();
  final formKey = GlobalKey<FormState>();
  final projectIdController = TextEditingController();
  final planDetailController = TextEditingController();
  final departmentController = TextEditingController();

  @override
  void initState() {
    setState(() {
      projectIdController.text = projectIdSample;
      departmentController.text = 'នាយកដ្ឋានហិរញ្ញវត្ថុ';
      planDetailController.text = reviewSample;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const Gap(16),
          buildTitle(
            Icons.visibility_rounded,
            'Preview',
          ),
          const Gap(16),
          SizedBox(
            // width: width * 0.25,
            child: PaperLayout(),
          ),
          const Gap(16),
          footerFields(),
        ],
      ),
    );
  }

  Widget footerFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: buildTitle(
                Icons.document_scanner_rounded,
                'Project ID',
              ),
            ),
            const Gap(8),
            Expanded(
              child: buildTitle(
                Icons.group,
                'Department',
              ),
            ),
          ],
        ),
        const Gap(8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: projectIdController,
                style: TextStyle(
                  fontFamily: siemreap,
                ),
                onChanged: (value) => setState(() {
                  appX.projectId.value = value.trim();
                }),
              ),
            ),
            const Gap(16),
            Expanded(
              child: TextFormField(
                controller: departmentController,
                style: TextStyle(
                  fontFamily: siemreap,
                ),
                onChanged: (value) => setState(() {
                  appX.department.value = value.trim();
                }),
              ),
            ),
          ],
        ),
        const Gap(16),
        buildTitle(Icons.info_rounded, 'Summary Description'),
        const Gap(8),
        TextFormField(
          controller: planDetailController,
          style: TextStyle(
            fontFamily: siemreap,
          ),
          maxLines: 7,
          onChanged: (value) => setState(() {
            appX.summary.value = value.trim();
          }),
        ),
        const Gap(16),
        ElevatedButton(
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.print_rounded,
                color: Colors.white,
              ),
              const Gap(8),
              Text(
                'Print',
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'This feature is currently under development.',
            ),
          ),
        ),
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
