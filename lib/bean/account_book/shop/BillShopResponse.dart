import 'BillShop.dart';
import 'package:json_annotation/json_annotation.dart';

part 'BillShopResponse.g.dart';

@JsonSerializable()
class BillShopResponse {
  /// 响应码 </br>
  /// 1:响应正常，此时 responseList 为响应数据 </br>
  /// -1:响应不正常，此时 responseList 为 null </br>
  int responseCode;

  /// 响应数据 List
  List<BillShop> responseList;


  BillShopResponse();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "responseCode": responseCode,
      "responseList": responseList,
    };
    return map;
  }

  factory BillShopResponse.fromJson(Map<String, dynamic> json) =>
      _$BillShopResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BillShopResponseToJson(this);

  int getResponseCode() {
    return responseCode;
  }

  void setResponseCode(int responseCode) {
    this.responseCode = responseCode;
  }

  List<BillShop> getResponseList() {
    return responseList;
  }

  void setResponseList(List<BillShop> responseList) {
    this.responseList = responseList;
  }
}
