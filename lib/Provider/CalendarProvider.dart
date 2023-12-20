import 'package:dasom_community_app/Data/Model/CalendarPlan.dart';
import 'package:dasom_community_app/Data/Service/api/Calendar.dart';
import 'package:dasom_community_app/util/UtilProvider.dart';
import 'package:flutter/material.dart';

class CalendarProvider extends ChangeNotifier {
  CalendarApi _api = CalendarApi();
  Map<DateTime, List<CalendarPlan>> _events = {};

  GetStatus _status = GetStatus.Failed;
  get events => _events;
  get status => _status;

  List<CalendarPlan> getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void _setstatus(GetStatus status) {
    _status = status;
    notifyListeners();
  }

  void _structplan(List<CalendarPlan> data) {
    _events.clear();
    for (var plan in data) {
      DateTime dateTime = DateTime.parse(plan.date);

      int year = dateTime.year;
      int month = dateTime.month;

      DateTime planDate = DateTime.utc(year, month, dateTime.day);
      if (_events.containsKey(planDate)) {
        _events[planDate]!.add(plan);
      } else {
        _events[planDate] = [plan];
      }
    }
  }

  Future<void> loadPlan([bool isinit = false]) async {
    if (isinit) {
      _status = GetStatus.Loading;
    } else {
      _setstatus(GetStatus.Loading);
    }

    Map<String, dynamic> result = await _api.getplan();

    if (result['status']) {
      debugPrint("success to load plan");
      _structplan(result['data']);
      _setstatus(GetStatus.Success);
    } else {
      _setstatus(GetStatus.Failed);
    }
  }

  Future<bool> postPlan(
      {required int studentId,
      required String title,
      required DateTime date,
      required String content}) async {
    Map<String, dynamic> result = await _api.postplan(
        content: content,
        date: date.toString(),
        studentId: studentId,
        title: title);

    if (result['status']) {
      debugPrint("success to post plan");
      loadPlan(true);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deletePost(
      {required int calendarId, required DateTime date}) async {
    Map<String, dynamic> result = await _api.deleteplan(calendarId);
    List<CalendarPlan> list = _events[date]!;

    if (result['status']) {
      debugPrint("success to delete plan");
      for (int i = 0; i < list.length; i++) {
        if (list[i].id == calendarId) {
          _events[date]!.removeAt(i);
          break;
        }
      }
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
