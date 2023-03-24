class UpdateAccountBookCardBean {
  double income;
  double expend;


  UpdateAccountBookCardBean(this.income, this.expend);

  double getIncome() {
    return income;
  }

  double getExpend() {
    return expend;
  }

  void setIncome(double income) {
    this.income = income;
  }

  void setExpend(double expend) {
    this.expend = expend;
  }
}
