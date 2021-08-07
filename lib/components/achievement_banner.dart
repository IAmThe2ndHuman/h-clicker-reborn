import 'package:flutter/material.dart';

class AchievementBanner extends StatelessWidget {
  final bool visible;
  final Border? border;
  final String achievementName;
  final String rewardDescription;

  AchievementBanner({this.visible = true, this.border, this.achievementName = "?", this.rewardDescription = ""});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: Duration(milliseconds: 200),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: 75,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(10),
                border: border
            ),
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.emoji_events_outlined, size: 40),
                        SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Achievement qet!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text(achievementName, style: TextStyle(fontSize: 15), overflow: TextOverflow.fade, softWrap: false,),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(rewardDescription != "" ? "REWARDED $rewardDescription" : "",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}
