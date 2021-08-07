import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:h_clicker_reborn/components/achievement_banner.dart';
import 'package:h_clicker_reborn/services/achievements.dart';
import 'package:h_clicker_reborn/services/audioplayer.dart';

import '../utility.dart';
import '../components/scaffold.dart';
import '../services/customization.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  int hCount = 0;
  Color hColor = Colors.white;

  // achievement get
  bool _isAchievementVisible = false;
  String _achievementName = "Unknown";
  String _achievementReward = "";

  void _incrementH() {
    getSharedPreferences().then((value) {
      hCount++;
      value.setInt("hCount", hCount);

      // achievement
      List<String> unlockedAchievements = value.getStringList("achievements") ?? [];
      for (var achievement in achievements.keys) {
        if (achievements[achievement]!.achievementType == AchievementType.clicker) {
          // used this and not && because i dont want it to check if it isnt AchievementType.purchase

          if (achievements[achievement]!.achievementCondition!(value) &&
              !(value.getStringList("achievements") ?? []).contains(achievement)) {
            if (achievements[achievement]!.onAchievementGet != null) {
              achievements[achievement]!.onAchievementGet!(value);
            }

            unlockedAchievements.add(achievement);
            value.setStringList("achievements", unlockedAchievements);

            _achievementName = achievement;
            _achievementReward = achievements[achievement]!.rewardDescription.toUpperCase();

            setState(() {
              _isAchievementVisible = true;
            });
            Future.delayed(Duration(seconds: 3), () {
              setState(() {
                _isAchievementVisible = false;
              });
            });

            break;
          }
        }
      }
    });
  }

  // secret havin jerma mode
  bool hasResumed = false;
  bool isReady = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && hCount == 48) {
      hasResumed = true;
    } else if (state == AppLifecycleState.resumed && hasResumed && hCount == 48) {
      isReady = true;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this); // detect when app launched i think
    audioPlayer.setAsset("assets/audio/hintro.mp3");
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSettings(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(body: Center(child: Text("Preparing your h...")));
        } else {
          hCount = snapshot.data!["hCount"];
          audioPlayer.play();

          return GradientScaffold(
            imageURL: storeThemes.values.toList()[snapshot.data!["themeIndex"]].imageURL,
            gradientList: storeThemes.values.toList()[snapshot.data!["themeIndex"]].colors,
            appBar: AppBar(
              title: GestureDetector(
                child: Text("H Clicker: Reborn"),
                onLongPress: () {
                  Navigator.pushNamed(context, "/hiddenReset").then((value) => setState(() {}));
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () => Navigator.pushNamed(context, "/about").then((value) => setState(() {})),
                ),
              ],
            ),
            body: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(hCount.toString(), style: TextStyle(fontSize: 50)),
                      GestureDetector(
                        child: Text("H", style: TextStyle(
                            fontSize: 200,
                            color: hColor,
                            fontFamily: storeFonts.keys.toList()[snapshot.data!["fontIndex"]]
                        )),
                        onPanUpdate: (_) { // todo debug remove
                          setState(() {
                            _incrementH();
                          });
                        },
                        onTap: () {
                          setState(() {
                            _incrementH();
                          });
                        },
                        onTapDown: (_) {
                          setState(() {
                            hColor = darken(Colors.white, 0.2);
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            hColor = lighten(Colors.white, 0.2);
                          });
                        },
                        onTapCancel: () {
                          setState(() {
                            hColor = lighten(Colors.white, 0.2);
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(99))
                                )
                            ),
                            onPressed: () => Navigator.pushNamed(context, "/achievements"),
                            onLongPress: isReady && hCount == 48 ? () {
                              getSharedPreferences().then((value) {
                                if (value.getBool("disableJerma") ?? false) {
                                  Fluttertoast.showToast(msg: "do you want to undo everything you've done?");
                                  showDialog(context: context, builder: (BuildContext context) {
                                    return AlertDialog(
                                      actions: [
                                        TextButton(
                                          child: Text("NO"),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                        TextButton(
                                          child: Text("YES"),
                                          onPressed: () {
                                            Fluttertoast.showToast(msg: "then");
                                            sleep(Duration(seconds: 4));
                                            Fluttertoast.showToast(msg: "it is done.");
                                            sleep(Duration(seconds: 4));
                                            value.remove("disableJerma");
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  });
                                } else {
                                  Navigator.popAndPushNamed(context, "/hiddenRemoveSus");
                                }
                              });
                            } : null,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.emoji_events_outlined),
                                  SizedBox(width: 10,),
                                  Text("Achievements")
                                ],
                              ),
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(99))
                                )
                            ),
                            onPressed: () => Navigator.pushNamed(context, "/store").then((value) => setState(() {})),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.palette_outlined),
                                  SizedBox(width: 10,),
                                  Text("Customize")
                                ],
                              ),
                            ),
                          )
                        ],
                      )

                    ],
                  ),
                  AchievementBanner(
                    visible: _isAchievementVisible,
                    border: storeThemes.values.toList()[snapshot.data!["themeIndex"]].colors[0] == Colors.black ?
                    Border.all(color: Colors.white) : null,
                    achievementName: _achievementName,
                    rewardDescription: _achievementReward
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
