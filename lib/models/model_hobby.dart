import 'package:json_annotation/json_annotation.dart';
import 'package:portfolio/models/enum_icon_class.dart';
import 'package:portfolio/models/model_detail.dart';

part 'model_hobby.g.dart';

@JsonSerializable()
class HobbyModel {
  final String? title;
  final int iconCode;
  final IconClass iconClass;
  final DetailModel? detail;

  const HobbyModel({
    required this.iconCode,
    required this.iconClass,
    this.title,
    this.detail,
  });

  factory HobbyModel.fromJson(Map<String, dynamic> json) =>
      _$HobbyModelFromJson(json);

  Map<String, dynamic> toJson() => _$HobbyModelToJson(this);
}
