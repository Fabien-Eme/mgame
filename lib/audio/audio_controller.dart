import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../settings/settings.dart';
import 'songs.dart';
import 'sounds.dart';

part 'audio_controller.g.dart';

@Riverpod(keepAlive: true)
class AudioController extends _$AudioController {
  static final _log = Logger('AudioController');

  late final AudioPlayer _musicPlayer;

  /// This is a list of [AudioPlayer] instances which are rotated to play
  /// sound effects.
  late final List<AudioPlayer> _sfxPlayers;

  int _currentSfxPlayer = 0;

  late Queue<Song> _playlist;

  final Random _random = Random();

  late SettingsValues _settings;

  @override
  void build() {
    _musicPlayer = AudioPlayer(playerId: 'musicPlayer');
    _playlist = Queue.of(List<Song>.of(songs));
    _musicPlayer.onPlayerComplete.listen(_handleSongFinished);

    _sfxPlayers = Iterable.generate(5, (i) => AudioPlayer(playerId: 'sfxPlayer#$i')).toList(growable: false);
    unawaited(_preloadSfx());

    AppLifecycleListener(
      onStateChange: (appLifecycleState) => _handleAppLifecycle(appLifecycleState),
    );

    ref.listen(
      settingsProvider,
      (_, settings) {
        _settings = settings;
        _audioOnHandler();
        _musicOnHandler();
        _soundsOnHandler();
      },
      fireImmediately: true,
    );

    if (_settings.audioOn && _settings.musicOn) {
      if (kIsWeb) {
        _log.info('On the web, music can only start after user interaction.');
      } else {
        _playCurrentSongInPlaylist();
      }
    }
    return;
  }

  /// Plays a single sound effect, defined by [type].
  ///
  /// The controller will ignore this call when the attached settings'
  /// [SettingsController.audioOn] is `true` or if its
  /// [SettingsController.soundsOn] is `false`.
  void playSfx(SfxType type) {
    final audioOn = _settings.audioOn;
    if (!audioOn) {
      _log.fine(() => 'Ignoring playing sound ($type) because audio is muted.');
      return;
    }
    final soundsOn = _settings.soundsOn;
    if (!soundsOn) {
      _log.fine(() => 'Ignoring playing sound ($type) because sounds are turned off.');
      return;
    }

    _log.fine(() => 'Playing sound: $type');
    final options = soundTypeToFilename(type);
    final filename = options[_random.nextInt(options.length)];
    _log.fine(() => '- Chosen filename: $filename');

    final currentPlayer = _sfxPlayers[_currentSfxPlayer];
    currentPlayer.play(AssetSource('sfx/$filename'), volume: soundTypeToVolume(type));
    _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
  }

  void _audioOnHandler() {
    if (_settings.audioOn) {
      // All sound just got un-muted. Audio is on.
      if (_settings.musicOn) {
        _startOrResumeMusic();
      }
    } else {
      // All sound just got muted. Audio is off.
      stopAllSound();
    }
  }

  void _handleAppLifecycle(value) {
    switch (value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        stopAllSound();
      case AppLifecycleState.resumed:
        if (_settings.audioOn && _settings.musicOn) {
          _startOrResumeMusic();
        }
      case AppLifecycleState.inactive:
        // No need to react to this state change.
        break;
    }
  }

  void _handleSongFinished(void _) {
    _log.info('Last song finished playing.');
    // Move the song that just finished playing to the end of the playlist.
    _playlist.addLast(_playlist.removeFirst());
    // Play the song at the beginning of the playlist.
    _playCurrentSongInPlaylist();
  }

  void _musicOnHandler() {
    if (_settings.musicOn) {
      // Music got turned on.
      if (_settings.audioOn) {
        _startOrResumeMusic();
      }
    } else {
      // Music got turned off.
      _musicPlayer.pause();
    }
  }

  Future<void> _playCurrentSongInPlaylist() async {
    _log.info(() => 'Playing ${_playlist.first} now.');
    try {
      await _musicPlayer.play(AssetSource('music/${_playlist.first.filename}'), volume: 0.5);
    } catch (e) {
      _log.severe('Could not play song ${_playlist.first}', e);
    }

    // Settings can change while the music player is preparing
    // to play a song (i.e. during the `await` above).
    // Unfortunately, `audioplayers` has a bug which will ignore calls
    // to `pause()` before that await is finished, so we need
    // to double check here.
    // See issue: https://github.com/bluefireteam/audioplayers/issues/1687
    if (!_settings.audioOn || !_settings.musicOn) {
      try {
        _log.fine('Settings changed while preparing to play song. '
            'Pausing music.');
        await _musicPlayer.pause();
      } catch (e) {
        _log.severe('Could not pause music player', e);
      }
    }
  }

  /// Preloads all sound effects.
  Future<void> _preloadSfx() async {
    _log.info('Preloading sound effects');
    // This assumes there is only a limited number of sound effects in the game.
    // If there are hundreds of long sound effect files, it's better
    // to be more selective when preloading.

    ///await AudioCache.instance.loadAll(SfxType.values.expand(soundTypeToFilename).map((path) => 'sfx/$path').toList());
  }

  void _soundsOnHandler() {
    for (final player in _sfxPlayers) {
      if (player.state == PlayerState.playing) {
        player.stop();
      }
    }
  }

  void _startOrResumeMusic() async {
    if (_musicPlayer.source == null) {
      _log.info('No music source set. '
          'Start playing the current song in playlist.');
      await _playCurrentSongInPlaylist();
      return;
    }

    try {
      _musicPlayer.resume();
    } catch (e) {
      // Sometimes, resuming fails with an "Unexpected" error.
      _log.severe("Error resuming music", e);
      // Try starting the song from scratch.
      _playCurrentSongInPlaylist();
    }
  }

  void stopAllSound() {
    _log.info('Stopping all sound');
    _musicPlayer.pause();
    for (final player in _sfxPlayers) {
      player.stop();
    }
  }

  void resetMusic() {
    _musicPlayer.stop();
    _playlist = Queue.of(List<Song>.of(songs));
    _playCurrentSongInPlaylist();
  }
}
