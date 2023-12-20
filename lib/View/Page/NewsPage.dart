import 'package:dasom_community_app/View/Page/ToWebViewPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dasom_community_app/Data/Service/endpoint.dart';
import 'package:dasom_community_app/Provider/DailyNewsProvider.dart';
import 'package:dasom_community_app/View/Widget/Appbar.dart';
import 'package:dasom_community_app/View/Widget/Decoration.dart';
import 'package:dasom_community_app/util/mediasize.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titleAppbar("MainNews", context),
      body: FutureBuilder(
        future: Provider.of<DailyNewsProvider>(context, listen: false)
            .loadnewsdata(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("failed to get data"),
            );
          } else {
            return NewsListView();
          }
        },
      ),
    );
  }
}

class NewsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _dailyNewsProvider =
        Provider.of<DailyNewsProvider>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(
              Icons.star,
              color: Colors.amber,
            ),
            Text(
              "오늘의 Hot Tech",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ]),
          const SizedBox(height: 7),
          Expanded(
            child: ListView.builder(
              itemCount: _dailyNewsProvider.newslength,
              itemBuilder: (BuildContext context, int index) {
                return NewsItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NewsItem extends StatelessWidget {
  final int index;

  NewsItem(this.index);

  @override
  Widget build(BuildContext context) {
    final dailyNewsProvider =
        Provider.of<DailyNewsProvider>(context, listen: true);
    String imgpath =
        HyoeunServer.webURI + dailyNewsProvider.getImagePath(index);

    return GestureDetector(
      // onTap: () {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (BuildContext context) {
      //     // return WebviewWithWebviewFlutterScreen(
      //     //     newsUrl: dailyNewsProvider.getnewspath(index));
      //   }));
      // },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: buildBoxDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        height: medh * 0.15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: Container(
                decoration: buildBoxDecoration(color: Colors.white),
                margin: const EdgeInsets.fromLTRB(0, 7, 7, 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dailyNewsProvider.getheadline(index),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    Text(
                      dailyNewsProvider.getcontent(index),
                      style: const TextStyle(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(children: [
                      const SizedBox(
                        width: 1,
                      ),
                      Icon(
                        Icons.access_time_rounded,
                        size: medh * 0.02,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(dailyNewsProvider.getpubar(index))
                    ]),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 7),
                width: double.infinity,
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    imgpath,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
