class Board {
  Board(
      {required this.id,
      required this.title,
      required this.writeLevel,
      required this.readLevel,
      required this.iconClass,
      required this.path});

  int id;
  String title;
  int writeLevel;
  int readLevel;
  String path;
  String iconClass;

  factory Board.fromjson(Map<String, dynamic> data) {
    return Board(
        id: data['id'],
        title: data['title'],
        writeLevel: data['write_level'],
        readLevel: data['read_level'],
        iconClass: data['icon_class'],
        path: data['path']);
  }
}
