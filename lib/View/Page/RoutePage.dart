import 'package:dasom_community_app/View/Page/CalendarPage.dart';
import 'package:dasom_community_app/View/Page/Drawer.dart';
import 'package:dasom_community_app/View/Page/NewsPage.dart';
import 'package:dasom_community_app/View/Page/WritePage.dart';
import 'package:flutter/material.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const NewsPage(),
    const CalendarPage(),
    const WritePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: MyDrawer(),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed, // 이 부분을 추가
          selectedItemColor: Colors.pink[200],
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded),
              label: 'calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: 'write',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
