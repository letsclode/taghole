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
      isVisible: json['isVisible'] as bool,
      type: json['type'] as String,
      imageUrl: json['imageUrl'] as String?,
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
      'isVisible': instance.isVisible,
      'type': instance.type,
      'imageUrl': instance.imageUrl,
      'address': instance.address,
      'landmark': instance.landmark,
      'position': instance.position,
    };
