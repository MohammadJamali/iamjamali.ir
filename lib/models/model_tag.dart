import 'package:json_annotation/json_annotation.dart';

import 'model_detail.dart';

part 'model_tag.g.dart';

@JsonSerializable()
class TagModel {
  final String tag;
  final DetailModel? detail;

  const TagModel({
    required this.tag,
    this.detail,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TagModelFromJson(json);

  Map<String, dynamic> toJson() => _$TagModelToJson(this);
}
