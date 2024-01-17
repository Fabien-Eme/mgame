import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'local_storage_settings_persistence.dart';

part 'settings.g.dart';

@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  static final _log = Logger('SettingsController');

  final LocalStorageSettingsPersistence _store = LocalStorageSettingsPersistence();

  final SettingsValues _settingsValues = SettingsValues(audioOn: true, playerName: 'Player', soundsOn: true, musicOn: true);

  @override
  SettingsValues build() {
    _loadStateFromPersistence();
    return _settingsValues;
  }

  void notify() {
    state = _settingsValues;
    ref.notifyListeners();
  }

  void setPlayerName(String name) {
    _settingsValues.playerName = name;
    _store.savePlayerName(_settingsValues.playerName);
    notify();
  }

  ///
  /// AUDIO
  ///

  void _switchAudio(bool isOn) {
    _settingsValues.audioOn = isOn;
    _store.saveAudioOn(_settingsValues.audioOn);
    notify();
  }

  void toggleAudio() {
    _switchAudio(!_settingsValues.audioOn);
  }

  void switchAudioOn() {
    _switchAudio(true);
  }

  void switchAudioOff() {
    _switchAudio(false);
  }

  ///
  /// MUSIC
  ///

  void _switchMusic(bool isOn) {
    _settingsValues.musicOn = isOn;
    _store.saveMusicOn(_settingsValues.musicOn);
    notify();
  }

  void toggleMusic() {
    _switchMusic(!_settingsValues.musicOn);
  }

  void switchMusicOn() {
    _switchMusic(true);
  }

  void switchMusicOff() {
    _switchMusic(false);
  }

  ///
  /// SOUND
  ///

  void _switchSounds(bool isOn) {
    _settingsValues.soundsOn = isOn;
    _store.saveSoundsOn(_settingsValues.soundsOn);
    notify();
  }

  void toggleSounds() {
    _switchSounds(!_settingsValues.soundsOn);
  }

  void switchSoundsOn() {
    _switchSounds(true);
  }

  void switchSoundsOff() {
    _switchSounds(false);
  }

  /// Asynchronously loads values from the injected persistence store.
  Future<void> _loadStateFromPersistence() async {
    final loadedValues = await Future.wait([
      _store.getAudioOn(defaultValue: true).then((value) {
        if (kIsWeb) {
          // On the web, sound can only start after user interaction, so
          // we start muted there on every game start.
          return _settingsValues.audioOn = false;
        }
        // On other platforms, we can use the persisted value.
        return _settingsValues.audioOn = value;
      }),
      _store.getSoundsOn(defaultValue: true).then((value) => _settingsValues.soundsOn = value),
      _store.getMusicOn(defaultValue: true).then((value) => _settingsValues.musicOn = value),
      _store.getPlayerName().then((value) => _settingsValues.playerName = value),
    ]);
    notify();
    _log.fine(() => 'Loaded settings: $loadedValues');
  }
}

class SettingsValues {
  bool audioOn;

  /// The player's name. Used for things like high score lists.
  String playerName;

  /// Whether or not the sound effects (sfx) are on.
  bool soundsOn;

  /// Whether or not the music is on.
  bool musicOn;

  SettingsValues({required this.audioOn, required this.playerName, required this.soundsOn, required this.musicOn});
}
