import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_model.freezed.dart';
part 'update_model.g.dart';

@freezed
class UpdateModel with _$UpdateModel {
  factory UpdateModel({
    required String description,
    required String image,
    required DateTime createdAt,
  }) = _UpdateModel;

  factory UpdateModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateModelFromJson(json);
}
