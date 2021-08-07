import 'package:flutter/material.dart';
import 'package:h_clicker_reborn/components/scaffold.dart';
import 'package:h_clicker_reborn/services/achievements.dart';
import 'package:h_clicker_reborn/services/customization.dart';

import '../utility.dart';

class Achievements extends StatefulWidget {
  @override
  _AchievementsState createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSettings(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(body: Center(child: Text("Preparing your h...")));
        } else {
          List<Widget> achievementsList = [];
          for (String achievement in achievements.keys) {
            bool hasAchievement = snapshot.data!["achievements"].contains(achievement);

            achievementsList.add(Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: hasAchievement ? BorderSide(color: Colors.amber, width: 3) : BorderSide.none
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(achievement, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey[900])),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(hasAchievement ? "UNLOCKED" : "LOCKED",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[900])),
                          )
                        ],
                      ),
                      Text(achievements[achievement]!.description, style: TextStyle(fontSize: 18, color: Colors.grey[900])),
                      Text(achievements[achievement]!.rewardDescription != "" ?
                      "Rewards ${achievements[achievement]!.rewardDescription}" : "No Reward",
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ));
          }

          return GradientScaffold(
            isAnimated: true,
            imageURL: storeThemes.values.toList()[snapshot.data!["themeIndex"]].imageURL,
            gradientList: storeThemes.values.toList()[snapshot.data!["themeIndex"]].colors,
            appBar: AppBar(
              title: Text("Achievements"),
            ),
            body: SafeArea(
              child: Scrollbar(
                  radius: Radius.circular(10),
                  child: ListView(children: achievementsList, physics: BouncingScrollPhysics())
              ),
            ),
          );
        }
      },
    );
  }
}
