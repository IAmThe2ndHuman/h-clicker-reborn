import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final bool isAnimated;
  final List<Color> gradientList;
  final String imageURL;

  GradientScaffold(
      {this.appBar, this.body, this.isAnimated = false, this.gradientList = const [Colors.white, Colors.grey], this.imageURL = ""});

  @override
  Widget build(BuildContext context) {
    Widget animatedContainer = AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: imageURL != "" ? DecorationImage(fit: BoxFit.cover, image: AssetImage(imageURL)) : null,
          gradient: imageURL == "" ? LinearGradient(colors: gradientList, begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
        ),
        child: body,
    );

    Widget container = Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: imageURL != "" ? DecorationImage(fit: BoxFit.cover, image: AssetImage(imageURL)) : null,
          gradient: imageURL == "" ? LinearGradient(colors: gradientList, begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
        ),
        child: body,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      // primary: true,
      appBar: appBar,
      body: isAnimated ? animatedContainer : container,
    );
  }
}
