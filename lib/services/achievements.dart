// achievements
import 'package:shared_preferences/shared_preferences.dart';

enum AchievementType {
  clicker, // by spamming h
  purchase, // by buying items
  other // ??
}

class _Achievement {
  final String description;
  final String rewardDescription;
  final AchievementType achievementType;
  final Function? achievementCondition;
  final Function? onAchievementGet;

  _Achievement({this.description = "??", this.rewardDescription = "", this.achievementType = AchievementType.clicker, this.achievementCondition, this.onAchievementGet});
}

Map<String, _Achievement> achievements = {
  "First Steps": _Achievement(
    description: "Click your first 10 H to earn this achievement!",
    achievementCondition: (SharedPreferences preferences) {
      return preferences.getInt("hCount") == 10 ? true : false;
    }
  ),
  "Interested": _Achievement(
    description: "Click your first 100 H earn this achievement!",
    achievementCondition: (SharedPreferences preferences) {
      return preferences.getInt("hCount") == 100 ? true : false;
    }
  ),

  "Stylish": _Achievement(
    achievementType: AchievementType.purchase,
    description: "Own a total of 3 themes excludinq \"Default\" to earn this achievement!",
    rewardDescription: "+50 H",
    achievementCondition: (SharedPreferences preferences) {
      return (preferences.getStringList("purchasedThemes") ?? ["Default"]).length == 4 ? true : false;
    },
    onAchievementGet: (SharedPreferences preferences) {
      preferences.setInt("hCount", (preferences.getInt("hCount") ?? 0) + 50);
    }
  ),
  "Fabulous": _Achievement(
    achievementType: AchievementType.purchase,
    description: "Own a total of 6 themes excludinq \"Default\" to earn this achievement!",
    rewardDescription: "+100 H",
    achievementCondition: (SharedPreferences preferences) {
      return (preferences.getStringList("purchasedThemes") ?? ["Default"]).length == 7 ? true : false;
    },
    onAchievementGet: (SharedPreferences preferences) {
      preferences.setInt("hCount", (preferences.getInt("hCount") ?? 0) + 100);
    }
  ),
  "😳": _Achievement(
    achievementType: AchievementType.purchase,
    description: "Purchase the \"Sus\" theme to earn this achievement!",
    achievementCondition: (SharedPreferences preferences) {
      return (preferences.getStringList("purchasedThemes") ?? ["Default"]).contains("Sus") ? true : false;
    },
  ),
  "Proud": _Achievement(
    description: "Spam H durinq pride month to earn this achievement!",
    rewardDescription: "\"Pride\" theme",
    achievementCondition: (SharedPreferences preferences) {
      return DateTime.now().month == 6 ? true : false;
    },
    onAchievementGet: (SharedPreferences preferences) {
      List<String> purchased = preferences.getStringList("purchasedThemes") ?? ["Default"];
      purchased.add("Pride");
      preferences.setStringList("purchasedThemes", purchased);
    }
  ),
  "H Connoisseur": _Achievement(
    achievementType: AchievementType.other,
    description: "Join the H Discord server to earn this achievement!",
    rewardDescription: "\"Blurple\" theme",
    achievementCondition: (SharedPreferences preferences) {
      return false;
    },
    onAchievementGet: (SharedPreferences preferences) {
      List<String> purchased = preferences.getStringList("purchasedThemes") ?? ["Default"];
      purchased.add("Blurple");
      purchased.add("Leqacy Blurple");
      preferences.setStringList("purchasedThemes", purchased);
    }
  ),

};