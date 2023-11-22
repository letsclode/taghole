import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taghole/adminweb/models/update_model/update_model.dart';

import '../position/position_model.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

@freezed
class ReportModel with _$ReportModel {
  factory ReportModel(
      {required String id,
      required String title,
      required String userId,
      required String description,
      required String status,
      required bool isVerified,
      required String type,
      required DateTime createdAt,
      required DateTime updatedAt,
      String? imageUrl,
      required List<UpdateModel> updates,
      required String address,
      required String landmark,
      double? ratings,
      required PositionModel position}) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
}
