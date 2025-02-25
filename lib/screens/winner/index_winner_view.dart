import 'package:estimation_list_generator/screens/winner/winner_list_view.dart';
import 'package:estimation_list_generator/utils/custom_card.dart';
import 'package:estimation_list_generator/widgets/verification.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class IndexWinnerView extends StatelessWidget {
  const IndexWinnerView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: height / 4.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomCard(
                heading: 'Admin mode',
                description:
                    'មុខងារនេះត្រូវបានរចនាឡើងដើម្បីអនុញ្ញាតឱ្យអ្នកប្រើប្រាស់ធ្វើបច្ចុប្បន្នភាពទិន្នន័យសម្រាប់ព្រឹត្តិការណ៍រង្វាន់។',
                onTap: () =>
                    launchVerificationDialog(VerificationType.winnerAdmin),
              ),
              const Gap(16),
              CustomCard(
                heading: 'View mode',
                description:
                    'ត្រូវបានរចនាឡើងដើម្បីអនុញ្ញាតឱ្យអ្នកប្រើប្រាស់បង្ហាញទិន្នន័យព្រឹត្តិការណ៍រង្វាន់ដែលបានធ្វើបច្ចុប្បន្នភាពដោយអ្នកប្រើប្រាស់ផ្សេងទៀត។',
                onTap: () => launchWinnerListView(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
