import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/widgets/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class WinnerView extends StatelessWidget {
  const WinnerView({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildTitle(
      IconData icon,
      String title,
    ) {
      return Row(
        mainAxisSize: MainAxisSize.min,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(16),
        buildTitle(FontAwesomeIcons.circleUser, 'Admin mode'),
        buildDescription(
          'មុខងារនេះត្រូវបានរចនាឡើងដើម្បីអនុញ្ញាតឱ្យអ្នកប្រើប្រាស់ធ្វើបច្ចុប្បន្នភាពទិន្នន័យសម្រាប់ព្រឹត្តិការណ៍រង្វាន់។',
        ),
        const Gap(16),
        ElevatedButton(onPressed: () {}, child: Text('ចូលប្រើប្រាស់')),
        const Gap(16),
        const DottedLine(width: double.infinity),
        const Gap(16),
        buildTitle(FontAwesomeIcons.eye, 'View mode'),
        buildDescription(
          'ត្រូវបានរចនាឡើងដើម្បីអនុញ្ញាតឱ្យអ្នកប្រើប្រាស់បង្ហាញទិន្នន័យព្រឹត្តិការណ៍រង្វាន់ដែលបានធ្វើបច្ចុប្បន្នភាពដោយអ្នកប្រើប្រាស់ផ្សេងទៀត។',
        ),
        const Gap(16),
        ElevatedButton(onPressed: () {}, child: Text('ចូលប្រើប្រាស់')),
        const Gap(16),
      ],
    );
  }

  Widget buildDescription(String description) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            FontAwesomeIcons.circleInfo,
            color: AppColors.primaryLight,
          ),
          const Gap(8),
          Flexible(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
