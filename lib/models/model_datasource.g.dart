// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_datasource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datasource _$DatasourceFromJson(Map<String, dynamic> json) => Datasource(
      language: json['language'] as String,
      aboutMe: AboutMeModel.fromJson(json['aboutMe'] as Map<String, dynamic>),
      timeline: (json['timeline'] as List<dynamic>)
          .map((e) => TimelineModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      contacts: (json['contacts'] as List<dynamic>)
          .map((e) => ContactModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      supportDeveloper: json['supportDeveloper'] as bool? ?? true,
      blog: json['blog'] == null
          ? null
          : BlogModel.fromJson(json['blog'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DatasourceToJson(Datasource instance) =>
    <String, dynamic>{
      'language': instance.language,
      'supportDeveloper': instance.supportDeveloper,
      'aboutMe': instance.aboutMe,
      'blog': instance.blog,
      'timeline': instance.timeline,
      'contacts': instance.contacts,
    };
