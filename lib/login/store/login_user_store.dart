import 'dart:convert';

import 'package:flutter_deer/login/models/login_user.dart';
import 'package:flutter_deer/res/constant.dart';
import 'package:sp_util/sp_util.dart';

class LoginUserStore {
  static List<LoginUser> get users {
    final String? value = SpUtil.getString(Constant.loginUsers);
    if (value == null || value.isEmpty) {
      return <LoginUser>[];
    }
    try {
      final List<dynamic> jsonList = jsonDecode(value) as List<dynamic>;
      return jsonList
          .map((dynamic item) =>
              LoginUser.fromJson(Map<String, dynamic>.from(item as Map<dynamic, dynamic>)))
          .toList();
    } on Object {
      return <LoginUser>[];
    }
  }

  static LoginUser? get currentUser {
    final String? currentId = SpUtil.getString(Constant.currentLoginUser);
    for (final LoginUser user in users) {
      if (user.id == currentId) {
        return user;
      }
    }
    return null;
  }

  static void save(LoginUser user) {
    final List<LoginUser> updatedUsers =
        users.where((LoginUser item) => item.id != user.id).toList()..add(user);
    SpUtil.putString(Constant.loginUsers,
        jsonEncode(updatedUsers.map((LoginUser item) => item.toJson()).toList()));
    SpUtil.putString(Constant.currentLoginUser, user.id);
  }

  static void clear() {
    SpUtil.putString(Constant.loginUsers, '[]');
    SpUtil.putString(Constant.currentLoginUser, '');
    SpUtil.putString(Constant.profileGender, '');
    SpUtil.putString(Constant.profileBirthday, '');
    SpUtil.putString(Constant.profileInviteCode, '');
  }
}
