import 'package:flutter/material.dart';
import '../utility.dart';

class HiddenReset extends StatefulWidget {
  @override
  _HiddenResetState createState() => _HiddenResetState();
}

class _HiddenResetState extends State<HiddenReset> {
  List<String> messages = [
    "Welcome to the reset chamber.",
    "huh",
    "bruh",
    "can you like",
    "use the buttons",
    "theres like",
    "a yes and a no button",
    "click those",
    "bro",
    "im serious",
    "do it",
    "do it or you will be sorry",
    "just click yes or no damn it",
    "..."
    "ok"
  ];
  int messageIndex = 0;
  String sure = "Would you like to reset your h count?";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          sure = "";
          messageIndex++;
        });
        return false;
      },
      child: SafeArea(
        child: ScrollConfiguration(
          behavior: NoScrollbarSplash(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(messages[messageIndex]),
              Text(sure),
              GestureDetector(
                child: Text("Yes."),
                onTap: () {
                  getSharedPreferences().then((value) {
                    value.clear();
                    Navigator.pop(context);
                  });
                },
              ),
              GestureDetector(
                child: Text("No."),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(child: Scaffold(backgroundColor: Colors.red[900],
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: SelectableText("""
◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
'package:flutter/src/widgets/basic.dart': Failed assertion: line 6931 pos 15: 'child != null': is not true.
See also:
https://www.youtube.com/watch?v=iik25wqIuFo
◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
Exception caught by widgets library

The following MissingPluginException was thrown building HiddenReset(dirty):
MissingPluginException(null)

The relevant error-causing widget was: 
  HiddenReset file:///C:/Users/ok/AndroidStudioProjects/h_clicker_reborn/lib/main.dart:34:38
When the exception was thrown, this was the stack: 
#0      HiddenReset.build (package:h_clicker_reborn/screens/hidden_reset.dart:8:5)
#1      StatelessElement.build (package:flutter/src/widgets/framework.dart:4648:28)
#2      ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:4574:15)
#3      Element.rebuild (package:flutter/src/widgets/framework.dart:4267:5)
#4      StatelessElement.update (package:flutter/src/widgets/framework.dart:4655:5)
...
◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
                    """, style: TextStyle(color: Colors.yellow, fontSize: 15),),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

