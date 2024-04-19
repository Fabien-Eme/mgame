// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_user_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameUser {
  String? get email => throw _privateConstructorUsedError;
  bool get isLocal => throw _privateConstructorUsedError;
  Map<String, dynamic> get mapLevelUser => throw _privateConstructorUsedError;
  int get ecoCredits => throw _privateConstructorUsedError;
  List<String> get achievements => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GameUserCopyWith<GameUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameUserCopyWith<$Res> {
  factory $GameUserCopyWith(GameUser value, $Res Function(GameUser) then) =
      _$GameUserCopyWithImpl<$Res, GameUser>;
  @useResult
  $Res call(
      {String? email,
      bool isLocal,
      Map<String, dynamic> mapLevelUser,
      int ecoCredits,
      List<String> achievements});
}

/// @nodoc
class _$GameUserCopyWithImpl<$Res, $Val extends GameUser>
    implements $GameUserCopyWith<$Res> {
  _$GameUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? isLocal = null,
    Object? mapLevelUser = null,
    Object? ecoCredits = null,
    Object? achievements = null,
  }) {
    return _then(_value.copyWith(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      isLocal: null == isLocal
          ? _value.isLocal
          : isLocal // ignore: cast_nullable_to_non_nullable
              as bool,
      mapLevelUser: null == mapLevelUser
          ? _value.mapLevelUser
          : mapLevelUser // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      ecoCredits: null == ecoCredits
          ? _value.ecoCredits
          : ecoCredits // ignore: cast_nullable_to_non_nullable
              as int,
      achievements: null == achievements
          ? _value.achievements
          : achievements // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameUserImplCopyWith<$Res>
    implements $GameUserCopyWith<$Res> {
  factory _$$GameUserImplCopyWith(
          _$GameUserImpl value, $Res Function(_$GameUserImpl) then) =
      __$$GameUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? email,
      bool isLocal,
      Map<String, dynamic> mapLevelUser,
      int ecoCredits,
      List<String> achievements});
}

/// @nodoc
class __$$GameUserImplCopyWithImpl<$Res>
    extends _$GameUserCopyWithImpl<$Res, _$GameUserImpl>
    implements _$$GameUserImplCopyWith<$Res> {
  __$$GameUserImplCopyWithImpl(
      _$GameUserImpl _value, $Res Function(_$GameUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? isLocal = null,
    Object? mapLevelUser = null,
    Object? ecoCredits = null,
    Object? achievements = null,
  }) {
    return _then(_$GameUserImpl(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      isLocal: null == isLocal
          ? _value.isLocal
          : isLocal // ignore: cast_nullable_to_non_nullable
              as bool,
      mapLevelUser: null == mapLevelUser
          ? _value._mapLevelUser
          : mapLevelUser // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      ecoCredits: null == ecoCredits
          ? _value.ecoCredits
          : ecoCredits // ignore: cast_nullable_to_non_nullable
              as int,
      achievements: null == achievements
          ? _value._achievements
          : achievements // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$GameUserImpl implements _GameUser {
  _$GameUserImpl(
      {this.email,
      required this.isLocal,
      required final Map<String, dynamic> mapLevelUser,
      required this.ecoCredits,
      required final List<String> achievements})
      : _mapLevelUser = mapLevelUser,
        _achievements = achievements;

  @override
  final String? email;
  @override
  final bool isLocal;
  final Map<String, dynamic> _mapLevelUser;
  @override
  Map<String, dynamic> get mapLevelUser {
    if (_mapLevelUser is EqualUnmodifiableMapView) return _mapLevelUser;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_mapLevelUser);
  }

  @override
  final int ecoCredits;
  final List<String> _achievements;
  @override
  List<String> get achievements {
    if (_achievements is EqualUnmodifiableListView) return _achievements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_achievements);
  }

  @override
  String toString() {
    return 'GameUser(email: $email, isLocal: $isLocal, mapLevelUser: $mapLevelUser, ecoCredits: $ecoCredits, achievements: $achievements)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameUserImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal) &&
            const DeepCollectionEquality()
                .equals(other._mapLevelUser, _mapLevelUser) &&
            (identical(other.ecoCredits, ecoCredits) ||
                other.ecoCredits == ecoCredits) &&
            const DeepCollectionEquality()
                .equals(other._achievements, _achievements));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      email,
      isLocal,
      const DeepCollectionEquality().hash(_mapLevelUser),
      ecoCredits,
      const DeepCollectionEquality().hash(_achievements));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameUserImplCopyWith<_$GameUserImpl> get copyWith =>
      __$$GameUserImplCopyWithImpl<_$GameUserImpl>(this, _$identity);
}

abstract class _GameUser implements GameUser {
  factory _GameUser(
      {final String? email,
      required final bool isLocal,
      required final Map<String, dynamic> mapLevelUser,
      required final int ecoCredits,
      required final List<String> achievements}) = _$GameUserImpl;

  @override
  String? get email;
  @override
  bool get isLocal;
  @override
  Map<String, dynamic> get mapLevelUser;
  @override
  int get ecoCredits;
  @override
  List<String> get achievements;
  @override
  @JsonKey(ignore: true)
  _$$GameUserImplCopyWith<_$GameUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
