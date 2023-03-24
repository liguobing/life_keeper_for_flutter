// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BillImageResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillImageResponse _$BillImageResponseFromJson(Map<String, dynamic> json) {
  return BillImageResponse()
    ..resultCode = json['resultCode'] as int
    ..imageName = json['imageName'] as String;
}

Map<String, dynamic> _$BillImageResponseToJson(BillImageResponse instance) =>
    <String, dynamic>{
      'resultCode': instance.resultCode,
      'imageName': instance.imageName,
    };
