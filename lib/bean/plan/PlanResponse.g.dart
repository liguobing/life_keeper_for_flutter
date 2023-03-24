// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PlanResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanResponse _$PlanResponseFromJson(Map<String, dynamic> json) {
  return PlanResponse()
    ..code = json['code'] as int
    ..list = (json['list'] as List)
        ?.map((e) =>
            e == null ? null : PlanBean.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PlanResponseToJson(PlanResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'list': instance.list,
    };
