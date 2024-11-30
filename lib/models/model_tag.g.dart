// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagModel _$TagModelFromJson(Map<String, dynamic> json) => TagModel(
      tag: json['tag'] as String,
      detail: json['detail'] == null
          ? null
          : DetailModel.fromJson(json['detail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TagModelToJson(TagModel instance) => <String, dynamic>{
      'tag': instance.tag,
      'detail': instance.detail,
    };
