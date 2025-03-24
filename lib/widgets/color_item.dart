import 'package:flutter/material.dart';
import 'package:estimation_list_generator/widgets/scale_button.dart';

class ColorItem extends StatelessWidget {
  final Color? color;
  final String? hexColor;
  final VoidCallback? onTap;
  final bool isSelected;

  const ColorItem({
    super.key,
    this.hexColor,
    this.color,
    this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    Color displayColor;

    if (color != null) {
      displayColor = color!;
    } else if (hexColor != null) {
      try {
        String hex = hexColor!.replaceAll("#", "");
        if (hex.length == 6) {
          // Check for valid hex length
          displayColor = Color(int.parse("0xFF$hex"));
        } else {
          displayColor = Colors.grey; // Or any default color
        }
      } catch (e) {
        displayColor = Colors.grey;
      }
    } else {
      displayColor = Colors.black;
    }

    return ScaleButton(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: displayColor,
              shape: BoxShape.circle,
            ),
          ),
          if (isSelected)
            Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.done,
                size: 18,
                color: displayColor,
              ),
            ),
        ],
      ),
    );
  }
}
