import 'package:json_annotation/json_annotation.dart';
import 'package:portfolio/models/model_detail.dart';

import 'enum_icon_class.dart';

part 'model_timeline.g.dart';

@JsonSerializable()
class TimelineModel {
  final String title;
  final String description;
  final String? image;
  final String? externalLink;
  final String? caption;
  final String? subtitle;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final DetailModel? detail;

  final int? color;
  final int? iconCode;
  final IconClass? iconClass;

  const TimelineModel({
    required this.title,
    required this.description,
    this.caption,
    this.startedAt,
    this.finishedAt,
    this.subtitle,
    this.externalLink,
    this.image,
    this.detail,
    this.color,
    this.iconCode,
    this.iconClass,
  });

  factory TimelineModel.fromJson(Map<String, dynamic> json) =>
      _$TimelineModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimelineModelToJson(this);
}
