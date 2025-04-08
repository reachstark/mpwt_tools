import 'dart:async';

import 'package:estimation_list_generator/utils/strings.dart';
import 'package:estimation_list_generator/widgets/dialogs/enter_username.dart';
import 'package:estimation_list_generator/widgets/snackbar/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  final GetStorage storage = GetStorage();
  RxString appVersion = ''.obs;
  RxInt featureIndex = 0.obs;
  RxString username = ''.obs;
  RxBool useClassicTheme = true.obs;
  RxString hexColor = ''.obs;
  RxBool useTintedBlue = false.obs;
  RxBool isDarkMode = false.obs;

  ThemeMode get themeMode =>
      isDarkMode.isTrue ? ThemeMode.dark : ThemeMode.light;

  // Review Project
  RxString department = 'នាយកដ្ឋានហិរញ្ញវត្ថុ'.obs;
  RxString summary = reviewSample.obs;
  RxString projectId = projectIdSample.obs;

  RxBool hasNetwork = false.obs;

  late StreamSubscription<InternetStatus> internetConnection;

  @override
  Future<void> onInit() async {
    checkTheme();
    getAppVersion();
    listenToInternetConnection();
    checkUsername();
    checkHexColor();
    getTintedBlue();
    super.onInit();
  }

  Future<void> toggleTintedBlue(bool value) async {
    useTintedBlue.value = value;
    useTintedBlue.refresh();
    storage.write('useTintedBlue', value);
  }

  Future<void> getTintedBlue() async {
    useTintedBlue.value = storage.read('useTintedBlue') ?? false;
    useTintedBlue.refresh();
  }

  Future<void> toggleDarkMode(bool? value) async {
    if (value != null) {
      isDarkMode.value = value;
    } else {
      isDarkMode.value = !isDarkMode.value;
    }

    Get.changeThemeMode(themeMode);
    storage.write('isDarkMode', isDarkMode.value);
    isDarkMode.refresh();
  }

  Future<void> getDarkMode() async {
    isDarkMode.value = storage.read('isDarkMode') ?? false;
    isDarkMode.refresh();
  }

  Future<void> checkTheme() async {
    final savedTheme = storage.read('useClassicTheme');
    if (savedTheme != null) useClassicTheme.value = savedTheme;
  }

  Future<void> toggleTheme(bool value) async {
    if (value == true) {
      setFeatureIndex(0);
      toggleDarkMode(false);
    }
    useClassicTheme.value = value;
    storage.write('useClassicTheme', value);
    useClassicTheme.refresh();
  }

  Future<void> saveHexColor(String customHexColor) async {
    storage.write('hexColor', customHexColor);
  }

  Future<void> checkHexColor() async {
    final savedHexColor = storage.read('hexColor');
    if (savedHexColor != null) hexColor.value = savedHexColor;
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

  Future<void> setUsername(String name) async {
    await storage.write('username', name);
    username.value = name;
  }

  Future<void> checkUsername() async {
    username.value = storage.read<String>('username') ?? '';
    print('USERNAME: ${username.value}');
    if (username.value.trim().isEmpty) {
      Future.delayed(
        const Duration(seconds: 1),
        () => launchUsernameDialog(),
      );
    }
  }
}
