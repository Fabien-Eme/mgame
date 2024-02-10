// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'construction_mode_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ConstructionState {
  ConstructionMode get status => throw _privateConstructorUsedError;
  TileType? get tileType => throw _privateConstructorUsedError;
  BuildingType? get buildingType => throw _privateConstructorUsedError;
  Directions? get buildingDirection => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConstructionStateCopyWith<ConstructionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConstructionStateCopyWith<$Res> {
  factory $ConstructionStateCopyWith(
          ConstructionState value, $Res Function(ConstructionState) then) =
      _$ConstructionStateCopyWithImpl<$Res, ConstructionState>;
  @useResult
  $Res call(
      {ConstructionMode status,
      TileType? tileType,
      BuildingType? buildingType,
      Directions? buildingDirection});
}

/// @nodoc
class _$ConstructionStateCopyWithImpl<$Res, $Val extends ConstructionState>
    implements $ConstructionStateCopyWith<$Res> {
  _$ConstructionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? tileType = freezed,
    Object? buildingType = freezed,
    Object? buildingDirection = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ConstructionMode,
      tileType: freezed == tileType
          ? _value.tileType
          : tileType // ignore: cast_nullable_to_non_nullable
              as TileType?,
      buildingType: freezed == buildingType
          ? _value.buildingType
          : buildingType // ignore: cast_nullable_to_non_nullable
              as BuildingType?,
      buildingDirection: freezed == buildingDirection
          ? _value.buildingDirection
          : buildingDirection // ignore: cast_nullable_to_non_nullable
              as Directions?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConstructionStateImplCopyWith<$Res>
    implements $ConstructionStateCopyWith<$Res> {
  factory _$$ConstructionStateImplCopyWith(_$ConstructionStateImpl value,
          $Res Function(_$ConstructionStateImpl) then) =
      __$$ConstructionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ConstructionMode status,
      TileType? tileType,
      BuildingType? buildingType,
      Directions? buildingDirection});
}

/// @nodoc
class __$$ConstructionStateImplCopyWithImpl<$Res>
    extends _$ConstructionStateCopyWithImpl<$Res, _$ConstructionStateImpl>
    implements _$$ConstructionStateImplCopyWith<$Res> {
  __$$ConstructionStateImplCopyWithImpl(_$ConstructionStateImpl _value,
      $Res Function(_$ConstructionStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? tileType = freezed,
    Object? buildingType = freezed,
    Object? buildingDirection = freezed,
  }) {
    return _then(_$ConstructionStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ConstructionMode,
      tileType: freezed == tileType
          ? _value.tileType
          : tileType // ignore: cast_nullable_to_non_nullable
              as TileType?,
      buildingType: freezed == buildingType
          ? _value.buildingType
          : buildingType // ignore: cast_nullable_to_non_nullable
              as BuildingType?,
      buildingDirection: freezed == buildingDirection
          ? _value.buildingDirection
          : buildingDirection // ignore: cast_nullable_to_non_nullable
              as Directions?,
    ));
  }
}

/// @nodoc

class _$ConstructionStateImpl implements _ConstructionState {
  _$ConstructionStateImpl(
      {required this.status,
      this.tileType,
      this.buildingType,
      this.buildingDirection});

  @override
  final ConstructionMode status;
  @override
  final TileType? tileType;
  @override
  final BuildingType? buildingType;
  @override
  final Directions? buildingDirection;

  @override
  String toString() {
    return 'ConstructionState(status: $status, tileType: $tileType, buildingType: $buildingType, buildingDirection: $buildingDirection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConstructionStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.tileType, tileType) ||
                other.tileType == tileType) &&
            (identical(other.buildingType, buildingType) ||
                other.buildingType == buildingType) &&
            (identical(other.buildingDirection, buildingDirection) ||
                other.buildingDirection == buildingDirection));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, status, tileType, buildingType, buildingDirection);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConstructionStateImplCopyWith<_$ConstructionStateImpl> get copyWith =>
      __$$ConstructionStateImplCopyWithImpl<_$ConstructionStateImpl>(
          this, _$identity);
}

abstract class _ConstructionState implements ConstructionState {
  factory _ConstructionState(
      {required final ConstructionMode status,
      final TileType? tileType,
      final BuildingType? buildingType,
      final Directions? buildingDirection}) = _$ConstructionStateImpl;

  @override
  ConstructionMode get status;
  @override
  TileType? get tileType;
  @override
  BuildingType? get buildingType;
  @override
  Directions? get buildingDirection;
  @override
  @JsonKey(ignore: true)
  _$$ConstructionStateImplCopyWith<_$ConstructionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
