import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/controllers/initializer.dart';
import 'package:estimation_list_generator/screens/donate/donate_page.dart';
import 'package:estimation_list_generator/screens/follow_fmis/follow_fmis.dart';
import 'package:estimation_list_generator/screens/qr_generator/qr_code_generator.dart';
import 'package:estimation_list_generator/screens/winner/index_winner_view.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_theme.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:estimation_list_generator/widgets/feature_views/follow_estimation/follow_estimation.dart';
import 'package:estimation_list_generator/widgets/features_gridview.dart';
import 'package:estimation_list_generator/widgets/feature_views/estimation_generator/preview_layout.dart';
import 'package:estimation_list_generator/widgets/verification.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

void main() async {
  await Initializer.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light, // dark, system
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final appX = Get.find<AppController>();
  final dbX = Get.find<DbController>();
  bool showAbout = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    bool isDesktop = width > 800;
    final appBarHeight = isDesktop ? width / 10 : width / 5;

    Widget buildSystemInfo() {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastEaseInToSlowEaseOut,
        left: 32,
        bottom: showAbout ? 0 : -380,
        child: AnimatedContainer(
          padding: const EdgeInsets.all(16.0),
          duration: const Duration(milliseconds: 300),
          width: showAbout ? width * 0.3 : 200,
          height: 450,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(width * 0.02),
              topRight: Radius.circular(width * 0.02),
            ),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.1,
                ),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    showAbout = !showAbout;
                  });
                },
                icon: Row(
                  children: [
                    Icon(
                      showAbout
                          ? FontAwesomeIcons.caretDown
                          : FontAwesomeIcons.circleInfo,
                      color: AppColors.primaryLight,
                    ),
                    const Gap(8),
                    Text(
                      showAbout ? 'Close this info' : 'About this system',
                      style: TextStyle(color: AppColors.primaryLight),
                    ),
                  ],
                ),
              ),
              const Gap(32),
              Image.asset(
                mpwtLogoPNG,
                width: 120,
                height: 120,
              ),
              const Gap(12),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'MPWT DoF Tool Box',
                        style: TextStyle(
                          color: AppColors.primaryLight,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primaryLight,
                      ),
                      child: Text(
                        'BETA',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              Text('Version: ${appX.appVersion}'),
              const Gap(12),
              Text(
                'This product is made and used by Department of Finance only.',
                textAlign: TextAlign.center,
              ),
              const Gap(12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: ElevatedButton(
                  onPressed: () => appX.launchUpdates(),
                  child: Text('Check for updates'),
                ),
              ),
              const Gap(16),
              Text('Copyright © 2025 Department of Finance'),
            ],
          ),
        ),
      );
    }

    Widget buildAppBar() {
      return Material(
        child: Container(
          width: width,
          height: appBarHeight,
          decoration: BoxDecoration(
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
            gradient: AppColors.lightGradient,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () {
                          IconData buildIcon() {
                            switch (appX.featureIndex.value) {
                              case 0:
                                return Icons.document_scanner_rounded;
                              case 1:
                                return Icons.casino_rounded;
                              case 2:
                                return Icons.people_rounded;
                              case 3:
                                return Icons.follow_the_signs_rounded;
                              case 4:
                                return FontAwesomeIcons.qrcode;
                              case 5:
                                return FontAwesomeIcons.circleDollarToSlot;
                              case 6:
                                return FontAwesomeIcons.fileCode;
                              default:
                                return Icons.document_scanner_rounded;
                            }
                          }

                          return Icon(
                            buildIcon(),
                            color: Colors.white,
                            size: isDesktop ? width / 22 : width / 10,
                          );
                        },
                      ),
                      const Gap(16),
                      Obx(
                        () {
                          String buildTitle() {
                            switch (appX.featureIndex.value) {
                              case 0:
                                return forReviewGenerator;
                              case 1:
                                return mpwtLotteryList;
                              case 2:
                                return mpwtLotteryWinnerList;
                              case 3:
                                return followEstimationList;
                              case 4:
                                return qrCodeGenerator;
                              case 5:
                                return donateDeveloper;
                              case 6:
                                return followFMIS;
                              default:
                                return forReviewGenerator;
                            }
                          }

                          return Text(
                            buildTitle(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? width / 30 : width / 20,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              Column(
                children: <Widget>[
                  // app bar's gap
                  Gap(appBarHeight),
                  Row(
                    children: [
                      Container(
                        width: width * 0.37,
                        height: height - appBarHeight,
                        padding: const EdgeInsets.all(16.0),
                        color: AppColors.white,
                        child: FeaturesGridView(),
                      ),
                      Obx(
                        () {
                          bool allowScrolling = false;

                          if (appX.featureIndex.value == 6) {
                            allowScrolling = false;
                          } else {
                            allowScrolling = true;
                          }
                          Widget switchFeatureView() {
                            switch (appX.featureIndex.value) {
                              case 0:
                                return const PreviewLayout();
                              case 1:
                                return VerifyPage();
                              case 2:
                                return const IndexWinnerView();
                              case 3:
                                return const FollowEstimation();
                              case 4:
                                return const QrCodeGenerator();
                              case 5:
                                return const DonatePage();
                              case 6:
                                return const FollowFmis();
                              default:
                                return Container();
                            }
                          }

                          return Container(
                            width: width * 0.63,
                            height: height - appBarHeight,
                            color: AppColors.backgroundLight,
                            padding: !allowScrolling
                                ? const EdgeInsets.symmetric(horizontal: 16)
                                : null,
                            child: allowScrolling
                                ? SingleChildScrollView(
                                    padding: appX.featureIndex.value == 5
                                        ? null
                                        : const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                    physics: const BouncingScrollPhysics(),
                                    child: switchFeatureView(),
                                  )
                                : switchFeatureView(),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              buildSystemInfo(),
            ],
          ),
        ),
        buildAppBar(),
      ],
    );
  }
}
