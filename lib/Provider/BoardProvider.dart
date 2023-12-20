import 'package:dasom_community_app/Data/Model/Board.dart';
import 'package:dasom_community_app/Data/Service/api/Articles.dart';
import 'package:dasom_community_app/util/UtilProvider.dart';
import 'package:flutter/material.dart';

class BoarderProvider extends ChangeNotifier {
  final ArticleApi _articleapi = ArticleApi();
  List<Board> _boardlist = [];
  late GetStatus _boardstatus;
  late GetStatus _poststatus;
  String _failmsg = "";
  late int postboardid;
  late int postarticleid;

  get boardlength => _boardlist.length;
  get status => _boardstatus;
  get poststatus => _poststatus;
  get failmsg => _failmsg;

  String getboardTitle(int index) {
    return _boardlist[index].title;
  }

  int getboardId(int index) {
    return _boardlist[index].id;
  }

  void _setBoardStatus(GetStatus status) {
    _boardstatus = status;
    notifyListeners();
  }

  void _setPostStatus(GetStatus status) {
    _poststatus = status;
    notifyListeners();
  }

  //boarder 목록 가져오는 함수임. -> BoarderList 가져오려면 boarderlist 가져오면 됨.
  Future<void> getBoardList() async {
    if (_boardlist.isNotEmpty) {
      return;
    }

    _boardstatus = GetStatus.Loading;

    Map<String, dynamic> result = await _articleapi.getBoardsList();
    if (result['status']) {
      _boardlist = result['data'];
      _boardlist.removeAt(1);
      _setBoardStatus(GetStatus.Success);
    } else {
      _failmsg = result['message'];
      _setBoardStatus(GetStatus.Failed);
    }
  }

  Future<void> articlePost(String title, String content, int boardId) async {
    _setPostStatus(GetStatus.Loading);

    var result = await _articleapi.writePost(
        title: title, content: content, boardId: boardId);
    postboardid = result['data']['board_id'];
    postarticleid = result['data']['article_id'];
    if (result['status']) {
      _setPostStatus(GetStatus.Success);
    } else {
      _setPostStatus(GetStatus.Failed);
    }
  }
}
