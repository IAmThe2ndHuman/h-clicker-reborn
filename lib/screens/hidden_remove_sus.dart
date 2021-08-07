import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:h_clicker_reborn/utility.dart';

class HiddenRemoveSus extends StatefulWidget {
  const HiddenRemoveSus({Key? key}) : super(key: key);

  @override
  _HiddenRemoveSusState createState() => _HiddenRemoveSusState();
}

class _HiddenRemoveSusState extends State<HiddenRemoveSus> {
  String answer = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("""
so you found me
congratulations
was it worth it?

because i have never seen someone dislike jerma sus before
but to each their own
if you really want to disable the sus, so be it.

but i won't make this easy...
solve this simple puzzle, and then maybe i'll disable the sus for you

you've done this before, right?

good luck
                  """, textAlign: TextAlign.center),
                  SizedBox(height: 1000),
                  ColorFiltered(
                    child: Image.network("https://i.ytimg.com/vi/0bZ0hkiIKt0/maxresdefault.jpg"),
                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.color),
                  ),
                  SizedBox(height: 1000),
                  Text(
                      "When the impostor is $answer",
                      style: TextStyle(color: answer == "sus" ? Colors.lightGreen : Colors.white)
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          answer = value.toLowerCase();
                        });
                        if (answer == "sus") {
                          getSharedPreferences().then((value) {
                            sleep(Duration(seconds: 1));
                            value.setBool("disableJerma", true);
                            Fluttertoast.showToast(msg: "this is it.");
                            sleep(Duration(seconds: 4));
                            Fluttertoast.showToast(msg: "you wanted this");
                            sleep(Duration(seconds: 4));
                            Fluttertoast.showToast(msg: "if you want to undo what you did");
                            sleep(Duration(seconds: 4));
                            Fluttertoast.showToast(msg: "come back here");
                            sleep(Duration(seconds: 4));
                            Fluttertoast.showToast(msg: "have fun");
                            sleep(Duration(seconds: 4));
                            Navigator.popAndPushNamed(context, "/");
                          });

                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
