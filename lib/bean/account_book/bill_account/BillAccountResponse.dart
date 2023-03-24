import 'BillAccount.dart';
import 'package:json_annotation/json_annotation.dart';

part 'BillAccountResponse.g.dart';

@JsonSerializable()
class BillAccountResponse {
  /// 响应码 </br>
  /// 1:响应正常，此时 responseList 为响应数据 </br>
  /// -1:响应不正常，此时 responseList 为 null </br>
  int responseCode;

  /// 响应数据 List
  List<BillAccount> responseList;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "responseCode": responseCode,
      "responseList": responseList,
    };
    return map;
  }

  factory BillAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$BillAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BillAccountResponseToJson(this);


  BillAccountResponse();

  int getResponseCode() {
    return responseCode;
  }

  void setResponseCode(int responseCode) {
    this.responseCode = responseCode;
  }

  List<BillAccount> getResponseList() {
    return responseList;
  }

  void setResponseList(List<BillAccount> responseList) {
    this.responseList = responseList;
  }
}
