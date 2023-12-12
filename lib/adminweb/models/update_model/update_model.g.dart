// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UpdateModel _$$_UpdateModelFromJson(Map<String, dynamic> json) =>
    _$_UpdateModel(
      description: json['description'] as String,
      image: json['image'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$_UpdateModelToJson(_$_UpdateModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'image': instance.image,
      'createdAt': instance.createdAt.toIso8601String(),
    };
