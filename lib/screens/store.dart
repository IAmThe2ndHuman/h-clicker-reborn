import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:h_clicker_reborn/components/achievement_banner.dart';
import 'package:h_clicker_reborn/services/achievements.dart';
import 'package:h_clicker_reborn/services/audioplayer.dart';

import '../utility.dart';
import '../components/scaffold.dart';
import '../services/customization.dart';

class Store extends StatefulWidget {
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store>{

  // achievement get
  bool _isAchievementVisible = false;
  String _achievementName = "Unknown";
  String _achievementReward = "";

  @override
  void initState() {
    audioPlayer.pause();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSettings(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(body: Center(child: Text("Preparing your h...")));
        } else {

          // THEMES TAB
          List<Widget> colorTypes = [SizedBox(height: 5)];
          for (String colorName in storeThemes.keys) {
            Widget icon = Container();
            Function onPressed;
            BorderSide border = BorderSide.none;
            bool achievementReward = storeThemes[colorName]!.price != -1;

            void applyTheme() {
              // avoiding unnecessary setState
              if (snapshot.data!["themeIndex"] != storeThemes.keys.toList().indexOf(colorName)) {
                setState(() {
                  getSharedPreferences().then(
                          (value) => value.setInt("themeIndex", storeThemes.keys.toList().indexOf(colorName)));
                });
              }
            }

            void purchaseItem() {
              if (!achievementReward) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black,
                  duration: Duration(seconds: 2),
                  content: Text(
                      "This theme can only be unlocked by earninq an achievement!",
                      style: TextStyle(color: Colors.white)
                  ),
                ));
              } else if (snapshot.data!["hCount"] < storeThemes[colorName]!.price) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black,
                  duration: Duration(seconds: 2),
                  content: Text(
                      randIntInRange(1, 1000) == 1 ? "lol poor" : "You can't afford this!",
                      style: TextStyle(color: Colors.white)
                  ),
                ));
              } else {
                getSharedPreferences().then((value) {
                  // we have to use this not snapshot because we need to get the latest bought list
                  setState(() {
                    List<String> boughtItems = snapshot.data!["purchasedThemes"];
                    boughtItems.add(colorName);
                    value.setStringList("purchasedThemes", boughtItems);
                    value.setInt("hCount", snapshot.data!["hCount"] - storeThemes[colorName]!.price!);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.black,
                    content: Text("Purchased $colorName successfully!", style: TextStyle(color: Colors.white)),
                  ));

                  // achievement...again
                  List<String> unlockedAchievements = value.getStringList("achievements") ?? [];
                  for (var achievement in achievements.keys) {
                    if (achievements[achievement]!.achievementType == AchievementType.purchase) {
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
            }

            // check if bought
            if (!snapshot.data!["purchasedThemes"].contains(colorName)) {
              // show price instead of checkmark
              icon = Row(
                children: [
                  Icon(Icons.lock_outline),
                  SizedBox(width: 5),
                  Text(achievementReward ? "Buy for ${storeThemes[colorName]!.price}" : "Achievement Reward",
                    style: TextStyle(
                        fontWeight: !(snapshot.data!["hCount"] < storeThemes[colorName]!.price) ? FontWeight.bold : null
                    ),
                  )
                ],
              );
              onPressed = purchaseItem;
            } else {
              onPressed = applyTheme;
            }

            // check if selected
            if (storeThemes.keys.toList().indexOf(colorName) == snapshot.data!["themeIndex"]) {
              icon = Icon(Icons.check);
              border = BorderSide(color: Colors.white, width: 2);
            }

            // if havin amogus disabled
            if (snapshot.data!["disableJerma"] && colorName == "Sus") {
              colorTypes.add(
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: border
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text("You're welcome.")),
                  ),
                )
              );
            } else {
              colorTypes.add(Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: border
                ),
                child: Container(
                  width: double.infinity,
                  height: 110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: storeThemes[colorName]!.imageURL != "" ? DecorationImage(fit: BoxFit.cover, image: AssetImage(storeThemes[colorName]!.imageURL)) : null,
                      gradient: storeThemes[colorName]!.imageURL == "" ? LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: storeThemes[colorName]!.colors) : null),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(colorName, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                            Text(storeThemes[colorName]!.description, style: TextStyle(fontSize: 18)),
                            Expanded(child: Row(children: [Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: icon,
                            )], mainAxisAlignment: MainAxisAlignment.end,))
                          ],
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => onPressed(),
                      onLongPress: storeThemes[colorName]!.imageURL != "" ? () {
                        showDialog(context: context, builder: (BuildContext context) {
                          return AlertDialog(
                            content: Image.asset(storeThemes[colorName]!.imageURL),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: Text("CLOSE"))
                            ],
                          );
                        });
                      } : null,
                    ),
                  ),
                ),
              ));
            }
          }

          colorTypes.add(
            Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Hold imaqe items to preview them.", style: TextStyle(fontWeight: FontWeight.bold)),
                )
            )
          );


          // FONTS TAB YES I REUSED CODE SO WHAT ITS WHAT WE PROGRAMMERS DO WE COPY CODE AND HOPE IT WORKS
          // FONTS TAB
          List<Widget> fontTypes = [SizedBox(height: 5)];
          for (String fontName in storeFonts.keys) {
            Widget icon = Container();
            Function onPressed;
            BorderSide border = BorderSide.none;
            bool achievementReward = storeFonts[fontName]!.price != -1;

            void applyFont() {
              // avoiding unnecessary setState
              if (snapshot.data!["fontIndex"] != storeFonts.keys.toList().indexOf(fontName)) {
                setState(() {
                  getSharedPreferences().then(
                          (value) => value.setInt("fontIndex", storeFonts.keys.toList().indexOf(fontName)));
                });
              }
            }

            void purchaseItem() {
              if (!achievementReward) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black,
                  duration: Duration(seconds: 2),
                  content: Text(
                      "This font can only be unlocked by earninq an achievement!",
                      style: TextStyle(color: Colors.white)
                  ),
                ));
              } else if (snapshot.data!["hCount"] < storeFonts[fontName]!.price) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black,
                  duration: Duration(seconds: 2),
                  content: Text(
                      randIntInRange(1, 1000) == 1 ? "lol poor" : "You can't afford this!", // easter egg
                      style: TextStyle(color: Colors.white)
                  ),
                ));
              } else {
                getSharedPreferences().then((value) {
                  // we have to use this not snapshot because we need to get the latest bought list
                  setState(() {
                    List<String> boughtItems = snapshot.data!["purchasedFonts"];
                    boughtItems.add(fontName);
                    value.setStringList("purchasedFonts", boughtItems);
                    value.setInt("hCount", snapshot.data!["hCount"] - storeFonts[fontName]!.price!);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.black,
                    content: Text("Purchased $fontName successfully!", style: TextStyle(color: Colors.white)),
                  ));

                  // achievement...again
                  List<String> unlockedAchievements = value.getStringList("achievements") ?? [];
                  for (var achievement in achievements.keys) {
                    if (achievements[achievement]!.achievementType == AchievementType.purchase) {
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
            }

            // check if bought
            if (!snapshot.data!["purchasedFonts"].contains(fontName)) {
              // show price instead of checkmark
              icon = Row(
                children: [
                  Icon(Icons.lock_outline, color: Colors.black),
                  SizedBox(width: 5),
                  Text(achievementReward ? "Buy for ${storeFonts[fontName]!.price}" : "Achievement Reward",
                    style: TextStyle(
                      fontWeight: !(snapshot.data!["hCount"] < storeFonts[fontName]!.price) ? FontWeight.bold : null,
                      color: Colors.black
                    ),
                  )
                ],
              );
              onPressed = purchaseItem;
            } else {
              onPressed = applyFont;
            }

            // check if selected
            if (storeFonts.keys.toList().indexOf(fontName) == snapshot.data!["fontIndex"]) {
              icon = Icon(Icons.check, color: Colors.black);
              border = BorderSide(color: Colors.black, width: 2);
            }


            fontTypes.add(Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: border
              ),
              child: Container(
                width: double.infinity,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("H", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: fontName, color: Colors.black)),
                          Text(fontName, style: TextStyle(fontSize: 18, color: Colors.black)),
                          Expanded(child: Row(children: [Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: icon,
                          )], mainAxisAlignment: MainAxisAlignment.end,))
                        ],
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => onPressed(),
                  ),
                ),
              ),
            ));
          }



          return DefaultTabController(
            length: 3,
            child: GradientScaffold(
              isAnimated: true,
              imageURL: storeThemes.values.toList()[snapshot.data!["themeIndex"]].imageURL,
              gradientList: storeThemes.values.toList()[snapshot.data!["themeIndex"]].colors,
              appBar: AppBar(
                title: Text("Customize"),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  physics: BouncingScrollPhysics(),
                  tabs: [
                    Tab(text: "THEMES"),
                    Tab(text: "FONTS"),
                    Tab(text: "MUSIC"),
                  ],
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Text("${snapshot.data!["hCount"]} remaininq"),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 2, color: Colors.white)
                        ),
                      ),
                    ),
                  )
                ],
              ),
              body: SafeArea(
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    TabBarView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        Scrollbar(
                          radius: Radius.circular(10),
                          child: ListView(children: colorTypes, physics: BouncingScrollPhysics())
                        ),
                        Scrollbar(
                          radius: Radius.circular(10),
                          child: ListView(children: fontTypes, physics: BouncingScrollPhysics())
                        ),
                        Center(child: Text("h"))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: AchievementBanner(
                        visible: _isAchievementVisible,
                        border: storeThemes.values.toList()[snapshot.data!["themeIndex"]].colors[0] == Colors.black ?
                        Border.all(color: Colors.white) : null,
                        achievementName: _achievementName,
                        rewardDescription: _achievementReward
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
