// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_icon_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IconTagModel _$IconTagModelFromJson(Map<String, dynamic> json) => IconTagModel(
      title: json['title'] as String,
      value: json['value'] as String,
      iconCode: json['iconCode'] as int,
      iconClass: $enumDecode(_$IconClassEnumMap, json['iconClass']),
    );

Map<String, dynamic> _$IconTagModelToJson(IconTagModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'value': instance.value,
      'iconCode': instance.iconCode,
      'iconClass': _$IconClassEnumMap[instance.iconClass]!,
    };

const _$IconClassEnumMap = {
  IconClass.iconDataSolid: 'IconDataSolid',
  IconClass.iconDataBrands: 'IconDataBrands',
  IconClass.iconDataRegular: 'IconDataRegular',
  IconClass.materialIcon: 'MaterialIcon',
};
