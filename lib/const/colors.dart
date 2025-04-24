import 'package:flutter/material.dart';

class AppColors {
  static const Color main = Color.fromRGBO(2, 53, 118, 1);
  static const Color main2 = Color.fromRGBO(78, 114, 160, 1);
  static const Color mainer = Color.fromRGBO(2, 53, 118, 0.1);
  static const Color blurColor = Color.fromRGBO(217, 217, 217, 0.6);

  static const LinearGradient mainGradient = LinearGradient(
    colors: [main, mainer],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
