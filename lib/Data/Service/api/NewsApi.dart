import 'dart:convert';

import 'package:dasom_community_app/Data/Model/DailyNews.dart';
import 'package:dasom_community_app/Data/Service/endpoint.dart';
import 'package:dasom_community_app/Data/Service/utilService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NewsApi {
  Future<Map<String, dynamic>> getNews(int page, int limit) async {
    Map<String, dynamic> params = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    Map<String, dynamic> result;
    Uri url = Uri.parse(HyoeunServer.newsURL).replace(queryParameters: params);

    try {
      Response res = await get(url).timeout(const Duration(seconds: 20));
      if (res.statusCode == 200) {
        var data = jsonDecode(utf8.decode(res.bodyBytes));
        data = data['data'];
        List<DailyNews> listnews = (data as List)
            .map((e) => DailyNews.fromjson(e as Map<String, dynamic>))
            .toList();
        debugPrint(listnews[0].newsPath);
        result = {'status': true, 'data': listnews};
        debugPrint(listnews[0].imagePath);
      } else {
        result = errorhandler();
      }
    } catch (e) {
      result = excephandler("mynews api", e);
    }

    return result;
  }
}
