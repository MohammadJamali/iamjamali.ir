import 'package:json_annotation/json_annotation.dart';
import 'package:portfolio/models/model_detail.dart';

import 'enum_icon_class.dart';

part 'model_bog_post.g.dart';

@JsonSerializable()
class BlogPostModel {
  final String title;
  final DateTime publishedDate;

  final int? iconCode;
  final IconClass? iconClass;

  final String? imgUrl;
  final String? description;
  final String? externalLink;
  final DetailModel? detail;

  const BlogPostModel({
    required this.title,
    required this.publishedDate,
    this.imgUrl,
    this.detail,
    this.iconCode,
    this.iconClass,
    this.description,
    this.externalLink,
  })  : assert(description != null || externalLink != null),
        assert(iconCode == null || iconClass != null);

  factory BlogPostModel.fromJson(Map<String, dynamic> json) =>
      _$BlogPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlogPostModelToJson(this);
}
