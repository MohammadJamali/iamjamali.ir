import 'package:json_annotation/json_annotation.dart';

import 'model_icon_tag.dart';

part 'model_detail.g.dart';

@JsonSerializable()
class DetailModel {
  final String title;
  final List<IconTagModel> tags;
  final List<Map<String, dynamic>> document;

  const DetailModel({
    required this.title,
    required this.tags,
    required this.document,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) =>
      _$DetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailModelToJson(this);
}
