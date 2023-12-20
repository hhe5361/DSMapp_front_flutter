import 'dart:convert';

import 'package:dasom_community_app/Data/Model/Comment.dart';
import 'package:dasom_community_app/Data/Service/accesstoken.dart';
import 'package:dasom_community_app/Data/Service/endpoint.dart';
import 'package:dasom_community_app/Data/Service/utilService.dart';
import 'package:http/http.dart';

class CommentApi {
  Future<Map<String, dynamic>> getComment(
      {required int boarderId, required int articlesId}) async {
    Map<String, dynamic> result;

    Uri url = Uri.parse(
        DasomUrI.accessComment(boardId: boarderId, postId: articlesId));

    try {
      Response res = await get(url, headers: {'Authorization': Accesstoken});

      if (res.statusCode == 200) {
        var data = jsonDecode(utf8.decode(res.bodyBytes));
        List<Comment>? comments = (data['data']['comments'] as List)
            .map((commentdata) =>
                Comment.fromjson(commentdata as Map<String, dynamic>))
            .toList();
        result = {'status': true, 'data': comments};
      } else {
        var data = json.decode(res.body);
        result = errorhandler(data);
      }
    } catch (e) {
      result = excephandler("getComment", e);
    }
    return result;
  }

  Future<Map<String, dynamic>> writecomment(
      {required int boardId,
      required int ariticleId,
      required String comment}) async {
    Uri url =
        Uri.parse(DasomUrI.accessComment(boardId: boardId, postId: ariticleId));
    Map<String, dynamic> payload = {'comment': comment};
    Map<String, dynamic> result;

    try {
      Response res = await post(url, body: json.encode(payload), headers: {
        'Authorization': Accesstoken,
        'Content-Type': 'application/json',
      });

      if (res.statusCode == 200) {
        result = {'status': true};
      } else {
        var data = json.decode(res.body);
        result = errorhandler(data);
      }
    } catch (e) {
      result = excephandler("writecomment", e);
    }

    return result;
  }

  Future<Map<String, dynamic>> deleteComment(
      {required int boardId,
      required int ariticleId,
      required int commentId}) async {
    Uri url = Uri.parse(DasomUrI.accessCommentId(
        boardId: boardId, postId: ariticleId, commentId: commentId));
    Map<String, dynamic> result;

    try {
      Response res = await delete(url, headers: {
        'Authorization': Accesstoken,
      });

      if (res.statusCode == 200) {
        result = {'status': true};
      } else {
        var data = json.decode(res.body);
        result = errorhandler(data);
      }
    } catch (e) {
      result = excephandler("deletecomment", e);
    }

    return result;
  }
}

class FileApi {}
