import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  final bool isVertical;
  final double width;

  const DottedLine({super.key, required this.width, this.isVertical = false});

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return CustomPaint(
        size: Size(0.5, width),
        painter: DashPainter(),
      );
    } else {
      return CustomPaint(
        size: Size(width, 0.5),
        painter: DashPainter(),
      );
    }
  }
}

class DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;

    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
