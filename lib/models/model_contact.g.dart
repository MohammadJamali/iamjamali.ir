// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) => ContactModel(
      host: $enumDecode(_$ContactHostEnumMap, json['host']),
      identifier: json['identifier'] as String,
    );

Map<String, dynamic> _$ContactModelToJson(ContactModel instance) =>
    <String, dynamic>{
      'host': _$ContactHostEnumMap[instance.host]!,
      'identifier': instance.identifier,
    };

const _$ContactHostEnumMap = {
  ContactHost.phone: 'phone',
  ContactHost.sms: 'sms',
  ContactHost.email: 'email',
  ContactHost.facebook: 'facebook',
  ContactHost.instagram: 'instagram',
  ContactHost.telegram: 'telegram',
  ContactHost.whatsapp: 'whatsapp',
  ContactHost.skype: 'Skype',
  ContactHost.pinterest: 'pinterest',
  ContactHost.twitter: 'twitter',
  ContactHost.twitch: 'twitch',
  ContactHost.viber: 'viber',
  ContactHost.youtube: 'youtube',
  ContactHost.linkedIn: 'linkedIn',
  ContactHost.medium: 'medium',
  ContactHost.github: 'github',
  ContactHost.gitlab: 'gitlab',
  ContactHost.bitbucket: 'bitbucket',
};
