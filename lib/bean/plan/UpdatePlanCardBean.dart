///更新 IndexActivity 计划 CardView 内容的对象原型
///@author LGB
class UpdatePlanCardBean {
  ///当日计划总数
  int dailyPlanCount;

  ///当月计划总数
  int monthlyPlanCount;

  UpdatePlanCardBean( this.dailyPlanCount, this.monthlyPlanCount);

  int getDailyPlanCount() {
    return dailyPlanCount;
  }

  set setDailyPlanCount(int dailyPlanCount) {
    this.dailyPlanCount = dailyPlanCount;
  }

  int getMonthlyPlanCount() {
    return monthlyPlanCount;
  }

  set setMonthlyPlanCount(int monthlyPlanCount) {
    this.monthlyPlanCount = monthlyPlanCount;
  }
}
