import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:lifekeeperforflutter/bean/account_book/shop/SearchBillShop.dart';
import 'package:lifekeeperforflutter/presenter/BillShopRoutePresenter.dart';
import 'package:lifekeeperforflutter/view/custom_view/LoadingDialog.dart';
import 'package:lifekeeperforflutter/view/custom_view/SaveDialog.dart';
import 'package:permission_handler/permission_handler.dart';

class BillShopRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BillShopRouteState();
  }
}

class BillShopRouteState extends State<BillShopRoute> {
  BillShopRoutePresenter presenter;

  ///Scaffold State
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  ///定位权限
  int locationPermission = 0;

  ///“经常使用” item 背景色
  Color oftenUseColor = Colors.white;

  ///“所有” item 背景色
  Color allShopColor = Color(0xffF7F4F8);

  ///“附近” item 背景色
  Color nearShopColor = Color(0xffF7F4F8);

  ///商家数据集
  List<String> list = List();

  ///关键字搜索输入框 Controller
  TextEditingController keyWordSearchController = TextEditingController();

  ///焦点，用于展开搜索框时获取焦点
  FocusNode focusNode = new FocusNode();

  ///是否是关键字搜索，用于控制 appbar 显示
  bool isKeyWordSearch = false;

  ///关键字搜索数据集合
  List<SearchBillShop> keyWordSearchResultList = List();

  ///关键字搜索页数
  int keySearchResultPageNum = 1;

  ///搜索的关键字
  String keyWordSearchKeyWord = "";

  ///ModalBottomSheet State
  StateSetter keyWordSearchState;

  ///关键字搜索是否还有下一页
  bool keyWordSearchHasNextPage = false;

  ///商家 ListView 的类型
  ///0.经常使用商家
  ///1.所有自定义商家
  ///2.附近商家分类
  ///3.附近某分类商家
  int shopListViewItemType = 0;

  ///附近商家是否还有下一页
  bool nearShopHasNextPage = true;

  ///附近商家页数
  int nearShopPageNumber2 = 1;

  ///附近商家分类
  String nearShopCategory = "";

  ///添加新商家输入框 Controller
  TextEditingController addNewShopController = TextEditingController();

