import 'package:json_annotation/json_annotation.dart';

part 'PlanBean.g.dart';

///计划原型
///@author LGB
///

@JsonSerializable()
class PlanBean {
  /// ObjectId 唯一标识
  String objectId;

  /// 计划 ID
  String planId;

  /// 分组 ID
  String groupId;

  /// 是否是全天计划，全天计划没有提醒
  /// 1：全天计划
  /// -1：非全天计划
  int isAllDay;

  /// 计划名称
  String planName;

  /// 计划描述
  String planDescription;

  /// 计划地点
  String planLocation;

  /// 计划用户
  String planUser;

  /// 开始时间
  int startTime;

  /// 重复模式
  /// 0：一次性活动（不重复）
  /// 1：每日计划
  /// 2：每周计划
  /// 3：每月计划
  /// 4：每年计划
  int repeatType;

  /// 结束重复模式
  /// 0：时间
  /// 1：次数
  int endRepeatType;

  /// 结束重复值
  /// 当 endRepeatType 为 0 时，该值代表结束时间
  /// 当 endRepeatType 为 1 时，该值代表执行次数
  int endRepeatValue;

  /// 提醒时间
  /// -1：为不提醒
  /// N：为 N 分钟前提醒
  int alarmTime;

  /// 是否已经完成
  /// 1：已完成
  /// -1：未完成
  int isFinished;

  /// 计划状态
  /// 1：正常；
  /// -1：非正常；
  int planStatus;

  /// 计划类型
  /// 0：正常
  /// 1：已删除
  /// 2：已修改
  int planType;

  /// 创建时间
  int createTime;

  /// 更新时间
  int updateTime;

  /// 完成时间
  int finishTime;

  factory PlanBean.fromJson(Map<String, dynamic> json) => _$PlanBeanFromJson(json);
  Map<String, dynamic> toJson() => _$PlanBeanToJson(this);


  PlanBean();

  String getObjectId() {
    return objectId;
  }

  void setObjectId(String objectId) {
    this.objectId = objectId;
  }

  String getPlanId() {
    return planId;
  }

  void setPlanId(String planId) {
    this.planId = planId;
  }

  String getGroupId() {
    return groupId;
  }

  void setGroupId(String groupId) {
    this.groupId = groupId;
  }

  int getIsAllDay() {
    return isAllDay;
  }

  void setIsAllDay(int isAllDay) {
    this.isAllDay = isAllDay;
  }

  String getPlanName() {
    return planName;
  }

  void setPlanName(String planName) {
    this.planName = planName;
  }

  String getPlanDescription() {
    return planDescription;
  }

  void setPlanDescription(String planDescription) {
    this.planDescription = planDescription;
  }

  String getPlanUser() {
    return planUser;
  }

  void setPlanUser(String planUser) {
    this.planUser = planUser;
  }

  String getPlanLocation() {
    return planLocation;
  }

  void setPlanLocation(String planLocation) {
    this.planLocation = planLocation;
  }

  int getStartTime() {
    return startTime;
  }

  void setStartTime(int startTime) {
    this.startTime = startTime;
  }

  int getAlarmTime() {
    return alarmTime;
  }

  void setAlarmTime(int alarmTime) {
    this.alarmTime = alarmTime;
  }

  int getIsFinished() {
    return isFinished;
  }

  void setIsFinished(int isFinished) {
    this.isFinished = isFinished;
  }

  int getPlanStatus() {
    return planStatus;
  }

  void setPlanStatus(int planStatus) {
    this.planStatus = planStatus;
  }

  int getPlanType() {
    return planType;
  }

  void setPlanType(int planType) {
    this.planType = planType;
  }

  int getCreateTime() {
    return createTime;
  }

  void setCreateTime(int createTime) {
    this.createTime = createTime;
  }

  int getUpdateTime() {
    return updateTime;
  }

  void setUpdateTime(int updateTime) {
    this.updateTime = updateTime;
  }

  int getFinishTime() {
    return finishTime;
  }

  void setFinishTime(int finishTime) {
    this.finishTime = finishTime;
  }

  int getRepeatType() {
    return repeatType;
  }

  void setRepeatType(int repeatType) {
    this.repeatType = repeatType;
  }

  int getEndRepeatType() {
    return endRepeatType;
  }

  void setEndRepeatType(int endRepeatType) {
    this.endRepeatType = endRepeatType;
  }

  int getEndRepeatValue() {
    return endRepeatValue;
  }

  void setEndRepeatValue(int endRepeatValue) {
    this.endRepeatValue = endRepeatValue;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "ObjectId": objectId,
      "PlanId": planId,
      "GroupId": groupId,
      "IsAllDay": isAllDay,
      "PlanName": planName,
      "PlanDescription": planDescription,
      "PlanLocation": planLocation,
      "PlanUser": planUser,
      "StartTime": startTime,
      "RepeatType": repeatType,
      "EndRepeatType": endRepeatType,
      "EndRepeatValue": endRepeatValue,
      "AlarmTime": alarmTime,
      "IsFinished": isFinished,
      "PlanStatus": planStatus,
      "PlanType": planType,
      "CreateTime": createTime,
      "UpdateTime": updateTime,
      "FinishTime": finishTime,
    };
    return map;
  }
}
