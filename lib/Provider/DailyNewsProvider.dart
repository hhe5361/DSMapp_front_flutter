import 'package:dasom_community_app/Data/Model/DailyNews.dart';
import 'package:dasom_community_app/Data/Service/api/NewsApi.dart';
import 'package:dasom_community_app/util/UtilProvider.dart';
import 'package:flutter/material.dart';

//주기적으로 업데이트 할 수 있게 해야함. page 어떻게 할지 생각 중 서버에서 단위로 짤라서 넘길까? 아니면 그냥 provider에서 이렇게 넘길까
class DailyNewsProvider extends ChangeNotifier {
  List<DailyNews> _news = [];
  int _currentpage = 0;
  GetStatus _status = GetStatus.Failed;
  final NewsApi _api = NewsApi();

  get status => _status;
  get newslength => _news.length;
  String getheadline(int index) => _news[index].headline;
  String getpubar(int index) => _news[index].timeline;
  String getcontent(int index) => _news[index].conetent;
  String getImagePath(int index) => _news[index].imagePath;
  String getnewspath(int index) => _news[index].newsPath;

  void setstatus(GetStatus status) {
    _status = status;
    notifyListeners();
  }

  void pageUp() {
    _currentpage++;
    loadnewsdata();
  }

  Future<void> loadnewsdata() async {
    _status = GetStatus.Loading;

    Map<String, dynamic> result = await _api.getNews(_currentpage, 25);

    if (result['status']) {
      _news += result['data'];
      setstatus(GetStatus.Success);
    } else {
      setstatus(GetStatus.Failed);
    }
  }
}
