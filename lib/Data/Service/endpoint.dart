class DasomUrI {
  static const String serverURI = "http://api.dasom.io";
  static const String testURI = "http://10.0.2.2:4000";
  static const String baseURL = serverURI;
  static const String login = baseURL + "/signin";
  static const String signUp = baseURL + "/signup";
  static const String checkIdDuple = baseURL + "/duplicate";
  static const String board = baseURL + "/boards";

  static String accessArticle({required int boardId, required int postId}) =>
      "$board/${boardId.toString()}/articles/${postId.toString()}";
  static String accessComment({required int boardId, required int postId}) =>
      "${accessArticle(boardId: boardId, postId: postId)}/comments";
  static String accessCommentId(
          {required int boardId,
          required int postId,
          required int commentId}) =>
      "${accessComment(boardId: boardId, postId: postId)}/${commentId.toString()}";
}

class HyoeunServer {
  //port 8000
  static const String baseofcalen =
      'https://47a5-163-180-173-171.ngrok-free.app';
  //port 5000
  static const String baseofnews =
      "https://d202-163-180-173-171.ngrok-free.app"; //local host라서 일단 에뮬레이터로 돌리겠음.
  static const String webURI = "https://www.itworld.co.kr";
  //static const String baseURL = serverURI;
  static const String newsURL = baseofnews + "/api/news";

  static const String accessCalendar = "$baseofcalen/app/calender";
  static String accessDeleteCalendar(int id) =>
      "$baseofcalen/api/calender/${id.toString()}";
  static String accessPostCalendar = "$baseofcalen/api/calender";
  static String accessComment(int postID) =>
      "$baseofcalen/app/calender/comments/${postID.toString()}";
  static String accessPostComment = "$baseofcalen/api/calender/comments";
  static String accessDeleteComment(int postId, int commentId) =>
      "$baseofcalen/api/calender/${postId.toString()}/comments/${commentId.toString()}";
}
