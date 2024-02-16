// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overlay_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$OverlayState {
  bool get isVisible => throw _privateConstructorUsedError;
  OverlayDialogType? get overlayDialogType =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OverlayStateCopyWith<OverlayState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverlayStateCopyWith<$Res> {
  factory $OverlayStateCopyWith(
          OverlayState value, $Res Function(OverlayState) then) =
      _$OverlayStateCopyWithImpl<$Res, OverlayState>;
  @useResult
  $Res call({bool isVisible, OverlayDialogType? overlayDialogType});
}

/// @nodoc
class _$OverlayStateCopyWithImpl<$Res, $Val extends OverlayState>
    implements $OverlayStateCopyWith<$Res> {
  _$OverlayStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVisible = null,
    Object? overlayDialogType = freezed,
  }) {
    return _then(_value.copyWith(
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      overlayDialogType: freezed == overlayDialogType
          ? _value.overlayDialogType
          : overlayDialogType // ignore: cast_nullable_to_non_nullable
              as OverlayDialogType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OverlayStateImplCopyWith<$Res>
    implements $OverlayStateCopyWith<$Res> {
  factory _$$OverlayStateImplCopyWith(
          _$OverlayStateImpl value, $Res Function(_$OverlayStateImpl) then) =
      __$$OverlayStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isVisible, OverlayDialogType? overlayDialogType});
}

/// @nodoc
class __$$OverlayStateImplCopyWithImpl<$Res>
    extends _$OverlayStateCopyWithImpl<$Res, _$OverlayStateImpl>
    implements _$$OverlayStateImplCopyWith<$Res> {
  __$$OverlayStateImplCopyWithImpl(
      _$OverlayStateImpl _value, $Res Function(_$OverlayStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVisible = null,
    Object? overlayDialogType = freezed,
  }) {
    return _then(_$OverlayStateImpl(
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      overlayDialogType: freezed == overlayDialogType
          ? _value.overlayDialogType
          : overlayDialogType // ignore: cast_nullable_to_non_nullable
              as OverlayDialogType?,
    ));
  }
}

/// @nodoc

class _$OverlayStateImpl implements _OverlayState {
  _$OverlayStateImpl({required this.isVisible, this.overlayDialogType});

  @override
  final bool isVisible;
  @override
  final OverlayDialogType? overlayDialogType;

  @override
  String toString() {
    return 'OverlayState(isVisible: $isVisible, overlayDialogType: $overlayDialogType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverlayStateImpl &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.overlayDialogType, overlayDialogType) ||
                other.overlayDialogType == overlayDialogType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isVisible, overlayDialogType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OverlayStateImplCopyWith<_$OverlayStateImpl> get copyWith =>
      __$$OverlayStateImplCopyWithImpl<_$OverlayStateImpl>(this, _$identity);
}

abstract class _OverlayState implements OverlayState {
  factory _OverlayState(
      {required final bool isVisible,
      final OverlayDialogType? overlayDialogType}) = _$OverlayStateImpl;

  @override
  bool get isVisible;
  @override
  OverlayDialogType? get overlayDialogType;
  @override
  @JsonKey(ignore: true)
  _$$OverlayStateImplCopyWith<_$OverlayStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
