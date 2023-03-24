// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UpdateUserBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserBean _$UpdateUserBeanFromJson(Map<String, dynamic> json) {
  return UpdateUserBean()
    ..newUser = json['newUser'] == null
        ? null
        : User.fromJson(json['newUser'] as Map<String, dynamic>)
    ..oldUserObjectId = json['oldUserObjectId'] as String
    ..oldUserUpdateTime = json['oldUserUpdateTime'] as int;
}

Map<String, dynamic> _$UpdateUserBeanToJson(UpdateUserBean instance) =>
    <String, dynamic>{
      'newUser': instance.newUser,
      'oldUserObjectId': instance.oldUserObjectId,
      'oldUserUpdateTime': instance.oldUserUpdateTime,
    };
