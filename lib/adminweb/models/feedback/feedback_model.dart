import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_model.freezed.dart';
part 'feedback_model.g.dart';

@freezed
class FeedbackModel with _$FeedbackModel {
  factory FeedbackModel({
    required String id,
    required String userId,
    required String reportId,
    required String description,
    required double ratings,
  }) = _FeedbackModel;

  factory FeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackModelFromJson(json);
}
