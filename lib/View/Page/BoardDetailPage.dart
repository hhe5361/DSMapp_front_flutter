import 'package:dasom_community_app/Provider/BoardDetailProvider.dart';
import 'package:dasom_community_app/View/Page/ArticlePage.dart';
import 'package:dasom_community_app/View/Widget/Appbar.dart';
import 'package:dasom_community_app/View/Widget/Decoration.dart';
import 'package:dasom_community_app/util/UtilProvider.dart';
import 'package:dasom_community_app/util/mediasize.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardDetailPage extends StatefulWidget {
  BoardDetailPage({super.key, required this.boardid, required this.boardTitle});
  int boardid;
  String boardTitle;
  @override
  State<BoardDetailPage> createState() => _BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage> {
  late BoardDetailProvider _boarderdetail;

  @override
  void initState() {
    super.initState();
    _boarderdetail = Provider.of<BoardDetailProvider>(context, listen: false);
    _boarderdetail.setBoardId(widget.boardid);
    _boarderdetail.callpostList();
  }

  Widget _renderPostTile(String title, String authname, String pubat,
          int comments, int views, int articleid) =>
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return ArticlePage(
                boardid: widget.boardid,
                articleid: articleid,
                boardtitle: widget.boardTitle);
          }));
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          height: medh * 0.13,
          decoration: buildBoxDecoration(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "[$title]",
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(authname),
                      const SizedBox(width: 10),
                      Text(pubat),
                      const SizedBox(width: 10),
                      Text(views.toString()),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: buildBoxDecoration(color: Colors.white),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("댓글"),
                        Text(comments.toString()),
                      ])),
            ),
          ]),
        ),
      );
  @override
  Widget build(BuildContext context) {
    _boarderdetail = Provider.of<BoardDetailProvider>(context, listen: true);
    debugPrint(_boarderdetail.postlength.toString());
    if (_boarderdetail.status == GetStatus.Loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_boarderdetail.status == GetStatus.Failed) {
      return const Text("failed msg는 나중에 추가 예정"); //have to add
    } else {
      return SafeArea(
        child: Scaffold(
            appBar: titleAppbar(widget.boardTitle, context, true),
            body: ListView.builder(
              itemCount: _boarderdetail.postlength,
              itemBuilder: (context, index) {
                return _renderPostTile(
                    _boarderdetail.getPostTitle(index),
                    _boarderdetail.getPostAuthorName(index),
                    _boarderdetail.getPostPublished(index),
                    _boarderdetail.getPostCommentsCounts(index),
                    _boarderdetail.getPostViews(index),
                    _boarderdetail.getPostId(index));
              },
            )),
      );
    }
  }
}
