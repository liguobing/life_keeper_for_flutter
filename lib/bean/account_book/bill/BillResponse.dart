import 'package:lifekeeperforflutter/bean/account_book/bill/BillBean.dart';
import 'package:json_annotation/json_annotation.dart';

part 'BillResponse.g.dart';

@JsonSerializable()
class BillResponse {
  /// Status Code
  int responseCode;

  /// 账单数据列表
  List<BillBean> responseList;


  BillResponse();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "responseCode": responseCode,
      "responseList": responseList,
    };
    return map;
  }

  factory BillResponse.fromJson(Map<String, dynamic> json) =>
      _$BillResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BillResponseToJson(this);

  int getResponseCode() {
    return responseCode;
  }

  void setResponseCode(int responseCode) {
    this.responseCode = responseCode;
  }

  List<BillBean> getResponseList() {
    return responseList;
  }

  void setResponseList(List<BillBean> responseList) {
    this.responseList = responseList;
  }
}
