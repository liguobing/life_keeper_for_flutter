// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..createTime = json['createTime'] as int
    ..objectId = json['objectId'] as String
    ..updateTime = json['updateTime'] as int
    ..userBindQQ = json['userBindQQ'] as String
    ..userBindQQAccessToken = json['userBindQQAccessToken'] as String
    ..userBindQQExpiresTime = json['userBindQQExpiresTime'] as String
    ..userBindQQIcon = json['userBindQQIcon'] as String
    ..userBindQQOpenId = json['userBindQQOpenId'] as String
    ..userBindWeibo = json['userBindWeibo'] as String
    ..userBindWeiboAccessToken = json['userBindWeiboAccessToken'] as String
    ..userBindWeiboExpiresTime = json['userBindWeiboExpiresTime'] as String
    ..userBindWeiboIcon = json['userBindWeiboIcon'] as String
    ..userBindWeiboId = json['userBindWeiboId'] as String
    ..userIconUrl = json['userIconUrl'] as String
    ..userId = json['userId'] as String
    ..userName = json['userName'] as String
    ..userPassword = json['userPassword'] as String
    ..userPhone = json['userPhone'] as String
    ..userStatus = json['userStatus'] as int
    ..userType = json['userType'] as int;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'createTime': instance.createTime,
      'objectId': instance.objectId,
      'updateTime': instance.updateTime,
      'userBindQQ': instance.userBindQQ,
      'userBindQQAccessToken': instance.userBindQQAccessToken,
      'userBindQQExpiresTime': instance.userBindQQExpiresTime,
      'userBindQQIcon': instance.userBindQQIcon,
      'userBindQQOpenId': instance.userBindQQOpenId,
      'userBindWeibo': instance.userBindWeibo,
      'userBindWeiboAccessToken': instance.userBindWeiboAccessToken,
      'userBindWeiboExpiresTime': instance.userBindWeiboExpiresTime,
      'userBindWeiboIcon': instance.userBindWeiboIcon,
      'userBindWeiboId': instance.userBindWeiboId,
      'userIconUrl': instance.userIconUrl,
      'userId': instance.userId,
      'userName': instance.userName,
      'userPassword': instance.userPassword,
      'userPhone': instance.userPhone,
      'userStatus': instance.userStatus,
      'userType': instance.userType,
    };
