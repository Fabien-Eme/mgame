// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'narrative.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Narrative {
  String get title => throw _privateConstructorUsedError;
  Map<String, dynamic> get text => throw _privateConstructorUsedError;
  int get textIndex => throw _privateConstructorUsedError;
  bool get isOver => throw _privateConstructorUsedError;
  bool get hasFinishedNarrative => throw _privateConstructorUsedError;
  bool get autoPlay => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NarrativeCopyWith<Narrative> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NarrativeCopyWith<$Res> {
  factory $NarrativeCopyWith(Narrative value, $Res Function(Narrative) then) =
      _$NarrativeCopyWithImpl<$Res, Narrative>;
  @useResult
  $Res call(
      {String title,
      Map<String, dynamic> text,
      int textIndex,
      bool isOver,
      bool hasFinishedNarrative,
      bool autoPlay});
}

/// @nodoc
class _$NarrativeCopyWithImpl<$Res, $Val extends Narrative>
    implements $NarrativeCopyWith<$Res> {
  _$NarrativeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? text = null,
    Object? textIndex = null,
    Object? isOver = null,
    Object? hasFinishedNarrative = null,
    Object? autoPlay = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      textIndex: null == textIndex
          ? _value.textIndex
          : textIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isOver: null == isOver
          ? _value.isOver
          : isOver // ignore: cast_nullable_to_non_nullable
              as bool,
      hasFinishedNarrative: null == hasFinishedNarrative
          ? _value.hasFinishedNarrative
          : hasFinishedNarrative // ignore: cast_nullable_to_non_nullable
              as bool,
      autoPlay: null == autoPlay
          ? _value.autoPlay
          : autoPlay // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NarrativeImplCopyWith<$Res>
    implements $NarrativeCopyWith<$Res> {
  factory _$$NarrativeImplCopyWith(
          _$NarrativeImpl value, $Res Function(_$NarrativeImpl) then) =
      __$$NarrativeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      Map<String, dynamic> text,
      int textIndex,
      bool isOver,
      bool hasFinishedNarrative,
      bool autoPlay});
}

/// @nodoc
class __$$NarrativeImplCopyWithImpl<$Res>
    extends _$NarrativeCopyWithImpl<$Res, _$NarrativeImpl>
    implements _$$NarrativeImplCopyWith<$Res> {
  __$$NarrativeImplCopyWithImpl(
      _$NarrativeImpl _value, $Res Function(_$NarrativeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? text = null,
    Object? textIndex = null,
    Object? isOver = null,
    Object? hasFinishedNarrative = null,
    Object? autoPlay = null,
  }) {
    return _then(_$NarrativeImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value._text
          : text // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      textIndex: null == textIndex
          ? _value.textIndex
          : textIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isOver: null == isOver
          ? _value.isOver
          : isOver // ignore: cast_nullable_to_non_nullable
              as bool,
      hasFinishedNarrative: null == hasFinishedNarrative
          ? _value.hasFinishedNarrative
          : hasFinishedNarrative // ignore: cast_nullable_to_non_nullable
              as bool,
      autoPlay: null == autoPlay
          ? _value.autoPlay
          : autoPlay // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NarrativeImpl extends _Narrative {
  _$NarrativeImpl(
      {required this.title,
      required final Map<String, dynamic> text,
      required this.textIndex,
      required this.isOver,
      required this.hasFinishedNarrative,
      required this.autoPlay})
      : _text = text,
        super._();

  @override
  final String title;
  final Map<String, dynamic> _text;
  @override
  Map<String, dynamic> get text {
    if (_text is EqualUnmodifiableMapView) return _text;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_text);
  }

  @override
  final int textIndex;
  @override
  final bool isOver;
  @override
  final bool hasFinishedNarrative;
  @override
  final bool autoPlay;

  @override
  String toString() {
    return 'Narrative(title: $title, text: $text, textIndex: $textIndex, isOver: $isOver, hasFinishedNarrative: $hasFinishedNarrative, autoPlay: $autoPlay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NarrativeImpl &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._text, _text) &&
            (identical(other.textIndex, textIndex) ||
                other.textIndex == textIndex) &&
            (identical(other.isOver, isOver) || other.isOver == isOver) &&
            (identical(other.hasFinishedNarrative, hasFinishedNarrative) ||
                other.hasFinishedNarrative == hasFinishedNarrative) &&
            (identical(other.autoPlay, autoPlay) ||
                other.autoPlay == autoPlay));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      const DeepCollectionEquality().hash(_text),
      textIndex,
      isOver,
      hasFinishedNarrative,
      autoPlay);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NarrativeImplCopyWith<_$NarrativeImpl> get copyWith =>
      __$$NarrativeImplCopyWithImpl<_$NarrativeImpl>(this, _$identity);
}

abstract class _Narrative extends Narrative {
  factory _Narrative(
      {required final String title,
      required final Map<String, dynamic> text,
      required final int textIndex,
      required final bool isOver,
      required final bool hasFinishedNarrative,
      required final bool autoPlay}) = _$NarrativeImpl;
  _Narrative._() : super._();

  @override
  String get title;
  @override
  Map<String, dynamic> get text;
  @override
  int get textIndex;
  @override
  bool get isOver;
  @override
  bool get hasFinishedNarrative;
  @override
  bool get autoPlay;
  @override
  @JsonKey(ignore: true)
  _$$NarrativeImplCopyWith<_$NarrativeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
