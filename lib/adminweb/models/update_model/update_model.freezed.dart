// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UpdateModel _$UpdateModelFromJson(Map<String, dynamic> json) {
  return _UpdateModel.fromJson(json);
}

/// @nodoc
mixin _$UpdateModel {
  String get description => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateModelCopyWith<UpdateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateModelCopyWith<$Res> {
  factory $UpdateModelCopyWith(
          UpdateModel value, $Res Function(UpdateModel) then) =
      _$UpdateModelCopyWithImpl<$Res, UpdateModel>;
  @useResult
  $Res call({String description, String image, DateTime createdAt});
}

/// @nodoc
class _$UpdateModelCopyWithImpl<$Res, $Val extends UpdateModel>
    implements $UpdateModelCopyWith<$Res> {
  _$UpdateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? image = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UpdateModelCopyWith<$Res>
    implements $UpdateModelCopyWith<$Res> {
  factory _$$_UpdateModelCopyWith(
          _$_UpdateModel value, $Res Function(_$_UpdateModel) then) =
      __$$_UpdateModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String description, String image, DateTime createdAt});
}

/// @nodoc
class __$$_UpdateModelCopyWithImpl<$Res>
    extends _$UpdateModelCopyWithImpl<$Res, _$_UpdateModel>
    implements _$$_UpdateModelCopyWith<$Res> {
  __$$_UpdateModelCopyWithImpl(
      _$_UpdateModel _value, $Res Function(_$_UpdateModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? image = null,
    Object? createdAt = null,
  }) {
    return _then(_$_UpdateModel(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UpdateModel implements _UpdateModel {
  _$_UpdateModel(
      {required this.description,
      required this.image,
      required this.createdAt});

  factory _$_UpdateModel.fromJson(Map<String, dynamic> json) =>
      _$$_UpdateModelFromJson(json);

  @override
  final String description;
  @override
  final String image;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'UpdateModel(description: $description, image: $image, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UpdateModel &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, description, image, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UpdateModelCopyWith<_$_UpdateModel> get copyWith =>
      __$$_UpdateModelCopyWithImpl<_$_UpdateModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UpdateModelToJson(
      this,
    );
  }
}

abstract class _UpdateModel implements UpdateModel {
  factory _UpdateModel(
      {required final String description,
      required final String image,
      required final DateTime createdAt}) = _$_UpdateModel;

  factory _UpdateModel.fromJson(Map<String, dynamic> json) =
      _$_UpdateModel.fromJson;

  @override
  String get description;
  @override
  String get image;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$_UpdateModelCopyWith<_$_UpdateModel> get copyWith =>
      throw _privateConstructorUsedError;
}
