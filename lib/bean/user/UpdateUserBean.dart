import 'User.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UpdateUserBean.g.dart';

@JsonSerializable()

class UpdateUserBean {
  User newUser;
  String oldUserObjectId;
  int oldUserUpdateTime;


  UpdateUserBean();

  factory UpdateUserBean.fromJson(Map<String, dynamic> json) => _$UpdateUserBeanFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUserBeanToJson(this);

  User getNewUser() {
    return newUser;
  }

  void setNewUser(User newUser) {
    this.newUser = newUser;
  }

  String getOldUserObjectId() {
    return oldUserObjectId;
  }

  void setOldUserObjectId(String oldUserObjectId) {
    this.oldUserObjectId = oldUserObjectId;
  }

  int getOldUserUpdateTime() {
    return oldUserUpdateTime;
  }

  void setOldUserUpdateTime(int oldUserUpdateTime) {
    this.oldUserUpdateTime = oldUserUpdateTime;
  }
}
