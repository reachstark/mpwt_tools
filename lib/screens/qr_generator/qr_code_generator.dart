import 'dart:io';
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
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/app_controller.dart';

class QrCodeGenerator extends StatefulWidget {
  const QrCodeGenerator({super.key});

  @override
  State<QrCodeGenerator> createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  final appX = Get.find<AppController>();
  final colorCodeController = TextEditingController();
  final fileNameController = TextEditingController();
  bool isEmbedded = false;
  double logoOpacity = 0.25;
  double logoSize = 0.15;
  String qrData = 'https://www.mpwt.gov.kh/kh/about-us/mission-and-vision';
  String selectedQRSize = '640x640';
  GlobalKey qrKey = GlobalKey();
  Color selectedColor = Color(0xFF1E2A5E);
  bool saveColor = false;
  bool isRounded = true;

  Future<void> _saveQrCode() async {
    try {
      RenderRepaintBoundary boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Determine pixelRatio based on selectedQRSize
      String qrSize = 'Small';
      double pixelRatio = 1.0; // Default
      if (selectedQRSize == '640x640') {
        pixelRatio = 2.0;
        qrSize = 'Medium';
      } else if (selectedQRSize == '1280x1280') {
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

        if (fileNameController.text.trim().isNotEmpty) {
          filePath =
              '${downloadsDir.path}/${fileNameController.text.trim()}.png';
        }

        File file = File(filePath);
        await file.writeAsBytes(pngBytes);

        if (saveColor) {
          await appX.saveHexColor(colorCodeController.text);
        }

        showSuccessSnackbar(message: 'QR code saved to $filePath');
      }
    } catch (e) {
      showErrorMessage(e.toString());
    }
  }

