// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BillCategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillCategory _$BillCategoryFromJson(Map<String, dynamic> json) {
  return BillCategory()
    ..objectId = json['objectId'] as String
    ..categoryId = json['categoryId'] as String
    ..categoryUser = json['categoryUser'] as String
    ..categoryName = json['categoryName'] as String
    ..isIncome = json['isIncome'] as int
    ..categoryStatus = json['categoryStatus'] as int
    ..categoryType = json['categoryType'] as int
    ..createTime = json['createTime'] as int
    ..updateTime = json['updateTime'] as int
    ..orderIndex = json['orderIndex'] as int;
}

Map<String, dynamic> _$BillCategoryToJson(BillCategory instance) =>
    <String, dynamic>{
      'objectId': instance.objectId,
      'categoryId': instance.categoryId,
      'categoryUser': instance.categoryUser,
      'categoryName': instance.categoryName,
      'isIncome': instance.isIncome,
      'categoryStatus': instance.categoryStatus,
      'categoryType': instance.categoryType,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'orderIndex': instance.orderIndex,
    };
