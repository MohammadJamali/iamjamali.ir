// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_hobby.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HobbyModel _$HobbyModelFromJson(Map<String, dynamic> json) => HobbyModel(
      iconCode: (json['iconCode'] as num).toInt(),
      iconClass: $enumDecode(_$IconClassEnumMap, json['iconClass']),
      title: json['title'] as String?,
      detail: json['detail'] == null
          ? null
          : DetailModel.fromJson(json['detail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HobbyModelToJson(HobbyModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'iconCode': instance.iconCode,
      'iconClass': _$IconClassEnumMap[instance.iconClass]!,
      'detail': instance.detail,
    };

const _$IconClassEnumMap = {
  IconClass.iconDataSolid: 'IconDataSolid',
  IconClass.iconDataBrands: 'IconDataBrands',
  IconClass.iconDataRegular: 'IconDataRegular',
  IconClass.materialIcon: 'MaterialIcon',
};
