import 'User.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UserResponse.g.dart';

@JsonSerializable()
class UserResponse {
  /// 响应 Code </>
  /// 1：查找成功 </>
  /// -1：查找失败 ，此时 List 为 null </>
  int responseCode;

  /// 查找成功时的查找结果列表 </>
  List<User> responseList;


  UserResponse();

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);


  int getResponseCode() {
    return responseCode;
  }

  void setResponseCode(int responseCode) {
    this.responseCode = responseCode;
  }

  List<User> getResponseList() {
    return responseList;
  }

  void setResponseList(List<User> responseList) {
    this.responseList = responseList;
  }
}
