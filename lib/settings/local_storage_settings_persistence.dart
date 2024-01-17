import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageSettingsPersistence {
  final Future<SharedPreferences> instanceFuture = SharedPreferences.getInstance();

  Future<bool> getAudioOn({required bool defaultValue}) async {
    final prefs = await instanceFuture;
    return prefs.getBool('audioOn') ?? defaultValue;
  }

  Future<bool> getMusicOn({required bool defaultValue}) async {
    final prefs = await instanceFuture;
    return prefs.getBool('musicOn') ?? defaultValue;
  }

  Future<String> getPlayerName() async {
    final prefs = await instanceFuture;
    return prefs.getString('playerName') ?? 'Player';
  }

  Future<bool> getSoundsOn({required bool defaultValue}) async {
    final prefs = await instanceFuture;
    return prefs.getBool('soundsOn') ?? defaultValue;
  }

  Future<void> saveAudioOn(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('audioOn', value);
  }

  Future<void> saveMusicOn(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('musicOn', value);
  }

  Future<void> savePlayerName(String value) async {
    final prefs = await instanceFuture;
    await prefs.setString('playerName', value);
  }

  Future<void> saveSoundsOn(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('soundsOn', value);
  }
}
