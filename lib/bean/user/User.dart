import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User {
  ///创建时间
  int createTime;

  ///唯一标识
  String objectId;

  ///更新时间
  int updateTime;

  ///绑定 QQ 名
  String userBindQQ;

  ///绑定 QQ token
  String userBindQQAccessToken;

  ///绑定 QQ token 过期时间
  String userBindQQExpiresTime;

  ///绑定 QQ 头像链接
  String userBindQQIcon;

  ///绑定 QQ Id
  String userBindQQOpenId;

  ///绑定微博名
  String userBindWeibo;

  ///绑定微博 token
  String userBindWeiboAccessToken;

  ///绑定微博 token 过期时间
  String userBindWeiboExpiresTime;

  ///绑定微博头像
  String userBindWeiboIcon;

  ///绑定微博 ID
  String userBindWeiboId;

  ///用户头像链接
  String userIconUrl;

  /// 用户 ID
  String userId;

  ///用户名
  String userName;

  ///用户密码
  String userPassword;

  ///用户手机号
  String userPhone;

  ///用户状态
  ///  1：正常；
  ///  -1：非正常；
  int userStatus;

  ///用户类型
  ///  0：正常
  ///  1：已删除
  ///  2：已修改
  int userType;

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  String getObjectId() {
    return objectId;
  }

  void setObjectId(String objectId) {
    this.objectId = objectId;
  }

  void setUserId(String userId) {
    this.userId = userId;
  }

  void setUserPhone(String userPhone) {
    this.userPhone = userPhone;
  }

  void setUserName(String userName) {
    this.userName = userName;
  }

  void setUserBindWeibo(String userBindWeibo) {
    this.userBindWeibo = userBindWeibo;
  }

  void setUserBindQQExpiresTime(String userBindQQExpiresTime) {
    this.userBindQQExpiresTime = userBindQQExpiresTime;
  }

  void setUserBindQQAccessToken(String userBindQQAccessToken) {
    this.userBindQQAccessToken = userBindQQAccessToken;
  }

  void setUserBindQQIcon(String userBindQQIcon) {
    this.userBindQQIcon = userBindQQIcon;
  }

  void setUserBindWeiboAccessToken(String userBindWeiboAccessToken) {
    this.userBindWeiboAccessToken = userBindWeiboAccessToken;
  }

  void setUserPassword(String userPassword) {
    this.userPassword = userPassword;
  }

  void setUserBindWeiboIcon(String userBindWeiboIcon) {
    this.userBindWeiboIcon = userBindWeiboIcon;
  }

  void setUserBindWeiboExpiresTime(String userBindWeiboExpiresTime) {
    this.userBindWeiboExpiresTime = userBindWeiboExpiresTime;
  }

  void setUserBindWeiboId(String userBindWeiboId) {
    this.userBindWeiboId = userBindWeiboId;
  }

  void setUserBindQQ(String userBindQQ) {
    this.userBindQQ = userBindQQ;
  }

  void setUserIconUrl(String userIconUrl) {
    this.userIconUrl = userIconUrl;
  }

  void setUserBindQQOpenId(String userBindQQOpenId) {
    this.userBindQQOpenId = userBindQQOpenId;
  }

  void setUserStatus(int userStatus) {
    this.userStatus = userStatus;
  }

  void setUserType(int userType) {
    this.userType = userType;
  }

  void setCreateTime(int createTime) {
    this.createTime = createTime;
  }

  void setUpdateTime(int updateTime) {
    this.updateTime = updateTime;
  }

  String getUserId() {
    return userId;
  }

  String getUserPhone() {
    return userPhone;
  }

  String getUserName() {
    return userName;
  }

  String getUserBindWeibo() {
    return userBindWeibo;
  }

  String getUserBindQQExpiresTime() {
    return userBindQQExpiresTime;
  }

  String getUserBindQQAccessToken() {
    return userBindQQAccessToken;
  }

  String getUserBindQQIcon() {
    return userBindQQIcon;
  }

  String getUserBindWeiboAccessToken() {
    return userBindWeiboAccessToken;
  }

  String getUserPassword() {
    return userPassword;
  }

  String getUserBindWeiboIcon() {
    return userBindWeiboIcon;
  }

  String getUserBindWeiboExpiresTime() {
    return userBindWeiboExpiresTime;
  }

  String getUserBindWeiboId() {
    return userBindWeiboId;
  }

  String getUserBindQQ() {
    return userBindQQ;
  }

  String getUserIconUrl() {
    return userIconUrl;
  }

  String getUserBindQQOpenId() {
    return userBindQQOpenId;
  }

  int getUserStatus() {
    return userStatus;
  }

  int getUserType() {
    return userType;
  }

  int getCreateTime() {
    return createTime;
  }

  int getUpdateTime() {
    return updateTime;
  }
}
