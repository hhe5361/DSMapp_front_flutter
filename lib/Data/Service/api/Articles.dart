import 'dart:convert';

import 'package:dasom_community_app/Data/Model/Board.dart';
import 'package:dasom_community_app/Data/Model/Post.dart';
import 'package:dasom_community_app/Data/Service/utilService.dart';
import 'package:dasom_community_app/Data/Service/accesstoken.dart';
import 'package:dasom_community_app/Data/Service/endpoint.dart';
import 'package:http/http.dart';

//post 관련 api
class ArticleApi {
  Future<Map<String, dynamic>> getBoardsList() async {
    Uri uri = Uri.parse(DasomUrI.board);
    Map<String, dynamic> result;

    try {
      var res = await get(
        uri,
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(utf8.decode(res.bodyBytes));
        List<Board> boards = (data['data']['boards'] as List)
            .map((boardData) =>
                Board.fromjson(boardData as Map<String, dynamic>))
            .toList();
        result = {'status': true, 'data': boards};
      } else if (res.statusCode == 401 || res.statusCode == 403) {
        var data = json.decode(res.body);

        result = errorhandler(data);
      } else {
        result = {'status': false, 'message': 'failed'};
      }
    } catch (e) {
      result = excephandler("getboardlist", e);
    }

    return result;
  }

  //특정 게시판의 Post 조회 : limit 15임.
  Future<Map<String, dynamic>> getPostList(
      {required int page, required int boardId}) async {
    Map<String, dynamic> result;
    int limit = 15;
    Map<String, dynamic> params = {
      'page': page.toString(),
      'limit': limit.toString(),
      'sort': "new"
    };

    var url = Uri.parse("${DasomUrI.board}/${boardId.toString()}/articles")
        .replace(queryParameters: params);

    try {
      var res = await get(
        url,
        headers: {'Authorization': Accesstoken},
      );

      switch (res.statusCode) {
        case 200:
          var data = jsonDecode(utf8.decode(res.bodyBytes));
          data = data['data'];

          List<Post> posts = (data['articles'] as List)
              .map(
                  (postdata) => Post.fromjson(postdata as Map<String, dynamic>))
              .toList();
          result = {'status': true, 'data': posts};
          break;
        case 401:
        case 403:
        case 404:
          var data = json.decode(res.body);
          result = errorhandler(data);
          break;
        default:
          result = {'status': false, 'message': 'failed'};
      }
    } catch (e) {
      result = excephandler("getpostlist", e);
    }

    return result;
  }

  //articles 넣으면 put임.
  Future<Map<String, dynamic>> getPostDetail(
      {required int boardId, required int articleId}) async {
    Uri url =
        Uri.parse(DasomUrI.accessArticle(boardId: boardId, postId: articleId));
    Map<String, dynamic> result;

    try {
      var res = await get(
        url,
        headers: {'Authorization': Accesstoken},
      );

      switch (res.statusCode) {
        case 200:
          var data = jsonDecode(utf8.decode(res.bodyBytes));
          PostDetail post = PostDetail.fromjson(data['data']);
          result = {'status': true, 'data': post};
          break;
        case 401:
        case 403:
        case 404:
          var data = json.decode(res.body);
          result = {'status': false, 'message': data['message']};

          break;
        default:
          result = {'status': false, 'message': "failed"};
      }
    } catch (e) {
      result = excephandler("getpostdetail", e);
    }

    return result;
  }

  //content html 형식 가능한 것 같은데
  //반환은 board_id와 article id 반환함.
  Future<Map<String, dynamic>> writePost(
      {required String title,
      required String content,
      List<int>? uploadIds,
      required int boardId,
      int? articlesId}) async {
    Map<String, dynamic> result;
    Map<String, dynamic> payload = {
      'title': title,
      'content': content,
    };
    if (uploadIds != null) payload['upload_ids'] = uploadIds;

    try {
      Uri url;
      Response res;

      if (articlesId == null) {
        url = Uri.parse("${DasomUrI.board}/${boardId.toString()}/articles");
        res = await post(url, body: json.encode(payload), headers: {
          'Authorization': Accesstoken,
          'Content-Type': 'application/json', // 추가
        });
      } else {
        url = Uri.parse(
            DasomUrI.accessArticle(boardId: boardId, postId: articlesId));
        res = await put(url,
            body: json.encode(payload),
            headers: {'Authorization': Accesstoken});
      }

      if (res.statusCode == 200) {
        var data = json.decode(res.body)['data'];
        result = {
          'status': true,
          'data': {
            'board_id': data['board_id'],
            'article_id': data['article_id']
          }
        };
      } else {
        var data = json.decode(res.body);
        result = errorhandler(data);
      }
    } catch (e) {
      result = excephandler("writePost", e);
    }

    return result; //url path 넘김.
  }

  Future<Map<String, dynamic>> deletePost(
      {required int boarderId, required int postId}) async {
    Map<String, dynamic> result;
    Uri url =
        Uri.parse(DasomUrI.accessArticle(boardId: boarderId, postId: postId));
    try {
      var res = await delete(url, headers: {'Authorization': Accesstoken});
      if (res.statusCode == 200) {
        result = {'status': true};
      } else {
        var data = json.decode(res.body);
        result = errorhandler(data);
      }
    } catch (e) {
      result = excephandler("deletePost", e);
    }
    return result;
  }

  // Future<Map<String,dynamic>> searchPost() async
}
