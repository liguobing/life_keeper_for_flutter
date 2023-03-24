import 'package:flutter/cupertino.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_category/BillCategory.dart';
import 'package:lifekeeperforflutter/model/BillCategoryRouteModel.dart';
import 'package:lifekeeperforflutter/view/route/BillCategoryRoute.dart';

class BillCategoryRoutePresenter {
  BillCategoryRouteModel model;
  BillCategoryRouteState view;

  BillCategoryRoutePresenter(BillCategoryRouteState view) {
    this.view = view;
    this.model = BillCategoryRouteModel();
  }

  ///获取账单分类
  void getBillCategories() async {
    List<BillCategory> incomeCategories = await model.getIncomeCategories();
    List<BillCategory> expendCategories = await model.getExpendCategories();
    view.updateCategory(incomeCategories, expendCategories);
  }

  ///添加分类
  void addBillCategory(
      BuildContext context, int isIncome, String categoryName) async {
    if (categoryName.length == 0) {
      view.showSnackBar(context, "名称不能为空");
      return;
    }
    view.showLoadingDialog(context, "请稍后...");
    bool isExists = await model.categoryIsExists(isIncome, categoryName);
    if (isExists) {
      view.hideDialog();
      view.showSnackBar(context, "该分类名称已经存在");
    } else {
      bool addSuccessful = await model.addCategory(isIncome, categoryName);
      if (addSuccessful) {
        getBillCategories();
        view.showSnackBar(context, "添加成功");
        view.hideDialog();
      } else {
        view.showSnackBar(context, "添加失败，请稍后重试");
        view.hideDialog();
      }
    }
  }

  void deleteCategory(BuildContext context, String objectId) async {
    view.showLoadingDialog(context, "请稍后...");
    bool deleteSuccessful = await model.deleteCategory(objectId);
    if (deleteSuccessful) {
      getBillCategories();
      view.showSnackBar(context, "删除成功");
      view.hideDialog();
    } else {
      view.showSnackBar(context, "删除失败，请稍后重试");
      view.hideDialog();
    }
  }

  void updateCategory(
      BuildContext context, BillCategory category, String newName) async {
    if (newName.length == 0) {
      view.showSnackBar(context, "新分类名称不能为空");
      return;
    }

    view.showLoadingDialog(context, "请稍后...");
    bool isExists = await model.categoryIsExists(category.isIncome, newName);
    if (isExists) {
      view.hideDialog();
      view.showSnackBar(context, "该名称已经存在了");
    } else {
      bool updateSuccessful = await model.updateCategory(category, newName);
      if (updateSuccessful) {
        getBillCategories();
        view.hideDialog();
        view.showSnackBar(context, "更新成功");
      } else {
        view.hideDialog();
        view.showSnackBar(context, "更新失败，请稍后重试");
      }
    }
  }
}
