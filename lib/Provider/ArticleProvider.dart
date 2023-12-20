import 'package:dasom_community_app/Data/Model/Attachment.dart';
import 'package:dasom_community_app/Data/Model/Comment.dart';
import 'package:dasom_community_app/Data/Model/Post.dart';
import 'package:dasom_community_app/Data/Service/api/Articles.dart';
import 'package:dasom_community_app/util/UtilProvider.dart';
import 'package:flutter/material.dart';

//여기 프로바이더는 그 전에 위젯에서 instance 올리는게 좋을 것 같다.
class ArticleProvider extends ChangeNotifier {
  final ArticleApi _articleApi = ArticleApi();
  late int _boardId;
  late int _articleId;
  late PostDetail _currentPost;
  late List<Comment>? _comments;
  late List<Attachment>? _attachment;
  late GetStatus _status;

  //get data 하는 부분 제공 목록 :
  get comments => _comments;
  get attachment => _attachment;
  get views => _currentPost.views;
  get title => _currentPost.title;
  get contents => _currentPost.content;
  get pubat => _currentPost.pubAtKor;
  get auth => _currentPost.authorName;
  get authId => _currentPost.authorId;
  get commentscount => _currentPost.commentCounts;
  get status => _status;
  get boardid => _boardId;
  get articleid => _articleId;

  void setclean({required int boardid, required int articleid}) {
    _boardId = boardid;
    _articleId = articleid;
  }

  void setGetStatus(GetStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> callDetailPost() async {
    _status = GetStatus.Loading;

    Map<String, dynamic> result = await _articleApi.getPostDetail(
        boardId: _boardId, articleId: _articleId);

    if (result['status']) {
      _currentPost = result['data'];

      //comment, attachment 분리해서 관리
      if (_currentPost.comments != null) {
        _comments = _currentPost.comments;
      } else {
        _comments = [];
      }
      if (_currentPost.attachments != null) {
        _attachment = _currentPost.attachments;
      } else {
        _attachment = [];
      }
      setGetStatus(GetStatus.Success);
    } else {
      setGetStatus(GetStatus.Failed);
    }
  }

  Future<bool> callDeletePost() async {
    _status = GetStatus.Loading;

    Map<String, dynamic> result =
        await _articleApi.deletePost(boarderId: _boardId, postId: _articleId);
    return (result['status']);
  }
}
