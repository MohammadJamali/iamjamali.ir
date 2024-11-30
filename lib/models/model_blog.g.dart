// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_blog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogModel _$BlogModelFromJson(Map<String, dynamic> json) => BlogModel(
      blogPosts: (json['blogPosts'] as List<dynamic>?)
          ?.map((e) => BlogPostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      mediumRssLink: json['mediumRssLink'] as String?,
    );

Map<String, dynamic> _$BlogModelToJson(BlogModel instance) => <String, dynamic>{
      'blogPosts': instance.blogPosts,
      'mediumRssLink': instance.mediumRssLink,
    };
