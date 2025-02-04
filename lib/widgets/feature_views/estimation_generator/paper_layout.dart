import 'dart:math';

import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:estimation_list_generator/widgets/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PaperLayout extends StatelessWidget {
  const PaperLayout({super.key});

  @override
  Widget build(BuildContext context) {
    const double a4Width = 210.0;
    // const double a4Height = 297.0;
    // const double aspectRatio = a4Width / a4Height;
    final appX = Get.find<AppController>();

    return Obx(
      () => Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const Gap(26),
              Text(
                'គោរពជូនពិនិត្យ-សម្រេច',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: moulLight,
                  fontWeight: FontWeight.bold,
                  decorationColor: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
              const Gap(5),
              Text(
                'ក្រសួងសាធារណការ និងដឹកជញ្ជូន',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: moulLight,
                  fontWeight: FontWeight.bold,
                  decorationColor: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
              const Gap(8),
              Column(
                children: [
                  Container(
                    width: max(a4Width, 650),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: EasyRichText(
                      'ខ្លឹមសារសង្ខេបៈ ${appX.summary.value}',
                      textAlign: TextAlign.justify,
                      selectable: true,
                      defaultStyle: TextStyle(
                        fontSize: 12,
                        fontFamily: siemreap,
                        color: Colors.black,
                      ),
                      patternList: [
                        EasyRichTextPattern(
                          targetString: 'ខ្លឹមសារសង្ខេបៈ',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: moulLight,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(5),
                  SizedBox(
                    width: max(a4Width, 650),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          appX.projectId.value,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: siemreap,
                          ),
                        ),
                        Text(
                          appX.department.value,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: siemreap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(12),
              // dotted line for cutout
              DottedLine(width: double.infinity),
              const Gap(12),
            ],
          ),
        ),
      ),
    );
  }
}
