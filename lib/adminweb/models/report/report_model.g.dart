// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ReportModel _$$_ReportModelFromJson(Map<String, dynamic> json) =>
    _$_ReportModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      description: json['description'] as String,
      status: json['status'] as bool,
      isVerified: json['isVerified'] as bool,
      type: json['type'] as String,
      imageUrl: json['imageUrl'] as String?,
      updates: (json['updates'] as List<dynamic>?)
          ?.map((e) => UpdateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      address: json['address'] as String,
      landmark: json['landmark'] as String,
      position:
          PositionModel.fromJson(json['position'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ReportModelToJson(_$_ReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'description': instance.description,
      'status': instance.status,
      'isVerified': instance.isVerified,
      'type': instance.type,
      'imageUrl': instance.imageUrl,
      'updates': instance.updates,
      'address': instance.address,
      'landmark': instance.landmark,
      'position': instance.position,
    };
