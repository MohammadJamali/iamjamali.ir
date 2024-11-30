import 'package:json_annotation/json_annotation.dart';

import 'model_hobby.dart';
import 'model_tag.dart';

part 'model_aboutme.g.dart';

@JsonSerializable()
class AboutMeModel {
  final String lightProfilePic;
  final String darkProfilePic;
  final String fullname;
  final String slogan;
  final String biography;
  final int topSkills;
  final List<TagModel>? skills;
  final List<HobbyModel>? hobbies;

  const AboutMeModel({
    required this.lightProfilePic,
    required this.darkProfilePic,
    required this.fullname,
    required this.slogan,
    required this.biography,
    this.skills,
    this.topSkills = 5,
    this.hobbies,
  });

  factory AboutMeModel.fromJson(Map<String, dynamic> json) =>
      _$AboutMeModelFromJson(json);

  Map<String, dynamic> toJson() => _$AboutMeModelToJson(this);
}
