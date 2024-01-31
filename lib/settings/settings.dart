import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mgame/core/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings.g.dart';
part 'settings.freezed.dart';

@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  late final SharedPreferences _sharedPreferences;

  @override
  SettingsValues build() {
    _sharedPreferences = ref.read(sharedPreferencesProvider).requireValue;

    return SettingsValues(
      playerName: _sharedPreferences.getString('playerName') ?? 'Player',

      // REMOVE THIS
      audioOn: false,
      // audioOn: (kIsWeb) ? false : _sharedPreferences.getBool('audioOn') ?? true,
      soundsOn: _sharedPreferences.getBool('soundsOn') ?? true,
      musicOn: _sharedPreferences.getBool('musicOn') ?? true,
      skipIntro: _sharedPreferences.getBool('skipIntro') ?? false,
    );
  }

  void setPlayerName(String name) {
    state = state.copyWith(playerName: name);
    _sharedPreferences.setString('playerName', name);
  }

  ///
  /// AUDIO
  ///

  void _switchAudio(bool isOn) {
    state = state.copyWith(audioOn: isOn);
    _sharedPreferences.setBool('audioOn', isOn);
  }

  void toggleAudio() {
    _switchAudio(!state.audioOn);
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
    state = state.copyWith(musicOn: isOn);
    _sharedPreferences.setBool('musicOn', isOn);
  }

  void toggleMusic() {
    _switchMusic(!state.musicOn);
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
    state = state.copyWith(soundsOn: isOn);
    _sharedPreferences.setBool('soundsOn', isOn);
  }

  void toggleSounds() {
    _switchSounds(!state.soundsOn);
  }

  void switchSoundsOn() {
    _switchSounds(true);
  }

  void switchSoundsOff() {
    _switchSounds(false);
  }

  ///
  /// SKIPINTRO
  ///

  void _switchSkipIntro(bool bool) {
    state = state.copyWith(skipIntro: bool);
    _sharedPreferences.setBool('skipIntro', bool);
  }

  void toggleSkipIntro() {
    _switchSkipIntro(!state.skipIntro);
  }

  void switchSkipIntroOn() {
    _switchSkipIntro(true);
  }

  void switchSkipIntroOff() {
    _switchSkipIntro(false);
  }
}

@freezed
class SettingsValues with _$SettingsValues {
  factory SettingsValues({
    required String playerName,
    required bool audioOn,
    required bool soundsOn,
    required bool musicOn,
    required bool skipIntro,
  }) = _SettingsValues;
}
