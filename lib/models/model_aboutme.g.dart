// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_aboutme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AboutMeModel _$AboutMeModelFromJson(Map<String, dynamic> json) => AboutMeModel(
      lightProfilePic: json['lightProfilePic'] as String,
      darkProfilePic: json['darkProfilePic'] as String,
      fullname: json['fullname'] as String,
      slogan: json['slogan'] as String,
      biography: json['biography'] as String,
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => TagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      topSkills: (json['topSkills'] as num?)?.toInt() ?? 5,
      hobbies: (json['hobbies'] as List<dynamic>?)
          ?.map((e) => HobbyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AboutMeModelToJson(AboutMeModel instance) =>
    <String, dynamic>{
      'lightProfilePic': instance.lightProfilePic,
      'darkProfilePic': instance.darkProfilePic,
      'fullname': instance.fullname,
      'slogan': instance.slogan,
      'biography': instance.biography,
      'topSkills': instance.topSkills,
      'skills': instance.skills,
      'hobbies': instance.hobbies,
    };
