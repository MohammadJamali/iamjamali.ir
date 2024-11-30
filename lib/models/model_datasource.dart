import 'package:json_annotation/json_annotation.dart';

import 'model_aboutme.dart';
import 'model_blog.dart';
import 'model_timeline.dart';
import 'model_contact.dart';

part 'model_datasource.g.dart';

@JsonSerializable()
class Datasource {
  final String language;
  final bool supportDeveloper;
  final AboutMeModel aboutMe;
  final BlogModel? blog;
  final List<TimelineModel> timeline;
  final List<ContactModel> contacts;

  const Datasource({
    required this.language,
    required this.aboutMe,
    required this.timeline,
    required this.contacts,
    this.supportDeveloper = true,
    this.blog,
  });

  factory Datasource.fromJson(Map<String, dynamic> json) =>
      _$DatasourceFromJson(json);

  Map<String, dynamic> toJson() => _$DatasourceToJson(this);
}
