import 'PlanBean.dart';
import 'package:json_annotation/json_annotation.dart';

part 'PlanResponse.g.dart';

@JsonSerializable()
class PlanResponse {
  /// 响应 Code </>
  /// 1：查找成功 </>
  /// -1：查找失败 ，此时 List 为 null </>
  int code;

  /// 查找成功时的查找结果列表 </>
  List<PlanBean> list;


  PlanResponse();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "code": code,
      "list": list,
    };
    return map;
  }

  factory PlanResponse.fromJson(Map<String, dynamic> json) =>
      _$PlanResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlanResponseToJson(this);

  int getCode() {
    return code;
  }

  void setCode(int code) {
    this.code = code;
  }

  List<PlanBean> getList() {
    return list;
  }

  void setList(List<PlanBean> list) {
    this.list = list;
  }
}
