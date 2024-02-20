// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SettingsValues {
  String get playerName => throw _privateConstructorUsedError;
  bool get audioOn => throw _privateConstructorUsedError;
  bool get soundsOn => throw _privateConstructorUsedError;
  bool get musicOn => throw _privateConstructorUsedError;
  bool get skipIntro => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingsValuesCopyWith<SettingsValues> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsValuesCopyWith<$Res> {
  factory $SettingsValuesCopyWith(
          SettingsValues value, $Res Function(SettingsValues) then) =
      _$SettingsValuesCopyWithImpl<$Res, SettingsValues>;
  @useResult
  $Res call(
      {String playerName,
      bool audioOn,
      bool soundsOn,
      bool musicOn,
      bool skipIntro});
}

/// @nodoc
class _$SettingsValuesCopyWithImpl<$Res, $Val extends SettingsValues>
    implements $SettingsValuesCopyWith<$Res> {
  _$SettingsValuesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerName = null,
    Object? audioOn = null,
    Object? soundsOn = null,
    Object? musicOn = null,
    Object? skipIntro = null,
  }) {
    return _then(_value.copyWith(
      playerName: null == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      audioOn: null == audioOn
          ? _value.audioOn
          : audioOn // ignore: cast_nullable_to_non_nullable
              as bool,
      soundsOn: null == soundsOn
          ? _value.soundsOn
          : soundsOn // ignore: cast_nullable_to_non_nullable
              as bool,
      musicOn: null == musicOn
          ? _value.musicOn
          : musicOn // ignore: cast_nullable_to_non_nullable
              as bool,
      skipIntro: null == skipIntro
          ? _value.skipIntro
          : skipIntro // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingsValuesImplCopyWith<$Res>
    implements $SettingsValuesCopyWith<$Res> {
  factory _$$SettingsValuesImplCopyWith(_$SettingsValuesImpl value,
          $Res Function(_$SettingsValuesImpl) then) =
      __$$SettingsValuesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String playerName,
      bool audioOn,
      bool soundsOn,
      bool musicOn,
      bool skipIntro});
}

/// @nodoc
class __$$SettingsValuesImplCopyWithImpl<$Res>
    extends _$SettingsValuesCopyWithImpl<$Res, _$SettingsValuesImpl>
    implements _$$SettingsValuesImplCopyWith<$Res> {
  __$$SettingsValuesImplCopyWithImpl(
      _$SettingsValuesImpl _value, $Res Function(_$SettingsValuesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerName = null,
    Object? audioOn = null,
    Object? soundsOn = null,
    Object? musicOn = null,
    Object? skipIntro = null,
  }) {
    return _then(_$SettingsValuesImpl(
      playerName: null == playerName
          ? _value.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      audioOn: null == audioOn
          ? _value.audioOn
          : audioOn // ignore: cast_nullable_to_non_nullable
              as bool,
      soundsOn: null == soundsOn
          ? _value.soundsOn
          : soundsOn // ignore: cast_nullable_to_non_nullable
              as bool,
      musicOn: null == musicOn
          ? _value.musicOn
          : musicOn // ignore: cast_nullable_to_non_nullable
              as bool,
      skipIntro: null == skipIntro
          ? _value.skipIntro
          : skipIntro // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SettingsValuesImpl
    with DiagnosticableTreeMixin
    implements _SettingsValues {
  _$SettingsValuesImpl(
      {required this.playerName,
      required this.audioOn,
      required this.soundsOn,
      required this.musicOn,
      required this.skipIntro});

  @override
  final String playerName;
  @override
  final bool audioOn;
  @override
  final bool soundsOn;
  @override
  final bool musicOn;
  @override
  final bool skipIntro;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SettingsValues(playerName: $playerName, audioOn: $audioOn, soundsOn: $soundsOn, musicOn: $musicOn, skipIntro: $skipIntro)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SettingsValues'))
      ..add(DiagnosticsProperty('playerName', playerName))
      ..add(DiagnosticsProperty('audioOn', audioOn))
      ..add(DiagnosticsProperty('soundsOn', soundsOn))
      ..add(DiagnosticsProperty('musicOn', musicOn))
      ..add(DiagnosticsProperty('skipIntro', skipIntro));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsValuesImpl &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.audioOn, audioOn) || other.audioOn == audioOn) &&
            (identical(other.soundsOn, soundsOn) ||
                other.soundsOn == soundsOn) &&
            (identical(other.musicOn, musicOn) || other.musicOn == musicOn) &&
            (identical(other.skipIntro, skipIntro) ||
                other.skipIntro == skipIntro));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, playerName, audioOn, soundsOn, musicOn, skipIntro);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsValuesImplCopyWith<_$SettingsValuesImpl> get copyWith =>
      __$$SettingsValuesImplCopyWithImpl<_$SettingsValuesImpl>(
          this, _$identity);
}

abstract class _SettingsValues implements SettingsValues {
  factory _SettingsValues(
      {required final String playerName,
      required final bool audioOn,
      required final bool soundsOn,
      required final bool musicOn,
      required final bool skipIntro}) = _$SettingsValuesImpl;

  @override
  String get playerName;
  @override
  bool get audioOn;
  @override
  bool get soundsOn;
  @override
  bool get musicOn;
  @override
  bool get skipIntro;
  @override
  @JsonKey(ignore: true)
  _$$SettingsValuesImplCopyWith<_$SettingsValuesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
