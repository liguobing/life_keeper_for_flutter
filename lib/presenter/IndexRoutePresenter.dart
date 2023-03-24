import 'package:lifekeeperforflutter/bean/account_book/UpdateAccountBookCardBean.dart';
import 'package:lifekeeperforflutter/bean/plan/UpdatePlanCardBean.dart';
import 'package:lifekeeperforflutter/model/IndexRouteModel.dart';
import 'package:lifekeeperforflutter/view/route/IndexRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexRoutePresenter {
  IndexRouteState view;
  IndexRouteModel model;

  IndexRoutePresenter(IndexRouteState view) {
    this.view = view;
    this.model = new IndexRouteModel();
  }

  ///获取用户 ID
  Future<String> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userId");
  }

  ///获取计划卡片数据
  void getPlanCardData() async {
    UpdatePlanCardBean planCardDataBean =
        await model.getPlanCardData(await getUserId());
    view.updatePlanCardView(planCardDataBean.getDailyPlanCount(),
        planCardDataBean.getMonthlyPlanCount());
  }

  ///获取账本卡片数据
  void getAccountBookCardData() async {
    UpdateAccountBookCardBean accountBookCardBean =
        await model.getAccountBookCardData(await getUserId());
    view.updateBillCardView(
        accountBookCardBean.getIncome(), accountBookCardBean.getExpend());
  }

  ///获取用户头像链接
  Future<String> getUserIconUrl() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userIconUrl");
  }

  ///获取用户名
  Future<String> getUserName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userName");
  }

  ///初始化数据
  void initData() async {
    String userId = await getUserId();
    if (userId == null) {
      view.updateLoginStatus(false);
    } else {
      view.updateLoginStatus(true);
      getAccountBookCardData();
      getPlanCardData();
      String userIconUrl = await getUserIconUrl();
      String userName = await getUserName();
      view.updateUserInfo(userIconUrl, userName);
    }
  }
}
