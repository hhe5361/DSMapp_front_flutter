import 'dart:convert';

import 'package:dasom_community_app/Data/Model/CalendarPlan.dart';
import 'package:dasom_community_app/Data/Service/endpoint.dart';
import 'package:dasom_community_app/Data/Service/utilService.dart';
import 'package:http/http.dart';

class CalendarApi {
  Future<Map<String, dynamic>> getplan() async {
    Map<String, dynamic> result;
    Uri url = Uri.parse(HyoeunServer.accessCalendar);

    try {
      var res = await get(url);

      if (res.statusCode == 200) {
        var data = jsonDecode(utf8.decode(res.bodyBytes))['data'];
        List<CalendarPlan> plans = (data as List)
            .map((e) => CalendarPlan.fromjson(e as Map<String, dynamic>))
            .toList();
        result = {'status': true, 'data': plans};
      } else {
        result = errorhandler();
      }
    } catch (e) {
      result = excephandler("calendar", e);
    }
    return result;
  }

  Future<Map<String, dynamic>> postplan(
      {required String title,
      required int studentId,
      required String date,
      required String content}) async {
    Map<String, dynamic> result;
    Map<String, dynamic> payload = {
      "title": title,
      "studentid": studentId,
      "date": date,
      "content": content
    };
    Uri url = Uri.parse(HyoeunServer.accessPostCalendar);

    try {
      var res = await post(url, body: json.encode(payload), headers: {
        'Content-Type': 'application/json', // 추가
      });

      if (res.statusCode == 200) {
        result = {'status': true};
      } else {
        result = errorhandler();
      }
    } catch (e) {
      result = excephandler("calendarPost", e);
    }
    return result;
  }

  Future<Map<String, dynamic>> deleteplan(int postId) async {
    Map<String, dynamic> result;
    Uri url = Uri.parse(HyoeunServer.accessDeleteCalendar(postId));

    try {
      var res = await delete(url);

      if (res.statusCode == 200) {
        result = {'status': true};
      } else {
        result = errorhandler();
      }
    } catch (e) {
      result = excephandler("calendarDelete", e);
    }
    return result;
  }
}
