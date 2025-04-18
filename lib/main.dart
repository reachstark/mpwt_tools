import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/controllers/initializer.dart';
import 'package:estimation_list_generator/screens/donate/donate_page.dart';
import 'package:estimation_list_generator/screens/follow_fmis/follow_fmis.dart';
import 'package:estimation_list_generator/screens/qr_generator/qr_code_generator.dart';
import 'package:estimation_list_generator/screens/settings/settings.dart';
import 'package:estimation_list_generator/screens/winner/index_winner_view.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/app_theme.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:estimation_list_generator/widgets/feature_views/follow_estimation/follow_estimation.dart';
import 'package:estimation_list_generator/widgets/features_gridview.dart';
import 'package:estimation_list_generator/widgets/feature_views/estimation_generator/preview_layout.dart';
import 'package:estimation_list_generator/widgets/scale_button.dart';
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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: AppController.to.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final appX = Get.find<AppController>();
  final dbX = Get.find<DbController>();
  bool extendDrawer = true;
  bool showAbout = false;

  Widget _buildSystemInfo(BuildContext context, double width) {
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
              color: Colors.black.withValues(alpha: 0.1),
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
                    child: const Text(
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
            const Text(
              'This product is made and used by Department of Finance only.',
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: ElevatedButton(
                onPressed: () => appX.launchUpdates(),
                child: const Text('Check for updates'),
              ),
            ),
            const Gap(16),
            const Text('Copyright © 2025 Department of Finance'),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(
      BuildContext context, double width, double appBarHeight, bool isDesktop) {
    return Material(
      child: Container(
        width: width,
        height: appBarHeight,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
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
                      () => Icon(
                        _buildAppBarIcon(),
                        color: Colors.white,
                        size: isDesktop ? width / 22 : width / 10,
                      ),
                    ),
                    const Gap(16),
                    Obx(
                      () => Text(
                        _buildAppBarTitle(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop ? width / 30 : width / 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () => appX.toggleTheme(false),
                icon: const Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.palette,
                      color: Colors.white,
                    ),
                    Gap(8),
                    Text(
                      'Switch Style',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _buildAppBarIcon() {
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

  String _buildAppBarTitle() {
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

  Widget _buildModernLayout(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor:
            appX.useTintedBlue.value ? AppColors.tintedBlue : AppColors.white,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigationRail(
              backgroundColor: appX.useTintedBlue.value
                  ? AppColors.tintedBlue
                  : Colors.white,
              indicatorColor: AppColors.backgroundLight,
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              selectedIconTheme: const IconThemeData(
                color: AppColors.primaryLight,
              ),
              labelType:
                  !extendDrawer ? NavigationRailLabelType.selected : null,
              leading: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 32,
                ),
                child: Row(
                  children: [
                    ScaleButton(
                      onTap: () => setState(() => extendDrawer = !extendDrawer),
                      child: Image.asset(
                        mpwtLogoPNG,
                        width: 80,
                        height: 80,
                      ),
                    ),
                    if (extendDrawer) ...[
                      const Gap(16),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MPWT DoF Tools',
                            style: TextStyle(
                              fontFamily: roboto,
                              color: appX.isDarkMode.value
                                  ? Colors.white
                                  : AppColors.primaryLight,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            'Version: ${appX.appVersion}',
                            style: TextStyle(
                              fontFamily: roboto,
                              color: appX.isDarkMode.value
                                  ? Colors.white
                                  : AppColors.primaryLight,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              extended: extendDrawer,
              onDestinationSelected: (int index) => appX.setFeatureIndex(index),
              destinations: _modernThemeNavigations,
              selectedIndex: appX.featureIndex.value,
            ),
            Expanded(
              child: Container(
                // color: appX.useTintedBlue.value
                //     ? AppColors.tintedBlue
                //     : AppColors.white,
                padding: _allowScrolling()
                    ? null
                    : const EdgeInsets.symmetric(horizontal: 16),
                child: _allowScrolling()
                    ? SingleChildScrollView(
                        padding: appX.featureIndex.value == 5
                            ? null
                            : const EdgeInsets.symmetric(horizontal: 16.0),
                        physics: const BouncingScrollPhysics(),
                        child: _switchFeatureView(),
                      )
                    : _switchFeatureView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _allowScrolling() {
    return !(appX.featureIndex.value == 7 ||
        appX.featureIndex.value == 6 ||
        appX.featureIndex.value == 4);
  }

  Widget _switchFeatureView() {
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
      case 7:
        return Settings();
      default:
        return Container();
    }
  }

  Widget _buildClassicLayout(
      BuildContext context, double width, double height, double appBarHeight) {
    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              Column(
                children: <Widget>[
                  Gap(appBarHeight),
                  Row(
                    children: [
                      Container(
                        width: width * 0.37,
                        height: height - appBarHeight,
                        padding: const EdgeInsets.all(16.0),
                        color: AppColors.white,
                        child: const FeaturesGridView(),
                      ),
                      Expanded(
                        child: Container(
                          height: height - appBarHeight,
                          color: AppColors.backgroundLight,
                          padding: _allowScrolling()
                              ? null
                              : const EdgeInsets.symmetric(horizontal: 16),
                          child: _allowScrolling()
                              ? SingleChildScrollView(
                                  padding: appX.featureIndex.value == 5
                                      ? null
                                      : const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                  physics: const BouncingScrollPhysics(),
                                  child: _switchFeatureView(),
                                )
                              : _switchFeatureView(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _buildSystemInfo(context, width),
            ],
          ),
        ),
        _buildAppBar(context, width, appBarHeight, width > 800),
      ],
    );
  }

  List<NavigationRailDestination> get _modernThemeNavigations {
    return [
      NavigationRailDestination(
        icon: const Icon(Icons.document_scanner_rounded),
        label: Text(forReviewGenerator),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.casino_rounded),
        label: Text(mpwtLotteryList),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.people_rounded),
        label: Text(mpwtLotteryWinnerList),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.follow_the_signs_rounded),
        label: Text(followEstimationList),
      ),
      NavigationRailDestination(
        icon: const Icon(FontAwesomeIcons.qrcode),
        label: Text(qrCodeGenerator),
      ),
      NavigationRailDestination(
        icon: const Icon(FontAwesomeIcons.circleDollarToSlot),
        label: Text(donateDeveloper),
      ),
      NavigationRailDestination(
        icon: const Icon(FontAwesomeIcons.fileCode),
        label: Text(followFMIS),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.settings_rounded),
        label: Text(settings),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isDesktop = width > 800;
    final appBarHeight = isDesktop ? width / 10 : width / 5;

    return Obx(
      () {
        switch (appX.useClassicTheme.value) {
          case true:
            return _buildClassicLayout(context, width, height, appBarHeight);
          case false:
            return _buildModernLayout(context);
        }
      },
    );
  }
}
