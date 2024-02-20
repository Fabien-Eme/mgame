// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_ui.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameUi {
  bool get isVisibleSettings => throw _privateConstructorUsedError;
  bool get isVisibleForward => throw _privateConstructorUsedError;
  GameUiFunction? get settingsFunction => throw _privateConstructorUsedError;
  GameUiFunction? get forwardFunction => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GameUiCopyWith<GameUi> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameUiCopyWith<$Res> {
  factory $GameUiCopyWith(GameUi value, $Res Function(GameUi) then) =
      _$GameUiCopyWithImpl<$Res, GameUi>;
  @useResult
  $Res call(
      {bool isVisibleSettings,
      bool isVisibleForward,
      GameUiFunction? settingsFunction,
      GameUiFunction? forwardFunction});
}

/// @nodoc
class _$GameUiCopyWithImpl<$Res, $Val extends GameUi>
    implements $GameUiCopyWith<$Res> {
  _$GameUiCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVisibleSettings = null,
    Object? isVisibleForward = null,
    Object? settingsFunction = freezed,
    Object? forwardFunction = freezed,
  }) {
    return _then(_value.copyWith(
      isVisibleSettings: null == isVisibleSettings
          ? _value.isVisibleSettings
          : isVisibleSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      isVisibleForward: null == isVisibleForward
          ? _value.isVisibleForward
          : isVisibleForward // ignore: cast_nullable_to_non_nullable
              as bool,
      settingsFunction: freezed == settingsFunction
          ? _value.settingsFunction
          : settingsFunction // ignore: cast_nullable_to_non_nullable
              as GameUiFunction?,
      forwardFunction: freezed == forwardFunction
          ? _value.forwardFunction
          : forwardFunction // ignore: cast_nullable_to_non_nullable
              as GameUiFunction?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameUiImplCopyWith<$Res> implements $GameUiCopyWith<$Res> {
  factory _$$GameUiImplCopyWith(
          _$GameUiImpl value, $Res Function(_$GameUiImpl) then) =
      __$$GameUiImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isVisibleSettings,
      bool isVisibleForward,
      GameUiFunction? settingsFunction,
      GameUiFunction? forwardFunction});
}

/// @nodoc
class __$$GameUiImplCopyWithImpl<$Res>
    extends _$GameUiCopyWithImpl<$Res, _$GameUiImpl>
    implements _$$GameUiImplCopyWith<$Res> {
  __$$GameUiImplCopyWithImpl(
      _$GameUiImpl _value, $Res Function(_$GameUiImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVisibleSettings = null,
    Object? isVisibleForward = null,
    Object? settingsFunction = freezed,
    Object? forwardFunction = freezed,
  }) {
    return _then(_$GameUiImpl(
      isVisibleSettings: null == isVisibleSettings
          ? _value.isVisibleSettings
          : isVisibleSettings // ignore: cast_nullable_to_non_nullable
              as bool,
      isVisibleForward: null == isVisibleForward
          ? _value.isVisibleForward
          : isVisibleForward // ignore: cast_nullable_to_non_nullable
              as bool,
      settingsFunction: freezed == settingsFunction
          ? _value.settingsFunction
          : settingsFunction // ignore: cast_nullable_to_non_nullable
              as GameUiFunction?,
      forwardFunction: freezed == forwardFunction
          ? _value.forwardFunction
          : forwardFunction // ignore: cast_nullable_to_non_nullable
              as GameUiFunction?,
    ));
  }
}

/// @nodoc

class _$GameUiImpl implements _GameUi {
  _$GameUiImpl(
      {required this.isVisibleSettings,
      required this.isVisibleForward,
      this.settingsFunction,
      this.forwardFunction});

  @override
  final bool isVisibleSettings;
  @override
  final bool isVisibleForward;
  @override
  final GameUiFunction? settingsFunction;
  @override
  final GameUiFunction? forwardFunction;

  @override
  String toString() {
    return 'GameUi(isVisibleSettings: $isVisibleSettings, isVisibleForward: $isVisibleForward, settingsFunction: $settingsFunction, forwardFunction: $forwardFunction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameUiImpl &&
            (identical(other.isVisibleSettings, isVisibleSettings) ||
                other.isVisibleSettings == isVisibleSettings) &&
            (identical(other.isVisibleForward, isVisibleForward) ||
                other.isVisibleForward == isVisibleForward) &&
            (identical(other.settingsFunction, settingsFunction) ||
                other.settingsFunction == settingsFunction) &&
            (identical(other.forwardFunction, forwardFunction) ||
                other.forwardFunction == forwardFunction));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isVisibleSettings,
      isVisibleForward, settingsFunction, forwardFunction);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameUiImplCopyWith<_$GameUiImpl> get copyWith =>
      __$$GameUiImplCopyWithImpl<_$GameUiImpl>(this, _$identity);
}

abstract class _GameUi implements GameUi {
  factory _GameUi(
      {required final bool isVisibleSettings,
      required final bool isVisibleForward,
      final GameUiFunction? settingsFunction,
      final GameUiFunction? forwardFunction}) = _$GameUiImpl;

  @override
  bool get isVisibleSettings;
  @override
  bool get isVisibleForward;
  @override
  GameUiFunction? get settingsFunction;
  @override
  GameUiFunction? get forwardFunction;
  @override
  @JsonKey(ignore: true)
  _$$GameUiImplCopyWith<_$GameUiImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
