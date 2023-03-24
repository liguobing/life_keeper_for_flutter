// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PlanBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanBean _$PlanBeanFromJson(Map<String, dynamic> json) {
  return PlanBean()
    ..objectId = json['objectId'] as String
    ..planId = json['planId'] as String
    ..groupId = json['groupId'] as String
    ..isAllDay = json['isAllDay'] as int
    ..planName = json['planName'] as String
    ..planDescription = json['planDescription'] as String
    ..planLocation = json['planLocation'] as String
    ..planUser = json['planUser'] as String
    ..startTime = json['startTime'] as int
    ..repeatType = json['repeatType'] as int
    ..endRepeatType = json['endRepeatType'] as int
    ..endRepeatValue = json['endRepeatValue'] as int
    ..alarmTime = json['alarmTime'] as int
    ..isFinished = json['isFinished'] as int
    ..planStatus = json['planStatus'] as int
    ..planType = json['planType'] as int
    ..createTime = json['createTime'] as int
    ..updateTime = json['updateTime'] as int
    ..finishTime = json['finishTime'] as int;
}

Map<String, dynamic> _$PlanBeanToJson(PlanBean instance) => <String, dynamic>{
      'objectId': instance.objectId,
      'planId': instance.planId,
      'groupId': instance.groupId,
      'isAllDay': instance.isAllDay,
      'planName': instance.planName,
      'planDescription': instance.planDescription,
      'planLocation': instance.planLocation,
      'planUser': instance.planUser,
      'startTime': instance.startTime,
      'repeatType': instance.repeatType,
      'endRepeatType': instance.endRepeatType,
      'endRepeatValue': instance.endRepeatValue,
      'alarmTime': instance.alarmTime,
      'isFinished': instance.isFinished,
      'planStatus': instance.planStatus,
      'planType': instance.planType,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'finishTime': instance.finishTime,
    };
