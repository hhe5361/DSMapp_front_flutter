//post
import 'package:dasom_community_app/Data/Model/Attachment.dart';
import 'package:dasom_community_app/Data/Model/Comment.dart';

class Post {
  Post({
    required this.id,
    required this.path,
    required this.title,
    required this.shortTile,
    required this.views,
    required this.authorId,
    required this.authorName,
    required this.commentCounts,
    required this.pubAtKor,
  });
  int id;
  String path;
  String title;
  String shortTile;
  int views;
  String pubAtKor;
  String authorName;
  int authorId;
  int commentCounts;

  factory Post.fromjson(Map<String, dynamic> data) {
    return Post(
        id: data['id'],
        path: data['path'],
        title: data['title'],
        shortTile: data['short_title'],
        views: data['views'],
        authorId: data['author_id'],
        authorName: data['author_name'],
        commentCounts: data['comment_counts'],
        pubAtKor: data['published_at_kor']);
  }
}

class PostDetail extends Post {
  PostDetail({
    required int id,
    required String path,
    required String title,
    required String shortTile,
    required int views,
    required String pulichsedAtKor,
    required String authorName,
    required int authorId,
    required int commentCounts,
    required this.content,
    required this.comments,
    required this.attachments,
  }) : super(
          id: id,
          path: path,
          title: title,
          shortTile: shortTile,
          views: views,
          pubAtKor: pulichsedAtKor,
          authorName: authorName,
          authorId: authorId,
          commentCounts: commentCounts,
        );

  String content;
  List<Comment>? comments;
  List<Attachment>? attachments;

  factory PostDetail.fromjson(Map<String, dynamic> data) {
    List<Comment>? commentsData = data['comments'] != null
        ? (data['comments'] as List<dynamic>)
            .map((commentdata) =>
                Comment.fromjson(commentdata as Map<String, dynamic>))
            .toList()
        : null;

    List<Attachment>? attachData = data['attachments'] != null
        ? (data['attachments'] as List<dynamic>)
            .map((attachdata) =>
                Attachment.fromJson(attachdata as Map<String, dynamic>))
            .toList()
        : null;

    return PostDetail(
      id: data['id'],
      path: data['path'],
      title: data['title'],
      shortTile: data['short_title'],
      views: data['views'],
      authorId: data['author_id'],
      authorName: data['author_name'],
      commentCounts: data['comment_counts'],
      pulichsedAtKor: data['published_at_kor'],
      content: data['content'],
      comments: commentsData,
      attachments: attachData,
    );
  }
}
