import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/controllers/db_controller.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:window_manager/window_manager.dart';

class Initializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

    if (Platform.isWindows) {
      WindowManager.instance.setMinimumSize(const Size(1280, 720));
      WindowManager.instance.setMaximumSize(const Size(3840, 2160));
    }
    Get.put(AppController());
    Get.put(DbController());
  }
}
