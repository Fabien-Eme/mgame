import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mgame/flame_game/level.dart';

import '../riverpod_controllers/game_user_controller.dart';

Future<GameUser?> getCloudUser({required String userEmail}) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(userEmail).get();
  final map = doc.data();
  if (map == null) return null;

  int? ecoCredits = map['ecoCredits'] as int?;
  Map<String, dynamic>? mapLevelUser = map['mapLevelUser'] as Map<String, dynamic>?;
  List<String> achievements = [];
  for (final achievement in map['achievements'] as Iterable) {
    achievements.add(achievement as String);
  }

  if (ecoCredits != null && mapLevelUser != null) return GameUser(isLocal: false, email: userEmail, mapLevelUser: mapLevelUser, ecoCredits: ecoCredits, achievements: achievements);

  return null;
}

Future<void> updateCloudUser({required String userEmail, int? ecoCredits, String? levelToUpdate, bool? isCompleted, bool? isAvailable, int? score, Map<String, dynamic>? mapLevelUser}) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(userEmail).get();
  final map = doc.data();
  if (map == null) return;

  if (ecoCredits != null) await FirebaseFirestore.instance.collection('users').doc(userEmail).update({'ecoCredits': ecoCredits});

  if (levelToUpdate != null) {
    Map<String, dynamic> cloudMapLevelUser = map['mapLevelUser'] as Map<String, dynamic>? ?? {};
    if (isCompleted != null) cloudMapLevelUser['levelToUpdate']['isCompleted'] = isCompleted;
    if (isAvailable != null) cloudMapLevelUser['levelToUpdate']['isAvailable'] = isAvailable;
    if (score != null) cloudMapLevelUser['levelToUpdate']['score'] = score;

    await FirebaseFirestore.instance.collection('users').doc(userEmail).update({'mapLevelUser': cloudMapLevelUser});
  }

  if (mapLevelUser != null) {
    Map<String, dynamic> cloudMapLevelUser = map['mapLevelUser'] as Map<String, dynamic>? ?? {};

    for (String level in mapLevelUser.keys) {
      cloudMapLevelUser[level] = mapLevelUser[level];
    }

    await FirebaseFirestore.instance.collection('users').doc(userEmail).update({'mapLevelUser': cloudMapLevelUser});
  }
}

Future<void> createCloudUser({required String userEmail}) async {
  await FirebaseFirestore.instance.collection("users").doc(userEmail.toLowerCase()).set({
    'achievements': [],
    'ecoCredits': 10,
    'codeUsed': [],
    'mapLevelUser': {
      '1': {'isAvailable': true},
    },
  });
}

Future<GameUser?> syncGameUser({required GameUser localUser, required GameUser cloudUser}) async {
  bool isLocalMoreAdvanced = false;
  int level = 1;
  int totalNumberOfLevel = Level.totalNumberOfLevel;

  while (!isLocalMoreAdvanced && level < totalNumberOfLevel) {
    if ((localUser.mapLevelUser[level.toString()]?['isCompleted'] as bool?) ?? false) {
      if (!((cloudUser.mapLevelUser[level.toString()]?['isCompleted'] as bool?) ?? false)) {
        isLocalMoreAdvanced = true;
      } else {
        if (((localUser.mapLevelUser[level.toString()]?['score'] as int?) ?? -1) > ((cloudUser.mapLevelUser[level.toString()]?['score'] as int?) ?? -1)) {
          isLocalMoreAdvanced = true;
        }
      }
    }
    level++;
  }

  if (isLocalMoreAdvanced) {
    GameUser gameUser = GameUser(email: cloudUser.email!, isLocal: false, mapLevelUser: localUser.mapLevelUser, ecoCredits: localUser.ecoCredits, achievements: localUser.achievements);
    await updateCloudUser(userEmail: gameUser.email!, ecoCredits: gameUser.ecoCredits, mapLevelUser: gameUser.mapLevelUser);

    for (String achievement in localUser.achievements) {
      updateCloudUserAchievements(achievement: achievement, userEmail: cloudUser.email!);
    }

    return gameUser;
  } else {
    return null;
  }
}

void updateCloudUserAchievements({required String achievement, required String userEmail}) {
  FirebaseFirestore.instance.collection('users').doc(userEmail).update({
    "achievements": FieldValue.arrayUnion([achievement]),
  });

  FirebaseFirestore.instance.collection('achievements').doc(achievement).update({
    "citizen": FieldValue.increment(1),
  });
}
