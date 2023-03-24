import 'BillCategory.dart';
import 'package:json_annotation/json_annotation.dart';

part 'BillCategoryResponse.g.dart';

@JsonSerializable()
class BillCategoryResponse {
  /// 响应码 </>
  /// 1:响应正常，此时 responseList 为响应数据 </br>
  /// -1:响应不正常，此时 responseList 为 null </br>
  int responseCode;

  /// 响应数据列表
  List<BillCategory> responseList;


  BillCategoryResponse();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "responseCode": responseCode,
      "responseList": responseList,
    };
    return map;
  }

  factory BillCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$BillCategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BillCategoryResponseToJson(this);

  int getResponseCode() {
    return responseCode;
  }

  void setResponseCode(int responseCode) {
    this.responseCode = responseCode;
  }

  List<BillCategory> getResponseList() {
    return responseList;
  }

  void setResponseList(List<BillCategory> responseList) {
    this.responseList = responseList;
  }
}
