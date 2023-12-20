// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ReportModel _$$_ReportModelFromJson(Map<String, dynamic> json) =>
    _$_ReportModel(
      id: json['id'] as String,
      title: json['title'] as String,
      userId: json['userId'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      isVerified: json['isVerified'] as bool,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      reason: json['reason'] as String?,
      imageUrl: json['imageUrl'] as String?,
      updates: (json['updates'] as List<dynamic>)
          .map((e) => UpdateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      address: json['address'] as String,
      landmark: json['landmark'] as String,
      ratings: (json['ratings'] as num?)?.toDouble(),
      position: json['position'],
    );

Map<String, dynamic> _$$_ReportModelToJson(_$_ReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'userId': instance.userId,
      'description': instance.description,
      'status': instance.status,
      'isVerified': instance.isVerified,
      'type': instance.type,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'reason': instance.reason,
      'imageUrl': instance.imageUrl,
      'updates': instance.updates,
      'address': instance.address,
      'landmark': instance.landmark,
      'ratings': instance.ratings,
      'position': instance.position,
    };
