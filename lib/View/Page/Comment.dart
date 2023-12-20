import 'package:dasom_community_app/Data/Model/Comment.dart';
import 'package:dasom_community_app/Provider/ArticleProvider.dart';
import 'package:dasom_community_app/Provider/CommentProvider.dart';
import 'package:dasom_community_app/View/Widget/Decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CommentRenderWidget extends StatefulWidget {
  CommentRenderWidget({super.key, required this.comments});
  List<Comment> comments;

  @override
  State<CommentRenderWidget> createState() => _CommentRenderWidgetState();
}

class _CommentRenderWidgetState extends State<CommentRenderWidget> {
  final TextEditingController _controller = TextEditingController();
  late CommentProvider _commentprovider;

  @override
  void initState() {
    super.initState();
    CommentProvider comment =
        Provider.of<CommentProvider>(context, listen: false);
    comment.setinit(
        Provider.of<ArticleProvider>(context, listen: false).boardid,
        Provider.of<ArticleProvider>(context, listen: false).articleid,
        widget.comments);
  }

  Widget _renderCommentBox() {
    // int commentlength = _commentprovider.commentlength > 10
    //     ? 10
    //     : _commentprovider.commentlength;
    int commentlength = _commentprovider.commentlength;
    return Container(
      decoration: buildBoxDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      child: Column(children: [
        GestureDetector(
            onTap: () {
              debugPrint("click");
            },
            child: Row(children: [
              Text("댓글 ${_commentprovider.commentlength}"),
              const SizedBox(width: 10),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
              )
            ])),
        const Divider(color: Colors.black26),
        commentlength == 0
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("댓글이 없습니다."))
            : Container(),
        ...List.generate(
            commentlength,
            (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _renderOneComment(index))),
        const Divider(color: Colors.black26),
        const SizedBox(
          height: 10,
        ),
        _renderInputComment(),
      ]),
    );
  }

  Container _renderOneComment(int index) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
        decoration: buildBoxDecoration(color: Colors.white),
        child: Row(
          children: [
            const SizedBox(width: 10),
            SvgPicture.asset(
              'assets/svg/comment_icon.svg',
            ),
            const SizedBox(
              width: 20,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_commentprovider.commentcontent(index)),
              Row(children: [
                Text(
                  _commentprovider.commentpub(index),
                  style: const TextStyle(fontSize: 10),
                ),
                Text(
                    _commentprovider.commentauth(index) == null
                        ? ""
                        : _commentprovider.commentauth(index)!,
                    style: const TextStyle(fontSize: 10))
              ])
            ]),
          ],
        ));
  }

  Widget _renderInputComment() {
    return Row(children: [
      Expanded(
        flex: 8,
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
              label: const Text("댓글을 입력해주세요"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0)),
        ),
      ),
      Expanded(
          flex: 2,
          child: TextButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _commentprovider.addcomment(_controller.text);
                  _controller.clear();
                }
              },
              child: const Text("등록")))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _commentprovider = Provider.of<CommentProvider>(context, listen: true);
    return _renderCommentBox();
  }
}
