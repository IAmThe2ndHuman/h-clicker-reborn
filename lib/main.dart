import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:h_clicker_reborn/screens/about.dart';
import 'package:h_clicker_reborn/screens/achievements.dart';
import 'package:h_clicker_reborn/screens/hidden_remove_sus.dart';
import 'package:h_clicker_reborn/screens/hidden_reset.dart';
import 'package:h_clicker_reborn/screens/home.dart';
import 'package:h_clicker_reborn/screens/store.dart';
import 'package:h_clicker_reborn/utility.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]); // FIX WHEN

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'H Clicker Reborn',
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder()
          }
        ),
        brightness: Brightness.dark,
        primarySwatch: createMaterialColor(Colors.white),
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.transparent
        )
      ),
      routes: {
        "/": (context) => Home(),
        "/store": (context) => Store(),
        "/achievements": (context) => Achievements(),
        "/hiddenReset": (context) => HiddenReset(),
        "/hiddenRemoveSus": (context) => HiddenRemoveSus(),
        "/about": (context) => About()
      },
      initialRoute: "/",
    );
  }
}
