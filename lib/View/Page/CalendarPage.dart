import 'package:dasom_community_app/Component/ColorDef.dart';
import 'package:dasom_community_app/Data/Model/CalendarPlan.dart';
import 'package:dasom_community_app/Provider/AuthProvider.dart';
import 'package:dasom_community_app/Provider/CalendarProvider.dart';
import 'package:dasom_community_app/View/Widget/Appbar.dart';
import 'package:dasom_community_app/View/Widget/Decoration.dart';
import 'package:dasom_community_app/View/Widget/Dialog.dart';
import 'package:dasom_community_app/util/UtilProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    Provider.of<CalendarProvider>(context, listen: false)
        .loadPlan(true)
        .then((value) => null);
  }

  late CalendarProvider _calendarProvider;

  Widget _getpostTable(CalendarPlan plan) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
      decoration: buildBoxDecoration(color: Colors.white),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            const Icon(Icons.calendar_month),
            const SizedBox(
              width: 10,
            ),
            Text(plan.date),
            const SizedBox(
              width: 10,
            ),
            Text(
              plan.title,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        IconButton(
            onPressed: () {
              _calendarProvider
                  .deletePost(calendarId: plan.id, date: selectedDay)
                  .then((value) {
                if (value) {
                  showSnackBar("일정을 삭제하였습니다!", context);
                } else {
                  showSnackBar("권한이 없습니다!", context);
                }
              });
            },
            icon: const Icon(Icons.delete))
      ]),
    );
  }

  Widget _selectedDayTable() {
    List<CalendarPlan> selected =
        _calendarProvider.getEventsForDay(selectedDay);
    if (_calendarProvider.status == GetStatus.Loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_calendarProvider.status == GetStatus.Failed) {
      return const Center(
        child: Text("Error - load fail"),
      );
    } else {
      return selected.isEmpty
          ? const Center(
              child: Text("해당 날짜는 일정이 없습니다!"),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: _getpostTable(selected[index]));
              },
              itemCount: selected.length);
    }
  }

  Widget _rendercalendar() => TableCalendar(
      firstDay: DateTime.utc(2020, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        setState(() {
          this.selectedDay = selectedDay;
          this.focusedDay = focusedDay;
        });
      },
      selectedDayPredicate: (DateTime day) {
        return isSameDay(selectedDay, day);
      },
      calendarStyle: CalendarStyle(
        defaultTextStyle: const TextStyle(fontSize: 10), // 글자 크기 조절
        weekendTextStyle: const TextStyle(fontSize: 10), // 주말 글자 크기 조절
        outsideTextStyle: const TextStyle(fontSize: 10), // 영역 외부 글자 크기 조절
        outsideDaysVisible: false, // 영역 외부 날짜 숨김 여부
        todayTextStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold), // 오늘 날짜 글자 스타일
        selectedTextStyle: const TextStyle(fontSize: 10), // 선택된 날짜 글자 스타일
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.5),
        ),
        markerDecoration:
            const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        selectedDecoration: BoxDecoration(
            shape: BoxShape.circle, color: colormainpink), // 선택된 날짜의 배경 스타일
      ),
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),
        headerPadding: EdgeInsets.symmetric(vertical: 4.0),
        leftChevronIcon: Icon(
          Icons.arrow_left,
          size: 30.0,
        ),
        rightChevronIcon: Icon(
          Icons.arrow_right,
          size: 30.0,
        ),
      ),
      eventLoader: _calendarProvider.getEventsForDay);

  Future<void> _showTextDialog(BuildContext context) async {
    TextEditingController _textController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '일정 추가',
            textAlign: TextAlign.center,
          ),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: '일정을 입력하세요'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // AlertDialog 닫기
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  int userid =
                      Provider.of<AuthProvider>(context, listen: false).userid;
                  // _calendarProvider.
                  _calendarProvider.postPlan(
                      studentId: userid,
                      title: _textController.text,
                      date: selectedDay,
                      content: "content");
                }
                Navigator.of(context).pop(); // AlertDialog 닫기
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _calendarProvider = Provider.of<CalendarProvider>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: titleAppbar("Calendar", context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showTextDialog(context);
          },
          child: const Icon(Icons.edit_calendar_sharp),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 8),
          child: Column(
            children: [
              Container(
                decoration: buildBoxDecoration(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: _rendercalendar(),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 5,
                child: Container(
                    decoration: buildBoxDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Today 동아리 일정"),
                            const SizedBox(
                              height: 5,
                            ),
                            Expanded(child: _selectedDayTable())
                          ]),
                    )),
              )
            ],
          ),
        ));
  }
}
