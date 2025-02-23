import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/show_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../controllers/app_controller.dart';

class QrCodeGenerator extends StatefulWidget {
  const QrCodeGenerator({super.key});

  @override
  State<QrCodeGenerator> createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  final appX = Get.find<AppController>();
  String qrData = 'www.example.com';
  String selectedQRSize = '238x238';
  GlobalKey qrKey = GlobalKey();

  Future<void> _saveQrCode() async {
    try {
      RenderRepaintBoundary boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Determine pixelRatio based on selectedQRSize
      double pixelRatio = 1.0; // Default
      if (selectedQRSize == '475x475') {
        pixelRatio = 2.0;
      } else if (selectedQRSize == '949x949') {
        pixelRatio = 4.0;
      }

      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Get the downloads directory
      Directory? downloadsDir = await getDownloadsDirectory();
      if (downloadsDir != null) {
        String filePath =
            '${downloadsDir.path}/QRCode_${DateTime.now().millisecondsSinceEpoch}.png';
        File file = File(filePath);
        await file.writeAsBytes(pngBytes);

        Get.snackbar(
          'Success',
          'QR code saved to $filePath',
          backgroundColor: AppColors.vibrantGreen,
          colorText: Colors.black,
          margin: const EdgeInsets.all(20),
        );
      }
    } catch (e) {
      showErrorMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    List<RadioListTile> exportOptions = [
      RadioListTile(
        value: '238x238',
        groupValue: selectedQRSize,
        title: const Text('238x238'),
        onChanged: (value) {
          setState(() {
            selectedQRSize = value.toString();
          });
        },
      ),
      RadioListTile(
        value: '475x475',
        groupValue: selectedQRSize,
        title: const Text('475x475'),
        onChanged: (value) {
          setState(() {
            selectedQRSize = value.toString();
          });
        },
      ),
      RadioListTile(
        value: '949x949',
        groupValue: selectedQRSize,
        title: const Text('949x949'),
        onChanged: (value) {
          setState(() {
            selectedQRSize = value.toString();
          });
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(32),
        Text(
          'សូមបញ្ចូលតំណតភ្ជាប់របស់អ្នក ដើម្បីបង្កើតកូដ QR',
          style: TextStyle(fontSize: 18),
        ),
        const Gap(32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RepaintBoundary(
                key: qrKey,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: width * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    padding: const EdgeInsets.all(0),
                    data: qrData,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.circle,
                      color: AppColors.primaryLight,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: AppColors.secondaryLight,
                    ),
                  ), // qr here
                ),
              ),
            ),
            const Gap(16),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  buildTitle(
                    FontAwesomeIcons.quoteLeft,
                    'URL',
                  ),
                  const Gap(8),
                  TextFormField(
                    initialValue: qrData,
                    decoration: InputDecoration(),
                    onChanged: (value) => setState(() => qrData = value),
                  ),
                  const Gap(16),
                  buildTitle(FontAwesomeIcons.image, 'Export Options'),
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: exportOptions,
                    ),
                  ),
                  const Gap(32),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => _saveQrCode(),
                      icon: const Icon(
                        FontAwesomeIcons.download,
                        color: AppColors.white,
                      ),
                      label: Text('Export'),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
