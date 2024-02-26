// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'all_trucks_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AllTrucks {
  Map<String, Truck> get trucksOwned => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AllTrucksCopyWith<AllTrucks> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AllTrucksCopyWith<$Res> {
  factory $AllTrucksCopyWith(AllTrucks value, $Res Function(AllTrucks) then) =
      _$AllTrucksCopyWithImpl<$Res, AllTrucks>;
  @useResult
  $Res call({Map<String, Truck> trucksOwned});
}

/// @nodoc
class _$AllTrucksCopyWithImpl<$Res, $Val extends AllTrucks>
    implements $AllTrucksCopyWith<$Res> {
  _$AllTrucksCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trucksOwned = null,
  }) {
    return _then(_value.copyWith(
      trucksOwned: null == trucksOwned
          ? _value.trucksOwned
          : trucksOwned // ignore: cast_nullable_to_non_nullable
              as Map<String, Truck>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AllTrucksImplCopyWith<$Res>
    implements $AllTrucksCopyWith<$Res> {
  factory _$$AllTrucksImplCopyWith(
          _$AllTrucksImpl value, $Res Function(_$AllTrucksImpl) then) =
      __$$AllTrucksImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, Truck> trucksOwned});
}

/// @nodoc
class __$$AllTrucksImplCopyWithImpl<$Res>
    extends _$AllTrucksCopyWithImpl<$Res, _$AllTrucksImpl>
    implements _$$AllTrucksImplCopyWith<$Res> {
  __$$AllTrucksImplCopyWithImpl(
      _$AllTrucksImpl _value, $Res Function(_$AllTrucksImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trucksOwned = null,
  }) {
    return _then(_$AllTrucksImpl(
      trucksOwned: null == trucksOwned
          ? _value._trucksOwned
          : trucksOwned // ignore: cast_nullable_to_non_nullable
              as Map<String, Truck>,
    ));
  }
}

/// @nodoc

class _$AllTrucksImpl implements _AllTrucks {
  _$AllTrucksImpl({required final Map<String, Truck> trucksOwned})
      : _trucksOwned = trucksOwned;

  final Map<String, Truck> _trucksOwned;
  @override
  Map<String, Truck> get trucksOwned {
    if (_trucksOwned is EqualUnmodifiableMapView) return _trucksOwned;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_trucksOwned);
  }

  @override
  String toString() {
    return 'AllTrucks(trucksOwned: $trucksOwned)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AllTrucksImpl &&
            const DeepCollectionEquality()
                .equals(other._trucksOwned, _trucksOwned));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_trucksOwned));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AllTrucksImplCopyWith<_$AllTrucksImpl> get copyWith =>
      __$$AllTrucksImplCopyWithImpl<_$AllTrucksImpl>(this, _$identity);
}

abstract class _AllTrucks implements AllTrucks {
  factory _AllTrucks({required final Map<String, Truck> trucksOwned}) =
      _$AllTrucksImpl;

  @override
  Map<String, Truck> get trucksOwned;
  @override
  @JsonKey(ignore: true)
  _$$AllTrucksImplCopyWith<_$AllTrucksImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
