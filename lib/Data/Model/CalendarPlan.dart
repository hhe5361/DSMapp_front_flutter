class CalendarPlan {
  CalendarPlan({required this.id, required this.title, required this.date});

  int id;
  String title;
  String date;

  factory CalendarPlan.fromjson(Map<String, dynamic> data) {
    return CalendarPlan(
        id: data['id'], title: data['title'], date: data['date']);
  }
}
