import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

void launchConfetti(BuildContext context) {
  double randomInRange(double min, double max) {
    return min + Random().nextDouble() * (max - min);
  }

  Confetti.launch(
    context,
    options: ConfettiOptions(
        angle: randomInRange(55, 125),
        spread: randomInRange(50, 70),
        particleCount: randomInRange(200, 350).toInt(),
        y: 0.6),
  );
}