  @override
  void initState() {
    super.initState();
    presenter = BillShopRoutePresenter(this);
    checkPermission();
    enableFluttifyLog(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Container(
                padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                alignment: Alignment.bottomLeft,
                color: Color(0xff1C81D1),
                child: Row(
                  children: [
                    isKeyWordSearch
                        ? Text("")
                        : Text(
                            "消费商家",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                    Expanded(
                      child: isKeyWordSearch
                          ? TextField(
                              autofocus: true,
                              focusNode: focusNode,
                              controller: keyWordSearchController,
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                              decoration: InputDecoration.collapsed(
                                hintText: "请输入关键字",
                                hintStyle: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              ),
                            )
                          : Text(""),
                    ),
                    isKeyWordSearch
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                //点击执行新搜索，先清空数据集合
                                this.keyWordSearchResultList.clear();
                                //展开底部模板
                                _showModalBottomSheet();
                                //将标识设置为 false，会隐藏输入框
                                isKeyWordSearch = false;
                                //保存关键字，以便搜索第二页
                                keyWordSearchKeyWord =
                                    keyWordSearchController.text;
                                //开始执行关键字搜索
                                presenter.keyWordSearch(
                                    context, keyWordSearchController.text, 1);
                              });
                            },
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                //点击搜索按钮之后，重置搜索框内容
                                keyWordSearchController.text = "";
                                //将标识设置为 true，会显示搜索关键字输入框
                                isKeyWordSearch = true;
                              });
                            },
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Color(0xffF7F4F8),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              presenter.selectShopCategory(context, 0);
                            },
                            child: Container(
                              alignment: Alignment.topCenter,
                              color: oftenUseColor,
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              margin: EdgeInsets.fromLTRB(0, 1, 0, 1),
                              child: Text("经常使用"),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              presenter.selectShopCategory(context, 1);
                            },
                            child: Container(
                              color: allShopColor,
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              margin: EdgeInsets.fromLTRB(0, 1, 0, 1),
                              child: Text("所有"),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              presenter.selectShopCategory(context, 2);
                            },
                            child: Container(
                              color: nearShopColor,
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              margin: EdgeInsets.fromLTRB(0, 1, 0, 1),
                              child: Text("附近"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.white,
                      child: MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  shopListViewItemOnTap(context, index);
                                },
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  margin: EdgeInsets.fromLTRB(0, 1, 0, 1),
                                  child: Text(list[index]),
                                ),
                              );
                            },
                            itemCount: list.length,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateShopType(int type) {
    setState(() {
      switch (type) {
        case 0:
          oftenUseColor = Colors.white;
          allShopColor = Color(0xffF7F4F8);
          nearShopColor = Color(0xffF7F4F8);
          break;
        case 1:
          oftenUseColor = Color(0xffF7F4F8);
          allShopColor = Colors.white;
          nearShopColor = Color(0xffF7F4F8);
          break;
        case 2:
          oftenUseColor = Color(0xffF7F4F8);
          allShopColor = Color(0xffF7F4F8);
          nearShopColor = Colors.white;
          break;
        case 3:
          oftenUseColor = Color(0xffF7F4F8);
          allShopColor = Color(0xffF7F4F8);
          nearShopColor = Colors.white;
          break;
      }
    });
  }

  void updateShopListView2(
      int type, List<String> list, int pageNum, bool hasNextPage) {
    switch (type) {
      case 0:
        setState(() {
          this.list.clear();
          this.list.addAll(list);
          shopListViewItemType = 0;
          nearShopPageNumber2 = 1;
          nearShopHasNextPage = true;
        });
        break;
      case 1:
        setState(() {
          this.list.clear();
          this.list.addAll(list);
          this.list.add("添加新商家");
          shopListViewItemType = 1;
          nearShopPageNumber2 = 1;
          nearShopHasNextPage = true;
        });
        break;
      case 2:
        setState(() {
          this.list.clear();
          this.list.addAll(list);
          shopListViewItemType = 2;
          nearShopPageNumber2 = 1;
          nearShopHasNextPage = true;
        });
        break;
      case 3:
        shopListViewItemType = 3;
        this.nearShopPageNumber2 = pageNum;
        setState(() {
          if (pageNum == 1) {
            if (list.length == 0) {
              this.list.clear();
              nearShopHasNextPage = false;
              this.list.add("该分类下没有商家");
            } else {
              this.list.clear();
              this.list.addAll(list);
              if (list.length == 20) {
                this.list.add("下一页");
              } else {
                this.list.add("没有了");
                nearShopHasNextPage = false;
              }
            }
          } else {
            this.list.removeLast();
            this.list.addAll(list);
            if (list.length == 20) {
              this.list.add("下一页");
            } else {
              this.list.add("没有了");
              nearShopHasNextPage = false;
            }
          }
        });
        break;
    }
  }

  void shopListViewItemOnTap(BuildContext context, int index) {
    switch (shopListViewItemType) {
      case 0:
        Navigator.pop(context, {"Shop": list[index]});
        break;
      case 1:
        if (index == list.length - 1) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("添加新商家"),
                content: TextField(controller: addNewShopController),
                actions: [
                  MaterialButton(
                    child: Text("保存"),
                    onPressed: () {
                      Navigator.pop(context);
                      presenter.addNewShop(context, addNewShopController.text);
                      addNewShopController.text = "";
                    },
                  ),
                ],
              );
            },
          );
        } else {
          Navigator.pop(context, {"Shop": list[index]});
        }
        break;
      case 2:
        presenter.selectNearShop(context, list[index], nearShopPageNumber2);
        nearShopCategory = list[index];
        break;
      case 3:
        if (this.list.length != 1) {
          if (index != this.list.length - 1) {
            Navigator.pop(context, {"Shop": list[index]});
          } else {
            if (nearShopHasNextPage) {
              nearShopPageNumber2++;
              presenter.selectNearShop(
                  context, nearShopCategory, nearShopPageNumber2);
            }
          }
        }
        break;
    }
  }

  ///显示关键字搜索结果
  _showModalBottomSheet() {
    return showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context1, state) {
            keyWordSearchState = state;
            return ListView.builder(
              itemCount: keyWordSearchResultList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title:
                      Text("${keyWordSearchResultList[index].getShopName()}"),
                  subtitle: Text(
                      "${keyWordSearchResultList[index].getShopAddress()}"),
                  onTap: () {
                    if (index == this.keyWordSearchResultList.length - 1) {
                      if (keyWordSearchHasNextPage) {
                        presenter.keyWordSearch(context, keyWordSearchKeyWord,
                            ++keySearchResultPageNum);
                      }
                    } else {
                      print(
                          "选中了：${this.keyWordSearchResultList[index].getShopName()}");
                      Navigator.pop(context);
                      Navigator.pop(context, {
                        "Shop":
                            this.keyWordSearchResultList[index].getShopName()
                      });
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  ///检查权限
  Future checkPermission() async {
    Future<int> camera = presenter.checkPermission(await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location));
    camera.then((value) async {
      setState(() {
        locationPermission = value;
      });
    });
  }

  Future<double> getLocationLatLng() async {
    if (locationPermission == 1) {
      final location = await AmapLocation.fetchLocation();
      return location.latLng.latitude;
    } else {
      return 0;
    }
  }

  ///更新关键字搜索商家列表
  void updateKeyWordSearchListView(
      List<SearchBillShop> list, int pageNum, bool hasNext) {
    keyWordSearchState(() {
      if (this.keyWordSearchResultList.length > 0) {
        this.keyWordSearchResultList.removeLast();
      }
      this.keyWordSearchResultList.addAll(list);
      keyWordSearchHasNextPage = hasNext;
    });
  }

  ///显示 SnackBar
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

  ///显示保存 Dialog
  Future<Null> showSaveDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        return SaveDialog(50, Colors.lightGreenAccent, 45, Colors.white, 10);
      },
    );
  }

  ///显示普通等待 Dialog
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

  ///申请权限
  Future requestPermission(BuildContext context) async {
    switch (locationPermission) {
      //还没请求过
      case 0:
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
        PermissionStatus permission = await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.location);
        if (permission == PermissionStatus.granted) {
          presenter.selectShopCategory(context, 3);
          locationPermission = 1;
        }
        break;
      //已经通过权限申请
      case 1:
        locationPermission = 1;
        break;
      //已经拒绝权限申请
      case -1:
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
        PermissionStatus permission = await PermissionHandler()
            .checkPermissionStatus(PermissionGroup.location);
        if (permission == PermissionStatus.granted) {
          presenter.selectShopCategory(context, 3);
          locationPermission = 1;
        }
        break;
      //已经拒绝，并选择用不提醒
      case -2:
        PermissionHandler().openAppSettings();
        break;
      //iOS专用
      default:
        break;
    }
  }
}
