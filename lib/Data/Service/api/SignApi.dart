import 'dart:convert';

import 'package:dasom_community_app/Data/Model/User.dart';
import 'package:dasom_community_app/Data/Service/accesstoken.dart';
import 'package:dasom_community_app/Data/Service/endpoint.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AuthApi {
  Future<Map<String, dynamic>> loginApi(
      {required int id, required String password}) async {
    final Map<String, dynamic> payload = {'id': id, 'password': password};

    var result;

    try {
      Response response = await post(
        Uri.parse(DasomUrI.login),
        body: json.encode(payload),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        var userData = responseData['data'];
        User authUser = User.fromJson(userData);
        Accesstoken = authUser.access_token;
        result = {
          'status': true,
          'message': responseData['message'],
          'data': authUser
        };
      } else if (response.statusCode == 401) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        result = {'status': false, 'message': responseData['message']};
      } else {
        result = {'status': false, 'message': "login failed"};
      }
    } catch (e) {
      debugPrint("***login :exception catch $e");
      result = {'status': false, 'message': "request error : $e"};
    }
    //debugPrint("***login :exception catch $e");
    return result;
  }

  Future<Map<String, dynamic>> registerApi(
      {required int id,
      required String password,
      required String name,
      required String email,
      required int enrollyear,
      String? birth}) async {
    Map<String, dynamic> payload = {
      "id": id,
      "password": password,
      "name": name,
      "email": email,
      "enrollYear": enrollyear
    };
    if (birth != null) {
      payload['birth'] = birth;
    }
    var result;

    try {
      var res = await post(
        Uri.parse(DasomUrI.signUp),
        body: json.encode(payload),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        Map<String, dynamic> responsedata = json.decode(res.body);
        result = {'status': true, 'message': responsedata["message"]};
      } else if (res.statusCode == 400 || res.statusCode == 500) {
        Map<String, dynamic> responsedata = json.decode(res.body);
        result = {'status': false, 'message': responsedata["message"]};
      } else {
        result = {'status': false, 'message': 'failed'};
      }
    } catch (e) {
      debugPrint("***signupApi :exception catch $e");
      result = {'status': false, 'message': "request failed"};
    }
    return result;
  }

  Future<Map<String, dynamic>> duplcateApi(String id) async {
    var url = Uri.parse("${DasomUrI.checkIdDuple}/$id");
    var result;
    try {
      var res = await get(url);
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        result = {'status': true, 'data': data['message']};
      } else {
        result = {'status': false, 'message': ' error'};
      }
    } catch (e) {
      debugPrint('***deplicateApi :exception catch $e');
      result = {'status': false, 'message': ' $e'};
    }
    return result;
  }
}
