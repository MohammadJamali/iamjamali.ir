// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimelineModel _$TimelineModelFromJson(Map<String, dynamic> json) =>
    TimelineModel(
      title: json['title'] as String,
      description: json['description'] as String,
      caption: json['caption'] as String?,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      finishedAt: json['finishedAt'] == null
          ? null
          : DateTime.parse(json['finishedAt'] as String),
      subtitle: json['subtitle'] as String?,
      externalLink: json['externalLink'] as String?,
      image: json['image'] as String?,
      detail: json['detail'] == null
          ? null
          : DetailModel.fromJson(json['detail'] as Map<String, dynamic>),
      color: json['color'] as int?,
      iconCode: json['iconCode'] as int?,
      iconClass: $enumDecodeNullable(_$IconClassEnumMap, json['iconClass']),
    );

Map<String, dynamic> _$TimelineModelToJson(TimelineModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'externalLink': instance.externalLink,
      'caption': instance.caption,
      'subtitle': instance.subtitle,
      'startedAt': instance.startedAt?.toIso8601String(),
      'finishedAt': instance.finishedAt?.toIso8601String(),
      'detail': instance.detail,
      'color': instance.color,
      'iconCode': instance.iconCode,
      'iconClass': _$IconClassEnumMap[instance.iconClass],
    };

const _$IconClassEnumMap = {
  IconClass.iconDataSolid: 'IconDataSolid',
  IconClass.iconDataBrands: 'IconDataBrands',
  IconClass.iconDataRegular: 'IconDataRegular',
  IconClass.materialIcon: 'MaterialIcon',
};
