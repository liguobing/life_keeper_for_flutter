import 'package:json_annotation/json_annotation.dart';

part 'BillImageResponse.g.dart';

///上传账单图片响应原型
///@author LGB

@JsonSerializable()
class BillImageResponse {
  
   // 响应码
   int resultCode;
  
   // 图片名称
   String imageName;

   int getResultCode() {
    return resultCode;
  }


   BillImageResponse();

  void setResultCode(int resultCode) {
    this.resultCode = resultCode;
  }

   String getImageName() {
    return imageName;
  }

   void setImageName(String imageName) {
    this.imageName = imageName;
  }

   Map<String, dynamic> toMap() {
     var map = <String, dynamic>{
       "ResultCode": resultCode,
       "ImageName": imageName,
     };
     return map;
   }

   factory BillImageResponse.fromJson(Map<String, dynamic> json) =>
       _$BillImageResponseFromJson(json);

   Map<String, dynamic> toJson() => _$BillImageResponseToJson(this);
}
