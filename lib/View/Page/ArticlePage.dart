import 'package:dasom_community_app/Data/Model/User.dart';
import 'package:dasom_community_app/Provider/ArticleProvider.dart';
import 'package:dasom_community_app/Provider/AuthProvider.dart';
import 'package:dasom_community_app/View/Page/Comment.dart';
import 'package:dasom_community_app/View/Widget/Appbar.dart';
import 'package:dasom_community_app/View/Widget/Decoration.dart';
import 'package:dasom_community_app/View/Widget/Dialog.dart';
import 'package:dasom_community_app/util/UtilProvider.dart';
import 'package:dasom_community_app/util/mediasize.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart';

class ArticlePage extends StatefulWidget {
  ArticlePage(
      {super.key,
      required this.boardid,
      required this.articleid,
      required this.boardtitle});
  int boardid;
  String boardtitle;
  int articleid;

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late ArticleProvider _articleprovider;
  late bool isuserpost;

  @override
  void initState() {
    super.initState();
    ArticleProvider forinit =
        Provider.of<ArticleProvider>(context, listen: false);
    forinit.setclean(boardid: widget.boardid, articleid: widget.articleid);
    forinit.callDetailPost();
  }

  Widget _renderContent() {
    final document = parse(_articleprovider.contents);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
      decoration: buildBoxDecoration(),
      child: Text(parsedString),
    );
  }

  Widget _renderDeleteIcon() {
    return IconButton(
        onPressed: () {
          _articleprovider.callDeletePost().then((value) => {
                if (value)
                  {
                    shortDialog(
                        "Success", "Success to delete this post!", context)
                  }
                else
                  {
                    shortDialog(
                        "Fail", "fail to delete this post!", context, () {})
                  }
              });
        },
        icon: const Icon(Icons.delete));
  }

  Widget _renderHead() {
    return SizedBox(
      height: medh * 0.13,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 15),
          Text("[${_articleprovider.title}]",
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("작성자 : ${_articleprovider.auth}|",
                      style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 10),
                  Text("날짜 : ${_articleprovider.pubat}|",
                      style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 10),
                  Text("조회수 : ${_articleprovider.views.toString()}",
                      style: const TextStyle(fontSize: 13))
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _articleprovider = Provider.of<ArticleProvider>(context);
    int userid = Provider.of<AuthProvider>(context, listen: false).userid;

    if (_articleprovider.status == GetStatus.Loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_articleprovider.status == GetStatus.Failed) {
      return const Text("failed msg나중에 연결해야함");
    } else {
      isuserpost = _articleprovider.authId == userid;
      return SafeArea(
        child: Scaffold(
            appBar: titleAppbar(widget.boardtitle, context, true,
                isuserpost ? _renderDeleteIcon() : null),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView(
                children: [
                  _renderHead(),
                  const Divider(height: 20),
                  _renderContent(),
                  const SizedBox(height: 20),
                  Expanded(
                      child: CommentRenderWidget(
                          comments: _articleprovider.comments))
                ],
              ),
            )),
      );
    }
  }
}
