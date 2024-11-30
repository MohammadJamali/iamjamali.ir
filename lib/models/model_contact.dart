import 'package:json_annotation/json_annotation.dart';
import 'package:portfolio/models/enum_contact_host.dart';

part 'model_contact.g.dart';

@JsonSerializable()
class ContactModel {
  final ContactHost host;
  final String identifier;

  const ContactModel({
    required this.host,
    required this.identifier,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactModelToJson(this);
}
