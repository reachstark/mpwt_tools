import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/show_error.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:path_provider/path_provider.dart';

import '../../controllers/app_controller.dart';

class QrCodeGenerator extends StatefulWidget {
  const QrCodeGenerator({super.key});

  @override
  State<QrCodeGenerator> createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  final appX = Get.find<AppController>();
  String logoStyle = 'background';
  double logoOpacity = 0.25;
  double logoSize = 0.15;
  String qrData = 'https://www.mpwt.gov.kh/kh/about-us/mission-and-vision';
  String selectedQRSize = '475x475';
  GlobalKey qrKey = GlobalKey();

  Future<void> _saveQrCode() async {
    try {
      RenderRepaintBoundary boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Determine pixelRatio based on selectedQRSize
      String qrSize = 'Small';
      double pixelRatio = 1.0; // Default
      if (selectedQRSize == '475x475') {
        pixelRatio = 2.0;
        qrSize = 'Medium';
      } else if (selectedQRSize == '949x949') {
        pixelRatio = 4.0;
        qrSize = 'Large';
      }

      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Get the downloads directory
      Directory? downloadsDir = await getDownloadsDirectory();
      if (downloadsDir != null) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        String filePath =
            '${downloadsDir.path}/QRCode_${formattedDate}_${qrSize}_${logoOpacity.toStringAsFixed(2)}.png';
        File file = File(filePath);
        await file.writeAsBytes(pngBytes);

        Get.snackbar(
          'Success',
          'QR code saved to $filePath',
          backgroundColor: AppColors.primaryLight,
          colorText: Colors.white,
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

    List<RadioListTile> logoOptions = [
      RadioListTile(
        value: 'background',
        groupValue: logoStyle,
        title: const Text('ផ្ទៃខាងក្រោយ'),
        onChanged: (value) {
          setState(() {
            logoStyle = value as String;
          });
        },
      ),
      RadioListTile(
        value: 'foreground',
        groupValue: logoStyle,
        title: const Text('បង្កប់'),
        onChanged: (value) {
          setState(() {
            logoStyle = value as String;
          });
        },
      ),
    ];

    List<RadioListTile> exportOptions = [
      RadioListTile(
        value: '238x238',
        groupValue: selectedQRSize,
        title: const Text('តូច (Approximate size: 30KB)'),
        onChanged: (value) {
          setState(() {
            selectedQRSize = value.toString();
          });
        },
      ),
      RadioListTile(
        value: '475x475',
        groupValue: selectedQRSize,
        title: const Text('មធ្យម (Approximate size: 60KB)'),
        onChanged: (value) {
          setState(() {
            selectedQRSize = value.toString();
          });
        },
      ),
      RadioListTile(
        value: '949x949',
        groupValue: selectedQRSize,
        title: const Text('ធំ (Approximate size: 120KB)'),
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
              child: Column(
                children: [
                  RepaintBoundary(
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Visibility(
                            visible: logoStyle == 'background',
                            child: Opacity(
                              opacity: logoOpacity,
                              child: Image.asset(
                                mpwtLogoPNG,
                                width: 180,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          PrettyQrView.data(
                            data: qrData,
                            decoration: PrettyQrDecoration(
                              shape: const PrettyQrSmoothSymbol(
                                color: AppColors.primaryLight,
                              ),
                              image: logoStyle == 'foreground'
                                  ? PrettyQrDecorationImage(
                                      opacity: logoOpacity,
                                      scale: logoSize,
                                      image: AssetImage(mpwtLogoPNG),
                                      padding: const EdgeInsets.all(6.0),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ), // qr here
                    ),
                  ),
                  const Gap(32),
                  ElevatedButton.icon(
                    onPressed: () => _saveQrCode(),
                    icon: const Icon(
                      FontAwesomeIcons.download,
                      color: AppColors.white,
                    ),
                    label: Text('Export'),
                  ),
                ],
              ),
            ),
            const Gap(16),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  buildTitle(FontAwesomeIcons.quoteLeft, 'តំណភ្ជាប់'),
                  const Gap(8),
                  TextFormField(
                    initialValue: qrData,
                    decoration: InputDecoration(),
                    onChanged: (value) => setState(() => qrData = value),
                  ),
                  const Gap(16),
                  buildTitle(
                      FontAwesomeIcons.image, 'ប្តូររចនាប័ទ្មនិមិត្តសញ្ញា'),
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
                      children: logoOptions,
                    ),
                  ),
                  const Gap(16),
                  buildTitle(FontAwesomeIcons.sliders,
                      'កែតម្រូវភាពស្រអាប់នៃរូបភាពនិមិត្តសញ្ញា'),
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
                    child: Slider(
                      year2023: false,
                      min: 0.0,
                      max: 1.0,
                      value: logoOpacity,
                      onChanged: (value) => setState(() => logoOpacity = value),
                    ),
                  ),
                  if (logoStyle == 'foreground') ...[
                    const Gap(16),
                    buildTitle(FontAwesomeIcons.sliders,
                        'កែតម្រូវទំហំនៃរូបភាពនិមិត្តសញ្ញា'),
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
                      child: Slider(
                        year2023: false,
                        min: 0.09,
                        max: 0.2,
                        value: logoSize,
                        onChanged: (value) => setState(() => logoSize = value),
                      ),
                    ),
                  ],
                  const Gap(16),
                  buildTitle(FontAwesomeIcons.image, 'ទំហំរូបភាព'),
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
                  const Gap(16),
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
