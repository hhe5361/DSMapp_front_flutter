import 'package:dasom_community_app/Data/Model/Comment.dart';
import 'package:dasom_community_app/Data/Service/api/CommentApi.dart';
import 'package:dasom_community_app/util/UtilProvider.dart';
import 'package:flutter/material.dart';

//article id 랑 boardid 좀 상위 위젯..? 으로 옮겨야 할 듯 더러움.
class CommentProvider extends ChangeNotifier {
  final CommentApi _commentApi = CommentApi();
  late int _boardid;
  late int _articleid;
  List<Comment> _comments = [];
  GetStatus _writestatus = GetStatus.Loading;
  GetStatus _deletestatus = GetStatus.Loading;

  get writestatus => _writestatus;
  get commentlength => _comments.length;
  String? commentauth(int index) => _comments[index].authorName;
  String commentcontent(int index) => _comments[index].comment;
  String commentpub(int index) => _comments[index].publishedAtKor;

  void _setWritestatus(GetStatus status) {
    _writestatus = status;
    notifyListeners();
  }

  void _setDeletestatus(GetStatus status) {
    _deletestatus = status;
    notifyListeners();
  }

  void setinit(int boardid, int articleid, List<Comment> comment) {
    _comments.clear();

    _comments = comment;
    _boardid = boardid;
    _articleid = articleid;
  }

  void addcomment(String content) async {
    _setWritestatus(GetStatus.Loading);

    Map<String, dynamic> result = await _commentApi.writecomment(
        boardId: _boardid, ariticleId: _articleid, comment: content);

    if (result['status']) {
      getcomment();
      _setWritestatus(GetStatus.Success);
    } else {
      _setWritestatus(GetStatus.Failed);
    }
  }

  void getcomment() async {
    Map<String, dynamic> result = await _commentApi.getComment(
        boarderId: _boardid, articlesId: _articleid);

    if (result['status']) {
      _comments = result['data'];
    }
  }

  void deletecomment(int index) async {
    _setDeletestatus(GetStatus.Loading);

    Map<String, dynamic> result = await _commentApi.deleteComment(
        boardId: _boardid,
        ariticleId: _articleid,
        commentId: _comments[index].commendId);

    if (result['status']) {
      _setDeletestatus(GetStatus.Success);
    } else {
      _setDeletestatus(GetStatus.Failed);
    }
  }
}
