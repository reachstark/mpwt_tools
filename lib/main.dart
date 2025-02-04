import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/controllers/initializer.dart';
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    bool isDesktop = width > 800;
    final appBarHeight = isDesktop ? width / 10 : width / 5;

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
          body: Center(
            child: Column(
              children: <Widget>[
                // app bar's gap
                Gap(appBarHeight),
                Row(
                  children: [
                    Container(
                      width: width * 0.4,
                      height: height - appBarHeight,
                      padding: const EdgeInsets.all(16.0),
                      color: AppColors.white,
                      child: FeaturesGridView(),
                    ),
                    Container(
                      width: width * 0.6,
                      height: height - appBarHeight,
                      color: AppColors.backgroundLight,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        physics: const BouncingScrollPhysics(),
                        child: Obx(
                          () {
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
                                default:
                                  return Container();
                              }
                            }

                            return switchFeatureView();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        buildAppBar(),
      ],
    );
  }
}
