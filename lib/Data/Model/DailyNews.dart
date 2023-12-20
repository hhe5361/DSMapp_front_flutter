class DailyNews {
  DailyNews(
      {required this.imagePath,
      required this.newsPath,
      required this.conetent,
      required this.headline,
      required this.timeline});

  String imagePath;
  String newsPath;
  String headline;
  String conetent;
  String timeline;

  factory DailyNews.fromjson(Map<String, dynamic> jsondata) {
    return DailyNews(
        imagePath: jsondata['img'],
        newsPath: jsondata['link'],
        conetent: jsondata['content'],
        headline: jsondata['headline'],
        timeline: jsondata['timeline']);
  }
}
