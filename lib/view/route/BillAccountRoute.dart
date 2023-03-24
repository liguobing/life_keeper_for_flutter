import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeperforflutter/bean/account_book/bill_account/BillAccount.dart';
import 'package:lifekeeperforflutter/presenter/BillAccountRoutePresenter.dart';
import 'package:lifekeeperforflutter/view/custom_view/LoadingDialog.dart';

class BillAccountRoute extends StatefulWidget {
  BillAccountRouteState createState() {
    return BillAccountRouteState();
  }
}

class BillAccountRouteState extends State<BillAccountRoute> {
  List<BillAccount> accounts = List();
  BillAccountRoutePresenter presenter;
  TextEditingController addAccountController = TextEditingController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    presenter = BillAccountRoutePresenter(this);
    presenter.getBillAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("账户",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          GridView.builder(
            itemCount: accounts.length,
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
                  Text("${accounts[index].getAccountName()}"),
                ),
                onTap: () {
                  _showModalBottomSheet(index);
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
                  label: Text("添加账单账户"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    addAccountController.text = "";
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("添加账单账户"),
                          content: TextField(
                            controller: addAccountController,
                          ),
                          actions: [
                            Container(
                              child: GestureDetector(
                                child: Text("添加"),
                                onTap: () {
                                  Navigator.pop(context);
                                  presenter.addBillAccount(context,addAccountController.text);
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
    );
  }

  void updateAccounts(List<BillAccount> accounts) {
    setState(() {
      this.accounts.clear();
      this.accounts.addAll(accounts);
    });
  }

  _showModalBottomSheet(int index) {
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
                      child: Text("操作 - [${accounts[index].getAccountName()}]"),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Container(
                      alignment: Alignment.center,
                      child: ListTile(
                        title: Text("编辑"),
                        onTap: () {
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
                                      "${accounts[index].getAccountName()}",
                                      style: TextStyle(
                                          color: Color(0xff36C17E),
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
                                        presenter.updateAccount(
                                            context, accounts[index], controller.text);
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
                                      presenter.deleteAccount(
                                          context, accounts[index].getObjectId());
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
