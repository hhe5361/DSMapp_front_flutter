import 'dart:async';

import 'package:dasom_community_app/Data/Model/User.dart';
import 'package:dasom_community_app/Data/Service/accesstoken.dart';
import 'package:dasom_community_app/Data/Service/api/SignApi.dart';
import 'package:flutter/material.dart';

//test용

enum AuthStatus {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  LoggedOut,
  Loading
}

class AuthProvider with ChangeNotifier {
  final AuthApi _api = AuthApi();
  late User? _user;

  late String _msg = "";
  AuthStatus _loggedInStatus = AuthStatus.NotLoggedIn;
  AuthStatus _registeredInStatus = AuthStatus.NotRegistered;

  AuthStatus get loggedInStatus => _loggedInStatus;
  AuthStatus get registeredInStatus => _registeredInStatus;
  String get message => _msg;
  int get userid => _user!.userId!;

  void _setloginStatus(AuthStatus status) {
    _loggedInStatus = status;
    notifyListeners();
  }

  void _setRegisterStatus(AuthStatus status) {
    _registeredInStatus = status;
    notifyListeners();
  }

  Future<void> tryLogin(int inid, String inpassword) async {
    _setloginStatus(AuthStatus.Loading);

    Map<String, dynamic> data =
        await _api.loginApi(id: inid, password: inpassword);
    if (data['status']) {
      _user = data['data'];
      _user!.userId = inid;
      debugPrint("login 성공");
      _setloginStatus(AuthStatus.LoggedIn);
    } else {
      _msg = data['message'];
      _setloginStatus(AuthStatus.NotLoggedIn);
    }
  }

  Future<void> register(int inid, String inpassword, String inname,
      String inemail, int inenrollYear, String? inbirth) async {
    Map<String, dynamic> data = await _api.registerApi(
        id: inid,
        password: inpassword,
        name: inname,
        email: inemail,
        enrollyear: inenrollYear,
        birth: inbirth);

    _msg = data['message'];
    if (data['status']) {
      _setRegisterStatus(AuthStatus.Registered);
    } else {
      _setRegisterStatus(AuthStatus.NotRegistered);
    }
  }

  void _tokenUpload() {
    Accesstoken = _user!.access_token;
  }
  //token refresh 랑 token 업데이트도 할 것.
}