  @override
  void dispose() {
    colorCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget openFolderButton() {
      Future<void> openFolder() async {
        try {
          final downloadsDir = await getDownloadsDirectory();

          if (downloadsDir == null) {
            showErrorMessage('Downloads directory not found.');
          }

          final uri = Uri.file(downloadsDir!.path);

          await launchUrl(uri);
        } catch (e) {
          showErrorMessage(e.toString());
        }
      }

      return IconButton(
        onPressed: () => openFolder(),
        tooltip: 'Open folder',
        icon: const Icon(
          FontAwesomeIcons.folder,
          color: AppColors.primaryLight,
        ),
      );
    }

    Widget qrCodeBuilder() {
      return SizedBox(
        width: 320,
        child: Column(
          children: [
            RepaintBoundary(
              key: qrKey,
              child: Container(
                padding: const EdgeInsets.all(16.0),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: fadeShadow,
                  border: Border.all(
                    color: selectedColor,
                    width: 2,
                  ),
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
                          roundFactor: isRounded ? 1 : 0,
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
            ),
            const Gap(16),
            Row(
              children: [
                buildTitle(icon: FontAwesomeIcons.file, title: 'File name'),
                const Gap(8),
                ScaleButton(
                  tooltip:
                      'This system will generate a default file name if not given',
                  child: Icon(
                    FontAwesomeIcons.circleQuestion,
                    color: AppColors.primaryLight,
                    size: 14,
                  ),
                ),
              ],
            ),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: fileNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        FontAwesomeIcons.fileCode,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                openFolderButton(),
              ],
            ),
          ],
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

    List<Widget> logoOptions = [
      CheckboxListTile(
        tileColor: Colors.transparent,
        value: !isEmbedded,
        title: const Text('ផ្ទៃខាងក្រោយ'),
        onChanged: (value) {
          setState(() {
            isEmbedded = false;
          });
        },
      ),
      CheckboxListTile(
        tileColor: Colors.transparent,
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
        tileColor: Colors.transparent,
        value: '238x238',
        groupValue: selectedQRSize,
        title: const Text('តូច'),
        secondary: const Text('320x320'),
        onChanged: (value) {
          setState(() {
            selectedQRSize = value.toString();
          });
        },
      ),
      RadioListTile(
        tileColor: Colors.transparent,
        value: '640x640',
        groupValue: selectedQRSize,
        title: const Text('មធ្យម'),
        secondary: const Text('640x640'),
        onChanged: (value) {
          setState(() {
            selectedQRSize = value.toString();
          });
        },
      ),
      RadioListTile(
        tileColor: Colors.transparent,
        value: '1280x1280',
        groupValue: selectedQRSize,
        title: const Text('ធំ'),
        secondary: const Text('1280x1280'),
        onChanged: (value) {
          setState(() {
            selectedQRSize = value.toString();
          });
        },
      ),
    ];

    bool isCustomColorSelected = colorCodeController.text.isNotEmpty &&
        colorCodeController.text.length == 6 &&
        selectedColor ==
            Color(int.parse(
                "0xFF${colorCodeController.text.replaceAll("#", "")}"));

    Widget settingItems() {
      return Obx(
        () {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.fastEaseInToSlowEaseOut,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            margin: const EdgeInsets.symmetric(vertical: 32.0),
            decoration: BoxDecoration(
              color: appX.useClassicTheme.value
                  ? Colors.white
                  : selectedColor.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: fadeShadow,
            ),
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  buildTitle(
                    icon: FontAwesomeIcons.quoteLeft,
                    title: 'តំណភ្ជាប់',
                  ),
                  const Gap(8),
                  TextFormField(
                    initialValue: qrData,
                    decoration: InputDecoration(),
                    onChanged: (value) => setState(() => qrData = value),
                  ),
                  const Gap(16),
                  buildTitle(
                    icon: FontAwesomeIcons.palette,
                    title: 'ប្តូរពណ៌',
                  ),
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
                          child: Obx(
                            () {
                              List<Color> colorOptions = [
                                AppColors.primaryLight,
                                AppColors.davyGray,
                                AppColors.black,
                                AppColors.spaceCadet,
                                AppColors.gentianBlue,
                                Color(0xFF03CEA4),
                                AppColors.mpwtYellow,
                                Color(0xFF4F4789),
                                AppColors.midnightGreen,
                                AppColors.mpwtRed,
                                AppColors.neonBlue,
                                AppColors.neonPink,
                                AppColors.vibrantGreen,
                                AppColors.goldenYellow,
                                AppColors.terracotta,
                                if (appX.hexColor.value.isNotEmpty)
                                  Color(
                                      int.parse("0xFF${appX.hexColor.value}")),
                              ];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Choice.inline(
                                    itemCount: colorOptions.length,
                                    itemBuilder: (state, i) {
                                      return ColorItem(
                                        isSelected:
                                            colorOptions[i] == selectedColor,
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
                                    icon: FontAwesomeIcons.paintbrush,
                                    title: 'ពណ៌លេខកូដ',
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
                                          if (colorCodeController.text.length !=
                                              6) {
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
                                  if (isCustomColorSelected) ...[
                                    const Gap(8),
                                    Row(
                                      children: [
                                        const Gap(8),
                                        const Text('រក្សាទុកពណ៌លេខកូដ'),
                                        const Gap(8),
                                        ScaleButton(
                                          tooltip:
                                              'បើក ✅ រួចចុច Export ដើម្បីរក្សាទុកពណ៌លេខកូដ',
                                          child: Icon(
                                            FontAwesomeIcons.circleQuestion,
                                            color: AppColors.primaryLight,
                                            size: 16,
                                          ),
                                        ),
                                        const Gap(8),
                                        Switch(
                                          inactiveTrackColor:
                                              AppColors.backgroundLight,
                                          activeTrackColor:
                                              AppColors.backgroundLight,
                                          thumbIcon: WidgetStateProperty.all(
                                            Icon(
                                              saveColor
                                                  ? Icons.done
                                                  : Icons.close,
                                              color: AppColors.white,
                                            ),
                                          ),
                                          value: saveColor,
                                          onChanged: (value) => setState(() {
                                            saveColor = value;
                                          }),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  buildTitle(
                    icon: FontAwesomeIcons.image,
                    title: 'ប្តូររចនាប័ទ្មនិមិត្តសញ្ញា',
                  ),
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: blurShadow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        children: logoOptions,
                      ),
                    ),
                  ),
                  const Gap(16),
                  buildTitle(
                    icon: FontAwesomeIcons.sliders,
                    title: 'កែតម្រូវភាពស្រអាប់នៃរូបភាពនិមិត្តសញ្ញា',
                  ),
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
                      icon: FontAwesomeIcons.sliders,
                      title: 'កែតម្រូវទំហំនៃរូបភាពនិមិត្តសញ្ញា',
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
                  const Gap(16),
                  buildTitle(
                    icon: FontAwesomeIcons.circleNotch,
                    title: 'ភាពមូល/ជ្រុង',
                  ),
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: blurShadow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16.0),
                      child: Column(
                        children: [
                          CheckboxListTile(
                            tileColor: Colors.transparent,
                            value: isRounded,
                            onChanged: (value) =>
                                setState(() => isRounded = true),
                            title: const Text('មូល'),
                            secondary:
                                const Icon(FontAwesomeIcons.square, size: 16),
                          ),
                          CheckboxListTile(
                            tileColor: Colors.transparent,
                            value: !isRounded,
                            onChanged: (value) =>
                                setState(() => isRounded = false),
                            title: const Text('ជ្រុង'),
                            secondary: const Icon(FontAwesomeIcons.squareFull,
                                size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(32),
                  DottedLine(width: double.infinity),
                  const Gap(32),
                  Row(
                    children: [
                      buildTitle(
                        icon: FontAwesomeIcons.image,
                        title: 'ទំហំរូបភាព',
                      ),
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
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16.0),
                      child: Column(
                        children: exportOptions,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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

  Widget buildTitle({
    required IconData icon,
    required String title,
    Color? color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: color ?? AppColors.primaryLight,
        ),
        const Gap(8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: color ?? AppColors.primaryLight,
          ),
        ),
      ],
    );
  }
}
