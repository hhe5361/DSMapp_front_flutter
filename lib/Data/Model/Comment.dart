class Comment {
  Comment(
      {required this.commendId,
      required this.comment,
      required this.publishedAtKor,
      required this.authorId,
      this.authorName});

  int commendId;
  String comment;
  String publishedAtKor;
  int authorId;
  String? authorName = null;

  factory Comment.fromjson(Map<String, dynamic> data) {
    if (data['post_id'] != null) {
      return Comment(
        commendId: data["comment_id"],
        comment: data['comment'],
        publishedAtKor: data['timestamp'],
        authorId: data['student_id'],
      );
    } else {
      return Comment(
          commendId: data["comment_id"],
          comment: data['comment'],
          publishedAtKor: data['published_at_kor'],
          authorId: data['author_id'],
          authorName: data['author_name']);
    }
  }
}
