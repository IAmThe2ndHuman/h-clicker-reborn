import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:h_clicker_reborn/components/scaffold.dart';
import 'package:h_clicker_reborn/services/achievements.dart';
import 'package:h_clicker_reborn/services/customization.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utility.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSettings(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(body: Center(child: Text("Preparing your h...")));
        } else {
          return GradientScaffold(
            imageURL: storeThemes.values.toList()[snapshot.data!["themeIndex"]].imageURL,
            gradientList: storeThemes.values.toList()[snapshot.data!["themeIndex"]].colors,
            appBar: AppBar(
              title: GestureDetector(
                child: Text("About"),
              ),
            ),
            body: SafeArea(
              child: ScrollConfiguration(
                  child: Scrollbar(
                      radius: Radius.circular(10),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: ListView(
                          children: [
                            Text("DEVELOPER", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("u/IAmThe2ndHuman", style: TextStyle(fontSize: 30)),
                            SizedBox(height: 20),
                            Text("ORIQINAL H CLICKER DEVELOPER", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("u/dnorhoj", style: TextStyle(fontSize: 30)),
                            SizedBox(height: 20),
                            Text("ADDITIONAL HELP", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("MakufonSkifto#1414", style: TextStyle(fontSize: 30)),
                            Divider(thickness: 2, color: Colors.white30),
                            ElevatedButton(
                              child: Text("DOWNLOAD THE ORIQINAL H CLICKER", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[900])),
                              onPressed: () => launch("https://play.google.com/store/apps/details?"
                                  "id=me.dnorhoj.h_clicker&hl=tr&gl=US"),
                            ),
                            ElevatedButton(
                              child: Text("JOIN THE H SERVER", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[900])),
                              onPressed: () {
                                launch("https://discord.gg/efKCpuA");
                                getSharedPreferences().then((value) {
                                  if (!(value.getStringList("achievements") ?? []).contains("H Connoisseur")) {
                                    achievements["H Connoisseur"]!.onAchievementGet!(value);

                                    List<String> unlockedAchievements = value.getStringList("achievements") ?? [];
                                    unlockedAchievements.add("H Connoisseur");
                                    value.setStringList("achievements", unlockedAchievements);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      )
                  ),
                  behavior: NoScrollbarSplash()
              ),
            ),
          );
        }
      },
    );
  }
}
