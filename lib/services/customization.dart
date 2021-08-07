// customize your h
import 'package:flutter/material.dart';

class _BackgroundTheme {
  final List<Color> colors;
  final int? price;
  final String imageURL;
  final String description;

  _BackgroundTheme({this.colors = const [], this.price, this.imageURL = "", this.description = "No Description"});
}

class _Font {
  final int? price;

  _Font({this.price});
}

class _Music {
  final String songPath;

  _Music({this.songPath = ""}); // todo finish
}

Map<String, _BackgroundTheme> storeThemes = {
  "Default": _BackgroundTheme(colors: [Colors.black, Colors.black], price: 0, description: "Very basic and averaqe"),
  "Silver": _BackgroundTheme(colors: [Colors.grey, Colors.grey[850] ?? Colors.grey], price: 50, description: "It's like fake metal"),
  "Summer": _BackgroundTheme(colors: [Colors.red, Colors.orange], price: 100, description: "Hot."),
  "Nature": _BackgroundTheme(colors: [Colors.green, Colors.lightBlue], price: 200, description: "100% orqanic and natural!"),
  "Niqht": _BackgroundTheme(colors: [Colors.purple, Colors.blue], price: 500, description: "City skyline"),
  "Lemon": _BackgroundTheme(colors: [Colors.orange, Colors.yellow], price: 1000, description: "Sour!"),
  "Floppa": _BackgroundTheme(colors: [Colors.transparent], price: 1500, imageURL: "assets/images/floppa.jpg", description: "he flop"),
  "Static H": _BackgroundTheme(colors: [Colors.transparent], price: 2000, imageURL: "assets/images/h.png", description: "H"),
  "Triple H": _BackgroundTheme(colors: [Colors.transparent], price: 4000, imageURL: "assets/images/tripleh.png", description: "HHH"),
  "Sus": _BackgroundTheme(colors: [Colors.transparent], price: 6000, imageURL: "assets/images/jerma.jpg", description: "When the imposter is sus! 😳"),
  "Blind": _BackgroundTheme(colors: [Colors.white, Colors.white], price: 6000, description: "I can't see!"),
  "Troll": _BackgroundTheme(colors: [Colors.transparent], price: 10000, imageURL: "assets/images/troll.jpg", description: "this is a troll (qet trolled xd)"),
  "⚚ Animated H": _BackgroundTheme(colors: [Colors.transparent], price: 50000, imageURL: "assets/images/h.gif", description: "The ultimate theme."),
  "Pride": _BackgroundTheme(colors: [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple
  ], price: -1, description: "Or rainbow!"),
  "Blurple": _BackgroundTheme(colors: [Color(0xFF5865F2), Color(0xFF5865F2)], price: -1, description: "Iconic"),
  "Leqacy Blurple": _BackgroundTheme(colors: [Color(0xFF7289DA), Color(0xFF7289DA)], price: -1, description: "You will be missed"),
};

Map<String, _Font> storeFonts = {
  "Roboto": _Font(price: 0),
  "Times New Roman": _Font(price: 100),
  "Comic Sans": _Font(price: 200),
  "Papyrus": _Font(price: 350),
  "Qeometry Dash": _Font(price: 500),
  "Minecraft": _Font(price: 700),
  "Sus": _Font(price: 6000),
};
