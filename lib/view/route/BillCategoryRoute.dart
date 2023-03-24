import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_category/BillCategory.dart';
import 'package:lifekeeperforflutter/presenter/BillCategoryRoutePresenter.dart';
import 'package:lifekeeperforflutter/view/custom_view/LoadingDialog.dart';

class BillCategoryRoute extends StatefulWidget {
  BillCategoryRouteState createState() {
    return BillCategoryRouteState();
  }
}

class BillCategoryRouteState extends State<BillCategoryRoute> {
  PageController pageViewController;
  double appBarTitleSizeIncome = 20;
  double appBarTitleSizeExpend = 15;
  List<BillCategory> incomeCategories = List();
  List<BillCategory> expendCategories = List();
  BillCategoryRoutePresenter presenter;
  int isIncome = 1;
  TextEditingController addCategoryController = TextEditingController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    presenter = BillCategoryRoutePresenter(this);
    pageViewController = PageController();
    pageViewController.addListener(() {
      setState(() {
        if (pageViewController.page == 1) {
          appBarTitleSizeIncome = 15;
          appBarTitleSizeExpend = 20;
          isIncome = -1;
        } else if (pageViewController.page == 0) {
          appBarTitleSizeIncome = 20;
          appBarTitleSizeExpend = 15;
          isIncome = 1;
        }
      });
    });
    presenter.getBillCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "收入 ",
                style: TextStyle(fontSize: appBarTitleSizeIncome),
              ),
              TextSpan(
                text: " 支出",
                style: TextStyle(fontSize: appBarTitleSizeExpend),
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        children: [
          Stack(
            children: [
              GridView.builder(
                itemCount: incomeCategories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(5),
                      width: 100,
                      height: 100,
                      color: Color(0xff36C17E),
                      child:
                          Text("${incomeCategories[index].getCategoryName()}"),
                    ),
                    onTap: () {
                      _showModalBottomSheet(1, index);
                    },
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 90,
                  child: Container(
                    margin: EdgeInsets.only(left: 30, right: 30, bottom: 40),
                    child: RaisedButton.icon(
                      color: Color(0xff36C17E),
                      icon: Icon(Icons.add),
                      label: Text("添加收入分类"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        addCategoryController.text = "";
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("添加收入分类"),
                              content: TextField(
                                controller: addCategoryController,
                              ),
                              actions: [
                                Container(
                                  child: GestureDetector(
                                    child: Text("添加"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      presenter.addBillCategory(context,
                                          isIncome, addCategoryController.text);
                                    },
                                  ),
                                  padding:
                                      EdgeInsets.only(bottom: 10, right: 20),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              GridView.builder(
                itemCount: expendCategories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(5),
                      width: 100,
                      height: 100,
                      color: Color(0xffFF534F),
                      child:
                          Text("${expendCategories[index].getCategoryName()}"),
                    ),
                    onTap: () {
                      _showModalBottomSheet(-1, index);
                    },
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 90,
                  child: Container(
                    margin: EdgeInsets.only(left: 30, right: 30, bottom: 40),
                    child: RaisedButton.icon(
                      color: Color(0xffFF534F),
                      icon: Icon(Icons.add),
                      label: Text("添加支出分类"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        addCategoryController.text = "";
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("添加支出分类"),
                              content: TextField(
                                controller: addCategoryController,
                              ),
                              actions: [
                                Container(
                                  child: GestureDetector(
                                    child: Text("添加"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      presenter.addBillCategory(context,
                                          isIncome, addCategoryController.text);
                                    },
                                  ),
                                  padding:
                                      EdgeInsets.only(bottom: 10, right: 20),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        controller: pageViewController,
      ),
    );
  }

  void updateCategory(List<BillCategory> incomeCategories,
      List<BillCategory> expendCategories) {
    setState(() {
      this.incomeCategories.clear();
      this.expendCategories.clear();
      this.incomeCategories.addAll(incomeCategories);
      this.expendCategories.addAll(expendCategories);
    });
  }

  _showModalBottomSheet(int isIncome, int index) {
    print("isIncome = $isIncome,Index = $index");

    String inComeOrExpend = isIncome > 0 ? "收入" : "支出";
    String categoryName = isIncome > 0
        ? incomeCategories[index].getCategoryName()
        : expendCategories[index].getCategoryName();
    return showModalBottomSheet<int>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context1, state) {
            return SizedBox(
              height: 180,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text("操作 - $inComeOrExpend - [$categoryName]"),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Container(
                      alignment: Alignment.center,
                      child: ListTile(
                        title: Text("编辑"),
                        onTap: () {
                          BillCategory category = isIncome > 0
                              ? incomeCategories[index]
                              : expendCategories[index];
                          showDialog(
                            context: context,
                            builder: (context) {
                              TextEditingController controller =
                                  TextEditingController();
                              return SimpleDialog(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    alignment: Alignment.center,
                                    child: Text("将"),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${category.getCategoryName()}",
                                      style: TextStyle(
                                          color: isIncome > 0
                                              ? Color(0xff36C17E)
                                              : Color(0xffFF534F),
                                          fontSize: 30),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    alignment: Alignment.center,
                                    child: Text("修改为"),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 10, left: 20, right: 20),
                                    alignment: Alignment.center,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      controller: controller,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 20, right: 30, bottom: 10),
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        presenter.updateCategory(
                                            context, category, controller.text);
                                      },
                                      child: Text("确定"),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Container(
                      alignment: Alignment.center,
                      child: ListTile(
                        title: Text("删除"),
                        onTap: () {
                          String objectId = isIncome > 0
                              ? incomeCategories[index].getObjectId()
                              : expendCategories[index].getObjectId();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("提示"),
                                content: Text("您确定要删除吗?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("删除"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      presenter.deleteCategory(
                                          context, objectId);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context, //BuildContext对象
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingDialog(
          //调用对话框
          text: message,
        );
      },
    );
  }

  void hideDialog() {
    Navigator.pop(context);
  }

  Future<void> showSnackBar(BuildContext context, String message) async {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        elevation: 20,
        action: new SnackBarAction(
          label: "知道了",
          onPressed: () {
            Scaffold.of(context).removeCurrentSnackBar();
          },
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
