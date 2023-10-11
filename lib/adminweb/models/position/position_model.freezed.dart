// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'position_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PositionModel _$PositionModelFromJson(Map<String, dynamic> json) {
  return _PositionModel.fromJson(json);
}

/// @nodoc
mixin _$PositionModel {
  String get geohash => throw _privateConstructorUsedError;
  dynamic get geopoint => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PositionModelCopyWith<PositionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PositionModelCopyWith<$Res> {
  factory $PositionModelCopyWith(
          PositionModel value, $Res Function(PositionModel) then) =
      _$PositionModelCopyWithImpl<$Res, PositionModel>;
  @useResult
  $Res call({String geohash, dynamic geopoint});
}

/// @nodoc
class _$PositionModelCopyWithImpl<$Res, $Val extends PositionModel>
    implements $PositionModelCopyWith<$Res> {
  _$PositionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geohash = null,
    Object? geopoint = freezed,
  }) {
    return _then(_value.copyWith(
      geohash: null == geohash
          ? _value.geohash
          : geohash // ignore: cast_nullable_to_non_nullable
              as String,
      geopoint: freezed == geopoint
          ? _value.geopoint
          : geopoint // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PositionModelCopyWith<$Res>
    implements $PositionModelCopyWith<$Res> {
  factory _$$_PositionModelCopyWith(
          _$_PositionModel value, $Res Function(_$_PositionModel) then) =
      __$$_PositionModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String geohash, dynamic geopoint});
}

/// @nodoc
class __$$_PositionModelCopyWithImpl<$Res>
    extends _$PositionModelCopyWithImpl<$Res, _$_PositionModel>
    implements _$$_PositionModelCopyWith<$Res> {
  __$$_PositionModelCopyWithImpl(
      _$_PositionModel _value, $Res Function(_$_PositionModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geohash = null,
    Object? geopoint = freezed,
  }) {
    return _then(_$_PositionModel(
      geohash: null == geohash
          ? _value.geohash
          : geohash // ignore: cast_nullable_to_non_nullable
              as String,
      geopoint: freezed == geopoint
          ? _value.geopoint
          : geopoint // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PositionModel implements _PositionModel {
  _$_PositionModel({required this.geohash, required this.geopoint});

  factory _$_PositionModel.fromJson(Map<String, dynamic> json) =>
      _$$_PositionModelFromJson(json);

  @override
  final String geohash;
  @override
  final dynamic geopoint;

  @override
  String toString() {
    return 'PositionModel(geohash: $geohash, geopoint: $geopoint)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PositionModel &&
            (identical(other.geohash, geohash) || other.geohash == geohash) &&
            const DeepCollectionEquality().equals(other.geopoint, geopoint));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, geohash, const DeepCollectionEquality().hash(geopoint));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PositionModelCopyWith<_$_PositionModel> get copyWith =>
      __$$_PositionModelCopyWithImpl<_$_PositionModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PositionModelToJson(
      this,
    );
  }
}

abstract class _PositionModel implements PositionModel {
  factory _PositionModel(
      {required final String geohash,
      required final dynamic geopoint}) = _$_PositionModel;

  factory _PositionModel.fromJson(Map<String, dynamic> json) =
      _$_PositionModel.fromJson;

  @override
  String get geohash;
  @override
  dynamic get geopoint;
  @override
  @JsonKey(ignore: true)
  _$$_PositionModelCopyWith<_$_PositionModel> get copyWith =>
      throw _privateConstructorUsedError;
}
