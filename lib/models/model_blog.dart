import 'package:json_annotation/json_annotation.dart';

import 'model_bog_post.dart';

part 'model_blog.g.dart';

@JsonSerializable()
class BlogModel {
  final List<BlogPostModel>? blogPosts;
  final String? mediumRssLink;

  const BlogModel({
    this.blogPosts,
    this.mediumRssLink,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) =>
      _$BlogModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlogModelToJson(this);
}
