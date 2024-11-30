// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_bog_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogPostModel _$BlogPostModelFromJson(Map<String, dynamic> json) =>
    BlogPostModel(
      title: json['title'] as String,
      publishedDate: DateTime.parse(json['publishedDate'] as String),
      imgUrl: json['imgUrl'] as String?,
      detail: json['detail'] == null
          ? null
          : DetailModel.fromJson(json['detail'] as Map<String, dynamic>),
      iconCode: json['iconCode'] as int?,
      iconClass: $enumDecodeNullable(_$IconClassEnumMap, json['iconClass']),
      description: json['description'] as String?,
      externalLink: json['externalLink'] as String?,
    );

Map<String, dynamic> _$BlogPostModelToJson(BlogPostModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'publishedDate': instance.publishedDate.toIso8601String(),
      'iconCode': instance.iconCode,
      'iconClass': _$IconClassEnumMap[instance.iconClass],
      'imgUrl': instance.imgUrl,
      'description': instance.description,
      'externalLink': instance.externalLink,
      'detail': instance.detail,
    };

const _$IconClassEnumMap = {
  IconClass.iconDataSolid: 'IconDataSolid',
  IconClass.iconDataBrands: 'IconDataBrands',
  IconClass.iconDataRegular: 'IconDataRegular',
  IconClass.materialIcon: 'MaterialIcon',
};
