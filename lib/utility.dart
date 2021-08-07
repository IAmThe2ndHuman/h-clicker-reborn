import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

Future<Map<String, dynamic>> getSettings() async {
  SharedPreferences data = await SharedPreferences.getInstance();
  return {
    "hCount": data.getInt("hCount") ?? 0,
    "themeIndex": data.getInt("themeIndex") ?? 0,
    "fontIndex": data.getInt("fontIndex") ?? 0,
    "disableJerma": data.getBool("disableJerma") ?? false,
    "purchasedThemes": data.getStringList("purchasedThemes") ?? ["Default"],
    "purchasedFonts": data.getStringList("purchasedFonts") ?? ["Roboto"],
    "achievements": data.getStringList("achievements") ?? [],
  };
}

Future<SharedPreferences> getSharedPreferences() async {
  return await SharedPreferences.getInstance();
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

int randIntInRange(int min, int max) {
  Random random = Random();
  return random.nextInt(max) + min;
}

class NoScrollbarSplash extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
