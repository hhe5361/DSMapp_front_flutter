import 'package:dasom_community_app/Data/Model/Post.dart';
import 'package:dasom_community_app/Data/Service/api/Articles.dart';
import 'package:dasom_community_app/util/UtilProvider.dart';
import 'package:flutter/material.dart';

//BoardDetailProvider는 그때 그때 생성되는 느낌스.
class BoardDetailProvider extends ChangeNotifier {
  final ArticleApi _articleApi = ArticleApi();
  late int _currentBoardId;
  late GetStatus _status;
  int _currentPage = 0;
  List<Post> _post = [];

  //getter
  get postlength => _post.length;
  get status => _status;
  int getPostId(int index) => _post[index].id;
  String getPostTitle(int index) => _post[index].title;
  String getPostShortTile(int index) => _post[index].shortTile;
  int getPostViews(int index) => _post[index].views;
  int getPostAutorId(int index) => _post[index].authorId;
  String getPostAuthorName(int index) => _post[index].authorName;
  int getPostCommentsCounts(int index) => _post[index].commentCounts;
  String getPostPublished(int index) => _post[index].pubAtKor;

  void setGetStatus(GetStatus status) {
    _status = status;
    notifyListeners();
  }

  void setBoardId(int id) {
    _post.clear();
    _currentPage = 0;
    _currentBoardId = id;
  }

  void scrollPage() {
    _currentPage++;
    callpostList();
  }

  void callpostList() async {
    _status = GetStatus.Loading;

    Map<String, dynamic> result = await _articleApi.getPostList(
        page: _currentPage, boardId: _currentBoardId);

    if (result['status']) {
      _post.addAll(result['data']);
      setGetStatus(GetStatus.Success);
    } else {
      setGetStatus(GetStatus.Failed);
    }
  }
}
