import 'BillCategory.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UpdateCategoryBean.g.dart';


@JsonSerializable()
class UpdateCategoryBean {
  
   /// 旧账单分类 ObjectId
   String oldBillCategoryObjectId;
  
   /// 旧账单分类类别
   int oldBillCategoryType;
  
   /// 旧账单分类更新时间
   int oldBillCategoryUpdateTime;
  
   /// 新账单分类列表
   BillCategory newBillCategory;


   UpdateCategoryBean();

  String getOldBillCategoryObjectId() {
    return oldBillCategoryObjectId;
  }

   void setOldBillCategoryObjectId(String oldBillCategoryObjectId) {
    this.oldBillCategoryObjectId = oldBillCategoryObjectId;
  }

   int getOldBillCategoryType() {
    return oldBillCategoryType;
  }

   void setOldBillCategoryType(int oldBillCategoryType) {
    this.oldBillCategoryType = oldBillCategoryType;
  }

   int getOldBillCategoryUpdateTime() {
    return oldBillCategoryUpdateTime;
  }

   void setOldBillCategoryUpdateTime(int oldBillCategoryUpdateTime) {
    this.oldBillCategoryUpdateTime = oldBillCategoryUpdateTime;
  }

   BillCategory getNewBillCategory() {
    return newBillCategory;
  }

   void setNewBillCategory(BillCategory newBillCategory) {
    this.newBillCategory = newBillCategory;
  }

   Map<String, dynamic> toMap() {
     var map = <String, dynamic>{
       "OldBillCategoryObjectId": oldBillCategoryObjectId,
       "OldBillCategoryType": oldBillCategoryType,
       "OldBillCategoryUpdateTime": oldBillCategoryUpdateTime,
       "NewBillCategory": newBillCategory,
     };
     return map;
   }

   factory UpdateCategoryBean.fromJson(Map<String, dynamic> json) =>
       _$UpdateCategoryBeanFromJson(json);

   Map<String, dynamic> toJson() => _$UpdateCategoryBeanToJson(this);

}