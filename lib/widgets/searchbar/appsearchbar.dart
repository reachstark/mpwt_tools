import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Appsearchbar extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? suffixWidget;
  const Appsearchbar({super.key, this.controller, this.suffixWidget});

  @override
  Widget build(BuildContext context) {
    final appX = Get.find<AppController>();
    return Obx(
      () => TextFormField(
        controller: controller,
        style: TextStyle(
          color:
              appX.isDarkMode.value ? AppColors.backgroundLight : Colors.black,
          fontSize: 16,
        ),
        cursorColor: appX.isDarkMode.value ? Colors.white : Colors.black,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          hintText: 'Search...',
          hintStyle: TextStyle(
            color:
                appX.isDarkMode.value ? AppColors.backgroundLight : Colors.grey,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color:
                appX.isDarkMode.value ? AppColors.backgroundLight : Colors.grey,
          ),
          suffixIcon: suffixWidget,
          filled: true,
          fillColor: appX.isDarkMode.value ? Color(0xFF1E1E1E) : Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
                color: appX.isDarkMode.value ? Color(0xFF1E1E1E) : Colors.grey,
                width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
                color: appX.isDarkMode.value
                    ? AppColors.backgroundLight
                    : AppColors.primaryLight,
                width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );
  }
}
