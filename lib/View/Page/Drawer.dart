import 'package:dasom_community_app/View/Page/BoardDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dasom_community_app/Provider/AuthProvider.dart';
import 'package:dasom_community_app/Provider/BoardProvider.dart';
import 'package:dasom_community_app/util/UtilProvider.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late BoarderProvider _boarder;

  @override
  void initState() {
    super.initState();
  }

  ListTile _renderTile(String title, int boardid) => ListTile(
        leading: const Icon(Icons.book),
        title: Text(title),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      BoardDetailPage(boardid: boardid, boardTitle: title)));
        },
      );

  DrawerHeader _renderDrawerHeader(AuthProvider auth) {
    int username = auth.userid;

    return DrawerHeader(
      decoration: BoxDecoration(color: Colors.blue[50]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image(
                image: AssetImage('assets/image/logo.png'),
                width: 40,
                height: 40,
              ),
              SizedBox(
                width: 20,
              ),
              Text('Dasom')
            ]),
            const Divider(),
            Text("안녕하세요! $username님!")
          ],
        ),
      ),
    );
  }

  List<Widget> _boardlist() {
    if (_boarder.status == GetStatus.Success) {
      List<ListTile> tile = List.generate(
          _boarder.boardlength,
          (index) => _renderTile(
              _boarder.getboardTitle(index), _boarder.getboardId(index)));
      return tile;
    } else if (_boarder.status == GetStatus.Failed) {
      return [Text(_boarder.failmsg)];
    } else {
      return [
        const SizedBox(
            width: 30, height: 30, child: CircularProgressIndicator())
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    _boarder = Provider.of<BoarderProvider>(context, listen: true);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _renderDrawerHeader(auth),
          ..._boardlist(),
        ],
      ),
    );
  }
}
