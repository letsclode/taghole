// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FeedbackModel _$$_FeedbackModelFromJson(Map<String, dynamic> json) =>
    _$_FeedbackModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      reportId: json['reportId'] as String,
      description: json['description'] as String,
      ratings: (json['ratings'] as num).toDouble(),
    );

Map<String, dynamic> _$$_FeedbackModelToJson(_$_FeedbackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'reportId': instance.reportId,
      'description': instance.description,
      'ratings': instance.ratings,
    };
