import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mgame/flame_game/user/cloud_user_controller.dart';
import 'package:mgame/flame_game/user/local_user_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'game_user_controller.g.dart';
part 'game_user_controller.freezed.dart';

@Riverpod(keepAlive: true)
class GameUserController extends _$GameUserController {
  late final SharedPreferences _sharedPreferences;
  @override
  FutureOr<GameUser?> build() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    // deleteLocalUser(_sharedPreferences);

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null || user.email == null) {
        state = AsyncData(await getLocalUser(sharedPreferences: _sharedPreferences));
      } else {
        GameUser? cloudUser = await getCloudUser(userEmail: user.email!);

        if (cloudUser != null) {
          state = AsyncData(cloudUser);

          GameUser localUser = await getLocalUser(sharedPreferences: _sharedPreferences);
          GameUser? syncedGameUser = await syncGameUser(localUser: localUser, cloudUser: cloudUser);
          if (syncedGameUser != null) state = AsyncData(syncedGameUser);
          deleteLocalUser(_sharedPreferences);
        } else {
          state = AsyncData(await getLocalUser(sharedPreferences: _sharedPreferences));
        }
      }
    });

    return null;
  }

  Future<void> updateGameUser({int? ecoCredits, String? levelToUpdate, bool? isCompleted, bool? isAvailable, int? score, Map<String, dynamic>? mapLevelUser}) async {
    if (state.unwrapPrevious().valueOrNull != null) {
      if (!state.value!.isLocal && state.value!.email != null) {
        await updateCloudUser(
            userEmail: state.value!.email!, ecoCredits: ecoCredits, levelToUpdate: levelToUpdate, isCompleted: isCompleted, isAvailable: isAvailable, score: score, mapLevelUser: mapLevelUser);
        state = AsyncData(await getCloudUser(userEmail: state.value!.email!));
      } else {
        await updateLocalUser(
            sharedPreferences: _sharedPreferences, ecoCredits: ecoCredits, levelToUpdate: levelToUpdate, isCompleted: isCompleted, isAvailable: isAvailable, score: score, mapLevelUser: mapLevelUser);
        state = AsyncData(await getLocalUser(sharedPreferences: _sharedPreferences));
      }
    }
  }

  Map<String, dynamic> getUserMapLevel() {
    return state.value!.mapLevelUser;
  }

  int getUserEcoCredits() {
    return state.value!.ecoCredits;
  }

  String? getUserEmail() {
    return state.value!.email;
  }

  List<String> getUserAchievements() {
    return state.value!.achievements;
  }

  void addUserAchievements(String achievement) {
    if (state.unwrapPrevious().valueOrNull != null) {
      if (!state.value!.isLocal && state.value!.email != null) {
        updateCloudUserAchievements(achievement: achievement, userEmail: state.value!.email!);
      } else {
        updateLocalUserAchievements(achievement: achievement, sharedPreferences: _sharedPreferences);
      }
    }
  }

  void disconnect() {
    FirebaseAuth.instance.signOut();
  }
}

@freezed
class GameUser with _$GameUser {
  factory GameUser({
    String? email,
    required bool isLocal,
    required Map<String, dynamic> mapLevelUser,
    required int ecoCredits,
    required List<String> achievements,
  }) = _GameUser;
}
