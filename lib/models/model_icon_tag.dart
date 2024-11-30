import 'package:json_annotation/json_annotation.dart';
import 'package:portfolio/models/enum_icon_class.dart';

part 'model_icon_tag.g.dart';

@JsonSerializable()
class IconTagModel {
  final String title;
  final String value;
  final int iconCode;
  final IconClass iconClass;

  const IconTagModel({
    required this.title,
    required this.value,
    required this.iconCode,
    required this.iconClass,
  });

  factory IconTagModel.fromJson(Map<String, dynamic> json) =>
      _$IconTagModelFromJson(json);

  Map<String, dynamic> toJson() => _$IconTagModelToJson(this);
}
