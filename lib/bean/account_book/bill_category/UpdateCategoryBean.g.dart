// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UpdateCategoryBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCategoryBean _$UpdateCategoryBeanFromJson(Map<String, dynamic> json) {
  return UpdateCategoryBean()
    ..oldBillCategoryObjectId = json['oldBillCategoryObjectId'] as String
    ..oldBillCategoryType = json['oldBillCategoryType'] as int
    ..oldBillCategoryUpdateTime = json['oldBillCategoryUpdateTime'] as int
    ..newBillCategory = json['newBillCategory'] == null
        ? null
        : BillCategory.fromJson(
            json['newBillCategory'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UpdateCategoryBeanToJson(UpdateCategoryBean instance) =>
    <String, dynamic>{
      'oldBillCategoryObjectId': instance.oldBillCategoryObjectId,
      'oldBillCategoryType': instance.oldBillCategoryType,
      'oldBillCategoryUpdateTime': instance.oldBillCategoryUpdateTime,
      'newBillCategory': instance.newBillCategory,
    };
