// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) {
  return _ReportModel.fromJson(json);
}

/// @nodoc
mixin _$ReportModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get status => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<UpdateModel>? get updates => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get landmark => throw _privateConstructorUsedError;
  double? get ratings => throw _privateConstructorUsedError;
  PositionModel get position => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReportModelCopyWith<ReportModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportModelCopyWith<$Res> {
  factory $ReportModelCopyWith(
          ReportModel value, $Res Function(ReportModel) then) =
      _$ReportModelCopyWithImpl<$Res, ReportModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String description,
      bool status,
      bool isVerified,
      String type,
      DateTime createdAt,
      String? imageUrl,
      List<UpdateModel>? updates,
      String address,
      String landmark,
      double? ratings,
      PositionModel position});

  $PositionModelCopyWith<$Res> get position;
}

/// @nodoc
class _$ReportModelCopyWithImpl<$Res, $Val extends ReportModel>
    implements $ReportModelCopyWith<$Res> {
  _$ReportModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? description = null,
    Object? status = null,
    Object? isVerified = null,
    Object? type = null,
    Object? createdAt = null,
    Object? imageUrl = freezed,
    Object? updates = freezed,
    Object? address = null,
    Object? landmark = null,
    Object? ratings = freezed,
    Object? position = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      updates: freezed == updates
          ? _value.updates
          : updates // ignore: cast_nullable_to_non_nullable
              as List<UpdateModel>?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      landmark: null == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as String,
      ratings: freezed == ratings
          ? _value.ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as double?,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as PositionModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PositionModelCopyWith<$Res> get position {
    return $PositionModelCopyWith<$Res>(_value.position, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ReportModelCopyWith<$Res>
    implements $ReportModelCopyWith<$Res> {
  factory _$$_ReportModelCopyWith(
          _$_ReportModel value, $Res Function(_$_ReportModel) then) =
      __$$_ReportModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String description,
      bool status,
      bool isVerified,
      String type,
      DateTime createdAt,
      String? imageUrl,
      List<UpdateModel>? updates,
      String address,
      String landmark,
      double? ratings,
      PositionModel position});

  @override
  $PositionModelCopyWith<$Res> get position;
}

/// @nodoc
class __$$_ReportModelCopyWithImpl<$Res>
    extends _$ReportModelCopyWithImpl<$Res, _$_ReportModel>
    implements _$$_ReportModelCopyWith<$Res> {
  __$$_ReportModelCopyWithImpl(
      _$_ReportModel _value, $Res Function(_$_ReportModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? description = null,
    Object? status = null,
    Object? isVerified = null,
    Object? type = null,
    Object? createdAt = null,
    Object? imageUrl = freezed,
    Object? updates = freezed,
    Object? address = null,
    Object? landmark = null,
    Object? ratings = freezed,
    Object? position = null,
  }) {
    return _then(_$_ReportModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      updates: freezed == updates
          ? _value._updates
          : updates // ignore: cast_nullable_to_non_nullable
              as List<UpdateModel>?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      landmark: null == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as String,
      ratings: freezed == ratings
          ? _value.ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as double?,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as PositionModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ReportModel implements _ReportModel {
  _$_ReportModel(
      {required this.id,
      required this.userId,
      required this.description,
      required this.status,
      required this.isVerified,
      required this.type,
      required this.createdAt,
      this.imageUrl,
      final List<UpdateModel>? updates,
      required this.address,
      required this.landmark,
      this.ratings,
      required this.position})
      : _updates = updates;

  factory _$_ReportModel.fromJson(Map<String, dynamic> json) =>
      _$$_ReportModelFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String description;
  @override
  final bool status;
  @override
  final bool isVerified;
  @override
  final String type;
  @override
  final DateTime createdAt;
  @override
  final String? imageUrl;
  final List<UpdateModel>? _updates;
  @override
  List<UpdateModel>? get updates {
    final value = _updates;
    if (value == null) return null;
    if (_updates is EqualUnmodifiableListView) return _updates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String address;
  @override
  final String landmark;
  @override
  final double? ratings;
  @override
  final PositionModel position;

  @override
  String toString() {
    return 'ReportModel(id: $id, userId: $userId, description: $description, status: $status, isVerified: $isVerified, type: $type, createdAt: $createdAt, imageUrl: $imageUrl, updates: $updates, address: $address, landmark: $landmark, ratings: $ratings, position: $position)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ReportModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._updates, _updates) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.landmark, landmark) ||
                other.landmark == landmark) &&
            (identical(other.ratings, ratings) || other.ratings == ratings) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      description,
      status,
      isVerified,
      type,
      createdAt,
      imageUrl,
      const DeepCollectionEquality().hash(_updates),
      address,
      landmark,
      ratings,
      position);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ReportModelCopyWith<_$_ReportModel> get copyWith =>
      __$$_ReportModelCopyWithImpl<_$_ReportModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ReportModelToJson(
      this,
    );
  }
}

abstract class _ReportModel implements ReportModel {
  factory _ReportModel(
      {required final String id,
      required final String userId,
      required final String description,
      required final bool status,
      required final bool isVerified,
      required final String type,
      required final DateTime createdAt,
      final String? imageUrl,
      final List<UpdateModel>? updates,
      required final String address,
      required final String landmark,
      final double? ratings,
      required final PositionModel position}) = _$_ReportModel;

  factory _ReportModel.fromJson(Map<String, dynamic> json) =
      _$_ReportModel.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get description;
  @override
  bool get status;
  @override
  bool get isVerified;
  @override
  String get type;
  @override
  DateTime get createdAt;
  @override
  String? get imageUrl;
  @override
  List<UpdateModel>? get updates;
  @override
  String get address;
  @override
  String get landmark;
  @override
  double? get ratings;
  @override
  PositionModel get position;
  @override
  @JsonKey(ignore: true)
  _$$_ReportModelCopyWith<_$_ReportModel> get copyWith =>
      throw _privateConstructorUsedError;
}
