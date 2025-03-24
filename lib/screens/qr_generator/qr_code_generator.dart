import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:choice/choice.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_theme.dart';
import 'package:estimation_list_generator/utils/show_error.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:estimation_list_generator/widgets/color_item.dart';
import 'package:estimation_list_generator/widgets/dotted_line.dart';
import 'package:estimation_list_generator/widgets/scale_button.dart';
import 'package:estimation_list_generator/widgets/snackbar/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  final colorCodeController = TextEditingController();
  bool isEmbedded = false;
  double logoOpacity = 0.25;
  double logoSize = 0.15;
  String qrData = 'https://www.mpwt.gov.kh/kh/about-us/mission-and-vision';
  String selectedQRSize = '475x475';
  GlobalKey qrKey = GlobalKey();
  Color selectedColor = Color(0xFF1E2A5E);

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

        showSuccessSnackbar(message: 'QR code saved to $filePath');
      }
    } catch (e) {
      showErrorMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget qrCodeBuilder() {
      return RepaintBoundary(
        key: qrKey,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: 320,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: fadeShadow,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Visibility(
                visible: !isEmbedded,
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
                  shape: PrettyQrSmoothSymbol(
                    color: selectedColor,
                  ),
                  image: isEmbedded
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
      );
    }

    Widget exportButton() {
      return ElevatedButton.icon(
        onPressed: () => _saveQrCode(),
        icon: const Icon(
          FontAwesomeIcons.download,
          color: AppColors.white,
        ),
        label: Text('រក្សារទុក'),
      );
    }

    List<CheckboxListTile> logoOptions = [
      CheckboxListTile(
        value: !isEmbedded,
        title: const Text('ផ្ទៃខាងក្រោយ'),
        onChanged: (value) {
          setState(() {
            isEmbedded = false;
          });
        },
      ),
      CheckboxListTile(
        value: isEmbedded,
        title: const Text('បង្កប់'),
        onChanged: (value) {
          setState(() {
            isEmbedded = true;
          });
        },
      ),
    ];

    List<Widget> exportOptions = [
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

    List<Color> colorOptions = [
      AppColors.primaryLight,
      AppColors.backgroundDark,
      AppColors.black,
      AppColors.spaceCadet,
      AppColors.gentianBlue,
      Color(0xFF03CEA4),
      AppColors.mpwtYellow,
      Color(0xFF4F4789),
      AppColors.midnightGreen,
      AppColors.mpwtRed,
    ];

    bool isCustomColorSelected = colorCodeController.text.isNotEmpty &&
        colorCodeController.text.length == 6 &&
        selectedColor ==
            Color(int.parse(
                "0xFF${colorCodeController.text.replaceAll("#", "")}"));

    Widget settingItems() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: const EdgeInsets.symmetric(vertical: 32.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: fadeShadow,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          physics: const BouncingScrollPhysics(),
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
              buildTitle(FontAwesomeIcons.palette, 'ប្តូរពណ៌'),
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: blurShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Choice.inline(
                            itemCount: colorOptions.length,
                            itemBuilder: (state, i) {
                              return ColorItem(
                                isSelected: colorOptions[i] == selectedColor,
                                color: colorOptions[i],
                                onTap: () => setState(
                                  () => selectedColor = colorOptions[i],
                                ),
                              );
                            },
                          ),
                          const Gap(8),
                          DottedLine(width: double.infinity),
                          const Gap(8),
                          buildTitle(
                            FontAwesomeIcons.paintbrush,
                            'ពណ៌លេខកូដ',
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: colorCodeController,
                                  maxLength: 6,
                                  buildCounter: (context,
                                      {required currentLength,
                                      required isFocused,
                                      required maxLength}) {
                                    return null;
                                  },
                                  onChanged: (value) => setState(() {
                                    if (value.length == 6) {
                                      selectedColor = Color(int.parse(
                                          "0xFF${value.replaceAll("#", "")}"));
                                    }
                                  }),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.hashtag,
                                      color: AppColors.primaryLight,
                                    ),
                                    hintText: 'Hex Code',
                                  ),
                                ),
                              ),
                              const Gap(8),
                              ColorItem(
                                isSelected: isCustomColorSelected,
                                hexColor: colorCodeController.text,
                                onTap: () {
                                  if (colorCodeController.text.length != 6) {
                                    return;
                                  }
                                  setState(() {
                                    selectedColor = Color(int.parse(
                                        "0xFF${colorCodeController.text.replaceAll("#", "")}"));
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(16),
              buildTitle(FontAwesomeIcons.image, 'ប្តូររចនាប័ទ្មនិមិត្តសញ្ញា'),
              const Gap(8),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: blurShadow,
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
                  boxShadow: blurShadow,
                ),
                child: Slider(
                  year2023: false,
                  min: 0.0,
                  max: 1.0,
                  value: logoOpacity,
                  onChanged: (value) => setState(() => logoOpacity = value),
                ),
              ),
              if (isEmbedded) ...[
                const Gap(16),
                buildTitle(
                  FontAwesomeIcons.sliders,
                  'កែតម្រូវទំហំនៃរូបភាពនិមិត្តសញ្ញា',
                ),
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
              const Gap(32),
              DottedLine(width: double.infinity),
              const Gap(32),
              Row(
                children: [
                  buildTitle(FontAwesomeIcons.image, 'ទំហំរូបភាព'),
                  const Gap(8),
                  ScaleButton(
                    tooltip: 'Choose QR code size on export',
                    child: Icon(
                      FontAwesomeIcons.circleQuestion,
                      color: AppColors.primaryLight,
                      size: 14,
                    ),
                  ),
                ],
              ),
              const Gap(8),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: blurShadow,
                ),
                child: Column(
                  children: exportOptions,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(top: 16.0, right: 16.0),
          child: Column(
            children: [
              qrCodeBuilder(),
              const Gap(16),
              exportButton(),
            ],
          ),
        ),
        Expanded(
          child: settingItems(),
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
