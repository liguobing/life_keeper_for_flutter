// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BillAccountResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillAccountResponse _$BillAccountResponseFromJson(Map<String, dynamic> json) {
  return BillAccountResponse()
    ..responseCode = json['responseCode'] as int
    ..responseList = (json['responseList'] as List)
        ?.map((e) =>
            e == null ? null : BillAccount.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BillAccountResponseToJson(
        BillAccountResponse instance) =>
    <String, dynamic>{
      'responseCode': instance.responseCode,
      'responseList': instance.responseList,
    };
