// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FeedbackModel _$FeedbackModelFromJson(Map<String, dynamic> json) {
  return _FeedbackModel.fromJson(json);
}

/// @nodoc
mixin _$FeedbackModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get reportId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get ratings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedbackModelCopyWith<FeedbackModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackModelCopyWith<$Res> {
  factory $FeedbackModelCopyWith(
          FeedbackModel value, $Res Function(FeedbackModel) then) =
      _$FeedbackModelCopyWithImpl<$Res, FeedbackModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String reportId,
      String description,
      double ratings});
}

/// @nodoc
class _$FeedbackModelCopyWithImpl<$Res, $Val extends FeedbackModel>
    implements $FeedbackModelCopyWith<$Res> {
  _$FeedbackModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? reportId = null,
    Object? description = null,
    Object? ratings = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      reportId: null == reportId
          ? _value.reportId
          : reportId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      ratings: null == ratings
          ? _value.ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FeedbackModelCopyWith<$Res>
    implements $FeedbackModelCopyWith<$Res> {
  factory _$$_FeedbackModelCopyWith(
          _$_FeedbackModel value, $Res Function(_$_FeedbackModel) then) =
      __$$_FeedbackModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String reportId,
      String description,
      double ratings});
}

/// @nodoc
class __$$_FeedbackModelCopyWithImpl<$Res>
    extends _$FeedbackModelCopyWithImpl<$Res, _$_FeedbackModel>
    implements _$$_FeedbackModelCopyWith<$Res> {
  __$$_FeedbackModelCopyWithImpl(
      _$_FeedbackModel _value, $Res Function(_$_FeedbackModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? reportId = null,
    Object? description = null,
    Object? ratings = null,
  }) {
    return _then(_$_FeedbackModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      reportId: null == reportId
          ? _value.reportId
          : reportId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      ratings: null == ratings
          ? _value.ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FeedbackModel implements _FeedbackModel {
  _$_FeedbackModel(
      {required this.id,
      required this.userId,
      required this.reportId,
      required this.description,
      required this.ratings});

  factory _$_FeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$$_FeedbackModelFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String reportId;
  @override
  final String description;
  @override
  final double ratings;

  @override
  String toString() {
    return 'FeedbackModel(id: $id, userId: $userId, reportId: $reportId, description: $description, ratings: $ratings)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FeedbackModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.reportId, reportId) ||
                other.reportId == reportId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.ratings, ratings) || other.ratings == ratings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, reportId, description, ratings);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FeedbackModelCopyWith<_$_FeedbackModel> get copyWith =>
      __$$_FeedbackModelCopyWithImpl<_$_FeedbackModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FeedbackModelToJson(
      this,
    );
  }
}

abstract class _FeedbackModel implements FeedbackModel {
  factory _FeedbackModel(
      {required final String id,
      required final String userId,
      required final String reportId,
      required final String description,
      required final double ratings}) = _$_FeedbackModel;

  factory _FeedbackModel.fromJson(Map<String, dynamic> json) =
      _$_FeedbackModel.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get reportId;
  @override
  String get description;
  @override
  double get ratings;
  @override
  @JsonKey(ignore: true)
  _$$_FeedbackModelCopyWith<_$_FeedbackModel> get copyWith =>
      throw _privateConstructorUsedError;
}
