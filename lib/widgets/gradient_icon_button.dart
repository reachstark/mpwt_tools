import 'package:estimation_list_generator/utils/app_colors.dart';
import 'package:estimation_list_generator/widgets/scale_button.dart';
import 'package:flutter/material.dart';

class GradientIconButton extends StatefulWidget {
  final IconData icon;
  final double? size;
  final VoidCallback? onClick;
  final String? tooltip;
  const GradientIconButton({
    super.key,
    required this.icon,
    this.size,
    this.onClick,
    this.tooltip,
  });

  @override
  State<GradientIconButton> createState() => _GradientIconButtonState();
}

class _GradientIconButtonState extends State<GradientIconButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      onTap: widget.onClick,
      tooltip: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => setState(() => isHovered = true),
        onExit: (event) => setState(() => isHovered = false),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isHovered ? null : AppColors.backgroundLight,
            gradient: isHovered ? AppColors.lightGradient : null,
          ),
          child: Icon(
            widget.icon,
            color: isHovered ? AppColors.white : AppColors.primaryLight,
            size: widget.size ?? 18,
          ),
        ),
      ),
    );
  }
}
