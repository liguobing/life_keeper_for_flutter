import 'package:dio/dio.dart';
import 'package:lifekeeperforflutter/bean/user/UpdateUserBean.dart';
import 'package:lifekeeperforflutter/bean/user/User.dart';
import 'package:lifekeeperforflutter/bean/user/UserResponse.dart';
import 'package:lifekeeperforflutter/util/Constant.dart';
import 'package:lifekeeperforflutter/util/StringUtil.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class UserCenterRouteModel {
  ///获取用户名
  Future<String> getUserName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userName");
  }

  ///获取用户头像
  Future<String> getUserIcon() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userIconUrl");
  }

  ///获取用户手机号
  Future<String> getUserPhone() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userPhone");
  }

  ///获取用户ObjectId
  Future<String> getUserObjectId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("objectId");
  }

  ///获取用户 UserId
  Future<String> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("userId");
  }

  ///旧密码是否正确
  Future<bool> oldPasswordIsRight(String oldPassword) async {
    String phone = await getUserPhone();
    String password = StringUtil.stringToMd5(phone, oldPassword);
    Dio dio = Dio();
    Response<String> resp = await dio.get(Constant.CLOUD_ADDRESS +
        "/LifeKeeper/SelectUserByPhoneAndPassword?phone=$phone&password=$password");
    Map<String, dynamic> obj = jsonDecode(resp.data.toString());
    if ("${obj['responseCode']}" == "1") {
      var list = obj['responseList'];
      if (list.length > 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  ///获取加密后的密码
  Future<String> getPassword() async {
    String objectId = await getUserObjectId();
    Dio dio = Dio();
    Response<String> resp = await dio.get(Constant.CLOUD_ADDRESS +
        "/LifeKeeper/SelectUserByObjectId?objectId=$objectId");
    Map<String, dynamic> obj = jsonDecode(resp.data.toString());
    var list = obj['responseList'];
    String password = list[0]["userPassword"];
    return password;
  }

  ///修改密码
  Future<bool> changePassword(String newPassword) async {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    SharedPreferences sp = await SharedPreferences.getInstance();
    User user = User();
    user.setObjectId(StringUtil.getRandomString());
    user.setUserId(sp.getString("userId"));
    user.setUserPhone(sp.getString("userPhone"));
    user.setUserName(sp.getString("userName"));
    user.setUserBindWeibo(sp.getString("userBindWeibo"));
    user.setUserBindQQExpiresTime(sp.getString("userBindQQExpiresTime"));
    user.setUserBindQQAccessToken(sp.getString("userBindQQAccessToken"));
    user.setUserBindQQIcon(sp.getString("userBindQQIcon"));
    user.setUserBindWeiboAccessToken(sp.getString("userBindWeiboAccessToken"));
    user.setUserPassword(
        StringUtil.stringToMd5(sp.getString("userPhone"), newPassword));
    user.setUserBindWeiboIcon(sp.getString("userBindWeiboIcon"));
    user.setUserBindWeiboExpiresTime(sp.getString("userBindWeiboExpiresTime"));
    user.setUserBindWeiboId(sp.getString("userBindWeiboId"));
    user.setUserBindQQ(sp.getString("userBindQQ"));
    user.setUserIconUrl(sp.getString("userIconUrl"));
    user.setUserBindQQOpenId(sp.getString("userBindQQOpenId"));
    user.setUserStatus(1);
    user.setUserType(0);
    user.setCreateTime(currentTime);
    user.setUpdateTime(0);
    UpdateUserBean bean = UpdateUserBean();
    bean.setOldUserObjectId(sp.getString("objectId"));
    bean.setOldUserUpdateTime(currentTime);
    bean.setNewUser(user);
    Dio dio = Dio();
    Response<bool> resp = await dio.post(
        "${Constant.CLOUD_ADDRESS}/LifeKeeper/UpdateUser",
        data: bean.toJson());
    bool result = resp.data;
    if (result) {
      sp.setString("objectId", user.getObjectId());
    }
    return result;
  }

  ///修改用户名
  Future<bool> changeUserName(String name) async {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    SharedPreferences sp = await SharedPreferences.getInstance();
    User user = User();
    user.setObjectId(StringUtil.getRandomString());
    user.setUserId(sp.getString("userId"));
    user.setUserPhone(sp.getString("userPhone"));
    user.setUserName(name);
    user.setUserBindWeibo(sp.getString("userBindWeibo"));
    user.setUserBindQQExpiresTime(sp.getString("userBindQQExpiresTime"));
    user.setUserBindQQAccessToken(sp.getString("userBindQQAccessToken"));
    user.setUserBindQQIcon(sp.getString("userBindQQIcon"));
    user.setUserBindWeiboAccessToken(sp.getString("userBindWeiboAccessToken"));
    user.setUserPassword(await getPassword());
    user.setUserBindWeiboIcon(sp.getString("userBindWeiboIcon"));
    user.setUserBindWeiboExpiresTime(sp.getString("userBindWeiboExpiresTime"));
    user.setUserBindWeiboId(sp.getString("userBindWeiboId"));
    user.setUserBindQQ(sp.getString("userBindQQ"));
    user.setUserIconUrl(sp.getString("userIconUrl"));
    user.setUserBindQQOpenId(sp.getString("userBindQQOpenId"));
    user.setUserStatus(1);
    user.setUserType(0);
    user.setCreateTime(currentTime);
    user.setUpdateTime(0);
    UpdateUserBean bean = UpdateUserBean();
    bean.setOldUserObjectId(sp.getString("objectId"));
    bean.setOldUserUpdateTime(currentTime);
    bean.setNewUser(user);
    Dio dio = Dio();
    Response<bool> resp = await dio.post(
        "${Constant.CLOUD_ADDRESS}/LifeKeeper/UpdateUser",
        data: bean.toJson());
    bool result = resp.data;
    if (result) {
      sp.setString("objectId", user.getObjectId());
      sp.setString("userName", user.getUserName());
    }
    return result;
  }

  Future<bool> logout() async {
    bool result = false;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'LifeKeeper.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    await database.transaction((txn) async {
      txn.delete(Constant.BILL_TABLE);
      txn.delete(Constant.BILL_CATEGORY_TABLE);
      txn.delete(Constant.BILL_ACCOUNT_TABLE);
      txn.delete(Constant.BILL_SHOP_TABLE);
      txn.delete(Constant.PLAN_TABLE);
      SharedPreferences sp = await SharedPreferences.getInstance();
      result = await sp.clear();
    });
    return result;
  }

  Future<bool> updateUserIconUrl(String userIconName) async {
    bool updateResult = false;
    String userId = await getUserId();
    Dio dio = Dio();
    Response response = await dio.get(
        "http://104.245.40.124:8080/LifeKeeper/SelectUserByUserId?userId=$userId");
    UserResponse userResponse = UserResponse.fromJson(response.data);
    if (userResponse.getResponseCode() > 0) {
      if (userResponse.getResponseList().length > 0) {
        User user = userResponse.getResponseList()[0];
        String oldUserObject = user.getObjectId();
        String newUserObjectId = StringUtil.getRandomString();
        int oldUserUpdateTime = DateTime.now().millisecondsSinceEpoch;
        user.setUserIconUrl(
            "http://104.245.40.124:8080/BillImage/$userIconName}");
        user.setObjectId(newUserObjectId);
        UpdateUserBean updateUserBean = UpdateUserBean();
        updateUserBean.setOldUserObjectId(oldUserObject);
        updateUserBean.setOldUserUpdateTime(oldUserUpdateTime);
        updateUserBean.setNewUser(user);
        Response<bool> resp = await dio.post(
            "${Constant.CLOUD_ADDRESS}/LifeKeeper/UpdateUser",
            data: updateUserBean.toJson());
        bool result = resp.data;
        if (result) {
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString("objectId", newUserObjectId);
          sp.setString("userIconUrl",
              "http://104.245.40.124:8080/BillImage/$userIconName");
          updateResult = true;
        }
      }
    }
    return updateResult;
  }
}
