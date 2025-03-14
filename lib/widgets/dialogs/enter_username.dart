import 'package:estimation_list_generator/controllers/app_controller.dart';
import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void launchUsernameDialog() {
  Get.dialog(
    const EnterUsername(),
    barrierDismissible: false,
    barrierColor: Colors.black87,
    transitionCurve: Curves.easeInOut,
    transitionDuration: const Duration(milliseconds: 500),
  );
}

class EnterUsername extends StatefulWidget {
  const EnterUsername({super.key});

  @override
  State<EnterUsername> createState() => _EnterUsernameState();
}

class _EnterUsernameState extends State<EnterUsername> {
  final appX = Get.find<AppController>();
  final TextEditingController _usernameController = TextEditingController();
  String? errorMsg;

  bool isUsernameValid(String username) {
    return GetUtils.isAlphabetOnly(username) &&
        username.length >= 3 &&
        username.length <= 20;
  }

  void _validateAndSubmit() {
    setState(() {
      String username = _usernameController.text.trim();
      if (username.isEmpty) {
        errorMsg = 'សូមបញ្ចូលឈ្មោះអ្នកប្រើប្រាស់';
      } else if (!isUsernameValid(username)) {
        errorMsg =
            'ឈ្មោះ​អ្នក​ប្រើ​ត្រូវ​តែ​មាន​អក្សរប៉ុណ្ណោះ និង​មាន​ប្រវែង 3-20តួ ​ជា​ភាសា​អង់គ្លេស';
      } else {
        errorMsg = null;
        appX.setUsername(username).then((value) => Get.back());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "សូមបញ្ចូលឈ្មោះរបស់អ្នក",
              style: const TextStyle(
                fontSize: 22,
                fontFamily: kantumruy,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _usernameController,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: "ឈ្មោះ",
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
            ),
            const SizedBox(height: 10),
            if (errorMsg != null) ...[
              Text(
                errorMsg!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
              const SizedBox(height: 8),
            ],
            ElevatedButton(
              onPressed: _validateAndSubmit,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.blueAccent,
                elevation: 5,
                shadowColor: Colors.blue.withValues(alpha: 0.5),
              ),
              child: const Text(
                "យល់ព្រម",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: kantumruy,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
