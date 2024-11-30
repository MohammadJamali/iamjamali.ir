// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailModel _$DetailModelFromJson(Map<String, dynamic> json) => DetailModel(
      title: json['title'] as String,
      tags: (json['tags'] as List<dynamic>)
          .map((e) => IconTagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      document: (json['document'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$DetailModelToJson(DetailModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'tags': instance.tags,
      'document': instance.document,
    };
