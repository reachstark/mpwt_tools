import 'dart:async';

import 'package:estimation_list_generator/utils/strings.dart';
import 'package:estimation_list_generator/widgets/snackbar/snackbars.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  RxString appVersion = ''.obs;
  RxInt featureIndex = 0.obs;

  // Review Project
  RxString department = 'នាយកដ្ឋានហិរញ្ញវត្ថុ'.obs;
  RxString summary = reviewSample.obs;
  RxString projectId = projectIdSample.obs;

  RxBool hasNetwork = false.obs;

  late StreamSubscription<InternetStatus> internetConnection;

  @override
  Future<void> onInit() async {
    getAppVersion();
    listenToInternetConnection();
    super.onInit();
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
  }

  void setFeatureIndex(int index) {
    if (index == 1 || index == 2) {
      // check for internet status
      if (!hasNetwork.value) {
        // display snack bar
        return;
      }
    }
    featureIndex.value = index;
  }

  Future<void> launchEstimationList() async {
    await launchUrl(
      Uri.parse(followEstimationListUrl),
    );
  }

  Future<void> launchUpdates() async {
    await launchUrl(
      Uri.parse(updatesUrl),
    );
  }

  void listenToInternetConnection() {
    internetConnection = InternetConnection().onStatusChange.listen(
      (status) {
        switch (status) {
          case InternetStatus.connected:
            hasNetwork.value = true;
            showSuccessSnackbar(message: 'Your internet connection is back!');
            break;
          case InternetStatus.disconnected:
            hasNetwork.value = false;
            showWarningSnackbar(message: 'Your internet connection is lost!');
            break;
        }
      },
    );
  }

  void cancelInternetConnectionListener() => internetConnection.cancel();
}
