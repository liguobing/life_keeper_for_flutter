class BillChartOverViewBean {
  /// 收入
  double income;

  /// 结余
  double balance;

  /// 支出
  double expend;

  /// 日平均
  double evaluate;

  double getIncome() {
    return income;
  }

  double getBalance() {
    return balance;
  }

  double getExpend() {
    return expend;
  }

  double getEvaluate() {
    return evaluate;
  }

  void setIncome(double income) {
    this.income = income;
  }

  void setBalance(double balance) {
    this.balance = balance;
  }

  void setExpend(double expend) {
    this.expend = expend;
  }

  void setEvaluate(double evaluate) {
    this.evaluate = evaluate;
  }
}
