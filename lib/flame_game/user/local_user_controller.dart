import 'package:shared_preferences/shared_preferences.dart';

import '../level.dart';
import '../riverpod_controllers/game_user_controller.dart';

/// Check if Local User Exist
bool doesLocalUserExist(SharedPreferences sharedPreferences) {
  String localUserName = sharedPreferences.getString('localUserName') ?? '';

  if (localUserName == '') {
    return false;
  } else {
    return true;
  }
}

/// Create Local User
Future<void> createLocalUser(SharedPreferences sharedPreferences) async {
  await sharedPreferences.setString('localUserName', 'LocalUser');
  await sharedPreferences.setInt('ecoCredits', 10);
  await sharedPreferences.setBool('1 isAvailable', true);
}

/// Delete Local User
Future<void> deleteLocalUser(SharedPreferences sharedPreferences) async {
  await Future.wait([
    sharedPreferences.remove('localUserName'),
    sharedPreferences.remove('ecoCredits'),
  ]);

  int totalNumberOfLevel = Level.totalNumberOfLevel;
  for (int i = 1; i <= totalNumberOfLevel; i++) {
    await Future.wait([
      sharedPreferences.remove('$i isCompleted'),
      sharedPreferences.remove('$i isAvailable'),
      sharedPreferences.remove('$i score'),
    ]);
  }
}

/// Get Local User
Future<GameUser> getLocalUser({required SharedPreferences sharedPreferences}) async {
  if (!doesLocalUserExist(sharedPreferences)) await createLocalUser(sharedPreferences);

  int ecoCredits = sharedPreferences.getInt('ecoCredits') ?? 0;
  Map<String, dynamic> mapLevelUser = {};

  int totalNumberOfLevel = Level.totalNumberOfLevel;
  for (int i = 1; i <= totalNumberOfLevel; i++) {
    mapLevelUser[i.toString()] = {};

    mapLevelUser[i.toString()]['isCompleted'] = sharedPreferences.getBool('$i isCompleted') ?? false;
    mapLevelUser[i.toString()]['isAvailable'] = sharedPreferences.getBool('$i isAvailable') ?? false;
    mapLevelUser[i.toString()]['score'] = sharedPreferences.getInt('$i score') ?? -1;
  }

  List<String> achievements = sharedPreferences.getStringList('achievements') ?? [];

  return GameUser(isLocal: true, mapLevelUser: mapLevelUser, ecoCredits: ecoCredits, achievements: achievements);
}

/// Update Local User
Future<void> updateLocalUser(
    {required SharedPreferences sharedPreferences, int? ecoCredits, String? levelToUpdate, bool? isCompleted, bool? isAvailable, int? score, Map<String, dynamic>? mapLevelUser}) async {
  if (ecoCredits != null) await sharedPreferences.setInt('ecoCredits', ecoCredits);

  if (levelToUpdate != null) {
    if (isCompleted != null) await sharedPreferences.setBool('$levelToUpdate isCompleted', isCompleted);
    if (isAvailable != null) await sharedPreferences.setBool('$levelToUpdate isAvailable', isAvailable);
    if (score != null) await sharedPreferences.setInt('$levelToUpdate score', score);
  }

  if (mapLevelUser != null) {
    for (String level in mapLevelUser.keys) {
      await Future.wait([
        sharedPreferences.setBool('$level isCompleted', mapLevelUser[level]['isCompleted'] as bool? ?? false),
        sharedPreferences.setBool('$level isAvailable', mapLevelUser[level]['isAvailable'] as bool? ?? false),
        sharedPreferences.setInt('$level score', mapLevelUser[level]['score'] as int? ?? -1),
      ]);
    }
  }
}

void updateLocalUserAchievements({required String achievement, required SharedPreferences sharedPreferences}) {
  List<String> achievements = sharedPreferences.getStringList('achievements') ?? [];

  achievements.add(achievement);

  sharedPreferences.setStringList('achievements', achievements);
}
