import 'package:dasom_community_app/Component/ColorDef.dart';
import 'package:dasom_community_app/Provider/BoardProvider.dart';
import 'package:dasom_community_app/View/Page/BoardDetailPage.dart';
import 'package:dasom_community_app/View/Widget/Dialog.dart';
import 'package:dasom_community_app/util/UtilProvider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  late int? selectboard;
  late int? index;
  late String? selectboardname;

  Future<void> postOn() async {
    final form = formKey.currentState;
    BoarderProvider prov = Provider.of<BoarderProvider>(context, listen: false);

    if (form!.validate()) {
      form.save();
      prov.articlePost(_title, _content, selectboard!);
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            if (prov.poststatus == GetStatus.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (prov.poststatus == GetStatus.Success) {
              return AlertDialog(
                title: const Text("success"),
                content: const Text("success to upload post"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return BoardDetailPage(
                            boardid: prov.postboardid,
                            boardTitle: selectboardname!);
                      }));
                    },
                    child: const Text('확인'),
                  ),
                ],
              );
            } else {
              return shortAlert("Fail", "Fail to upload", context);
            }
          });
    }
  }

  Widget _dropBoard() {
    BoarderProvider prov = Provider.of<BoarderProvider>(context, listen: false);

    List<Map<String, dynamic>> options =
        List.generate(prov.boardlength, (int index) {
      return {
        'index': index,
        'boardtitle': prov.getboardTitle(index),
        'boardid': prov.getboardId(index)
      };
    });
    index = 0;
    selectboard = options[0]['boardid'];
    selectboardname = options[0]['boardtitle'];

    return DropdownButtonFormField<int>(
      value: index,
      items: options
          .map((e) => DropdownMenuItem<int>(
                value: e['index'],
                child: Text(e['boardtitle']),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectboard = options[index!]['boardtitle'];
          selectboardname = options[index!]['boardtitle'];
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final titlefield = TextFormField(
        autofocus: false,
        validator: (value) {
          if (value?.isEmpty ?? true) return 'Empty!';
          return null;
        },
        onSaved: (value) => _title = value!,
        decoration: const InputDecoration(hintText: "제목"));

    final contentfield = TextFormField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        autofocus: false,
        validator: (value) {
          if (value?.isEmpty ?? true) return 'Empty!';
          return null;
        },
        decoration: const InputDecoration(
          hintText: "내용을 입력하세요",
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 30),
        ),
        onSaved: (value) => _content = value!);

    return Scaffold(
        resizeToAvoidBottomInset: false, // 키보드가 떠 있을 때 화면 조절 비활성화

        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          title: Text("글 작성하기", style: const TextStyle(color: Colors.white)),
          backgroundColor: colormainpink,
          actions: [
            TextButton(
                onPressed: () {
                  postOn();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "저장",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [_dropBoard(), titlefield, contentfield],
              ),
            ),
          ),
        ));
  }
}
