import 'package:estimation_list_generator/utils/strings.dart';
import 'package:get/get.dart';
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

  @override
  Future<void> onInit() async {
    getAppVersion();
    super.onInit();
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
  }

  void setFeatureIndex(int index) {
    featureIndex.value = index;
  }

  Future<void> launchEstimationList() async {
    await launchUrl(
      Uri.parse(followEstimationListUrl),
    );
  }
}
