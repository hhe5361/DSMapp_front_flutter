import 'package:dasom_community_app/Data/Model/CalendarPlan.dart';
import 'package:dasom_community_app/Data/Model/Post.dart';
import 'package:dasom_community_app/Data/Service/api/Calendar.dart';
import 'package:dasom_community_app/Data/Service/api/CommentApi.dart';
import 'package:dasom_community_app/Data/Service/api/Articles.dart';
import 'package:flutter_test/flutter_test.dart';

//우와 테스트 패키지 신기하다
void main() {
  //calendarapi;
}

var articlesapi = group('PostApi 테스트', () {
  test('게시판 목록 조회 테스트', () async {
    ArticleApi postApi = ArticleApi();
    Map<String, dynamic> result = await postApi.getBoardsList();

    expect(result['status'], isA<bool>());
    if (result['status']) {
      expect(result['data'], isA<List>());
    } else {
      expect(result['message'], isA<String>());
    }
  });

  test('게시글 목록 조회 테스트', () async {
    ArticleApi postApi = ArticleApi();
    int page = 0;
    int boardId = 7;
    Map<String, dynamic> result =
        await postApi.getPostList(page: page, boardId: boardId);

    expect(result['status'], isA<bool>());
    if (result['status']) {
      expect(result['data'], isA<List>());
    } else {
      expect(result['message'], isA<String>());
    }
  });

  test('게시글 상세 조회 테스트', () async {
    ArticleApi postApi = ArticleApi();
    int boardId = 7;
    int articleId = 217;
    Map<String, dynamic> result =
        await postApi.getPostDetail(boardId: boardId, articleId: articleId);

    expect(result['status'], isA<bool>());
    if (result['status']) {
      expect(result['data'], isA<PostDetail>());
    } else {
      expect(result['message'], isA<String>());
    }
  });

  test('게시글 작성/수정 테스트', () async {
    ArticleApi postApi = ArticleApi();
    String title = "hello ";
    String content = "its mee";
    int boardId = 1;
    Map<String, dynamic> result = await postApi.writePost(
        title: title, content: content, boardId: boardId);

    expect(result['status'], isA<bool>());
    print(result['status']);
    if (result['status']) {
      expect(result['data'], isA<Map>());
    } else {
      expect(result['message'], isA<String>());
    }
  });

  test('게시글 삭제 테스트', () async {
    ArticleApi postApi = ArticleApi();
    int boardId = 7;
    int postId = 235;
    Map<String, dynamic> result =
        await postApi.deletePost(boarderId: boardId, postId: postId);
    expect(result['status'], isA<bool>());
    if (!result['status']) {
      expect(result['message'], isA<String>());
    }
  });
});

var commentapi = group('CommentApi 테스트', () {
  test('댓글 조회 테스트', () async {
    CommentApi commentApi = CommentApi();
    int boarderId = 7;
    int articlesId = 217;
    Map<String, dynamic> result = await commentApi.getComment(
        boarderId: boarderId, articlesId: articlesId);

    expect(result['status'], isA<bool>());
    if (result['status']) {
      expect(result['data'], isA<List>());
    } else {
      expect(result['message'], isA<String>());
    }
  });
});

var calendarapi = group('CalendarApi 테스트', () {
  test('일정 조회 테스트', () async {
    CalendarApi calendarApi = CalendarApi();
    Map<String, dynamic> result = await calendarApi.getplan();

    expect(result['status'], isA<bool>());
    if (result['status']) {
      expect(result['data'], isA<List<CalendarPlan>>());
    } else {
      expect(result['message'], isA<String>());
    }
  });

  test('일정 추가 테스트', () async {
    CalendarApi calendarApi = CalendarApi();
    String title = "새로운 일정";
    int studentId = 123; // 실제 사용자 ID로 대체
    String date = "2023-12-31"; // 적절한 날짜로 대체
    String content = "일정 내용";
    Map<String, dynamic> result = await calendarApi.postplan(
      title: title,
      studentId: studentId,
      date: date,
      content: content,
    );

    expect(result['status'], isTrue);
    if (result['status']) {
    } else {
      expect(result['message'], isA<String>());
    }
  });

  test('일정 삭제 테스트', () async {
    CalendarApi calendarApi = CalendarApi();
    int postId = 10; // 실제 일정 ID로 대체
    Map<String, dynamic> result = await calendarApi.deleteplan(postId);

    expect(result['status'], isA<bool>());
    if (result['status']) {
      // 일정 삭제 성공시에 추가 정보를 확인할 수 있는 코드 추가
    } else {
      expect(result['message'], isA<String>());
    }
  });
});
